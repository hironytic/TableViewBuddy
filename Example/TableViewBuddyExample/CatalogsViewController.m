//
// CatalogsViewController.m
// TableViewBuddyExample
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

#import "CatalogsViewController.h"
#import "TableViewBuddy.h"
#import "TBSystemVersion.h"

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
                [row setAccessibilityIdentifier:@"action" withContext:builder.context];
                [row setImage:[UIImage imageNamed:@"SampleIcon.png"] withContext:builder.context];
                row.tapHandler = ^{
                    [weakSelf showAlert:@"Action is tapped."];
                };
            }];
            
            // Row "Button"
            [builder buildButtonRow:^(TBButtonRow *row) {
                [row setTitle:@"Button" withContext:builder.context];
                [row setAccessibilityIdentifier:@"button" withContext:builder.context];
                [row setImage:[UIImage imageNamed:@"SampleIcon.png"] withContext:builder.context];
                row.tapHandler = ^{
                    [weakSelf showAlert:@"Button is tapped."];
                };
            }];
            
            // Row "Check"
            [builder buildCheckRow:^(TBCheckRow *row) {
                [row setTitle:@"Check" withContext:builder.context];
                [row setAccessibilityIdentifier:@"check" withContext:builder.context];
                [row setImage:[UIImage imageNamed:@"SampleIcon.png"] withContext:builder.context];
                [row setValue:YES withContext:builder.context];
                row.valueChangeHandler = ^(BOOL value) {
                    [weakSelf showAlert:[NSString stringWithFormat:@"Check value becomes %@.", (value) ? @"checked" : @"unchecked"]];
                };
            }];
            
            // Row "Label"
            [builder buildLabelRow:^(TBLabelRow *row) {
                [row setTitle:@"Label" withContext:builder.context];
                [row setAccessibilityIdentifier:@"label" withContext:builder.context];
                [row setImage:[UIImage imageNamed:@"SampleIcon.png"] withContext:builder.context];
                [row setDetailText:@"text" withContext:builder.context];
            }];
            
            // Row "Navigation"
            [builder buildNavigationRow:^(TBNavigationRow *row) {
                [row setTitle:@"Navigation" withContext:builder.context];
                [row setAccessibilityIdentifier:@"navigation" withContext:builder.context];
                [row setImage:[UIImage imageNamed:@"SampleIcon.png"] withContext:builder.context];
                row.tapHandler = ^{
                    TBTableViewController *nextViewController = [[TBTableViewController alloc] initWithStyle:UITableViewStylePlain];
                    nextViewController.title = @"Next";
                    [weakSelf.navigationController pushViewController:nextViewController animated:YES];
                };
            }];
            
            // Row "SingleChoice"
            [builder buildSingleChoiceNavigationRow:^(TBSingleChoiceNavigationRow *row) {
                [row setTitle:@"Single Choice" withContext:builder.context];
                [row setImage:[UIImage imageNamed:@"SampleIcon.png"] withContext:builder.context];
                [row setAccessibilityIdentifier:@"single_choice" withContext:builder.context];
                [row setChoiceTableAccessibilityIdentifier:@"choice_table" withContext:builder.context];
                row.navigationController = weakSelf.navigationController;
                NSArray *options = @[@"One", @"Two", @"Three"];
                [row setOptions:options selectedIndex:0 withContext:builder.context];
                [row setChoiceViewControllerTitle:@"Select" withContext:builder.context];
                [row setChoiceSectionHeaderTitle:@"Options" withContext:builder.context];
                row.selectionChangeHandler = ^(NSInteger index) {
                    [weakSelf showAlert:[NSString stringWithFormat:@"%@ is selected.", options[index]]];
                };
            }];
            
            // Row "Switch"
            [builder buildSwitchRow:^(TBSwitchRow *row) {
                [row setTitle:@"Switch" withContext:builder.context];
                [row setAccessibilityIdentifier:@"switch" withContext:builder.context];
                [row setSwitchAccessibilityIdentifier:@"the_switch" withContext:builder.context];
                [row setImage:[UIImage imageNamed:@"SampleIcon.png"] withContext:builder.context];
                [row setValue:YES withContext:builder.context];
                row.valueChangeHandler = ^(BOOL value) {
                    [weakSelf showAlert:[NSString stringWithFormat:@"Switch is %@.", (value) ? @"on" : @"off"]];
                };
            }];
        }];
        
        // Section "Single Choice Section"
        [builder buildSingleChoiceSection:^(TBSingleChoiceSection *section) {
            [section setHeaderTitle:@"Single Choice Section" withContext:builder.context];
            NSArray *options = @[@"Brewed Coffee", @"Caffè Latte", @"Cappuccino", @"Hot Chocolate"];
            [section setOptions:options selectedIndex:1 withContext:builder.context];
            section.selectionChangeHandler = ^(NSInteger index) {
                [weakSelf showAlert:[NSString stringWithFormat:@"%@ is selected.", options[index]]];
            };
            [section setFooterTitle:@"Select Your Favorite Drink." withContext:builder.context];
        }];
    }];
    return tableData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.accessibilityIdentifier = @"catalogs_table";
}

- (void)showAlert:(NSString *)message {
    if (TBSystemVersionAtLeast(@"8.0")) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self.navigationController presentViewController:alertController animated:YES completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

@end
