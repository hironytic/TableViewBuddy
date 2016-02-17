//
// TBTableData.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TBTableDataBuilder;
@class TBTableDataContext;
@class TBTableDataInitializationContext;
@class TBTableDataRow;
@class TBTableDataSection;
@class TBTableDataUpdateContext;

/**
 `TBTableData` represents a data model of the table view.
 
 `TBTableData` adopts the `UITableViewDataSource` and `UITableViewDelegate` protocols and is
 supposed to be set to `UITableView` as a data source and a delegate.
 */
@interface TBTableData : NSObject <UITableViewDataSource, UITableViewDelegate>

/** Target table view */
@property(nonatomic, weak) UITableView *tableView;

/**
 Section list.
 
 An list of `<TBTableDataSection>` objects.
 */
@property(nonatomic, strong, readonly) NSArray *sections;

/**
 Returns a section at index in unhidden sections.
 
 Because `<sections>` can contain hidden sections,
 the result of `[tableData.sections objectAtIndex:index]` may different from `[tableData sectionAtUnhiddenSectionIndex:index]`.
 
 @param sectionIndex An index of the section counting except hidden ones.
 @return The section object.
 */
- (TBTableDataSection *)sectionAtUnhiddenSectionIndex:(NSInteger)sectionIndex;

/**
 Returns a row at index in unhidden rows/sections.

 @param rowIndex An index of the row counting except hidden ones.
 @param sectionIndex An index of the section counting except hidden ones.
 @return The row object.
 @see - sectionAtUnhiddenSectionIndex:
 */
- (TBTableDataRow *)rowAtUnhiddenRowIndex:(NSInteger)rowIndex inUnhiddenSectionIndex:(NSInteger)sectionIndex;

/**
 Returns a row at index in unhidden rows/sections.
 
 @param indexPath A index path of the row counting except hidden ones.
 @return The row object.
 @see - sectionAtUnhiddenSectionIndex:
 */
- (TBTableDataRow *)rowAtUnhiddenIndexPath:(NSIndexPath *)indexPath;


/**
 Creates a new table data using specified configurator.

 @param configurator A block object to configure table data.
 @return The table data object.
 */
+ (instancetype)tableDataWithConfigurator:(void (^)(TBTableDataInitializationContext *context))configurator;

/**
 Creates a new table data with build block.
 
 @param buildBlock A block object to build a table data.
 @return The table data object.
 */
+ (instancetype)tableDataWithBuildBlock:(void (^)(TBTableDataBuilder *builder))buildBlock;

/**
 Updates the table view.
 
 With this method, you can get a `<TBTableDataUpdateContext>` object.
 It is required in some edit operations that may cause increase or decrease of sections/rows.
 
 @param animated Specify `YES` to animate.
 @param updater A block object to edit table data with `<TBTableDataUpdateContext>` object.
 */
- (void)updateAnimated:(BOOL)animated updater:(void (^)(TBTableDataUpdateContext *context))updater;

/**
 Creates a section and inserts it after specified section.
 
 @param previousSection The new section is inserted after this section.
 @param context A context object. `<TBTableDataInitializationContext>` or `<TBTableDataUpdateContext>` object is required.
 @param generator A block object to generate section object.
 @return The section object created by this method.
 */
- (TBTableDataSection *)insertSectionAfter:(TBTableDataSection *)previousSection
                               withContext:(TBTableDataContext *)context
                                 generator:(TBTableDataSection *(^)(TBTableDataInitializationContext *context))generator;

/**
 Creates and inserts sections built by specified build block.
 
 @param previousSection The new section is inserted after this section.
 @param context A context object. `<TBTableDataInitializationContext>` or `<TBTableDataUpdateContext>` object is required.
 @param buildBlock A block object to build sections.
 */
- (void)insertAfter:(TBTableDataSection *)previousSection
        withContext:(TBTableDataContext *)context
         buildBlock:(void (^)(TBTableDataBuilder *builder))buildBlock;

@end
