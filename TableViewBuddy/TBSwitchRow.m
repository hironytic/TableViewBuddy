//
// TBSwitchRow.m
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

#import "TBSwitchRow.h"
#import "TBSwitchTableViewCell.h"
#import "TBTableData.h"
#import "TBTableDataSection.h"

@implementation TBSwitchRow

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    
    NSIndexPath *indexPath = [self rowIndexPath];
    if (indexPath != nil) {
        NSArray *visibleCellsIndexPaths = [self.section.tableData.tableView indexPathsForVisibleRows];
        if ([visibleCellsIndexPaths containsObject:indexPath]) {
            UITableViewCell *cell = [self.section.tableData.tableView cellForRowAtIndexPath:indexPath];
            if (cell != nil) {
                cell.textLabel.text = (self.title != nil) ? self.title : @"";
                [cell layoutSubviews];
            }
        }
    }
}

- (UITableViewCell *)createTableViewCell {
    TBSwitchTableViewCell *cell = [[TBSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self reuseIdentifier]];
    return cell;
}

- (void)configureTableViewCell:(UITableViewCell *)cell {
    [super configureTableViewCell:cell];
    
    TBSwitchTableViewCell *switchCell = (TBSwitchTableViewCell *)cell;
    switchCell.textLabel.text = (self.title != nil) ? self.title : @"";
    switchCell.switchValue = self.value;
    
    TBSwitchRow * __weak weakSelf = self;
    switchCell.switchValueChanged = ^(BOOL value){
        weakSelf.value = value;
        if (self.valueChangeHandler != nil) {
            self.valueChangeHandler(value);
        }
    };
    
    [cell layoutSubviews];
}

@end
