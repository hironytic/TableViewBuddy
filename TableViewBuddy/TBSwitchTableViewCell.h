//
//  TBSwitchTableViewCell.h
//  TableViewBuddyExample
//
//  Created by ichi on 2014/08/23.
//  Copyright (c) 2014年 Hironytic. All rights reserved.
//

#import "TBTableViewCell.h"

@interface TBSwitchTableViewCell : TBTableViewCell

@property(nonatomic, assign) BOOL switchValue;
@property(nonatomic, copy) void (^switchValueChanged)(BOOL value);

@end
