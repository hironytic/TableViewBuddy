//
// TBCheckRow.m
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

#import "TBCheckRow.h"
#import "TBCheckRow_Internal.h"
#import "TBTableData.h"
#import "TBTableDataContext.h"
#import "TBTableDataSection.h"
#import "TBTableViewCell.h"

@implementation TBCheckRow

- (void)setTitle:(NSString *)title withContext:(TBTableDataContext *)context {
    _title = [title copy];
    
    if (![context isKindOfClass:[TBTableDataInitializationContext class]]) {
        UITableViewCell *cell = [self findVisibleCell];
        if (cell != nil) {
            cell.textLabel.text = (self.title != nil) ? self.title : @"";
            [cell layoutSubviews];
        }
    }
}

- (void)setValue:(BOOL)value withContext:(TBTableDataContext *)context {
    _value = value;
    
    if (![context isKindOfClass:[TBTableDataInitializationContext class]]) {
        UITableViewCell *cell = [self findVisibleCell];
        if (cell != nil) {
            cell.accessoryType = (value) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            [cell layoutSubviews];
        }
    }
}

- (UITableViewCell *)createTableViewCell {
    TBTableViewCell *cell = [[TBTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self reuseIdentifier]];
    return cell;
}

- (void)configureTableViewCell:(UITableViewCell *)cell {
    [super configureTableViewCell:cell];
    
    cell.textLabel.text = (self.title != nil) ? self.title : @"";
    cell.accessoryType = (self.value) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    [cell layoutSubviews];
}

- (void)rowDidTapInTableView:(UITableView *)tableView AtIndexPath:(NSIndexPath *)indexPath {
    [super rowDidTapInTableView:tableView AtIndexPath:indexPath];
    if ([self canChangeValueTo:!self.value]) {
        [self setValue:!self.value withContext:[TBTableDataContext context]];
        if (self.valueChangeHandler != nil) {
            self.valueChangeHandler(self.value);
        }
    }
}

- (BOOL)canChangeValueTo:(BOOL)value {
    return self.enabled;
}
@end


@implementation TBTableDataBuildHelper (TBCheckRow)
- (void)buildCheckRow:(void (^)(TBCheckRow *row))configurator {
    [self buildRowWithRowClass:[TBCheckRow class] configurator:^(TBTableDataRow *row) {
        configurator((TBCheckRow *)row);
    }];
}
@end
