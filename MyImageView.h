//
//  MyImageView.h
//  QingYingYong
//
//  Created by 中科创奇 on 15/4/22.
//  Copyright (c) 2015年 中科创奇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyImageView : UIImageView
{
    id _target;
    SEL _action;
}

- (void)addTarget:(id)target action:(SEL)action;

@property (nonatomic,strong)NSString * connectURL;  //图片的链接
@property (nonatomic,strong)NSString * nameStr;   //图片的名字

@property (nonatomic,strong)NSDictionary * myData;
@end
