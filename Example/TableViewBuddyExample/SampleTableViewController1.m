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
    __block TBTableDataRow *row_2_2;
    
    __block TBTableDataRow *row_New = nil;
    
    SampleTableViewController1 * __weak weakSelf = self;
    TBTableData *tableData = [TBTableData tableDataWithConfigurator:^(TBTableDataInitializationContext *context) {
        TBTableDataSection *prevSection = nil;
        
        section_1 = prevSection = [context.tableData withContext:context insertSectionAfter:prevSection generator:[TBTableDataSection generatorWithConfigurator:^(TBTableDataInitializationContext *context) {
            TBTableDataRow *prevRow = nil;
            
            row_1_1 = prevRow = [context.section withContext:context insertRowAfter:prevRow generator:[TBButtonRow generatorWithConfigurator:^(TBTableDataInitializationContext *context) {
                TBButtonRow *row = (TBButtonRow *)context.row;
                row.title = @"X";
                row.tapHandler = nil;
            }]];
            
            prevRow = [context.section withContext:context insertRowAfter:prevRow generator:[TBButtonRow generatorWithConfigurator:^(TBTableDataInitializationContext *context) {
                TBButtonRow *row = (TBButtonRow *)context.row;
                row.title = @"Y";
                row.tapHandler = ^{
                    [weakSelf.tableData updateAnimated:YES updater:^(TBTableDataUpdateContext *context) {
                        [section_2 withContext:context setHidden:!section_2.hidden];
                    }];
                };
            }]];
            
            prevRow = [context.section withContext:context insertRowAfter:prevRow generator:[TBButtonRow generatorWithConfigurator:^(TBTableDataInitializationContext *context) {
                TBButtonRow *row = (TBButtonRow *)context.row;
                row.title = @"Z";
                row.tapHandler = ^{
                    [weakSelf.tableData updateAnimated:YES updater:^(TBTableDataUpdateContext *context) {
                        for (NSInteger ix = 0; ix < 3; ++ix) {
                            NSInteger myCounter = counter;
                            ++counter;
                            row_New = [section_1 withContext:context
                                              insertRowAfter:(row_New == nil) ? row_1_1  : row_New
                                                   generator:[TBButtonRow generatorWithConfigurator:^(TBTableDataInitializationContext *context) {
                                TBButtonRow *row = (TBButtonRow *)context.row;
                                row.title = [NSString stringWithFormat:@"hoge %d", myCounter];
                            }]];
                        }
                    }];
                };
            }]];
        }]];
        
        section_2 = prevSection = [context.tableData withContext:context insertSectionAfter:prevSection generator:[TBTableDataSection generatorWithConfigurator:^(TBTableDataInitializationContext *context) {
            TBTableDataRow *prevRow = nil;
            
            prevRow = [context.section withContext:context insertRowAfter:prevRow generator:[TBButtonRow generatorWithConfigurator:^(TBTableDataInitializationContext *context) {
                TBButtonRow *row = (TBButtonRow *)context.row;
                row.title = @"Tap Here";
                row.tapHandler = ^{
                    [weakSelf.tableData updateAnimated:YES updater:^(TBTableDataUpdateContext *context) {
                        [row_1_1 withContext:context setHidden:!row_1_1.hidden];
                    }];
                };
            }]];
            
            prevRow = [context.section withContext:context insertRowAfter:prevRow generator:[TBButtonRow generatorWithConfigurator:^(TBTableDataInitializationContext *context) {
                TBButtonRow *row = (TBButtonRow *)context.row;
                row.title = @"...";
            }]];
            
            row_2_2 = prevRow = [context.section withContext:context insertRowAfter:prevRow generator:[TBButtonRow generatorWithConfigurator:^(TBTableDataInitializationContext *context) {
                TBButtonRow *row = (TBButtonRow *)context.row;
                row.title = @"...2";
            }]];
        }]];
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