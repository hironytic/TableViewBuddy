//
// InsertDeleteTestCase.m
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
