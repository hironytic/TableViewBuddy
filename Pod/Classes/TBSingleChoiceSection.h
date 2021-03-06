//
// TBSingleChoiceSection.h
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

#import "TBTableDataSection.h"
#import "TBTableDataBuilder.h"

/**
 `TBSingleChoiceSection` is a section that have options list in it.
 Each option is represented as `<TBChoiceRow>` and user can choose a one option by tapping it.
 */
@interface TBSingleChoiceSection : TBTableDataSection

/**
 A list of options.
 */
@property(nonatomic, copy, readonly) NSArray *options;

/**
 An index of selected option in `<options>` list, or `NSNotFound` if there is no selected option.
 */
@property(nonatomic, assign, readonly) NSInteger selectedIndex;

/**
 Sets a list of options and specify which one is selected.
 
 If the option is a string, it is used as title of the row.
 If the option is not a string but has a method `stringValue` that returns string, the return value of the method is used as title.
 Otherwise the return value of `[option valueForKey:@"title"]` is used as title and `[option valueForKey:@"image"]` is used as image.
 If `[option valueForKey:@"title"]` returns nil, `description` is used.
 
 @param options A list of options.
 @param selectedIndex An index of selected option in the list, or `NSNotFound` to clear the selection.
 @param context A context object. `<TBTableDataInitializationContext>` object is required.
 */
- (void)setOptions:(NSArray *)options selectedIndex:(NSInteger)selectedIndex withContext:(TBTableDataContext *)context;

/**
 Changes the selected option.
 
 @param selectedIndex An index of selected option in the list, or `NSNotFound` to clear the selection.
 @param context A context object.
 */
- (void)setSelectedIndex:(NSInteger)selectedIndex withContext:(TBTableDataContext *)context;

/**
 A block object which is called when selected options is changed.
 
 The parameter of the block is an index of the selected option (same as `<selectedIndex>`).
 */
@property(nonatomic, copy) void (^selectionChangeHandler)(NSInteger selectedIndex);

@end


@interface TBTableDataBuilder (TBSingleChoiceSection)
/**
 Builds a section of `<TBSingleChoiceSection>`.
 
 @param configurator A block object which configure the section.
 */
- (void)buildSingleChoiceSection:(void (^)(TBSingleChoiceSection *section))configurator;
@end
