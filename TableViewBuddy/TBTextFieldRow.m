//
// TBTextFieldRow.m
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

#import "TBTextFieldRow.h"
#import "TBTextFieldTableViewCell.h"
#import "TBTableData.h"
#import "TBTableDataContext.h"
#import "TBTableDataSection.h"

@implementation TBTextFieldRow

- (instancetype)initWithContext:(TBTableDataInitializationContext *)context {
    self = [super initWithContext:context];
    if (self != nil) {
        _textFieldWidth = 180;
    }
    return self;
}

- (void)setText:(NSString *)text withContext:(TBTableDataContext *)context {
    _text = text;
    
    if (![context isKindOfClass:[TBTableDataInitializationContext class]]) {
        TBTextFieldTableViewCell *cell = (TBTextFieldTableViewCell *)[self findVisibleCell];
        if (cell != nil) {
            cell.textField.text = (self.text != nil) ? self.text : @"";
            [cell layoutSubviews];
        }
    }
}

- (void)setPlaceholder:(NSString *)placeholder withContext:(TBTableDataContext *)context {
    _placeholder = placeholder;
    
    if (![context isKindOfClass:[TBTableDataInitializationContext class]]) {
        TBTextFieldTableViewCell *cell = (TBTextFieldTableViewCell *)[self findVisibleCell];
        if (cell != nil) {
            cell.textField.placeholder = placeholder;
            [cell layoutSubviews];
        }
    }
}

- (void)setTextFieldWidth:(CGFloat)textFieldWidth withContext:(TBTableDataContext *)context {
    _textFieldWidth = textFieldWidth;

    if (![context isKindOfClass:[TBTableDataInitializationContext class]]) {
        TBTextFieldTableViewCell *cell = (TBTextFieldTableViewCell *)[self findVisibleCell];
        if (cell != nil) {
            CGRect textFieldFrame = cell.textField.frame;
            textFieldFrame.size.width = textFieldWidth;
            cell.textField.frame = textFieldFrame;
            [cell layoutSubviews];
        }
    }
}

- (UITableViewCell *)createTableViewCell {
    TBTextFieldTableViewCell *cell = [[TBTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self reuseIdentifier]];
    return cell;
}

- (void)configureTableViewCell:(UITableViewCell *)cell {
    [super configureTableViewCell:cell];
    
    TBTextFieldTableViewCell *textFieldCell = (TBTextFieldTableViewCell *)cell;
    textFieldCell.textField.text = (self.text != nil) ? self.text : @"";
    textFieldCell.textField.placeholder = self.placeholder;
    if (self.textFieldConfigulator != nil) {
        self.textFieldConfigulator(textFieldCell.textField);
    }
    
    CGRect textFieldFrame = textFieldCell.textField.frame;
    textFieldFrame.size.width = _textFieldWidth;
    textFieldCell.textField.frame = textFieldFrame;
    
    TBTextFieldRow * __weak weakSelf = self;
    textFieldCell.textFieldEditingChangedHandler = ^(UITextField *textField) {
        _text = textField.text;
        if (weakSelf.textChangeHandler != nil) {
            weakSelf.textChangeHandler(textField.text);
        }
    };
    textFieldCell.textFieldShouldReturnHandler = ^BOOL (UITextField *textField) {
        if (weakSelf.textFieldShouldReturnHandler != nil) {
            return weakSelf.textFieldShouldReturnHandler(textField);
        } else {
            return YES;
        }
    };
    
    [cell layoutSubviews];
}

@end


@implementation TBTableDataBuildHelper (TBTextFieldRow)
- (void)buildTextFieldRow:(void (^)(TBTextFieldRow *row))configurator {
    [self buildRowWithRowClass:[TBTextFieldRow class] configurator:^(TBTableDataRow *row) {
        configurator((TBTextFieldRow *)row);
    }];
}
@end
