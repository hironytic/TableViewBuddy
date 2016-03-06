//
// TBSingleChoiceNavigationRow.m
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

#import "TBSingleChoiceNavigationRow.h"
#import "TBSingleChoiceSection.h"
#import "TBTableData.h"
#import "TBTableDataBuilder.h"
#import "TBTableDataContext.h"
#import "TBTableViewController.h"

@interface TBSingleChoiceNavigationRow ()
@property(nonatomic, copy) NSArray *options;
@end

@implementation TBSingleChoiceNavigationRow

- (instancetype)initWithContext:(TBTableDataInitializationContext *)context {
    self = [super initWithContext:context];
    if (self != nil) {
        _choiceViewControllerStyle = UITableViewStyleGrouped;
    }
    return self;
}

- (void)setOptions:(NSArray *)options selectedIndex:(NSInteger)selectedIndex withContext:(TBTableDataContext *)context {
    if (![context isKindOfClass:[TBTableDataInitializationContext class]]) {
        NSAssert(NO, @"options can be set only on initialization.");
        return;
    }
    
    _options = options;
    [self setSelectedIndex:selectedIndex withContext:context];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex withContext:(TBTableDataContext *)context {
    _selectedIndex = selectedIndex;

    NSString *optTitle = nil;
    if (selectedIndex != NSNotFound && selectedIndex >= 0 && selectedIndex < [self.options count]) {
        id opt = [self.options objectAtIndex:selectedIndex];
        if ([opt isKindOfClass:[NSString class]]) {
            optTitle = opt;
        } else if ([opt respondsToSelector:@selector(stringValue)]) {
            optTitle = [opt stringValue];
        } else {
            optTitle = [opt description];
        }
    } else {
        optTitle = @"";
    }
    [self setDetailText:optTitle withContext:context];
}

- (void)setChoiceViewControllerTitle:(NSString *)choiceViewControllerTitle withContext:(TBTableDataContext *)context {
    if (![context isKindOfClass:[TBTableDataInitializationContext class]]) {
        NSAssert(NO, @"currently, choiceViewControllerTitle can be set only on initialization.");
        return;
    }

    _choiceViewControllerTitle = choiceViewControllerTitle;
}

- (void)setChoiceViewControllerStyle:(UITableViewStyle)choiceViewControllerStyle withContext:(TBTableDataContext *)context {
    if (![context isKindOfClass:[TBTableDataInitializationContext class]]) {
        NSAssert(NO, @"currently, choiceViewControllerStyle can be set only on initialization.");
        return;
    }

    _choiceViewControllerStyle = choiceViewControllerStyle;
}

- (void)setChoiceTableAccessibilityIdentifier:(NSString *)choiceTableAccessibilityIdentifier withContext:(TBTableDataContext *)context {
    if (![context isKindOfClass:[TBTableDataInitializationContext class]]) {
        NSAssert(NO, @"currently, choiceViewControllerTitle can be set only on initialization.");
        return;
    }
    
    _choiceTableAccessibilityIdentifier = choiceTableAccessibilityIdentifier;
}

- (void)setChoiceSectionHeaderTitle:(NSString *)choiceSectionHeaderTitle withContext:(TBTableDataContext *)context {
    if (![context isKindOfClass:[TBTableDataInitializationContext class]]) {
        NSAssert(NO, @"currently, choiceSectionHeaderTitle can be set only on initialization.");
        return;
    }
    
    _choiceSectionHeaderTitle = choiceSectionHeaderTitle;
}

- (void)setChoiceSectionFooterTitle:(NSString *)choiceSectionFooterTitle withContext:(TBTableDataContext *)context {
    if (![context isKindOfClass:[TBTableDataInitializationContext class]]) {
        NSAssert(NO, @"currently, choiceSectionFooterTitle can be set only on initialization.");
        return;
    }
    
    _choiceSectionFooterTitle = choiceSectionFooterTitle;
}

- (void)setTapHandler:(void (^)())tapHandler {
    NSAssert(NO, @"tap handler is not supported.");
}

- (void (^)())tapHandler {
    return ^{
        [self showChoiceViewController];
    };
}

- (void)showChoiceViewController {
    NSAssert(self.navigationController != nil || self.navigationControllerBlock != nil, @"please set your navigation controller.");
    UINavigationController *navigationController = self.navigationController;
    if (navigationController == nil) {
        navigationController = self.navigationControllerBlock();
    }

    TBSingleChoiceNavigationRow * __weak weakSelf = self;
    TBTableViewController *choiceViewController = [[TBTableViewController alloc] initWithStyle:self.choiceViewControllerStyle buildTableDataBlock:^TBTableData *(TBTableViewController *vc) {
        return [TBTableData tableDataWithBuildBlock:^(TBTableDataBuilder *builder) {
            [builder buildSingleChoiceSection:^(TBSingleChoiceSection *section) {
                [section setHeaderTitle:weakSelf.choiceSectionHeaderTitle withContext:builder.context];
                [section setFooterTitle:weakSelf.choiceSectionFooterTitle withContext:builder.context];
                
                [section setOptions:weakSelf.options
                      selectedIndex:weakSelf.selectedIndex
                        withContext:builder.context];
                section.selectionChangeHandler = ^(NSInteger selectedIndex) {
                    [weakSelf setSelectedIndex:selectedIndex withContext:[TBTableDataContext context]];
                    if (weakSelf.selectionChangeHandler != nil) {
                        weakSelf.selectionChangeHandler(selectedIndex);
                    }
                };
            }];
        }];
    }];
    
    choiceViewController.title = self.choiceViewControllerTitle;
    choiceViewController.tableView.accessibilityIdentifier = self.choiceTableAccessibilityIdentifier;
    [navigationController pushViewController:choiceViewController animated:YES];
}

@end


@implementation TBTableDataBuilder (TBSingleChoiceNavigationRow)
- (void)buildSingleChoiceNavigationRow:(void (^)(TBSingleChoiceNavigationRow *row))configurator {
    [self buildRowWithRowClass:[TBSingleChoiceNavigationRow class] configurator:^(TBTableDataRow *row) {
        configurator((TBSingleChoiceNavigationRow *)row);
    }];
}
@end
