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
@property(nonatomic, weak) TBTableDataInitializationContext *context;
@property(nonatomic, weak) TBTableDataSection *previousSection;
@property(nonatomic, weak) TBTableDataRow *previousRow;
@end

@implementation TBTableDataBuildHelper

- (TBTableData *)buildTableData:(void (^)())configurator {
    return [self buildTableDataWithTableDataClass:[TBTableData class] configulator:configurator];
}

- (TBTableData *)buildTableDataWithTableDataClass:(Class)tableDataClass configulator:(void (^)())configurator {
    TBTableData *tableData = [tableDataClass tableDataWithConfigurator:^(TBTableDataInitializationContext *context) {
        self.previousSection = nil;
        self.context = context;
        configurator();
    }];
    return tableData;
}

- (void)buildSectionWithSectionClass:(Class)sectionClass configurator:(void (^)(TBTableDataSection *section))configurator {
    TBTableDataInitializationContext *orgContext = self.context;
    self.previousRow = nil;
    self.previousSection = [self.context.tableData insertSectionAfter:self.previousSection withContext:self.context generator:[sectionClass sectionGeneratorWithConfigurator:^(TBTableDataInitializationContext *context) {
        self.context = context;
        configurator(context.section);
    }]];
    self.context = orgContext;
}

- (void)buildRowWithRowClass:(Class)rowClass configurator:(void (^)(TBTableDataRow *row))configurator {
    TBTableDataInitializationContext *orgContext = self.context;
    self.previousRow = [self.context.section insertRowAfter:self.previousRow withContext:self.context generator:[rowClass rowGeneratorWithConfigurator:^(TBTableDataInitializationContext *context) {
        self.context = context;
        configurator(context.row);
    }]];
    self.context = orgContext;
}

- (void)buildGenericSection:(void (^)(TBTableDataSection *section))configurator {
    [self buildSectionWithSectionClass:[TBTableDataSection class] configurator:configurator];
}

@end
