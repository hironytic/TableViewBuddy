//
//  UIView+TestHelper.m
//  TableViewBuddyExample
//
//  Created by ichi on 2015/03/07.
//  Copyright (c) 2015年 Hironytic. All rights reserved.
//

#import "UIView+TestHelper.h"

@implementation UIView (TestHelper)

- (UIView *)superviewMatchesKindOfClass:(Class)clazz {
    UIView *view = self;
    while (view != nil) {
        if ([view isKindOfClass:clazz]) {
            break;
        }
        view = [view superview];
    }
    return view;
}

@end
