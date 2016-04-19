//
//  MyView.h
//  QingYingYong
//
//  Created by 中科创奇 on 15/4/22.
//  Copyright (c) 2015年 中科创奇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyView : UIView
{
    id _target;
    SEL _action;
}

- (void)addTarget:(id)target action:(SEL)action;
@end
