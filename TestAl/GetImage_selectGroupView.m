//
//  GetImage_selectGroupView.m
//  TestAl
//
//  Created by apple on 15/7/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "GetImage_selectGroupView.h"

@implementation GetImage_selectGroupView

- (instancetype)init
{
    if ([super init]) {
        self.frame = CGRectMake(0, 0, kScreenWidth/2, 30);
        self.center = CGPointMake(kScreenWidth/2, 22);
        self.userInteractionEnabled = YES;
        
        self.nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_nameLabel];
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 9)];
        _imageView.image = [UIImage imageNamed:@"x2_down_arrow"];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    CGFloat width = [text boundingRectWithSize:CGSizeMake(999999, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width;
    self.nameLabel.frame = CGRectMake(0, 0, width, 30);
    _nameLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.nameLabel.text = text;
    
    
    self.imageView.center = CGPointMake(CGRectGetMaxX(self.nameLabel.frame) + 10, self.frame.size.height/2);
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [_target performSelector:_action withObject:self];
#pragma clang diagnostic pop
    CGFloat rotation = 0;
    if (self.isOpen) {
        self.isOpen = NO;
    }else
    {
        rotation = M_PI;
        self.isOpen = YES;
    }
    [UIView animateWithDuration:.3 animations:^{
        self.imageView.transform = CGAffineTransformMakeRotation(rotation);

    }];
}

- (void)addTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}


@end
