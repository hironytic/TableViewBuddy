//
// TBSingleChoiceSection.m
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

#import "TBSingleChoiceSection.h"
#import "TBChoiceRow.h"
#import "TBTableDataContext.h"
#import "TBTableDataSection.h"

@interface TBSingleChoiceSection ()
@property(nonatomic, copy) NSArray *options;
@property(nonatomic, strong) NSMutableArray *choiceRows;
@end

@implementation TBSingleChoiceSection

- (instancetype)initWithContext:(TBTableDataInitializationContext *)context {
    self = [super initWithContext:context];
    if (self != nil) {
        _selectedIndex = NSNotFound;
    }
    return self;
}

- (void)setOptions:(NSArray *)options selectedIndex:(NSInteger)selectedIndex withContext:(TBTableDataContext *)context {
    if (![context isKindOfClass:[TBTableDataInitializationContext class]]) {
        NSAssert(NO, @"options can be set only on initialization.");
        return;
    }
    
    TBSingleChoiceSection * __weak weakSelf = self;
    _options = options;
    _selectedIndex = selectedIndex;
    self.choiceRows = [[NSMutableArray alloc] initWithCapacity:[options count]];
    [((TBTableDataInitializationContext *)context).section insertAfter:nil withContext:context buildBlock:^(TBTableDataBuilder *builder) {
        [options enumerateObjectsUsingBlock:^(id opt, NSUInteger ix, BOOL *stop) {
            [builder buildChoiceRow:^(TBChoiceRow *row) {
                NSString *optTitle = nil;
                UIImage *optImage = nil;
                if (optTitle == nil && [opt isKindOfClass:[NSString class]]) {
                    optTitle = opt;
                }
                if (optTitle == nil && [opt respondsToSelector:@selector(stringValue)]) {
                    optTitle = [opt stringValue];
                }
                if (optTitle == nil && [opt respondsToSelector:@selector(valueForKey:)]) {
                    optTitle = [opt valueForKey:@"title"];
                    optImage = [opt valueForKey:@"image"];
                }
                if (optTitle == nil) {
                    optTitle = [opt description];
                }
                [row setTitle:optTitle withContext:context];
                if (optImage != nil && [optImage isKindOfClass:[UIImage class]]) {
                    [row setImage:optImage withContext:context];
                }
                if (ix == selectedIndex) {
                    [row setValue:YES withContext:context];
                } else {
                    [row setValue:NO withContext:context];
                }
                
                row.valueChangeHandler = ^(BOOL value) {
                    [weakSelf optionValueSelected:ix];
                };
                
                [self.choiceRows addObject:row];
            }];
        }];
    }];
}

- (void)optionValueSelected:(NSInteger)index {
    if (_selectedIndex != NSNotFound && _selectedIndex >= 0) {
        TBChoiceRow *prevSelectedRow = self.choiceRows[_selectedIndex];
        [prevSelectedRow setValue:NO withContext:[TBTableDataContext context]];
    }
    _selectedIndex = index;
    if (self.selectionChangeHandler != nil) {
        self.selectionChangeHandler(_selectedIndex);
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex withContext:(TBTableDataContext *)context {
    if (_selectedIndex != NSNotFound && _selectedIndex >= 0) {
        TBChoiceRow *prevSelectedRow = self.choiceRows[_selectedIndex];
        [prevSelectedRow setValue:NO withContext:context];
    }
    if (selectedIndex != NSNotFound && selectedIndex >= 0) {
        TBChoiceRow *nowSelectedRow = self.choiceRows[selectedIndex];
        [nowSelectedRow setValue:YES withContext:context];
    }
    _selectedIndex = selectedIndex;
}

@end


@implementation TBTableDataBuilder (TBSingleChoiceSection)
- (void)buildSingleChoiceSection:(void (^)(TBSingleChoiceSection *row))configurator {
    [self buildSectionWithSectionClass:[TBSingleChoiceSection class] configurator:^(TBTableDataSection *section) {
        configurator((TBSingleChoiceSection *)section);
    }];
}
@end
