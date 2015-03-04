//
// TBTableViewController.m
// TableViewBuddy
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

#import "TBTableViewController.h"
#import "TBTableData.h"

@interface TBTableViewController ()
@property(nonatomic, copy) TBTableData *(^buildTableDataBlock)(TBTableViewController *vc);
@end

@implementation TBTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [self initWithStyle:style buildTableDataBlock:nil];
}

- (instancetype)initWithStyle:(UITableViewStyle)style buildTableDataBlock:(TBTableData *(^)(TBTableViewController *vc))block {
    self = [super initWithStyle:style];
    if (self != nil) {
        if (block != nil) {
            _buildTableDataBlock = [block copy];
        }
    }
    return self;
}

- (TBTableData *)buildTableData {
    if (self.buildTableDataBlock != nil) {
        return self.buildTableDataBlock(self);
    } else {
        return [[TBTableData alloc] init];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.tableData == nil) {
        self.tableData = [self buildTableData];
    }
    self.tableData.tableView = self.tableView;
    self.tableView.dataSource = self.tableData;
    self.tableView.delegate = self.tableData;
}

@end
