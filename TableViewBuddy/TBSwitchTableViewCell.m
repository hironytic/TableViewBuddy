//
//  TBSwitchTableViewCell.m
//  TableViewBuddyExample
//
//  Created by ichi on 2014/08/23.
//  Copyright (c) 2014年 Hironytic. All rights reserved.
//

#import "TBSwitchTableViewCell.h"

@interface TBSwitchTableViewCell ()
@property(nonatomic, weak) UISwitch *theSwitch;
@end

@implementation TBSwitchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        UISwitch *theSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [theSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        self.accessoryView = theSwitch;
        _theSwitch = theSwitch;
    }
    return self;
}

- (void)setAvailable:(BOOL)available {
    [super setAvailable:available];
    self.textLabel.enabled = available;
    self.theSwitch.enabled = available;
}

- (BOOL)switchValue {
    return self.theSwitch.on;
}

- (void)setSwitchValue:(BOOL)switchValue {
    self.theSwitch.on = switchValue;
}

- (void)valueChanged:(id)sender {
    if (self.switchValueChanged != nil) {
        self.switchValueChanged(self.theSwitch.on);
    }
}

@end
