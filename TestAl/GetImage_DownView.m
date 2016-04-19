//
//  GetImage_DownView.m
//  TestAl
//
//  Created by apple on 15/7/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "GetImage_DownView.h"

@implementation GetImage_DownView

- (instancetype)init
{
    if ([super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40);
        
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/4*3, 40)];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = kRootColor;
        label.text = @"请选一张或一组图片";
        [self addSubview:label];
        
        
        self.selectFinishView = [[MyView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 0, kScreenWidth/4, 40)];
        _selectFinishView.backgroundColor = [UIColor grayColor];
        [self addSubview:_selectFinishView];
        
        
        UILabel * finishLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
        finishLabel.textAlignment = NSTextAlignmentCenter;
        finishLabel.textColor = [UIColor whiteColor];
        finishLabel.text = @"选好了";
        finishLabel.font = [UIFont systemFontOfSize:13];
        finishLabel.center = CGPointMake(_selectFinishView.frame.size.width/3*2, _selectFinishView.frame.size.height/2);
        [_selectFinishView addSubview:finishLabel];
        
        self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        _numberLabel.center = CGPointMake(_selectFinishView.frame.size.width/4, _selectFinishView.frame.size.height/2);
        _numberLabel.backgroundColor = [UIColor whiteColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.textColor = kRootColor;
        [_selectFinishView addSubview:_numberLabel];
        _numberLabel.layer.cornerRadius = 10;
        _numberLabel.layer.masksToBounds = YES;
        _numberLabel.font = [UIFont systemFontOfSize:14];
        _numberLabel.text = @"0";
        
    }
    return self;
}


- (void)setNumber:(NSInteger)number
{
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",number];
    
    if (number > 0) {
        self.selectFinishView.backgroundColor = kRootColor;
        self.numberLabel.textColor = kRootColor;
        
    }else
    {
        self.selectFinishView.backgroundColor = [UIColor grayColor];
        self.numberLabel.textColor = [UIColor blackColor];
    }
}


@end
