//
// TBSwitchTableViewCell.m
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

#import "TBSwitchTableViewCell.h"

@interface TBSwitchTableViewCell ()
@property(nonatomic, weak) UISwitch *toggleSwitch;
@end

@implementation TBSwitchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        UISwitch *toggleSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [toggleSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        self.accessoryView = toggleSwitch;
        _toggleSwitch = toggleSwitch;
    }
    return self;
}

- (void)setAvailable:(BOOL)available {
    [super setAvailable:available];
    
    self.textLabel.enabled = available;
    self.toggleSwitch.enabled = available;
}

- (BOOL)switchValue {
    return self.toggleSwitch.on;
}

- (void)setSwitchValue:(BOOL)switchValue {
    self.toggleSwitch.on = switchValue;
}

- (void)setSwitchValue:(BOOL)switchValue animated:(BOOL)animated {
    [self.toggleSwitch setOn:switchValue animated:animated];
}

- (NSString *)switchAccessibilityIdentifier {
    return self.toggleSwitch.accessibilityIdentifier;
}

- (void)setSwitchAccessibilityIdentifier:(NSString *)switchAccessibilityIdentifier {
    self.toggleSwitch.accessibilityIdentifier = switchAccessibilityIdentifier;
}

- (void)valueChanged:(id)sender {
    if (self.switchValueChanged != nil) {
        self.switchValueChanged(self.toggleSwitch.on);
    }
}

@end
