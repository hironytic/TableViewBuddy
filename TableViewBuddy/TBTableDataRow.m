//
// TBTableDataRow.m
// TableViewBuddy
//
// Copyright (c) 2014,2015 Hironori Ichimiya <hiron@hironytic.com>
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

#import "TBTableDataRow.h"
#import "TBTableDataRow_Internal.h"
#import "TBTableData.h"
#import "TBTableDataContext_Internal.h"
#import "TBTableDataSection_Internal.h"
#import "TBTableViewCell.h"

@implementation TBTableDataRow

+ (TBTableDataRow *(^)(TBTableDataInitializationContext *context))rowGeneratorWithConfigurator:(void (^)(TBTableDataInitializationContext *context))configurator {
    return ^TBTableDataRow *(TBTableDataInitializationContext *context) {
        TBTableDataRow *row = [[self alloc] initWithContext:context];
        if (row != nil) {
            TBTableDataRow *originalRow = context.row;
            context.row = row;
            configurator(context);
            context.row = originalRow;
        }
        return row;
    };
}

- (instancetype)initWithContext:(TBTableDataInitializationContext *)context {
    self = [super init];
    if (self != nil) {
        _enabled = YES;
        _section = context.section;
    }
    return self;
}

- (NSIndexPath *)rowIndexPath {
    if (self.hidden) {
        return nil;
    }
    
    NSInteger sectionIndex = self.section.sectionIndex;
    if (sectionIndex == NSNotFound) {
        return nil;
    }
    
    NSInteger rowIndex = 0;
    for (TBTableDataRow *row in self.section.rows) {
        if (!row.hidden) {
            if (row == self) {
                return [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
            }
            
            ++rowIndex;
        }
    }
    return nil;
}

- (UITableViewCell *)findVisibleCell {
    if (self.section.tableData.tableView != nil) {
        NSIndexPath *indexPath = [self rowIndexPath];
        if (indexPath != nil) {
            NSArray *visibleCellsIndexPaths = [self.section.tableData.tableView indexPathsForVisibleRows];
            if ([visibleCellsIndexPaths containsObject:indexPath]) {
                UITableViewCell *cell = [self.section.tableData.tableView cellForRowAtIndexPath:indexPath];
                return cell;
            }
        }
    }
    return nil;
}

- (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

- (UITableViewCell *)createTableViewCell {
    // to be overridden
    return nil;
}

- (void)configureTableViewCell:(UITableViewCell *)cell {
    if ([cell isKindOfClass:[TBTableViewCell class]]) {
        [(TBTableViewCell *)cell setAvailable:self.enabled];
    }
    
    cell.textLabel.text = (self.title != nil) ? self.title : @"";
    cell.imageView.image = self.image;
    [cell setNeedsLayout];
}

- (void)rowDidTapInTableView:(UITableView *)tableView AtIndexPath:(NSIndexPath *)indexPath {
    // to be overridden if needed
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)setHidden:(BOOL)hidden withContext:(TBTableDataContext *)context {
    if ([context isKindOfClass:[TBTableDataInitializationContext class]]) {
        self.hidden = hidden;
    } else if ([context isKindOfClass:[TBTableDataUpdateContext class]]) {
        if (hidden) {
            switch (self.updateStatus) {
                case TBUpdateStatusNotChanged:
                case TBUpdateStatusHidden:
                case TBUpdateStatusShown:
                    self.updateStatus = TBUpdateStatusHidden;
                    break;
                case TBUpdateStatusDeleted:
                    break;
            }
        } else {
            switch (self.updateStatus) {
                case TBUpdateStatusNotChanged:
                case TBUpdateStatusHidden:
                case TBUpdateStatusShown:
                    self.updateStatus = TBUpdateStatusShown;
                    break;
                case TBUpdateStatusDeleted:
                    break;
            }
        }
    }
}

- (void)setEnabled:(BOOL)enabled withContext:(TBTableDataContext *)context {
    _enabled = enabled;

    if (![context isKindOfClass:[TBTableDataInitializationContext class]]) {
        UITableViewCell *cell = [self findVisibleCell];
        if (cell != nil && [cell isKindOfClass:[TBTableViewCell class]]) {
            [(TBTableViewCell *)cell setAvailable:enabled];
        }
    }
}

- (void)setImage:(UIImage *)image withContext:(TBTableDataContext *)context {
    _image = image;
    
    if (![context isKindOfClass:[TBTableDataInitializationContext class]]) {
        UITableViewCell *cell = [self findVisibleCell];
        if (cell != nil) {
            cell.imageView.image = image;
            [cell setNeedsLayout];
        }
    }
}

- (void)setTitle:(NSString *)title withContext:(TBTableDataContext *)context {
    _title = [title copy];
    
    if (![context isKindOfClass:[TBTableDataInitializationContext class]]) {
        UITableViewCell *cell = [self findVisibleCell];
        if (cell != nil) {
            cell.textLabel.text = (self.title != nil) ? self.title : @"";
            [cell setNeedsLayout];
        }
    }
}

- (void)reloadWithContext:(TBTableDataContext *)context {
    if ([context isKindOfClass:[TBTableDataUpdateContext class]]) {
        TBTableDataUpdateContext *updateContext = (TBTableDataUpdateContext *)context;
        
        if (updateContext.reloadedRows == nil) {
            updateContext.reloadedRows = [[NSMutableSet alloc] init];
        }
        [updateContext.reloadedRows addObject:self];
    }
}

- (void)deleteWithContext:(TBTableDataContext *)context {
    if ([context isKindOfClass:[TBTableDataInitializationContext class]]) {
        [self.section.mutableRows removeObject:self];
    } else if ([context isKindOfClass:[TBTableDataUpdateContext class]]) {
        switch (self.updateStatus) {
            case TBUpdateStatusNotChanged:
            case TBUpdateStatusHidden:
            case TBUpdateStatusShown:
            case TBUpdateStatusDeleted:
                self.updateStatus = TBUpdateStatusDeleted;
                break;
        }
    }
}

@end
