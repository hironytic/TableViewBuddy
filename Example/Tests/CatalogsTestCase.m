//
// CatalogsTestCase.m
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
#import "UIView+TestHelper.h"

@interface CatalogsTestCase : KIFTestCase

@end

@implementation CatalogsTestCase

- (void)beforeAll {
    [tester waitForViewWithAccessibilityIdentifier:@"catalogs"];
    [tester tapViewWithAccessibilityIdentifier:@"catalogs"];
}

- (void)afterAll {
    [tester tapViewWithAccessibilityLabel:@"Done"];
}

- (void)testActionRow {
    // tap Action
    [tester waitForViewWithAccessibilityLabel:@"Action"];
    [tester tapViewWithAccessibilityIdentifier:@"action"];
    
    // it should show an alert by tap handler
    [tester waitForViewWithAccessibilityLabel:@"Action is tapped."];
    [tester tapViewWithAccessibilityLabel:@"OK"];
}

- (void)testButtonRow {
    // tap Button
    [tester waitForViewWithAccessibilityLabel:@"Button"];
    [tester tapViewWithAccessibilityIdentifier:@"button"];
    
    // it should show an alert by tap handler
    [tester waitForViewWithAccessibilityLabel:@"Button is tapped."];
    [tester tapViewWithAccessibilityLabel:@"OK"];
}

- (void)testCheckRow {
    UIView *view;
    UITableViewCell *cell;
    
    // should be checked
    view = [tester waitForViewWithAccessibilityIdentifier:@"check"];
    expect(view).to.beKindOf([UITableViewCell class]);
    cell = (UITableViewCell *)view;
    expect(cell).notTo.beNil();
    expect(cell.accessoryType).to.equal(UITableViewCellAccessoryCheckmark);
    
    // tap Check
    [tester tapViewWithAccessibilityIdentifier:@"check"];

    // it should show an alert by value-change handler
    [tester waitForViewWithAccessibilityLabel:@"Check value becomes unchecked."];
    [tester tapViewWithAccessibilityLabel:@"OK"];

    // shoule be unchecked
    view = [tester waitForViewWithAccessibilityIdentifier:@"check"];
    expect(view).to.beKindOf([UITableViewCell class]);
    cell = (UITableViewCell *)view;
    expect(cell).notTo.beNil();
    expect(cell.accessoryType).to.equal(UITableViewCellAccessoryNone);
    
    // tap Check
    [tester tapViewWithAccessibilityIdentifier:@"check"];
    
    // it should show an alert by value-change handler
    [tester waitForViewWithAccessibilityLabel:@"Check value becomes checked."];
    [tester tapViewWithAccessibilityLabel:@"OK"];
    
    // should be checked
    view = [tester waitForViewWithAccessibilityIdentifier:@"check"];
    expect(view).to.beKindOf([UITableViewCell class]);
    cell = (UITableViewCell *)view;
    expect(cell).notTo.beNil();
    expect(cell.accessoryType).to.equal(UITableViewCellAccessoryCheckmark);
}

- (void)testLabelRow {
    UIView *view = [tester waitForViewWithAccessibilityIdentifier:@"label"];
    expect(view).to.beKindOf([UITableViewCell class]);
    UITableViewCell *cell = (UITableViewCell *)view;
    expect(cell).notTo.beNil();
    expect(cell.detailTextLabel.text).to.equal(@"text");
}

- (void)testNavigationRow {
    UIView *view = [tester waitForViewWithAccessibilityIdentifier:@"navigation"];
    expect(view).to.beKindOf([UITableViewCell class]);
    UITableViewCell *cell = (UITableViewCell *)view;
    expect(cell).notTo.beNil();
    expect(cell.accessoryType).to.equal(UITableViewCellAccessoryDisclosureIndicator);
    
    [tester tapViewWithAccessibilityIdentifier:@"navigation"];
    [tester waitForViewWithAccessibilityLabel:@"Next"];
    [tester tapViewWithAccessibilityLabel:@"Back"];
}

