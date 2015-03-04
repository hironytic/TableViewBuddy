//
//  InsertDeleteViewController.m
//  TableViewBuddyExample
//
//  Created by ichi on 2015/03/01.
//  Copyright (c) 2015年 Hironytic. All rights reserved.
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
