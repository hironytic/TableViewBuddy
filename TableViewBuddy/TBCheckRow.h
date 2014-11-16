//
// TBCheckRow.h
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
#import "TBTableDataBuildHelper.h"

/**
 `TBCheckRow` is a row that user can check or uncheck it by tapping.
 */
@interface TBCheckRow : TBTableDataRow

/**
 A string which is shown in the cell.
 */
@property(nonatomic, copy, readonly) NSString *title;

/**
 A boolean value that indicates whether checked or not.
 */
@property(nonatomic, assign, readonly) BOOL value;

/**
 Changes the text in the cell.
 
 @param title A string object.
 @param context A context object.
 */
- (void)setTitle:(NSString *)title withContext:(TBTableDataContext *)context;

/**
 Checks of unchecks the row.
 
 @param value A boolean value. Specify `YES` to check, or `NO to uncheck.
 @param context A context object.
 */
- (void)setValue:(BOOL)value withContext:(TBTableDataContext *)context;

/**
 A block object which is called when the checked state is changed.
 
 The parameter of the block is an boolean value that indicates the row have been checked or not.
 */
@property(nonatomic, copy) void (^valueChangeHandler)(BOOL value);

@end


@interface TBTableDataBuildHelper (TBCheckRow)
/**
 Build a row of `TBCheckRow`.
 
 @param configurator A block object which configure the row.
 */
- (void)buildCheckRow:(void (^)(TBCheckRow *row))configurator;
@end
