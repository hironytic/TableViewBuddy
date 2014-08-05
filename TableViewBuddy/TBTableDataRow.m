//
// TBTableDataRow.m
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

#import "TBTableDataRow.h"
#import "TBTableDataRow_Internal.h"
#import "TBTableDataContext_Internal.h"
#import "TBTableDataSection_Internal.h"

@implementation TBTableDataRow

@synthesize section = _section;
@synthesize hidden = _hidden;

@synthesize updateStatus = _updateStatus;
@synthesize insertedRows = _insertedRows;

+ (TBTableDataRow *(^)(TBTableDataInitializationContext *context))generatorWithConfigurator:(void (^)(TBTableDataInitializationContext *context))configurator {
    return ^TBTableDataRow *(TBTableDataInitializationContext *context) {
        return [self rowWithContext:context configurator:configurator];
    };
}

+ (instancetype)rowWithContext:(TBTableDataInitializationContext *)context configurator:(void (^)(TBTableDataInitializationContext *context))configurator {
    return [[[self class] alloc] initWithContext:context configurator:configurator];
}

- (instancetype)initWithContext:(TBTableDataInitializationContext *)context configurator:(void (^)(TBTableDataInitializationContext *context))configurator {
    self = [super init];
    if (self != nil) {
        _section = context.section;
        
        TBTableDataRow *originalRow = context.row;
        context.row = self;
        configurator(context);
        context.row = originalRow;
    }
    return self;
}

- (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

- (UITableViewCell *)createTableViewCell {
    // to be overridden
    return nil;
}

- (void)configureTableViewCell:(UITableViewCell *)cell {
    // to be overridden
}

- (void)rowDidTapInTableView:(UITableView *)tableView AtIndexPath:(NSIndexPath *)indexPath {
    // to be overridden if needed
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)withContext:(TBTableDataContext *)context setHidden:(BOOL)hidden {
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