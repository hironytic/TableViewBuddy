//
// TBSingleChoiceNavigationRow.h
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

#import "TBNavigationRow.h"

@class TBTableDataContext;

/**
 `TBSingleChoiceNavigationRow` is a row that user can choose a option by tapping it.
 
 This class is a combination of `<TBNavigationRow>` and `<TBSingleChoiceSection>`.
 On the row of this class, the selected option is automatically set to secondary text
 with a disclosure indicator mark.
 
 You must specify your navigation controller by either `<navigationController>` or `<navigationControllerBlock>`.
 When user taps the row, the next view controller with the options list is pushed to it.
 */
@interface TBSingleChoiceNavigationRow : TBNavigationRow

/**
 A `UINavigationController` object which is used to push the next view controller.
 If this property is nil, the navigation controller is retrieved from `<navigationControllerBlock>`.
 */
@property(nonatomic, weak) UINavigationController *navigationController;

/**
 A block returns a `UINavigationController` object which is used to push the next view controller.
 If this property is nil, `<navigationController>` is used for the navigation controller.
 */
@property(nonatomic, copy) UINavigationController *(^navigationControllerBlock)();

/**
 A string which is used as the title of the next view controller.
 */
@property(nonatomic, copy, readonly) NSString *choiceViewControllerTitle;

/**
 A string which is used as the accessibility identifier of the table view in the next view controller
 */
@property(nonatomic, copy, readonly) NSString *choiceTableAccessibilityIdentifier;

/**
 A string which is used as the section header of the options list on next view controller.
 */
@property(nonatomic, copy, readonly) NSString *choiceSectionHeaderTitle;

/**
 A string which is used as the section footer of the options list on next view controller.
 */
@property(nonatomic, copy, readonly) NSString *choiceSectionFooterTitle;

/**
 A list of options.
 */
@property(nonatomic, copy, readonly) NSArray *options;

/**
 An index of selected option in `<options>` list.
 */
@property(nonatomic, assign, readonly) NSInteger selectedIndex;

/**
 Sets a title string of the next view controller.
 
 @param choiceViewControllerTitle A string which is used as the title.
 @param context A context object. `<TBTableDataInitializationContext>` object is required.
 */
- (void)setChoiceViewControllerTitle:(NSString *)choiceViewControllerTitle withContext:(TBTableDataContext *)context;

/**
 Sets an accessibility identifier of the table view in the next view controller.
 
 @param choiceTableAccessibilityIdentifier A string which is used as the accessibility identifier.
 @param context A context object. `<TBTableDataInitializationContext>` object is required.
 */
- (void)setChoiceTableAccessibilityIdentifier:(NSString *)choiceTableAccessibilityIdentifier withContext:(TBTableDataContext *)context;

/**
 Sets a section header of the options list on next view controller.
 
 @param choiceSectionHeaderTitle A string which is used as the header.
 @param context A context object. `<TBTableDataInitializationContext>` object is required.
 */
- (void)setChoiceSectionHeaderTitle:(NSString *)choiceSectionHeaderTitle withContext:(TBTableDataContext *)context;

/**
 Sets a section footer of the options list on next view controller.
 
 @param choiceSectionFooterTitle A string which is used as the footer.
 @param context A context object. `<TBTableDataInitializationContext>` object is required.
 */
- (void)setChoiceSectionFooterTitle:(NSString *)choiceSectionFooterTitle withContext:(TBTableDataContext *)context;

/**
 Sets a list of options and specify which one is selected.
 
 If the option is a string, it is used as title of the row.
 If the option is not a string and it has method `stringValue` that returns string, the return value of the method is used as title.
 Otherwise `description`` is used.
 
 @param options A list of options.
 @param selectedIndex An index of selected option in the list
 @param context A context object. `<TBTableDataInitializationContext>` object is required.
 */
- (void)setOptions:(NSArray *)options selectedIndex:(NSInteger)selectedIndex withContext:(TBTableDataContext *)context;

/**
 Changes the selected option.
 
 @param selectedIndex An index of selected option in the list.
 @param context A context object.
 */
- (void)setSelectedIndex:(NSInteger)selectedIndex withContext:(TBTableDataContext *)context;

/**
 A block object which is called when selected options is changed.
 
 The parameter of the block is an index of the selected option (same as `<selectedIndex>`).
 */
@property(nonatomic, copy) void (^selectionChangeHandler)(NSInteger selectedIndex);

@end


@interface TBTableDataBuilder (TBSingleChoiceNavigationRow)
/**
 Builds a row of `<TBSingleChoiceNavigationRow>`.
 
 @param configurator A block object which configure the row.
 */
- (void)buildSingleChoiceNavigationRow:(void (^)(TBSingleChoiceNavigationRow *row))configurator;
@end
