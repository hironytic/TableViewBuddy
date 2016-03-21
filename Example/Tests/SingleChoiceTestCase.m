//
// SingleChoiceTestCase.m
// TableViewBuddyExample
//
// Copyright (c) 2016 Hironori Ichimiya <hiron@hironytic.com>
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

#import <XCTest/XCTest.h>
#import <KIF/KIF.h>
#import <KIF/KIFUITestActor-IdentifierTests.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <TableViewBuddy/TableViewBuddy.h>

@interface SingleChoiceTestItem : NSObject
@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) UIImage *image;
@end
@implementation SingleChoiceTestItem
@end

@interface SingleChoiceTestCase : KIFTestCase
@end

static UINavigationController *testViewController = nil;

@implementation SingleChoiceTestCase

- (void)beforeAll {
    TBTableViewController *viewController = [[TBTableViewController alloc] initWithStyle:UITableViewStyleGrouped buildTableDataBlock:^TBTableData *(TBTableViewController *vc) {
        TBTableData *tableData = [TBTableData tableDataWithBuildBlock:^(TBTableDataBuilder *builder) {
            [builder buildSingleChoiceSection:^(TBSingleChoiceSection *section) {
                [section setHeaderTitle:@"String Options" withContext:builder.context];
                [section setOptions:@[@"First", @"Second", @"Third"] selectedIndex:0 withContext:builder.context];
            }];
            [builder buildSingleChoiceSection:^(TBSingleChoiceSection *section) {
                [section setHeaderTitle:@"Option with Image 1" withContext:builder.context];
                [section setOptions:@[
                    @{
                        @"title": @"with image",
                        @"image": [UIImage imageNamed:@"SampleIcon.png"]
                    },
                    @{
                        @"title": @"with no image"
                    }
                ] selectedIndex:NSNotFound withContext:builder.context];
            }];
            [builder buildSingleChoiceSection:^(TBSingleChoiceSection *section) {
                [section setHeaderTitle:@"Option with Image 2" withContext:builder.context];
                SingleChoiceTestItem *item1 = [SingleChoiceTestItem new];
                item1.title = @"with image";
                item1.image = [UIImage imageNamed:@"SampleIcon.png"];
                SingleChoiceTestItem *item2 = [SingleChoiceTestItem new];
                item2.title = @"with no image";
                item2.image = nil;
                [section setOptions:@[item1, item2] selectedIndex:NSNotFound withContext:builder.context];
            }];
            [builder buildGenericSection:^(TBTableDataSection *section) {
                [builder buildSingleChoiceNavigationRow:^(TBSingleChoiceNavigationRow *row) {
                    [row setTitle:@"Choice" withContext:builder.context];
                    row.navigationControllerBlock = ^UINavigationController *() {
                        return testViewController;
                    };
                    [row setChoiceViewControllerStyle:UITableViewStyleGrouped withContext:builder.context];
                    [row setChoiceViewControllerTitle:@"Your choice" withContext:builder.context];
                    [row setChoiceTableAccessibilityIdentifier:@"your_choice" withContext:builder.context];
                    [row setOptions:@[
                        @{
                            @"title": @"with image",
                            @"image": [UIImage imageNamed:@"SampleIcon.png"]
                        },
                        @{
                            @"title": @"with no image"
                        }
                    ] selectedIndex:NSNotFound withContext:builder.context];
                }];
            }];
        }];
        return tableData;
    }];
    viewController.title = @"SingleChoiceTest";
    testViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:testViewController animated:YES completion:nil];
    [tester waitForViewWithAccessibilityLabel:@"SingleChoiceTest"];
    viewController.tableView.accessibilityIdentifier = @"single_choice_tableview";
}

- (void)afterAll {
    [testViewController dismissViewControllerAnimated:YES completion:nil];
    testViewController = nil;
}

