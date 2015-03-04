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
    TBTableData *tableData = [TBTableData tableDataWithBuildBlock:^(TBTableDataBuilder *builder) {
        // Section "Rows"
        [builder buildGenericSection:^(TBTableDataSection *section) {
            [section setHeaderTitle:@"Rows" withContext:builder.context];
            
            // Row "Action"
            [builder buildActionRow:^(TBActionRow *row) {
                [row setTitle:@"Action" withContext:builder.context];
                [row setImage:[UIImage imageNamed:@"SampleIcon.png"] withContext:builder.context];
                row.tapHandler = ^{
                    NSLog(@"Action is tapped.");
                };
            }];
            
            // Row "Button"
            [builder buildButtonRow:^(TBButtonRow *row) {
                [row setTitle:@"Button" withContext:builder.context];
                [row setImage:[UIImage imageNamed:@"SampleIcon.png"] withContext:builder.context];
                row.tapHandler = ^{
                    NSLog(@"Button is tapped.");
                };
            }];
            
            // Row "Check"
            [builder buildCheckRow:^(TBCheckRow *row) {
                [row setTitle:@"Check" withContext:builder.context];
                [row setImage:[UIImage imageNamed:@"SampleIcon.png"] withContext:builder.context];
                [row setValue:YES withContext:builder.context];
                row.valueChangeHandler = ^(BOOL value) {
                    NSLog(@"Check value becomes %@", (value) ? @"checked" : @"unchecked");
                };
            }];
            
            // Row "Label"
            [builder buildLabelRow:^(TBLabelRow *row) {
                [row setTitle:@"Label" withContext:builder.context];
                [row setImage:[UIImage imageNamed:@"SampleIcon.png"] withContext:builder.context];
                [row setDetailText:@"text" withContext:builder.context];
            }];
            
            // Row "Navigation"
            [builder buildNavigationRow:^(TBNavigationRow *row) {
                [row setTitle:@"Navigation" withContext:builder.context];
                [row setImage:[UIImage imageNamed:@"SampleIcon.png"] withContext:builder.context];
                row.tapHandler = ^{
                    TBTableViewController *nextViewController = [[TBTableViewController alloc] initWithStyle:UITableViewStylePlain];
                    [weakSelf.navigationController pushViewController:nextViewController animated:YES];
                };
            }];
            
            // Row "SingleChoice"
            [builder buildSingleChoiceNavigationRow:^(TBSingleChoiceNavigationRow *row) {
                [row setTitle:@"Single Choice" withContext:builder.context];
                [row setImage:[UIImage imageNamed:@"SampleIcon.png"] withContext:builder.context];
                row.navigationController = weakSelf.navigationController;
                NSArray *options = @[@"One", @"Two", @"Three"];
                [row setOptions:options selectedIndex:0 withContext:builder.context];
                [row setChoiceViewControllerTitle:@"Select" withContext:builder.context];
                [row setChoiceSectionHeaderTitle:@"Options" withContext:builder.context];
                row.selectionChangeHandler = ^(NSInteger index) {
                    NSLog(@"%@ is selected.", options[index]);
                };
            }];
            
            // Row "Switch"
            [builder buildSwitchRow:^(TBSwitchRow *row) {
                [row setTitle:@"Switch" withContext:builder.context];
                [row setImage:[UIImage imageNamed:@"SampleIcon.png"] withContext:builder.context];
                [row setValue:YES withContext:builder.context];
                row.valueChangeHandler = ^(BOOL value) {
                    NSLog(@"Switch is %@", (value) ? @"on" : @"off");
                };
            }];
        }];
        
        // Section "Single Choice Section"
        [builder buildSingleChoiceSection:^(TBSingleChoiceSection *section) {
            [section setHeaderTitle:@"Single Choice Section" withContext:builder.context];
            NSArray *options = @[@"Brewed Coffee", @"Caffè Latte", @"Cappuccino", @"Hot Chocolate"];
            [section setOptions:options selectedIndex:1 withContext:builder.context];
            section.selectionChangeHandler = ^(NSInteger index) {
                NSLog(@"%@ is selected.", options[index]);
            };
            [section setFooterTitle:@"Select Your Favorite Drink." withContext:builder.context];
        }];
    }];
    return tableData;
}

@end
