//
// TBSingleChoiceSection.h
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

#import "TBTableDataSection.h"
#import "TBTableDataBuildHelper.h"

@interface TBSingleChoiceSection : TBTableDataSection

@property(nonatomic, copy, readonly) NSArray *options;
@property(nonatomic, assign, readonly) NSInteger selectedIndex;

- (void)setOptions:(NSArray *)options selectedIndex:(NSInteger)selectedIndex withContext:(TBTableDataContext *)context;
- (void)setSelectedIndex:(NSInteger)selectedIndex withContext:(TBTableDataContext *)context;

@property(nonatomic, copy) void (^selectionChangeHandler)(NSInteger selectedIndex);

@end


@interface TBTableDataBuildHelper (TBSingleChoiceSection)
- (void)buildSingleChoiceSection:(void (^)(TBSingleChoiceSection *section))configurator;
@end
