//
// TBTextFieldTableViewCell.m
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

#import "TBTextFieldTableViewCell.h"

@interface TBTextFieldTableViewCell () <UITextFieldDelegate>
@property(nonatomic, strong) UITextField *textField;
@end

@implementation TBTextFieldTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 180, self.frame.size.height)];
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        self.accessoryView = _textField;
    }
    return self;
}

- (void)setAvailable:(BOOL)available {
    [super setAvailable:available];
    
    self.textLabel.enabled = available;
    self.textField.enabled = available;
}

- (NSString *)text {
    return self.textField.text;
}

- (void)setText:(NSString *)text {
    self.textField.text = text;
}

- (void)textFieldEditingChanged:(UITextField *)sender {
    if (self.textFieldEditingChangedHandler != nil) {
        self.textFieldEditingChangedHandler(sender);
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.textFieldShouldBeginEditingHandler != nil) {
        return self.textFieldShouldBeginEditingHandler(textField);
    } else {
        return YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.textFieldDidBeginEditingHandler != nil) {
        self.textFieldDidBeginEditingHandler(textField);
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.textFieldShouldEndEditingHandler != nil) {
        return self.textFieldShouldEndEditingHandler(textField);
    } else {
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.textFieldDidEndEditingHandler != nil) {
        self.textFieldDidEndEditingHandler(textField);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.textFieldShouldChangeCharactersHandler != nil) {
        return self.textFieldShouldChangeCharactersHandler(textField, range, string);
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (self.textFieldShouldClearHandler != nil) {
        return self.textFieldShouldClearHandler(textField);
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.textFieldShouldReturnHandler != nil) {
        return self.textFieldShouldReturnHandler(textField);
    } else {
        return YES;
    }
}

@end
