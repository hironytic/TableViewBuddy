//
//  SampleTableViewController2.m
//  TableViewBuddyExample
//
//  Created by ichi on 2014/10/04.
//  Copyright (c) 2014年 Hironytic. All rights reserved.
//

#import "SampleTableViewController2.h"
#import "TableViewBuddy.h"

@interface SampleTableViewController2 ()
@property(nonatomic, strong) TBTableData *tableData;
@end

@implementation SampleTableViewController2

- (void)viewDidLoad {
    [super viewDidLoad];

    TBTableData *tableData = [TBTableData tableDataWithConfigurator:^(TBTableDataInitializationContext *context) {
        TBTableDataSection *prevSection = nil;
        
        prevSection = [context.tableData insertSectionAfter:prevSection withContext:context generator:[TBTableDataSection generatorWithConfigurator:^(TBTableDataInitializationContext *context) {
            TBTableDataRow *prevRow = nil;
            
            prevRow = [context.section insertRowAfter:prevRow withContext:context generator:[TBLabelRow generatorWithConfigurator:^(TBTableDataInitializationContext *context) {
                TBLabelRow *row = (TBLabelRow *)context.row;
                row.title = @"Detail";
            }]];
        }]];
    }];
    tableData.tableView = self.tableView;
    
    self.tableData = tableData;
    self.tableView.dataSource = tableData;
    self.tableView.delegate = tableData;
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}
//
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
