//
// TBTableData.h
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

#import <Foundation/Foundation.h>

@class TBTableDataContext;
@class TBTableDataInitializationContext;
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
 
 An list of `TBTableDataSection` objects.
 */
@property(nonatomic, strong, readonly) NSArray *sections;

/**
 Creates a new table data using specified configurator.

 @param configurator A block object to configure table data.
 @return The table data object.
 */
+ (instancetype)tableDataWithConfigurator:(void (^)(TBTableDataInitializationContext *context))configurator;

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

@end