- (void)testSingleChoiceRow {
    UIView *view;
    UITableViewCell *cell;
    
    view = [tester waitForViewWithAccessibilityIdentifier:@"single_choice"];
    expect(view).to.beKindOf([UITableViewCell class]);
    cell = (UITableViewCell *)view;
    expect(cell).notTo.beNil();
    expect(cell.detailTextLabel.text).to.equal(@"One");
    expect(cell.accessoryType).to.equal(UITableViewCellAccessoryDisclosureIndicator);
    
    [tester tapViewWithAccessibilityIdentifier:@"single_choice"];
    
    [tester waitForViewWithAccessibilityLabel:@"Select"];
    [tester waitForViewWithAccessibilityLabel:@"OPTIONS"];  // capitalized in iOS 7+

    // tap "Three"
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] inTableViewWithAccessibilityIdentifier:@"choice_table"];

    // it should show an alert by selection-change handler
    [tester waitForViewWithAccessibilityLabel:@"Three is selected."];
    [tester tapViewWithAccessibilityLabel:@"OK"];
    
    [tester tapViewWithAccessibilityLabel:@"Back"];

    view = [tester waitForViewWithAccessibilityIdentifier:@"single_choice"];
    expect(view).to.beKindOf([UITableViewCell class]);
    cell = (UITableViewCell *)view;
    expect(cell).notTo.beNil();
    expect(cell.detailTextLabel.text).to.equal(@"Three");
}

- (void)testSwitch {
    [tester waitForViewWithAccessibilityLabel:@"Switch"];
    
    UIView *view;
    UISwitch *uiswitch;
    
    view = [tester waitForViewWithAccessibilityIdentifier:@"the_switch"];
    expect(view).to.beKindOf([UISwitch class]);
    uiswitch= (UISwitch *)view;
    expect(uiswitch.on).to.beTruthy();

    [tester setOn:NO forSwitchWithAccessibilityIdentifier:@"the_switch"];
    
    // it should show an alert by value-change handler
    [tester waitForViewWithAccessibilityLabel:@"Switch is off."];
    [tester tapViewWithAccessibilityLabel:@"OK"];

    view = [tester waitForViewWithAccessibilityIdentifier:@"the_switch"];
    expect(view).to.beKindOf([UISwitch class]);
    uiswitch= (UISwitch *)view;
    expect(uiswitch.on).to.beFalsy();
    
    [tester setOn:YES forSwitchWithAccessibilityIdentifier:@"the_switch"];

    // it should show an alert by value-change handler
    [tester waitForViewWithAccessibilityLabel:@"Switch is on."];
    [tester tapViewWithAccessibilityLabel:@"OK"];

    view = [tester waitForViewWithAccessibilityIdentifier:@"the_switch"];
    expect(view).to.beKindOf([UISwitch class]);
    uiswitch= (UISwitch *)view;
    expect(uiswitch.on).to.beTruthy();
}

- (void)testSingleChoiceSection {
    NSInteger section = 1;
    UITableViewCell *cell;
    
    cell = [tester waitForCellAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:section] inTableViewWithAccessibilityIdentifier:@"catalogs_table"];
    expect(cell).notTo.beNil();
    expect(cell.accessoryType).to.equal(UITableViewCellAccessoryCheckmark);
    
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] inTableViewWithAccessibilityIdentifier:@"catalogs_table"];

    // it should show an alert by value-change handler
    [tester waitForViewWithAccessibilityLabel:@"Brewed Coffee is selected."];
    [tester tapViewWithAccessibilityLabel:@"OK"];

    cell = [tester waitForCellAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:section] inTableViewWithAccessibilityIdentifier:@"catalogs_table"];
    expect(cell).notTo.beNil();
    expect(cell.accessoryType).to.equal(UITableViewCellAccessoryNone);

    cell = [tester waitForCellAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] inTableViewWithAccessibilityIdentifier:@"catalogs_table"];
    expect(cell).notTo.beNil();
    expect(cell.accessoryType).to.equal(UITableViewCellAccessoryCheckmark);
}

@end
