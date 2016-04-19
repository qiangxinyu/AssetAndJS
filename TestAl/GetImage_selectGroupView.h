//
//  GetImage_selectGroupView.h
//  TestAl
//
//  Created by apple on 15/7/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetImage_selectGroupView : UIView

{
    id _target;
    SEL _action;
}

@property (nonatomic,strong)UILabel * nameLabel;
@property (nonatomic,strong)UIImageView * imageView;

@property (nonatomic,assign)BOOL  isOpen;


- (void)setText:(NSString *)text;

- (void)addTarget:(id)target action:(SEL)action;

@end
