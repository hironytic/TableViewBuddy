//
// TBTableDataRow.h
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

/**
 * `TBTableDataRow` represents a data model of the row as a part of the table data.
 */
@interface TBTableDataRow : NSObject

/**
 * A `TBTableDataSection` object to which this object belongs.
 */
@property(nonatomic, weak, readonly) TBTableDataSection *section;

/**
 * A reuse identifier of the corresponding table cell.
 */
@property(nonatomic, copy, readonly) NSString *reuseIdentifier;

/**
 * A boolean value that determines whether the row is hidden.
 */
@property(nonatomic, assign, readonly) BOOL hidden;

/**
 * A boolean value that determines whether the row is enabled.
 */
@property(nonatomic, assign, readonly) BOOL enabled;

/**
 * Returns a generator block object, which can be used as a last parameter in `[TBTableDataSection insertRowAfter:withContext:generator:]`.
 *
 * @param configurator A block object to configure the row.
 * @return The generator block object.
 */
+ (TBTableDataRow *(^)(TBTableDataInitializationContext *context))rowGeneratorWithConfigurator:(void (^)(TBTableDataInitializationContext *context))configurator;

/**
 * Returns a `TBTableDataRow` object initialized with specified context.
 *
 * This is the designated initializer method.
 *
 * @param context A context object to initialize.
 * @return The row object.
 */
- (instancetype)initWithContext:(TBTableDataInitializationContext *)context;

/**
 * Returns an index path of the row in the table view.
 *
 * Indices in the returned path are indices in the visible sections/rows. Hidden sections/rows are not counted.
 *
 * @return The index path, or nil when this row is not visible.
 */
- (NSIndexPath *)rowIndexPath;

/**
 * Finds a corresponding table cell and returns it.
 *
 * @return The table cell object, or nil when it is not found.
 */
- (UITableViewCell *)findVisibleCell;

/**
 * Changes the visibility of the row.
 *
 * @param hidden `YES` to hide the row, or `NO` to show.
 * @param context A context object. `TBTableDataInitializationContext` or `TBTableDataUpdateContext` object is required.
 */
- (void)setHidden:(BOOL)hidden withContext:(TBTableDataContext *)context;

/**
 * Enables or disables the row.
 *
 * @param enabled `YES` to enable the row, or `NO` to disable.
 * @param context A context object.
 */
- (void)setEnabled:(BOOL)enabled withContext:(TBTableDataContext *)context;

/**
 * Reloads the row in table view.
 *
 * @param context A context object. `TBTableDataUpdateContext` object is required.
 */
- (void)reloadWithContext:(TBTableDataContext *)context;

/**
 * Deletes the row.
 *
 * @param context A context object. `TBTableDataInitializationContext` or `TBTableDataUpdateContext` object is required.
 */
- (void)deleteWithContext:(TBTableDataContext *)context;

// for subclass overriding
- (UITableViewCell *)createTableViewCell;
- (void)configureTableViewCell:(UITableViewCell *)cell;
- (void)rowDidTapInTableView:(UITableView *)tableView AtIndexPath:(NSIndexPath *)indexPath;

@end
