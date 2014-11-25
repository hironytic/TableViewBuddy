//
// TBNavigationRow.h
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
 `TBNavigationRow` is a row that yields next screen by tapping it.
 
 Note that this class has no function to show next screen.
 It just has a look and feel to navigate, i.e. it has a disclosure indicator.
 You should write your code in the block which is set to `<tapHandler>` property.
 */
@interface TBNavigationRow : TBTableDataRow

/**
 A string which is shown in the cell.
 */
@property(nonatomic, copy, readonly) NSString *title;

/**
 A secondary string which is shown in the cell.
 */
@property(nonatomic, copy, readonly) NSString *detailText;

/**
 Changes the text in the cell.
 
 @param title A string object.
 @param context A context object.
 */
- (void)setTitle:(NSString *)title withContext:(TBTableDataContext *)context;

/**
 Changes the secondary text in the cell.
 
 @param detailText A string object.
 @param context A context object.
 */
- (void)setDetailText:(NSString *)detailText withContext:(TBTableDataContext *)context;

/**
 A block object which is called when the row is tapped.
 */
@property(nonatomic, copy) void (^tapHandler)();

@end


@interface TBTableDataBuildHelper (TBNavigationRow)
/**
 Builds a row of `<TBNavigationRow>`.
 
 @param configurator A block object which configure the row.
 */
- (void)buildNavigationRow:(void (^)(TBNavigationRow *row))configurator;
@end
