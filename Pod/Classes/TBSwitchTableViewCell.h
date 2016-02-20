//
// TBSwitchTableViewCell.h
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

#import "TBUntappableCell.h"

/**
 `TBSwitchTableViewCell` represents a cell used by `<TBSwitchRow>`.
 */
@interface TBSwitchTableViewCell : TBUntappableCell

/**
 A boolean value that indicates whether the switch is On or Off.
 */
@property(nonatomic, assign) BOOL switchValue;

/**
 A string that identifies the switch
 */
@property(nonatomic, copy) NSString *switchAccessibilityIdentifier;

/**
 A block object that is called when state of the switch is changed.
 
 The parameter of the block is a boolean value that indicates the switch is On.
 */
@property(nonatomic, copy) void (^switchValueChanged)(BOOL value);

/**
 Changes the state of the switch.
 
 @param switchValue Specify `YES` to turn to the On
 @param animated Specify `YES` to animate.
 */
- (void)setSwitchValue:(BOOL)switchValue animated:(BOOL)animated;

@end
