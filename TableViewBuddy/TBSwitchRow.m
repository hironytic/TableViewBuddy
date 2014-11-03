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
#import "TBTableDataContext.h"
#import "TBTableDataSection.h"

@implementation TBSwitchRow

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
        TBSwitchTableViewCell *cell = (TBSwitchTableViewCell *)[self findVisibleCell];
        if (cell != nil) {
            [cell setSwitchValue:value animated:YES];
            [cell layoutSubviews];
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
        _value = value;
        if (weakSelf.valueChangeHandler != nil) {
            weakSelf.valueChangeHandler(value);
        }
    };
    
    [cell layoutSubviews];
}

@end


@implementation TBTableDataBuildHelper (TBSwitchRow)
- (void)buildSwitchRow:(void (^)(TBSwitchRow *row))configurator {
    [self buildRowWithRowClass:[TBSwitchRow class] configurator:^(TBTableDataRow *row) {
        configurator((TBSwitchRow *)row);
    }];
}
@end