- (void)testStringOptions {
    NSInteger section = 0;
    UITableViewCell *cell;
    
    cell = [tester waitForCellAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] inTableViewWithAccessibilityIdentifier:@"single_choice_tableview"];
    expect(cell).notTo.beNil();
    expect(cell.accessoryType).to.equal(UITableViewCellAccessoryCheckmark);
    
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:section] inTableViewWithAccessibilityIdentifier:@"single_choice_tableview"];
    
    cell = [tester waitForCellAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] inTableViewWithAccessibilityIdentifier:@"single_choice_tableview"];
    expect(cell).notTo.beNil();
    expect(cell.accessoryType).to.equal(UITableViewCellAccessoryNone);

    cell = [tester waitForCellAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:section] inTableViewWithAccessibilityIdentifier:@"single_choice_tableview"];
    expect(cell).notTo.beNil();
    expect(cell.accessoryType).to.equal(UITableViewCellAccessoryCheckmark);
}

- (void)testOptionWithImage1 {
    NSInteger section = 1;
    UITableViewCell *cell;
    
    cell = [tester waitForCellAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] inTableViewWithAccessibilityIdentifier:@"single_choice_tableview"];
    expect(cell).notTo.beNil();
    expect(cell.accessoryType).to.equal(UITableViewCellAccessoryNone);
    expect(cell.imageView.image).notTo.beNil();

    cell = [tester waitForCellAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:section] inTableViewWithAccessibilityIdentifier:@"single_choice_tableview"];
    expect(cell).notTo.beNil();
    expect(cell.accessoryType).to.equal(UITableViewCellAccessoryNone);
    expect(cell.imageView.image).to.beNil();
    
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] inTableViewWithAccessibilityIdentifier:@"single_choice_tableview"];
    
    cell = [tester waitForCellAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] inTableViewWithAccessibilityIdentifier:@"single_choice_tableview"];
    expect(cell).notTo.beNil();
    expect(cell.accessoryType).to.equal(UITableViewCellAccessoryCheckmark);
    expect(cell.imageView.image).notTo.beNil();
}

- (void)testOptionWithImage2 {
    NSInteger section = 2;
    UITableViewCell *cell;
    
    cell = [tester waitForCellAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] inTableViewWithAccessibilityIdentifier:@"single_choice_tableview"];
    expect(cell).notTo.beNil();
    expect(cell.accessoryType).to.equal(UITableViewCellAccessoryNone);
    expect(cell.imageView.image).notTo.beNil();
    
    cell = [tester waitForCellAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:section] inTableViewWithAccessibilityIdentifier:@"single_choice_tableview"];
    expect(cell).notTo.beNil();
    expect(cell.accessoryType).to.equal(UITableViewCellAccessoryNone);
    expect(cell.imageView.image).to.beNil();
    
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] inTableViewWithAccessibilityIdentifier:@"single_choice_tableview"];
    
    cell = [tester waitForCellAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] inTableViewWithAccessibilityIdentifier:@"single_choice_tableview"];
    expect(cell).notTo.beNil();
    expect(cell.accessoryType).to.equal(UITableViewCellAccessoryCheckmark);
    expect(cell.imageView.image).notTo.beNil();
}

- (void)testSingleChoiceNavigationRow {
    NSInteger section = 3;
    UITableViewCell *cell;
    
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] inTableViewWithAccessibilityIdentifier:@"single_choice_tableview"];
    [tester waitForViewWithAccessibilityLabel:@"Your choice"];
    
    cell = [tester waitForCellAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] inTableViewWithAccessibilityIdentifier:@"your_choice"];
    expect(cell).notTo.beNil();
    expect(cell.accessoryType).to.equal(UITableViewCellAccessoryNone);
    expect(cell.imageView.image).notTo.beNil();
    
    cell = [tester waitForCellAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] inTableViewWithAccessibilityIdentifier:@"your_choice"];
    expect(cell).notTo.beNil();
    expect(cell.accessoryType).to.equal(UITableViewCellAccessoryNone);
    expect(cell.imageView.image).to.beNil();
    
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] inTableViewWithAccessibilityIdentifier:@"your_choice"];
    
    cell = [tester waitForCellAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] inTableViewWithAccessibilityIdentifier:@"your_choice"];
    expect(cell).notTo.beNil();
    expect(cell.accessoryType).to.equal(UITableViewCellAccessoryCheckmark);
    expect(cell.imageView.image).notTo.beNil();

    [tester tapViewWithAccessibilityLabel:@"Back"];
}

@end
