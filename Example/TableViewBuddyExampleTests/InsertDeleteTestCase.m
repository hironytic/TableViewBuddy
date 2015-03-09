//
//  InsertDeleteTestCase.m
//  TableViewBuddyExample
//
//  Created by ichi on 2015/03/07.
//  Copyright (c) 2015年 Hironytic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <KIF/KIF.h>
#import <KIF/KIFUITestActor-IdentifierTests.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

@interface InsertDeleteTestCase : KIFTestCase

@end

@implementation InsertDeleteTestCase

- (void)beforeAll {
    [tester waitForViewWithAccessibilityIdentifier:@"insert_and_delete"];
    [tester tapViewWithAccessibilityIdentifier:@"insert_and_delete"];
}

- (void)afterAll {
    [tester waitForViewWithAccessibilityLabel:@"Done"];
    [tester tapViewWithAccessibilityLabel:@"Done"];
}

- (void)testInsertAndDelete {
    UITableViewCell *cell;

    [tester waitForViewWithAccessibilityLabel:@"New Item"];
    
    [tester enterText:@"Item 1" intoViewWithAccessibilityLabel:@"New Item"];
    [tester tapViewWithAccessibilityLabel:@"Insert"];
    [tester waitForAnimationsToFinish];
    
    cell = [tester waitForCellAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] inTableViewWithAccessibilityIdentifier:@"item_table"];
    [tester expectView:cell toContainText:@"Item 1"];

    [tester enterText:@"Item 2" intoViewWithAccessibilityLabel:@"New Item"];
    [tester tapViewWithAccessibilityLabel:@"Insert"];
    [tester waitForAnimationsToFinish];
    
    cell = [tester waitForCellAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] inTableViewWithAccessibilityIdentifier:@"item_table"];
    [tester expectView:cell toContainText:@"Item 2"];
    cell = [tester waitForCellAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] inTableViewWithAccessibilityIdentifier:@"item_table"];
    [tester expectView:cell toContainText:@"Item 1"];
    
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] inTableViewWithAccessibilityIdentifier:@"item_table"];
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] inTableViewWithAccessibilityIdentifier:@"item_table"];
    
    [tester tapViewWithAccessibilityLabel:@"Delete Checked Items"];
    [tester waitForAnimationsToFinish];

    cell = [tester waitForCellAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] inTableViewWithAccessibilityIdentifier:@"item_table"];
    [tester expectView:cell toContainText:@"Undeletable Item 2"];
}

@end
