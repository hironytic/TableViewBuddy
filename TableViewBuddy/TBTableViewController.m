//
// TBTableViewController.m
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

#import "TBTableViewController.h"
#import "TBTableData.h"
#import "TBTableDataBuildHelper.h"

@interface TBTableViewController ()
@property(nonatomic, copy) void (^configureBlock)(TBTableViewController *vc, TBTableDataBuildHelper *helper);
@end

@implementation TBTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [self initWithStyle:style configureBlock:nil];
}

- (instancetype)initWithStyle:(UITableViewStyle)style configureBlock:(void (^)(TBTableViewController *vc, TBTableDataBuildHelper *helper))block {
    self = [super initWithStyle:style];
    if (self != nil) {
        if (block != nil) {
            _configureBlock = [block copy];
        }
    }
    return self;
}

- (TBTableData *)buildTableData {
    TBTableDataBuildHelper *helper = [[TBTableDataBuildHelper alloc] init];
    if (self.configureBlock != nil) {
        TBTableViewController * __weak weakSelf = self;
        return [helper buildTableData:^{
            self.configureBlock(weakSelf, helper);
        }];
    } else {
        NSLog(@"Warning: TableData object was not built.");
        return nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.tableData == nil) {
        TBTableData *tableData = [self buildTableData];
        tableData.tableView = self.tableView;
        self.tableData = tableData;
        self.tableView.dataSource = tableData;
        self.tableView.delegate = tableData;
    }
}

@end
