//
// TBTableDataContext_Internal.h
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

#import "TBTableDataContext.h"

@class TBTableData;
@class TBTableDataRow;
@class TBTableDataSection;

@interface TBTableDataInitializationContext ()

@property(nonatomic, strong) TBTableData *tableData;
@property(nonatomic, strong) TBTableDataSection *section;
@property(nonatomic, strong) TBTableDataRow *row;

@end


@interface TBTableDataUpdateContext ()

@property(nonatomic, strong) NSMutableArray *insertedSections;
@property(nonatomic, strong) NSMutableSet *reloadedSections;
@property(nonatomic, strong) NSMutableSet *reloadedRows;

@end
