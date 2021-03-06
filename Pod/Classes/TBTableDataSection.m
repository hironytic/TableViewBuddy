//
// TBTableDataSection.m
// TableViewBuddy
//
// Copyright (c) 2014-2016 Hironori Ichimiya <hiron@hironytic.com>
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

#import "TBTableDataSection.h"
#import "TBTableData_Internal.h"
#import "TBTableDataBuilder.h"
#import "TBTableDataContext_Internal.h"
#import "TBTableDataRow_Internal.h"
#import "TBTableDataSection_Internal.h"

@implementation TBTableDataSection

- (NSArray *)rows {
    return self.mutableRows;
}

+ (TBTableDataSection *(^)(TBTableDataInitializationContext *context))sectionGeneratorWithConfigurator:(void (^)(TBTableDataInitializationContext *context))configurator {
    return ^TBTableDataSection *(TBTableDataInitializationContext *context) {
        TBTableDataSection *section = [[self alloc] initWithContext:context];
        if (section != nil) {
            TBTableDataSection *originalSection = context.section;
            context.section = section;
            configurator(context);
            context.section = originalSection;
        }
        return section;
    };
}

- (instancetype)initWithContext:(TBTableDataInitializationContext *)context {
    self = [super init];
    if (nil != self) {
        _mutableRows = [[NSMutableArray alloc] init];
        _tableData = context.tableData;
    }
    return self;
}

- (TBTableDataRow *)rowAtUnhiddenRowIndex:(NSInteger)rowIndex {
    for (TBTableDataRow *row in self.rows) {
        if (!row.hidden) {
            if (rowIndex == 0) {
                return row;
            }
            --rowIndex;
        }
    }
    return nil;
}

- (NSInteger)sectionIndex {
    if (self.hidden) {
        return NSNotFound;
    }
    
    NSInteger sectionIndex = 0;
    for (TBTableDataSection *section in self.tableData.sections) {
        if (!section.hidden) {
            if (section == self) {
                return sectionIndex;
            }
            
            ++sectionIndex;
        }
    }
    return NSNotFound;
}

- (TBTableDataRow *)insertRowAfter:(TBTableDataRow *)previousRow
                       withContext:(TBTableDataContext *)context
                      generator:(TBTableDataRow *(^)(TBTableDataInitializationContext *context))generator {
    TBTableDataInitializationContext *initializationContext = [[TBTableDataInitializationContext alloc] init];
    initializationContext.tableData = self.tableData;
    initializationContext.section = self;
    TBTableDataRow *row = generator(initializationContext);
    
    if ([context isKindOfClass:[TBTableDataInitializationContext class]]) {
        if (previousRow == nil) {
            [self.mutableRows insertObject:row atIndex:0];
        } else if ([previousRow isEqual:[self.mutableRows lastObject]]) {
            [self.mutableRows addObject:row];
        } else {
            NSUInteger index = [self.mutableRows indexOfObject:previousRow];
            if (index != NSNotFound) {
                [self.mutableRows insertObject:row atIndex:index + 1];
            }
        }
    } else if ([context isKindOfClass:[TBTableDataUpdateContext class]]) {
        if (previousRow == nil) {
            if (self.insertedRows == nil) {
                self.insertedRows = [[NSMutableArray alloc] init];
            }
            [self.insertedRows insertObject:row atIndex:0];
        } else {
            if (previousRow.insertedRows == nil) {
                previousRow.insertedRows = [[NSMutableArray alloc] init];
            }
            [previousRow.insertedRows insertObject:row atIndex:0];
        }
    }
    
    return row;
}

- (void)insertAfter:(TBTableDataRow *)previousRow
        withContext:(TBTableDataContext *)context
         buildBlock:(void (^)(TBTableDataBuilder *builder))buildBlock {
    TBTableDataBuilder *builder = [[TBTableDataBuilder alloc] initWithContext:context section:self previousRow:previousRow];
    buildBlock(builder);
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

- (void)setHeaderTitle:(NSString *)headerTitle withContext:(TBTableDataContext *)context {
    if ([context isKindOfClass:[TBTableDataInitializationContext class]] || [context isKindOfClass:[TBTableDataUpdateContext class]]) {
        _headerTitle = headerTitle;
    }
    if ([context isKindOfClass:[TBTableDataUpdateContext class]]) {
        [self reloadWithContext:context];
    }
}

- (void)setFooterTitle:(NSString *)footerTitle withContext:(TBTableDataContext *)context {
    if ([context isKindOfClass:[TBTableDataInitializationContext class]] || [context isKindOfClass:[TBTableDataUpdateContext class]]) {
        _footerTitle = footerTitle;
    }
    if ([context isKindOfClass:[TBTableDataUpdateContext class]]) {
        [self reloadWithContext:context];
    }
}


- (void)reloadWithContext:(TBTableDataContext *)context {
    if ([context isKindOfClass:[TBTableDataUpdateContext class]]) {
        TBTableDataUpdateContext *updateContext = (TBTableDataUpdateContext *)context;
        
        if (updateContext.reloadedSections == nil) {
            updateContext.reloadedSections = [[NSMutableSet alloc] init];
        }
        [updateContext.reloadedSections addObject:self];
    }
}

- (void)deleteWithContext:(TBTableDataContext *)context {
    if ([context isKindOfClass:[TBTableDataInitializationContext class]]) {
        [self.tableData.mutableSections removeObject:self];
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
