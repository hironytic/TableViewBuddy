//
// TBSingleChoiceNavigationRow.m
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

#import "TBSingleChoiceNavigationRow.h"
#import "TBSingleChoiceSection.h"
#import "TBTableData.h"
#import "TBTableDataBuildHelper.h"
#import "TBTableDataContext.h"

@interface TBSingleChoiceNavigationRow ()
@property(nonatomic, copy) NSArray *options;
@end

@interface TBSingleChoiceViewController : UITableViewController
@property(nonatomic, weak) TBSingleChoiceNavigationRow *singleChoiceNavigationRow;
@property(nonatomic, strong) TBTableData *tableData;
@end

@implementation TBSingleChoiceNavigationRow

- (void)setOptions:(NSArray *)options selectedIndex:(NSInteger)selectedIndex withContext:(TBTableDataContext *)context {
    if (![context isKindOfClass:[TBTableDataInitializationContext class]]) {
        NSAssert(NO, @"options can be set only on initialization.");
        return;
    }
    
    _options = options;
    self.selectedIndex = selectedIndex;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;

    NSString *optTitle = nil;
    if (selectedIndex >= 0 && selectedIndex < [self.options count]) {
        id opt = [self.options objectAtIndex:selectedIndex];
        if ([opt isKindOfClass:[NSString class]]) {
            optTitle = opt;
        } else if ([opt respondsToSelector:@selector(stringValue)]) {
            optTitle = [opt stringValue];
        } else {
            optTitle = [opt description];
        }
    }
    self.detailText = optTitle;
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
    NSAssert(self.navigationController != nil, @"please set your navigation controller.");

    TBSingleChoiceViewController *choiseViewController = [[TBSingleChoiceViewController alloc] initWithStyle:UITableViewStyleGrouped];
    choiseViewController.title = self.choiceViewControllerTitle;
    choiseViewController.singleChoiceNavigationRow = self;
    [self.navigationController pushViewController:choiseViewController animated:YES];
}

@end


@implementation TBTableDataBuildHelper (TBSingleChoiceNavigationRow)
- (void)buildSingleChoiceNavigationRow:(void (^)(TBSingleChoiceNavigationRow *row))configurator {
    [self buildRowWithRowClass:[TBSingleChoiceNavigationRow class] configurator:^(TBTableDataRow *row) {
        configurator((TBSingleChoiceNavigationRow *)row);
    }];
}
@end


@implementation TBSingleChoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TBSingleChoiceViewController * __weak weakSelf = self;
    TBTableDataBuildHelper *helper = [[TBTableDataBuildHelper alloc] init];
    TBTableData *tableData = [helper buildTableData:^{
        [helper buildSingleChoiceSection:^(TBSingleChoiceSection *section) {
            [section setHeaderTitle:weakSelf.singleChoiceNavigationRow.choiseSectionHeaderTitle withContext:helper.context];
            [section setFooterTitle:weakSelf.singleChoiceNavigationRow.choiseSectionFooterTitle withContext:helper.context];
            
            [section setOptions:self.singleChoiceNavigationRow.options
                  selectedIndex:self.singleChoiceNavigationRow.selectedIndex
                    withContext:helper.context];
            section.selectionChangeHandler = ^(NSInteger selectedIndex) {
                weakSelf.singleChoiceNavigationRow.selectedIndex = selectedIndex;
                if (weakSelf.singleChoiceNavigationRow.selectionChangeHandler != nil) {
                    weakSelf.singleChoiceNavigationRow.selectionChangeHandler(selectedIndex);
                }
            };
        }];
    }];
    tableData.tableView = self.tableView;
    self.tableData = tableData;
    self.tableView.dataSource = tableData;
    self.tableView.delegate = tableData;
}

@end
