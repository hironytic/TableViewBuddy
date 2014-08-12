//
// TBTableData.m
// TableViewBuddy
//
// Copyright (c) 2014 Hironori Ichimiya <hiron@hironytic.com>
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "TBTableData.h"
#import "TBTableData_Internal.h"
#import "TBTableDataContext_Internal.h"
#import "TBTableDataRow_Internal.h"
#import "TBTableDataSection_Internal.h"

@implementation TBTableData

- (NSArray *)sections {
    return self.mutableSections;
}

+ (instancetype)tableDataWithConfigurator:(void (^)(TBTableDataInitializationContext *context))configurator {
    TBTableData *tableData = [[self alloc] init];
    if (tableData != nil) {
        TBTableDataInitializationContext *context = [[TBTableDataInitializationContext alloc] init];
        context.tableData = tableData;
        configurator(context);
    }
    
    return tableData;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _mutableSections = [[NSMutableArray alloc] init];
    }
    return self;
}

- (TBTableDataSection *)visibleSectionAtSectionIndex:(NSInteger)sectionIndex {
    for (TBTableDataSection *section in self.sections) {
        if (!section.hidden) {
            if (sectionIndex == 0) {
                return section;
            }
            --sectionIndex;
        }
    }
    return nil;
}

- (TBTableDataRow *)visibleRowAtIndex:(NSInteger)rowIndex inSectionIndex:(NSInteger)sectionIndex {
    TBTableDataSection *section = [self visibleSectionAtSectionIndex:sectionIndex];
    if (section != nil) {
        for (TBTableDataRow *row in section.rows) {
            if (!row.hidden) {
                if (rowIndex == 0) {
                    return row;
                }
                --rowIndex;
            }
        }
    }
    return nil;
}

- (TBTableDataRow *)visibleRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self visibleRowAtIndex:indexPath.row inSectionIndex:indexPath.section];
}

- (void)updateAnimated:(BOOL)animated updater:(void (^)(TBTableDataUpdateContext *context))updater {
    TBTableDataUpdateContext *context = [[TBTableDataUpdateContext alloc] init];
    updater(context);
    
    NSMutableIndexSet *sectionsToDelete = [[NSMutableIndexSet alloc] init];
    NSMutableArray *rowsToDelete = [[NSMutableArray alloc] init];
    NSMutableIndexSet *sectionsToReload = [[NSMutableIndexSet alloc] init];
    NSMutableArray *rowsToReload = [[NSMutableArray alloc] init];
    [self collectDisappearedSectionIndices:sectionsToDelete
               andDisappearedRowIndexPaths:rowsToDelete
                 andReloadedSectionIndices:sectionsToReload
                  andReloadedRowIndexPaths:rowsToReload
                                   context:context];

    NSMutableIndexSet *sectionsToInsert = [[NSMutableIndexSet alloc] init];
    NSMutableArray *rowsToInsert = [[NSMutableArray alloc] init];
    [self collectAppearedSectionIndices:sectionsToInsert
               andAppearedRowIndexPaths:rowsToInsert
                                context:context];
    
    [self reflectUpdate:context];

    if (self.tableView != nil) {
        if ([sectionsToDelete count] > 0 || [sectionsToInsert count] > 0 || [sectionsToReload count] > 0 ||
            [rowsToDelete count] > 0 || [rowsToInsert count] > 0 || [rowsToReload count] > 0) {
            if (animated) {
                [self.tableView beginUpdates];
                
                if ([sectionsToDelete count] > 0) {
                    [self.tableView deleteSections:sectionsToDelete withRowAnimation:context.deletionAnimation];
                }
                if ([rowsToDelete count] > 0) {
                    [self.tableView deleteRowsAtIndexPaths:rowsToDelete withRowAnimation:context.deletionAnimation];
                }

                if ([sectionsToReload count] > 0) {
                    [self.tableView reloadSections:sectionsToReload withRowAnimation:context.reloadingAnimation];
                }
                if ([rowsToReload count] > 0) {
                    [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:context.reloadingAnimation];
                }
                
                if ([sectionsToInsert count] > 0) {
                    [self.tableView insertSections:sectionsToInsert withRowAnimation:context.insertionAnimation];
                }
                if ([rowsToInsert count] > 0) {
                    [self.tableView insertRowsAtIndexPaths:rowsToInsert withRowAnimation:context.insertionAnimation];
                }
                
                [self.tableView endUpdates];
            } else {
                [self.tableView reloadData];
            }
        }
    }
}

