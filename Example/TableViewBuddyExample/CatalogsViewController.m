//
// CatalogsViewController.m
// TableViewBuddyExample
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

#import "CatalogsViewController.h"
#import "TableViewBuddy.h"

@implementation CatalogsViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self != nil) {
        self.title = @"Catalogs";
    }
    return self;
}

- (TBTableData *)buildTableData {
    CatalogsViewController * __weak weakSelf = self;
    TBTableDataBuildHelper *helper = [[TBTableDataBuildHelper alloc] init];
    TBTableData *tableData = [helper buildTableData:^{
        // Section "Rows"
        [helper buildGenericSection:^(TBTableDataSection *section) {
            [section setHeaderTitle:@"Rows" withContext:helper.context];
            
            // Row "Action"
            [helper buildActionRow:^(TBActionRow *row) {
                row.title = @"Action";
                row.image = [UIImage imageNamed:@"SampleIcon.png"];
                row.tapHandler = ^{
                    NSLog(@"Action is tapped.");
                };
            }];
            
            // Row "Button"
            [helper buildButtonRow:^(TBButtonRow *row) {
                row.title = @"Button";
                row.tapHandler = ^{
                    NSLog(@"Button is tapped.");
                };
            }];
            
            // Row "Check"
            [helper buildCheckRow:^(TBCheckRow *row) {
                row.title = @"Check";
                row.value = YES;
                row.valueChangeHandler = ^(BOOL value) {
                    NSLog(@"Check value becomes %@", (value) ? @"checked" : @"unchecked");
                };
            }];
            
            // Row "Label"
            [helper buildLabelRow:^(TBLabelRow *row) {
                row.title = @"Label";
                row.detailText = @"text";
            }];
            
            // Row "Navigation"
            [helper buildNavigationRow:^(TBNavigationRow *row) {
                row.title = @"Navigation";
                row.tapHandler = ^{
                    TBTableViewController *nextViewController = [[TBTableViewController alloc] initWithStyle:UITableViewStylePlain];
                    [weakSelf.navigationController pushViewController:nextViewController animated:YES];
                };
            }];
            
            // Row "SingleChoice"
            [helper buildSingleChoiceNavigationRow:^(TBSingleChoiceNavigationRow *row) {
                row.title = @"Single Choice";
                row.navigationController = weakSelf.navigationController;
                NSArray *options = @[@"One", @"Two", @"Three"];
                [row setOptions:options selectedIndex:0 withContext:helper.context];
                row.selectionChangeHandler = ^(NSInteger index) {
                    NSLog(@"%@ is selected.", options[index]);
                };
            }];
            
            // Row "Switch"
            [helper buildSwitchRow:^(TBSwitchRow *row) {
                row.title = @"Switch";
                row.value = YES;
                row.valueChangeHandler = ^(BOOL value) {
                    NSLog(@"Switch is %@", (value) ? @"on" : @"off");
                };
            }];
        }];
    }];
    return tableData;
}

@end
