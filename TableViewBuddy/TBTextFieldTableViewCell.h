//
// TBTextFieldTableViewCell.h
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

#import "TBUntappableCell.h"

/**
 `TBTextFieldTableViewCell` represents a cell used by `<TBTextFieldRow>`.
 */
@interface TBTextFieldTableViewCell : TBUntappableCell

/**
 A string which is the value of the text field.
 */
@property(nonatomic, copy) NSString *text;

/**
 A `UITextField` object.
 */
@property(nonatomic, strong, readonly) UITextField *textField;


/**
 A block object which is called when UIControlEventEditingChanged control event is occured.
 */
@property(nonatomic, copy) void (^textFieldEditingChangedHandler)(UITextField *textField);


/**
 A block object which is called to ask if editing should begin.
 */
@property(nonatomic, copy) BOOL (^textFieldShouldBeginEditingHandler)(UITextField *textField);

/**
 A block object which is called to tell that editing began.
 */
@property(nonatomic, copy) void (^textFieldDidBeginEditingHandler)(UITextField *textField);

/**
 A block object which is called to asks if editing should stop.
 */
@property(nonatomic, copy) BOOL (^textFieldShouldEndEditingHandler)(UITextField *textField);

/**
 A block object which is called to tell that editing stopped.
 */
@property(nonatomic, copy) void (^textFieldDidEndEditingHandler)(UITextField *textField);

/**
 A block object which is called to ask if the specified text should be changed.
 */
@property(nonatomic, copy) BOOL (^textFieldShouldChangeCharactersHandler)(UITextField *textField, NSRange range, NSString *replacementString);

/**
 A block object which is called to ask if the text field's current contents should be removed.
 */
@property(nonatomic, copy) BOOL (^textFieldShouldClearHandler)(UITextField *textField);

/**
 A block object which is called to asks if the text field should process the pressing of the return button.
 */
@property(nonatomic, copy) BOOL (^textFieldShouldReturnHandler)(UITextField *textField);

@end
