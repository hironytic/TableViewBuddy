//
// TBTextFieldRow.h
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

#import "TBTableDataRow.h"
#import "TBTableDataBuilder.h"

/**
 `TBTextFieldRow` is a row that has a text field.
 */
@interface TBTextFieldRow : TBTableDataRow

/**
 A string which is the value of the text field.
 */
@property(nonatomic, copy, readonly) NSString *text;

/**
 A string which is shown in the text field when there is no other text in it.
 */
@property(nonatomic, copy, readonly) NSString *placeholder;

/**
 The width of the text field.
 */
@property(nonatomic, assign, readonly) CGFloat textFieldWidth;

/**
 Changes the text in the text field.
 
 @param text A string object.
 @param context A context object.
 */
- (void)setText:(NSString *)text withContext:(TBTableDataContext *)context;

/**
 Changes the placeholder text in the text field.
 
 @param placeholder A string object.
 @param context A context object.
 */
- (void)setPlaceholder:(NSString *)placeholder withContext:(TBTableDataContext *)context;

/**
 Changes the width of the text field.
 
 @param textFieldWidth A CGFloat value which specifies the width of the text field.
 @param context A context object.
 */
- (void)setTextFieldWidth:(CGFloat)textFieldWidth withContext:(TBTableDataContext *)context;

/**
 A block object which is called when the text in the text field is changed.
 
 The parameter of the block is a text in the text field.
 */
@property(nonatomic, copy) void (^textChangeHandler)(NSString *text);

/**
 A block object which is called in configuring the cell.
 
 Within this block, you can configure properties of the text field.
 */
@property(nonatomic, copy) void (^textFieldConfigulator)(UITextField *textField);

/**
 A block object which is called to ask if the text field should process the pressing of the return button.
 
 This block should return `YES` if the text field should do the default behavior; otherwise, `NO`.
 */
@property(nonatomic, copy) BOOL (^textFieldShouldReturnHandler)(UITextField *textField);

@end


@interface TBTableDataBuilder (TBTextFieldRow)
/**
 Builds a row of `<TBTextFieldRow>`.
 
 @param configurator A block object which configure the row.
 */
- (void)buildTextFieldRow:(void (^)(TBTextFieldRow *row))configurator;
@end
