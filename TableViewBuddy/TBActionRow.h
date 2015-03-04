//
// TBActionRow.h
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

#import "TBTableDataRow.h"
#import "TBTableDataBuilder.h"

/**
 `TBActionRow` is a row that user can tap and execute some action.
 */
@interface TBActionRow : TBTableDataRow

/**
 A block object which is called when the row is tapped.
 */
@property(nonatomic, copy) void (^tapHandler)();

@end


@interface TBTableDataBuilder (TBActionRow)
/**
 Builds a row of `<TBActionRow>`.
 
 @param configurator A block object which configure the row.
 */
- (void)buildActionRow:(void (^)(TBActionRow *row))configurator;
@end
