//
// TBTableDataSection.h
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

@class TBTableData;
@class TBTableDataBuilder;
@class TBTableDataContext;
@class TBTableDataInitializationContext;
@class TBTableDataRow;

/**
 `TBTableDataSection` represents a data model of the section as a part of the table data.
 */
@interface TBTableDataSection : NSObject

/**
 A `<TBTableData>` object to which this object belongs.
 */
@property(nonatomic, weak, readonly) TBTableData *tableData;

/**
 A boolean value that determines whether the section is hidden.
 */
@property(nonatomic, assign, readonly) BOOL hidden;

/**
 A title for the header of the section.
 */
@property(nonatomic, copy, readonly) NSString *headerTitle;

/**
 A title for the footer of the section.
 */
@property(nonatomic, copy, readonly) NSString *footerTitle;

/**
 Row list.
 
 A list of `<TBTableDataRow>` objects.
 */
@property(nonatomic, strong, readonly) NSArray *rows;

/**
 Returns a row at index in unhidden rows.

 Because `<rows>` can contain hidden sections,
 the result of `[tableDataSection.rows objectAtIndex:index]` may different from `[tableDataSection rowAtUnhiddenRowIndex:index]`.
 
 @param rowIndex An index of the row counting except hidden ones.
 @return The row object.
 */
- (TBTableDataRow *)rowAtUnhiddenRowIndex:(NSInteger)rowIndex;

/**
 Returns a generator block object, which can be used as a last parameter in `<[TBTableData insertSectionAfter:withContext:generator:]>`.
 
 @param configurator A block object to configure the section.
 @return The generator block object.
 */
+ (TBTableDataSection *(^)(TBTableDataInitializationContext *context))sectionGeneratorWithConfigurator:(void (^)(TBTableDataInitializationContext *context))configurator;

/**
 Returns a `TBTableDataSection` object initialized with specified context.
 
 This is the designated initializer method.
 
 @param context A context object to initialize.
 @return The section object.
 */
- (instancetype)initWithContext:(TBTableDataInitializationContext *)context;

/**
 Returns an index of the section in the table view.
 
 Returned value is index in the unhidden sections. Hidden sections are not counted.
 
 @return The index, or NSNotFound when this section is hidden.
 */
- (NSInteger)sectionIndex;

/**
 Creates a row and inserts it after specified row.
 
 @param previousRow The new row is inserted after this row.
 @param context A context object. `<TBTableDataInitializationContext>` or `<TBTableDataUpdateContext>` object is required.
 @param generator A block object to generate row object.
 @return The row object created by this method.
 */
- (TBTableDataRow *)insertRowAfter:(TBTableDataRow *)previousRow
                       withContext:(TBTableDataContext *)context
                      generator:(TBTableDataRow *(^)(TBTableDataInitializationContext *context))generator;

/**
 Creates and inserts rows built by specified build block.
 
 @param previousRow The new row is inserted after this row.
 @param context A context object. `<TBTableDataInitializationContext>` or `<TBTableDataUpdateContext>` object is required.
 @param buildBlock A block object to build rows.
 */
- (void)insertAfter:(TBTableDataRow *)previousRow
        withContext:(TBTableDataContext *)context
         buildBlock:(void (^)(TBTableDataBuilder *builder))buildBlock;

/**
 Changes the visibility of the section.
 
 @param hidden `YES` to hide the section, or `NO` to show.
 @param context A context object. `<TBTableDataInitializationContext>` or `<TBTableDataUpdateContext>` object is required.
 */
- (void)setHidden:(BOOL)hidden withContext:(TBTableDataContext *)context;

/**
 Changes the title for the header.
 
 @param headerTitle The title used for the header.
 @param context A context object.
 */
- (void)setHeaderTitle:(NSString *)headerTitle withContext:(TBTableDataContext *)context;

/**
 Changes the title for the footer.
 
 @param footerTitle The title used for the footer.
 @param context A context object.
 */
- (void)setFooterTitle:(NSString *)footerTitle withContext:(TBTableDataContext *)context;

/**
 Reloads the section in table view.
 
 @param context A context object. `<TBTableDataUpdateContext>` object is required.
 */
- (void)reloadWithContext:(TBTableDataContext *)context;

/**
 Deletes the section.
 
 @param context A context object. `<TBTableDataInitializationContext>` or `<TBTableDataUpdateContext>` object is required.
 */
- (void)deleteWithContext:(TBTableDataContext *)context;

@end