- (void)collectDisappearedSectionIndices:(NSMutableIndexSet *)disappearedSectionIndices
             andDisappearedRowIndexPaths:(NSMutableArray *)disappearedRowIndexPaths
               andReloadedSectionIndices:(NSMutableIndexSet *)reloadedSectionIndices
                andReloadedRowIndexPaths:(NSMutableArray *)reloadedRowIndexPaths
                                 context:(TBTableDataUpdateContext *)context {
    NSInteger sectionIndex = 0;
    NSInteger rowIndex = 0;
    for (TBTableDataSection *section in self.sections) {
        if (!section.hidden) {
            BOOL isSectionDisappeared = NO;
            switch (section.updateStatus) {
                case TBUpdateStatusHidden:
                case TBUpdateStatusDeleted:
                    [disappearedSectionIndices addIndex:sectionIndex];
                    isSectionDisappeared = YES;
                    break;
                case TBUpdateStatusNotChanged:
                case TBUpdateStatusShown:
                    break;
            }
            if (!isSectionDisappeared) {
                if (context.reloadedSections != nil && [context.reloadedSections containsObject:section]) {
                    [reloadedSectionIndices addIndex:sectionIndex];
                }
            }
            
            rowIndex = 0;
            for (TBTableDataRow *row in section.rows) {
                if (!row.hidden) {
                    BOOL isRowDisappeared = NO;
                    switch (row.updateStatus) {
                        case TBUpdateStatusHidden:
                        case TBUpdateStatusDeleted:
                            [disappearedRowIndexPaths addObject:[NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex]];
                            isRowDisappeared = YES;
                            break;
                        case TBUpdateStatusNotChanged:
                        case TBUpdateStatusShown:
                            break;
                    }
                    if (!isRowDisappeared) {
                        if (context.reloadedRows != nil && [context.reloadedRows containsObject:row]) {
                            [reloadedRowIndexPaths addObject:[NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex]];
                        }
                    }
                    
                    ++rowIndex;
                }
            }
            ++sectionIndex;
        }
    }
}

- (void)collectAppearedSectionIndices:(NSMutableIndexSet *)sectionIndices
             andAppearedRowIndexPaths:(NSMutableArray *)rowIndexPaths
                              context:(TBTableDataUpdateContext *)context {
    NSInteger sectionIndex = 0;
    NSInteger rowIndex = 0;
    
    if (context.insertedSections != nil) {
        for (TBTableDataSection *insertedSection in context.insertedSections) {
            [self collectAppearedSectionIndices:sectionIndices inInsertedSection:insertedSection sectionIndex:&sectionIndex];
        }
    }
    for (TBTableDataSection *section in self.mutableSections) {
        rowIndex = 0;
        BOOL isSectionVisible = NO;
        switch (section.updateStatus) {
            case TBUpdateStatusNotChanged:
                if (!section.hidden) {
                    isSectionVisible = YES;
                }
                break;
            case TBUpdateStatusShown:
                if (section.hidden) {
                    [sectionIndices addIndex:sectionIndex];
                }
                isSectionVisible = YES;
                break;
            case TBUpdateStatusDeleted:
            case TBUpdateStatusHidden:
                break;
        }
        if (isSectionVisible) {
            if (section.insertedRows != nil) {
                for (TBTableDataRow *insertedRow in section.insertedRows) {
                    [self collectAppearedRowIndexPaths:rowIndexPaths
                                         inInsertedRow:insertedRow
                                          sectionIndex:sectionIndex
                                              rowIndex:&rowIndex];
                }
            }
            for (TBTableDataRow *row in section.mutableRows) {
                BOOL isRowVisible = NO;
                switch (row.updateStatus) {
                    case TBUpdateStatusNotChanged:
                        if (!row.hidden) {
                            isRowVisible = YES;
                        }
                        break;
                    case TBUpdateStatusShown:
                        if (row.hidden) {
                            [rowIndexPaths addObject:[NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex]];
                        }
                        isRowVisible = YES;
                        break;
                    case TBUpdateStatusDeleted:
                    case TBUpdateStatusHidden:
                        break;
                }
                if (isRowVisible) {
                    ++rowIndex;
                }
                if (row.insertedRows != nil) {
                    for (TBTableDataRow *insertedRow in row.insertedRows) {
                        [self collectAppearedRowIndexPaths:rowIndexPaths
                                             inInsertedRow:insertedRow
                                              sectionIndex:sectionIndex
                                                  rowIndex:&rowIndex];
                    }
                }
            }
            
            ++sectionIndex;
        }
        if (section.insertedSections != nil) {
            for (TBTableDataSection *insertedSection in section.insertedSections) {
                [self collectAppearedSectionIndices:sectionIndices inInsertedSection:insertedSection sectionIndex:&sectionIndex];
            }
        }
    }
}

