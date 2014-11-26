//
// TBLabelRow.h
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
 `TBLabelRow` is a row that displays an information. The tap gesture is not handled in it.
 */
@interface TBLabelRow : TBTableDataRow

/**
 A secondary string which is shown in the cell.
 */
@property(nonatomic, copy, readonly) NSString *detailText;

/**
 Changes the secondary text in the cell.
 
 @param detailText A string object.
 @param context A context object.
 */
- (void)setDetailText:(NSString *)detailText withContext:(TBTableDataContext *)context;

@end


@interface TBTableDataBuildHelper (TBLabelRow)
/**
 Builds a row of `<TBLabelRow>`.
 
 @param configurator A block object which configure the row.
 */
- (void)buildLabelRow:(void (^)(TBLabelRow *row))configurator;
@end
