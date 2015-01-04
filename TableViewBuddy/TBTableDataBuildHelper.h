//
// TBTableDataBuildHelper.h
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

#import <Foundation/Foundation.h>

@class TBTableData;
@class TBTableDataInitializationContext;
@class TBTableDataRow;
@class TBTableDataSection;

/**
 `TBTableDataBuildHelper` helps to create a `<TBTableData>` object and to configure sections and rows.
 
 You can create a `<TBTableData>` object without this class,
 but using this class you can configure a series of sections and rows in a simple way like:
 
    TBTableDataBuildHelper *helper = [[TBTableDataBuildHelper alloc] init];
    TBTableData *tableData = [helper buildTableData:^{
        // Section "Cache"
        [helper buildGenericSection:^(TBTableDataSection *section) {
            [section setHeaderTitle:@"Cache" withContext:helper.context];
            
            // Row "Use Cache"
            [helper buildSwitchRow:^(TBSwitchRow *row) {
                [row setTitle:@"Use Cache" withContext:helper.context];
                [row setValue:YES withContext:helper.context];
                // ...
            }];
            
            // Row "Clear All Cache"
            [helper buildButtonRow:^(TBButtonRow *row) {
                [row setTitle:@"Clear All Cache" withContext:helper.context];
                // ...
            }];
        }];
        
        // Section "Search"
        [helper buildGenericSection:^(TBTableDataSection *section) {
            [section setHeaderTitle:@"Search" withContext:helper.context];
            
            // Row "Search Engine"
            [helper buildSingleChoiceNavigationRow:^(TBSingleChoiceNavigationRow *row) {
                [row setTitle:@"Search Engine" withContext:helper.context];
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
 
 Note this class does not help inserting new sections/rows to existing table data.
 
 */
@interface TBTableDataBuildHelper : NSObject

/**
 A `<TBTableDataInitializationContext>` object being used in initializing.
 */
@property(nonatomic, weak, readonly) TBTableDataInitializationContext *context;

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