- (void)collectAppearedSectionIndices:(NSMutableIndexSet *)sectionIndices
                    inInsertedSection:(TBTableDataSection *)section
                         sectionIndex:(NSInteger *)sectionIndex {
    BOOL isSectionVisible = NO;
    switch (section.updateStatus) {
        case TBUpdateStatusNotChanged:
            if (!section.hidden) {
                [sectionIndices addIndex:*sectionIndex];
                isSectionVisible = YES;
            }
            break;
        case TBUpdateStatusShown:
            [sectionIndices addIndex:*sectionIndex];
            isSectionVisible = YES;
            break;
        case TBUpdateStatusDeleted:
        case TBUpdateStatusHidden:
            break;
    }
    if (isSectionVisible) {
        *sectionIndex = *sectionIndex + 1;
    }
    if (section.insertedSections != nil) {
        for (TBTableDataSection *insertedSection in section.insertedSections) {
            [self collectAppearedSectionIndices:sectionIndices inInsertedSection:insertedSection sectionIndex:sectionIndex];
        }
    }
}

- (void)collectAppearedRowIndexPaths:(NSMutableArray *)rowIndexPaths
                       inInsertedRow:(TBTableDataRow *)row
                        sectionIndex:(NSInteger)sectionIndex
                            rowIndex:(NSInteger *)rowIndex {
    BOOL isRowVisible = NO;
    switch (row.updateStatus) {
        case TBUpdateStatusNotChanged:
            if (!row.hidden) {
                [rowIndexPaths addObject:[NSIndexPath indexPathForRow:*rowIndex inSection:sectionIndex]];
                isRowVisible = YES;
            }
            break;
        case TBUpdateStatusShown:
            [rowIndexPaths addObject:[NSIndexPath indexPathForRow:*rowIndex inSection:sectionIndex]];
            isRowVisible = YES;
            break;
        case TBUpdateStatusDeleted:
        case TBUpdateStatusHidden:
            break;
    }
    if (isRowVisible) {
        *rowIndex = *rowIndex + 1;
    }
    if (row.insertedRows != nil) {
        for (TBTableDataRow *insertedRow in row.insertedRows) {
            [self collectAppearedRowIndexPaths:rowIndexPaths inInsertedRow:insertedRow sectionIndex:sectionIndex rowIndex:rowIndex];
        }
    }
}

- (void)reflectUpdate:(TBTableDataUpdateContext *)context {
    NSInteger sectionIndex = 0;
    NSInteger rowIndex = 0;

    if (context.insertedSections != nil) {
        for (TBTableDataSection *insertedSection in context.insertedSections) {
            [self reflectInsertedSection:insertedSection sectionIndex:&sectionIndex];
        }
        context.insertedSections = nil;
    }
    while (sectionIndex < [self.mutableSections count]) {
        TBTableDataSection *section = [self.mutableSections objectAtIndex:sectionIndex];
        rowIndex = 0;
        BOOL isSectionDeleted = NO;
        switch (section.updateStatus) {
            case TBUpdateStatusDeleted:
                [self.mutableSections removeObjectAtIndex:sectionIndex];
                isSectionDeleted = YES;
                break;
            case TBUpdateStatusShown:
                section.hidden = NO;
                break;
            case TBUpdateStatusHidden:
                section.hidden = YES;
                break;
            case TBUpdateStatusNotChanged:
                break;
        }
        section.updateStatus = TBUpdateStatusNotChanged;

        if (section.insertedRows != nil) {
            for (TBTableDataRow *insertedRow in section.insertedRows) {
                [self reflectInsertedRow:insertedRow inSection:section rowIndex:&rowIndex];
            }
            section.insertedRows = nil;
        }
        while (rowIndex < [section.mutableRows count]) {
            TBTableDataRow *row = [section.mutableRows objectAtIndex:rowIndex];
            BOOL isRowDeleted = NO;
            switch (row.updateStatus) {
                case TBUpdateStatusDeleted:
                    [section.mutableRows removeObjectAtIndex:rowIndex];
                    isRowDeleted = YES;
                    break;
                case TBUpdateStatusShown:
                    row.hidden = NO;
                    break;
                case TBUpdateStatusHidden:
                    row.hidden = YES;
                    break;
                case TBUpdateStatusNotChanged:
                    break;
            }
            row.updateStatus = TBUpdateStatusNotChanged;
            if (!isRowDeleted) {
                ++rowIndex;
            }
            if (row.insertedRows != nil) {
                for (TBTableDataRow *insertedRow in row.insertedRows) {
                    [self reflectInsertedRow:insertedRow inSection:section rowIndex:&rowIndex];
                }
                row.insertedRows = nil;
            }
        }
        
        if (!isSectionDeleted) {
            ++sectionIndex;
        }
        if (section.insertedSections != nil) {
            for (TBTableDataSection *insertedSection in section.insertedSections) {
                [self reflectInsertedSection:insertedSection sectionIndex:&sectionIndex];
            }
            section.insertedSections = nil;
        }
    }
}

