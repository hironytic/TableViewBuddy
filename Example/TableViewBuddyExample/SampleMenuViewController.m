//
// SampleMenuViewController.m
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

#import "SampleMenuViewController.h"
#import "TableViewBuddy.h"
#import "CatalogsViewController.h"
#import "InsertDeleteViewController.h"

@interface SampleMenuViewController ()

@end

@implementation SampleMenuViewController

- (TBTableData *)buildTableData {
    SampleMenuViewController * __weak weakSelf = self;
    TBTableDataBuilder *builder = [[TBTableDataBuilder alloc] init];
    TBTableData *tableData = [builder buildTableData:^{
        [builder buildGenericSection:^(TBTableDataSection *section) {
            // "Catalogs"
            [builder buildActionRow:^(TBActionRow *row) {
                [row setTitle:@"Catalogs" withContext:builder.context];
                row.tapHandler = ^{
                    CatalogsViewController *catalogsViewController = [[CatalogsViewController alloc] init];
                    [weakSelf executeViewController:catalogsViewController];
                };
            }];
            
            // "Insert and Delete"
            [builder buildActionRow:^(TBActionRow *row) {
                [row setTitle:@"Insert and Delete" withContext:builder.context];
                row.tapHandler = ^{
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"InsertDelete" bundle:nil];
                    UIViewController *viewController = [storyboard instantiateInitialViewController];
                    [weakSelf executeViewController:viewController];
                };
            }];
        }];
    }];
    return tableData;
}

- (void)executeViewController:(UIViewController *)viewController {
    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(viewControllerDone:)];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)viewControllerDone:(id)sender {
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
