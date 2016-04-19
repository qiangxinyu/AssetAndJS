//
//  MyImageView.m
//  QingYingYong
//
//  Created by 中科创奇 on 15/4/22.
//  Copyright (c) 2015年 中科创奇. All rights reserved.
//

#import "MyImageView.h"

@implementation MyImageView

- (void)addTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [_target performSelector:_action withObject:self];
#pragma clang diagnostic pop
}
@end
