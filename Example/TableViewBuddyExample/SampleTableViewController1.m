//
// SampleTableViewController1.m
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

#import "SampleTableViewController1.h"
#import "TableViewBuddy.h"
#import "SampleTableViewController2.h"

@interface SampleTableViewController1 ()

@property(nonatomic, strong) TBTableData *tableData;

@end

@implementation SampleTableViewController1

@synthesize tableData = _tableData;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __block NSInteger counter = 1;
    __block NSInteger counter2 = 1;
    
    __block TBTableDataSection *section_1;
    __block TBTableDataSection *section_2;
    __block TBTableDataRow *row_1_1;
    __block TBTableDataRow *row_1_3;
    __block TBLabelRow *row_2_2;
    __block TBSwitchRow *row_2_4;
    __block TBCheckRow *row_2_5;
    __block TBTextFieldRow *row_2_6;
    
    __block TBTableDataRow *row_New = nil;
    
    SampleTableViewController1 * __weak weakSelf = self;
    TBTableDataBuildHelper *helper = [[TBTableDataBuildHelper alloc] init];
    TBTableData *tableData = [helper buildTableData:^{
        // Section 1
        [helper buildGenericSection:^(TBTableDataSection *section) {
            section_1 = section;
            
            [helper buildLabelRow:^(TBLabelRow *row) {
                row_1_1 = row;
                [row setTitle:@"X" withContext:helper.context];
            }];
            
            [helper buildActionRow:^(TBActionRow *row) {
                [row setImage:[UIImage imageNamed:@"SampleIcon.png"] withContext:helper.context];
                [row setTitle:@"Y" withContext:helper.context];
                row.tapHandler = ^{
                    [weakSelf.tableData updateAnimated:YES updater:^(TBTableDataUpdateContext *context) {
                        if (section_1.headerTitle == nil) {
                            [section_1 setHeaderTitle:@"Header1" withContext:context];
                            [section_1 setFooterTitle:@"Footer is a footer" withContext:context];
                        } else {
                            [section_1 setHeaderTitle:nil withContext:context];
                            [section_1 setFooterTitle:nil withContext:context];
                        }
                    }];
                    
//                    row_1_1.enabled = !row_1_1.enabled;
                    
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"aa" message:@"bb" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                    [alertView show];
//                    [weakSelf.tableData updateAnimated:YES updater:^(TBTableDataUpdateContext *context) {
//                        [section_2 withContext:context setHidden:!section_2.hidden];
//                    }];
                };
            }];
            
            [helper buildButtonRow:^(TBButtonRow *row) {
                [row setTitle:@"Z" withContext:helper.context];
                row.tapHandler = ^{
                    [weakSelf.tableData updateAnimated:YES updater:^(TBTableDataUpdateContext *context) {
                        for (NSInteger ix = 0; ix < 3; ++ix) {
                            NSInteger myCounter = counter;
                            ++counter;
                            row_New = [section_1 insertRowAfter:(row_New == nil) ? row_1_1  : row_New
                                                    withContext:context
                                                      generator:[TBButtonRow rowGeneratorWithConfigurator:^(TBTableDataInitializationContext *context) {
                                TBButtonRow *row = (TBButtonRow *)context.row;
                                [row setTitle:[NSString stringWithFormat:@"hoge %ld", (long)myCounter] withContext:context];
                            }]];
                        }
                    }];
                };
            }];
            
            [helper buildNavigationRow:^(TBNavigationRow *row) {
                row_1_3 = row;
                [row setTitle:@"Show Detail" withContext:helper.context];
                [row setDetailText:@"Normal" withContext:helper.context];
                row.tapHandler = ^{
                    SampleTableViewController2 *nextViewController = [[SampleTableViewController2 alloc] initWithStyle:UITableViewStylePlain];
                    [weakSelf.navigationController pushViewController:nextViewController animated:YES];
                };
            }];
        }];
        
        // Section 2
        [helper buildGenericSection:^(TBTableDataSection *section) {
            section_2 = section;
            [section setFooterTitle:@"Section 2" withContext:helper.context];
            
            [helper buildButtonRow:^(TBButtonRow *row) {
                [row setTitle:@"Tap Here" withContext:helper.context];
                row.tapHandler = ^{
                    [weakSelf.tableData updateAnimated:YES updater:^(TBTableDataUpdateContext *context) {
                        [row_1_1 setHidden:!row_1_1.hidden withContext:context];
                    }];
                };
            }];
           
            [helper buildButtonRow:^(TBButtonRow *row) {
                [row setTitle:@"..." withContext:helper.context];
                row.tapHandler = ^{
                    ++counter2;
                    [row_2_2 setTitle:[NSString stringWithFormat:@"Count %ld", (long)counter2] withContext:nil];
                    
                    row_2_4.value = !row_2_4.value;
                    [row_2_5 setValue:!row_2_5.value withContext:nil];
                };
            }];
            
            [helper buildLabelRow:^(TBLabelRow *row) {
                row_2_2 = row;
                [row setTitle:[NSString stringWithFormat:@"Count %ld", (long)counter2] withContext:helper.context];
                [row setDetailText:@"long long long long text is here." withContext:helper.context];
            }];
            
            [helper buildSwitchRow:^(TBSwitchRow *row) {
                row_2_4 = row;
                row.title = @"On/Off";
                row.value = YES;
                row.valueChangeHandler = ^(BOOL value) {
                    NSLog(@"switch value changed to %@", (value) ? @"ON" : @"OFF");
                };
            }];
            
            [helper buildCheckRow:^(TBCheckRow *row) {
                row_2_5 = row;
                [row setTitle:@"Check it" withContext:helper.context];
                [row setValue:NO withContext:helper.context];
                row.valueChangeHandler = ^(BOOL value) {
                    NSLog(@"check value changed to %@", (value) ? @"ON" : @"OFF");
                };
            }];
            
            [helper buildTextFieldRow:^(TBTextFieldRow *row) {
                row_2_6 = row;
                row.title = @"Text";
                row.text = nil;
                row.placeholder = @"Optional";
                row.textChangeHandler = ^(NSString *text) {
                    NSLog(@"text is %@", text);
                };
                row.textFieldConfigulator = ^(UITextField *textField) {
                    textField.returnKeyType = UIReturnKeyDone;
                };
                row.textFieldShouldReturnHandler = ^BOOL (UITextField *textField) {
                    [textField resignFirstResponder];
                    return NO;
                };
            }];
        }];
        
        // Section 3 --- choice section
        [helper buildSingleChoiceSection:^(TBSingleChoiceSection *section) {
            TBSingleChoiceSection * __weak weakSection = section;
            [section setHeaderTitle:@"Your Choice" withContext:helper.context];
            [section setOptions:@[@"First", @"Second", @"Third", @"Fourth"]
                  selectedIndex:2
                    withContext:helper.context];
            section.selectionChangeHandler = ^(NSInteger index) {
                NSLog(@"%@ is selected", weakSection.options[index]);
            };
        }];
        
        // Section 4
        [helper buildGenericSection:^(TBTableDataSection *section) {
            [helper buildSingleChoiceNavigationRow:^(TBSingleChoiceNavigationRow *row) {
                TBSingleChoiceNavigationRow * __weak weakRow = row;
                [row setTitle:@"Burger" withContext:helper.context];
                row.navigationController = weakSelf.navigationController;
                row.choiceViewControllerTitle = @"Select Burger";
                row.choiseSectionHeaderTitle = @"Menu";
                row.choiseSectionFooterTitle = @"Please select your favorite burger.";
                [row setOptions:@[@"None", @"Cheese Burger", @"Omlet Burger", @"Chili Burger", @"Special Burger"] selectedIndex:0 withContext:helper.context];
                row.selectionChangeHandler = ^(NSInteger index) {
                    NSLog(@"%@ is selected", weakRow.options[index]);
                };
            }];
        }];
    }];
    tableData.tableView = self.tableView;
    
    self.tableData = tableData;
    self.tableView.dataSource = tableData;
    self.tableView.delegate = tableData;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
