//
// TBSingleChoiceSection.m
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

#import "TBSingleChoiceSection.h"
#import "TBChoiceRow.h"
#import "TBTableDataContext.h"
#import "TBTableDataSection.h"

@interface TBSingleChoiceSection ()
@property(nonatomic, copy) NSArray *options;
@property(nonatomic, strong) NSMutableArray *choiceRows;
@end

@implementation TBSingleChoiceSection

- (void)setOptions:(NSArray *)options selectedIndex:(NSInteger)selectedIndex withContext:(TBTableDataContext *)context {
    if (![context isKindOfClass:[TBTableDataInitializationContext class]]) {
        NSAssert(NO, @"options can be set only on initialization.");
        return;
    }
    
    TBSingleChoiceSection * __weak weakSelf = self;
    _options = options;
    _selectedIndex = selectedIndex;
    self.choiceRows = [[NSMutableArray alloc] initWithCapacity:[options count]];
    __block TBTableDataRow *previousRow = nil;
    [options enumerateObjectsUsingBlock:^(id opt, NSUInteger ix, BOOL *stop) {
        previousRow = [((TBTableDataInitializationContext *)context).section insertRowAfter:previousRow withContext:context generator:[TBChoiceRow rowGeneratorWithConfigurator:^(TBTableDataInitializationContext *context) {
            TBChoiceRow *row = (TBChoiceRow *)context.row;
            
            NSString *optTitle = nil;
            if ([opt isKindOfClass:[NSString class]]) {
                optTitle = opt;
            } else if ([opt respondsToSelector:@selector(stringValue)]) {
                optTitle = [opt stringValue];
            } else {
                optTitle = [opt description];
            }
            row.title = optTitle;
            
            if (ix == selectedIndex) {
                row.value = YES;
            } else {
                row.value = NO;
            }
            
            row.valueChangeHandler = ^(BOOL value) {
                [weakSelf optionValueSelected:ix];
            };
        }]];
        [self.choiceRows addObject:previousRow];
    }];
}

- (void)optionValueSelected:(NSInteger)index {
    if (_selectedIndex >= 0) {
        TBChoiceRow *prevSelectedRow = self.choiceRows[_selectedIndex];
        prevSelectedRow.value = NO;
    }
    _selectedIndex = index;
    if (self.selectionChangeHandler != nil) {
        self.selectionChangeHandler(_selectedIndex);
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_selectedIndex >= 0) {
        TBChoiceRow *prevSelectedRow = self.choiceRows[_selectedIndex];
        prevSelectedRow.value = NO;
    }
    if (selectedIndex >= 0) {
        TBChoiceRow *nowSelectedRow = self.choiceRows[selectedIndex];
        nowSelectedRow.value = YES;
    }
    _selectedIndex = selectedIndex;
}

@end


@implementation TBTableDataBuildHelper (TBSingleChoiceSection)
- (void)buildSingleChoiceSection:(void (^)(TBSingleChoiceSection *row))configurator {
    [self buildSectionWithSectionClass:[TBSingleChoiceSection class] configurator:^(TBTableDataSection *section) {
        configurator((TBSingleChoiceSection *)section);
    }];
}
@end