- (void)reflectInsertedSection:(TBTableDataSection *)section sectionIndex:(NSInteger *)sectionIndex {
    switch (section.updateStatus) {
        case TBUpdateStatusNotChanged:
            [self.mutableSections insertObject:section atIndex:*sectionIndex];
            *sectionIndex = *sectionIndex + 1;
            break;
        case TBUpdateStatusShown:
            section.hidden = NO;
            [self.mutableSections insertObject:section atIndex:*sectionIndex];
            *sectionIndex = *sectionIndex + 1;
            break;
        case TBUpdateStatusHidden:
            section.hidden = YES;
            [self.mutableSections insertObject:section atIndex:*sectionIndex];
            *sectionIndex = *sectionIndex + 1;
            break;
        case TBUpdateStatusDeleted:
            break;
    }
    section.updateStatus = TBUpdateStatusNotChanged;
    if (section.insertedSections != nil) {
        for (TBTableDataSection *insertedSection in section.insertedSections) {
            [self reflectInsertedSection:insertedSection sectionIndex:sectionIndex];
        }
        section.insertedSections = nil;
    }
}

- (void)reflectInsertedRow:(TBTableDataRow *)row
                 inSection:(TBTableDataSection *)section
                  rowIndex:(NSInteger *)rowIndex {
    switch (row.updateStatus) {
        case TBUpdateStatusNotChanged:
            [section.mutableRows insertObject:row atIndex:*rowIndex];
            *rowIndex = *rowIndex + 1;
            break;
        case TBUpdateStatusShown:
            row.hidden = NO;
            [section.mutableRows insertObject:row atIndex:*rowIndex];
            *rowIndex = *rowIndex + 1;
            break;
        case TBUpdateStatusHidden:
            row.hidden = YES;
            [section.mutableRows insertObject:row atIndex:*rowIndex];
            *rowIndex = *rowIndex + 1;
            break;
        case TBUpdateStatusDeleted:
            break;
    }
    row.updateStatus = TBUpdateStatusNotChanged;
    if (row.insertedRows != nil) {
        for (TBTableDataRow *insertedRow in row.insertedRows) {
            [self reflectInsertedRow:insertedRow inSection:section rowIndex:rowIndex];
        }
        row.insertedRows = nil;
    }
}

- (TBTableDataSection *)withContext:(TBTableDataContext *)context
                 insertSectionAfter:(TBTableDataSection *)previousSection
                          generator:(TBTableDataSection *(^)(TBTableDataInitializationContext *context))generator {
    TBTableDataInitializationContext *initializationContext = [[TBTableDataInitializationContext alloc] init];
    initializationContext.tableData = self;
    TBTableDataSection *section = generator(initializationContext);
    
    if ([context isKindOfClass:[TBTableDataInitializationContext class]]) {
        if (previousSection == nil) {
            [self.mutableSections insertObject:section atIndex:0];
        } else if ([previousSection isEqual:[self.mutableSections lastObject]]) {
            [self.mutableSections addObject:section];
        } else {
            NSUInteger index = [self.mutableSections indexOfObject:previousSection];
            if (index != NSNotFound) {
                [self.mutableSections insertObject:section atIndex:index + 1];
            }
        }
    } else if ([context isKindOfClass:[TBTableDataUpdateContext class]]) {
        TBTableDataUpdateContext *updateContext = (TBTableDataUpdateContext *)context;
        if (previousSection == nil) {
            if (updateContext.insertedSections == nil) {
                updateContext.insertedSections = [[NSMutableArray alloc] init];
            }
            [updateContext.insertedSections insertObject:section atIndex:0];
        } else {
            if (previousSection.insertedSections == nil) {
                previousSection.insertedSections = [[NSMutableArray alloc] init];
            }
            [previousSection.insertedSections insertObject:section atIndex:0];
        }
    }
    
    return section;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = 0;
    for (TBTableDataSection *section in self.sections) {
        if (!section.hidden) {
            ++count;
        }
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    TBTableDataSection *section = [self visibleSectionAtSectionIndex:sectionIndex];
    if (section != nil) {
        NSInteger count = 0;
        for (TBTableDataRow *row in section.rows) {
            if (!row.hidden) {
                ++count;
            }
        }
        return count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TBTableDataRow *row = [self visibleRowAtIndexPath:indexPath];
    if (row != nil) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:row.reuseIdentifier];
        if (cell == nil) {
            cell = [row createTableViewCell];
        }
        [row configureTableViewCell:cell];
        return cell;
    }
    return nil;
}

#pragma mark UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TBTableDataRow *row = [self visibleRowAtIndexPath:indexPath];
    if (row == nil || !row.enabled) {
        return nil;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TBTableDataRow *row = [self visibleRowAtIndexPath:indexPath];
    if (row != nil) {
        [row rowDidTapInTableView:tableView AtIndexPath:indexPath];
    }
}

@end
