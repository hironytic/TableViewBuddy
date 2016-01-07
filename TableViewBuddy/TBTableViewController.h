//
// TBTableViewController.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TBTableData;
@class TBTableDataBuilder;

/**
 `TBTableViewController` is a table view controller that has a `<TBTableData>` object for data source.
 
 This is a convenient utility class that allows you to create `<TBTableData>` based view controller.
 You can use `<TBTableData>` in combination with any `UITableView` object without benefit of this class.
 But if you want a simple table view based controller, this class may help.
 
 `TBTableViewController` is used in many way.
 
 If you already have configured `<TBTableData>` object,
 create a `TBTableViewController` object, simply set the table data
 to `<tableData>` property, and present it.
 For example:

    TBTableViewController *viewController
            = [[TBTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    viewController.tableData = yourTableDataObject;
    [self.navigationController pushViewController:viewController animated:YES];
 
 Or you can create a `TBTableViewController` object with a block to configure its table data like below:
 
    TBTableViewController *viewController
            = [[TBTableViewController alloc] initWithStyle:UITableViewStyleGrouped
                                       buildTableDataBlock:^TBTableData *(TBTableViewController *vc)
    {
        TBTableData *tableData = [TBTableData tableDataWithBuildBlock:^(TBTableDataBuilder *builder) {
            // ... configuring table data here ...
        }];
        return tableData;
    }];
    [self.navigationController pushViewController:viewController animated:YES];
 
 You can also create a subclass of `TBTableViewController`.
 In this case, you may override `buildTableData` method to configure the table data.
 Here is an example:
 
    @interface XXXTableViewController : TBTableViewController
    @end
    
    @implementation XXXTableViewController
    - (TBTableData *)buildTableData {
        TBTableData *tableData = [TBTableData tableDataWithBuildBlock:^(TBTableDataBuilder *builder) {
            // ... configuring table data here ...
        }];
        return tableData;
    }
 
    // ... other implementations ...
 
    @end
 */
@interface TBTableViewController : UITableViewController

/**
 A `TBTableData` object used as a model of the table view.
 */
@property(nonatomic, strong) TBTableData *tableData;

/**
 Initializes object with a block object that configures table data.
 
 @param style A constant that specifies the style of table view.
 @param block A block object that configures table data. It is called from `buildTableData` method.
 */
- (instancetype)initWithStyle:(UITableViewStyle)style buildTableDataBlock:(TBTableData *(^)(TBTableViewController *vc))block;

/**
 Creates table data and configures it.
 
 This method is typically overridden by the derived class.
 It is called from `viewDidLoad` method if table data is not set yet.
 
 @return A generated table data.
 */
- (TBTableData *)buildTableData;

@end
