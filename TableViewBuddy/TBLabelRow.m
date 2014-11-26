//
// TBLabelRow.m
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

#import "TBLabelRow.h"
#import "TBLabelTableViewCell.h"
#import "TBTableData.h"
#import "TBTableDataContext.h"
#import "TBTableDataSection.h"

@implementation TBLabelRow

- (void)setDetailText:(NSString *)detailText withContext:(TBTableDataContext *)context {
    _detailText = [detailText copy];
    
    if (![context isKindOfClass:[TBTableDataInitializationContext class]]) {
        UITableViewCell *cell = [self findVisibleCell];
        if (cell != nil) {
            cell.detailTextLabel.text = (self.detailText != nil) ? self.detailText : @"";
            [cell layoutSubviews];
        }
    }
}

- (UITableViewCell *)createTableViewCell {
    TBLabelTableViewCell *cell = [[TBLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[self reuseIdentifier]];
    return cell;
}

- (void)configureTableViewCell:(UITableViewCell *)cell {
    [super configureTableViewCell:cell];
    cell.detailTextLabel.text = (self.detailText != nil) ? self.detailText : @"";
    [cell layoutSubviews];
}

@end


@implementation TBTableDataBuildHelper (TBLabelRow)
- (void)buildLabelRow:(void (^)(TBLabelRow *row))configurator {
    [self buildRowWithRowClass:[TBLabelRow class] configurator:^(TBTableDataRow *row) {
        configurator((TBLabelRow *)row);
    }];
}
@end
