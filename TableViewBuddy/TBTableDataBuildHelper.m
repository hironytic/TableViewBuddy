//
// TBTableDataBuildHelper.m
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

#import "TBTableDataBuildHelper.h"
#import "TBTableData.h"
#import "TBTableDataContext.h"
#import "TBTableDataRow.h"
#import "TBTableDataSection.h"

@interface TBTableDataBuildHelper ()
@property(nonatomic, weak) TBTableDataContext *context;
@property(nonatomic, weak) TBTableData *currentTableData;
@property(nonatomic, weak) TBTableDataSection *currentSection;
@property(nonatomic, weak) TBTableDataSection *previousSection;
@property(nonatomic, weak) TBTableDataRow *previousRow;
@end

@implementation TBTableDataBuildHelper

- (instancetype)init {
    return [self initWithUpdateContext:nil
                             tableData:nil
                               section:nil
                       previousSection:nil
                           previousRow:nil];
}

- (instancetype)initWithUpdateContext:(TBTableDataUpdateContext *)context tableData:(TBTableData *)currentTableData previousSection:(TBTableDataSection *)previousSection {
    return [self initWithUpdateContext:context
                             tableData:currentTableData
                               section:nil
                       previousSection:previousSection
                           previousRow:nil];
}

- (instancetype)initWithUpdateContext:(TBTableDataUpdateContext *)context section:(TBTableDataSection *)currentSection previousRow:(TBTableDataRow *)previousRow {
    return [self initWithUpdateContext:context
                             tableData:currentSection.tableData
                               section:currentSection
                       previousSection:currentSection
                           previousRow:previousRow];
}

- (instancetype)initWithUpdateContext:(TBTableDataUpdateContext *)context
                            tableData:(TBTableData *)currentTableData
                              section:(TBTableDataSection *)currentSection
                      previousSection:(TBTableDataSection *)previousSection
                          previousRow:(TBTableDataRow *)previousRow
{
    self = [super init];
    if (self != nil) {
        _context = context;
        _currentTableData = currentTableData;
        _currentSection = currentSection;
        _previousSection = previousSection;
        _previousRow = previousRow;
    }
    return self;
}

- (TBTableData *)buildTableData:(void (^)())configurator {
    return [self buildTableDataWithTableDataClass:[TBTableData class] configulator:configurator];
}

- (TBTableData *)buildTableDataWithTableDataClass:(Class)tableDataClass configulator:(void (^)())configurator {
    TBTableData *tableData = [tableDataClass tableDataWithConfigurator:^(TBTableDataInitializationContext *context) {
        self.previousSection = nil;
        self.context = context;
        self.currentTableData = context.tableData;
        configurator();
        self.currentTableData = nil;
    }];
    return tableData;
}

- (void)buildSectionWithSectionClass:(Class)sectionClass configurator:(void (^)(TBTableDataSection *section))configurator {
    TBTableDataContext *orgContext = self.context;
    self.previousRow = nil;
    self.previousSection = [self.currentTableData insertSectionAfter:self.previousSection withContext:self.context generator:[sectionClass sectionGeneratorWithConfigurator:^(TBTableDataInitializationContext *context) {
        self.context = context;
        self.currentSection = context.section;
        configurator(context.section);
        self.currentSection = nil;
    }]];
    self.context = orgContext;
}

- (void)buildRowWithRowClass:(Class)rowClass configurator:(void (^)(TBTableDataRow *row))configurator {
    TBTableDataContext *orgContext = self.context;
    self.previousRow = [self.currentSection insertRowAfter:self.previousRow withContext:self.context generator:[rowClass rowGeneratorWithConfigurator:^(TBTableDataInitializationContext *context) {
        self.context = context;
        configurator(context.row);
    }]];
    self.context = orgContext;
}

- (void)buildGenericSection:(void (^)(TBTableDataSection *section))configurator {
    [self buildSectionWithSectionClass:[TBTableDataSection class] configurator:configurator];
}

@end
