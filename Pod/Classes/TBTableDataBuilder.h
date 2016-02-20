//
// TBTableDataBuilder.h
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
@class TBTableDataContext;
@class TBTableDataRow;
@class TBTableDataSection;

/**
 `TBTableDataBuilder` helps to create a `<TBTableData>` object and to configure sections and rows.
 
 You can create a `<TBTableData>` object without this class,
 but using this class you can configure a series of sections and rows in a simple way like:
 
    TBTableData *tableData = [TBTableData tableDataWithBuildBlock:^(TBTableDataBuilder *builder) {
        // Section "Cache"
        [builder buildGenericSection:^(TBTableDataSection *section) {
            [section setHeaderTitle:@"Cache" withContext:builder.context];
            
            // Row "Use Cache"
            [builder buildSwitchRow:^(TBSwitchRow *row) {
                [row setTitle:@"Use Cache" withContext:builder.context];
                [row setValue:YES withContext:builder.context];
                // ...
            }];
            
            // Row "Clear All Cache"
            [builder buildButtonRow:^(TBButtonRow *row) {
                [row setTitle:@"Clear All Cache" withContext:builder.context];
                // ...
            }];
        }];
        
        // Section "Search"
        [builder buildGenericSection:^(TBTableDataSection *section) {
            [section setHeaderTitle:@"Search" withContext:builder.context];
            
            // Row "Search Engine"
            [builder buildSingleChoiceNavigationRow:^(TBSingleChoiceNavigationRow *row) {
                [row setTitle:@"Search Engine" withContext:builder.context];
                // ...
            }];
        }];
    }];
 
 instead of:
 
    TBTableData *tableData = [TBTableData tableDataWithConfigurator:^(TBTableDataInitializationContext *context) {
        // Section "Cache"
        __block TBTableDataSection *cacheSection = nil;
        [context.tableData insertSectionAfter:nil
                                  withContext:context
                                    generator:[TBTableDataSection sectionGeneratorWithConfigurator:
                                                     ^(TBTableDataInitializationContext *context) {
            cacheSection = context.section;
            [context.section setHeaderTitle:@"Cache" withContext:context];
            
            // Row "Use Cache"
            __block TBTableDataRow *useCacheRow = nil;
            [context.section insertRowAfter:nil
                                withContext:context
                                  generator:[TBSwitchRow rowGeneratorWithConfigurator:
                                        ^(TBTableDataInitializationContext *context) {
                useCacheRow = context.row;
                TBSwitchRow *row = (TBSwitchRow *)context.row;
                [row setTitle:@"Use Cache" withContext:context];
                [row setValue:YES withContext:context];
                // ...
            }]];
            
            // Row "Clear All Cache"
            [context.section insertRowAfter:useCacheRow
                                withContext:context
                                  generator:[TBButtonRow rowGeneratorWithConfigurator:
                                        ^(TBTableDataInitializationContext *context) {
                TBButtonRow *row = (TBButtonRow *)context.row;
                [row setTitle:@"Clear All Cache" withContext:context];
                // ...
            }]];
        }]];
        
        // Section "Search"
        [context.tableData insertSectionAfter:cacheSection
                                  withContext:context
                                    generator:[TBTableDataSection sectionGeneratorWithConfigurator:
                                                     ^(TBTableDataInitializationContext *context) {
            [context.section setHeaderTitle:@"Search" withContext:context];
            
            // Row "Search Engine"
            [context.section insertRowAfter:nil
                                withContext:context
                                  generator:[TBSingleChoiceNavigationRow rowGeneratorWithConfigurator:
                                                        ^(TBTableDataInitializationContext *context) {
                TBSingleChoiceNavigationRow *row = (TBSingleChoiceNavigationRow *)context.row;
                [row setTitle:@"Search Engine" withContext:context];
                // ...
            }]];
        }]];
    }];
 
 */
@interface TBTableDataBuilder : NSObject

/**
 Initializes and returns builder which is used for inserting sections.
 
 @param context A context object.
 @param currentTableData A `<TBTableData>` object to which the new section will be inserted.
 @param previousSection The new section will be inserted after this section.
 @return A new builder object.
 */
- (instancetype)initWithContext:(TBTableDataContext *)context tableData:(TBTableData *)currentTableData previousSection:(TBTableDataSection *)previousSection;

/**
 Initializes and returns builder which is used for inserting rows.
 
 @param context A context object.
 @param currentSection A `<TBTableDataSection>` object to which the new row will be inserted.
 @param previousRow The new section will be inserted after this row.
 @return A new builder object.
 */
- (instancetype)initWithContext:(TBTableDataContext *)context section:(TBTableDataSection *)currentSection previousRow:(TBTableDataRow *)previousRow;

/**
 Designated initializer.

 @param context A context object for updating.
 @param currentTableData A `<TBTableData>` object to which the new section will be inserted.
 @param currentSection A `<TBTableDataSection>` object to which the new row will be inserted.
 @param previousSection The new section will be inserted after this section.
 @param previousRow The new section will be inserted after this row.
 @return A new builder object.
 */
- (instancetype)initWithContext:(TBTableDataContext *)context
                      tableData:(TBTableData *)currentTableData
                        section:(TBTableDataSection *)currentSection
                previousSection:(TBTableDataSection *)previousSection
                    previousRow:(TBTableDataRow *)previousRow;

/**
 A `<TBTableDataContext>` object being used in initializing or updating.
 */
@property(nonatomic, weak, readonly) TBTableDataContext *context;

/**
 Creates a `<TBTableData>` object and configures it.
 
 @param configurator A block object that configures table data.
 */
- (TBTableData *)buildTableData:(void (^)())configurator;

/**
 Creates a `<TBTableData>` (or its derived class) object and configures it.
 
 @param tableDataClass A class object of `<TBTableData>` or its derived class.
 @param configurator A block object that configures table data.
 */
- (TBTableData *)buildTableDataWithTableDataClass:(Class)tableDataClass configulator:(void (^)())configurator;

/**
 Creates a section object, adds it at the end of sections, and configures it.
 
 @param sectionClass A class object of `<TBTableDataSection>` or its derived class.
 @param configurator A block object that configures the section.
 */
- (void)buildSectionWithSectionClass:(Class)sectionClass configurator:(void (^)(TBTableDataSection *section))configurator;

/**
 Creates a row object, adds it at the end of rows in current section, and configures it.
 
 @param rowClass A class object of `<TBTableDataRow>` or its derived class.
 @param configurator A block object that configures the row.
 */
- (void)buildRowWithRowClass:(Class)rowClass configurator:(void (^)(TBTableDataRow *row))configurator;

/**
 Builds a generic section object.
 
 @param configurator A block object that configures the section.
 */
- (void)buildGenericSection:(void (^)(TBTableDataSection *section))configurator;

@end
