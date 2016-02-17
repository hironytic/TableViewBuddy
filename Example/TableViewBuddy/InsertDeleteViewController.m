//
// InsertDeleteViewController.m
// TableViewBuddyExample
//
// Copyright (c) 2015,2016 Hironori Ichimiya <hiron@hironytic.com>
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

#import "InsertDeleteViewController.h"
#import "TableViewBuddy.h"

@interface InsertDeleteViewController ()
@property (weak, nonatomic) IBOutlet UITextField *itemNameField;
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (nonatomic, strong) TBTableData *itemData;
@end

@implementation InsertDeleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TBTableDataBuilder *builder = [TBTableDataBuilder new];
    self.itemData = [builder buildTableData:^{
        [builder buildGenericSection:^(TBTableDataSection *section) {
            // configure undeletable items
            for (NSInteger ix = 0; ix < 3; ++ix) {
                [builder buildLabelRow:^(TBLabelRow *row) {
                    NSString *title = [NSString stringWithFormat:@"Undeletable Item %ld", (long)ix];
                    [row setTitle:title withContext:builder.context];
                }];
            }
        }];
    }];
    
    self.itemData.tableView = self.itemTableView;
    self.itemTableView.delegate = self.itemData;
    self.itemTableView.dataSource = self.itemData;
    self.itemTableView.accessibilityIdentifier = @"item_table";
}

- (IBAction)insertButtonDidTap:(id)sender {
    [self.itemNameField resignFirstResponder];
    NSString *itemName = self.itemNameField.text;
    self.itemNameField.text = @"";
    
    TBTableDataSection *section = self.itemData.sections[0];
    TBTableDataRow *insertionPoint = section.rows[1];
    [self.itemData updateAnimated:YES updater:^(TBTableDataUpdateContext *context) {
        context.insertionAnimation = UITableViewRowAnimationFade;
        [section insertAfter:insertionPoint withContext:context buildBlock:^(TBTableDataBuilder *builder) {
            [builder buildCheckRow:^(TBCheckRow *row) {
                [row setTitle:itemName withContext:builder.context];
                [row setValue:NO withContext:builder.context];
            }];
        }];
    }];
}

- (IBAction)deleteButtonDidTap:(id)sender {
    TBTableDataSection *section = self.itemData.sections[0];
    NSArray *rows = section.rows;
    
    [self.itemData updateAnimated:YES updater:^(TBTableDataUpdateContext *context) {
        context.deletionAnimation = UITableViewRowAnimationFade;
        for (id row in rows) {
            if ([row isKindOfClass:[TBCheckRow class]]) {
                TBCheckRow *checkRow = (TBCheckRow *)row;
                if (checkRow.value) {
                    [checkRow deleteWithContext:context];
                }
            }
        }
    }];
}

@end
