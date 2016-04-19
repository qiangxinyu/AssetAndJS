//
//  GetImage_DownView.h
//  TestAl
//
//  Created by apple on 15/7/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyView.h"
@interface GetImage_DownView : UIView

@property (nonatomic,strong)UILabel * numberLabel;

@property (nonatomic,strong)MyView * selectFinishView;

- (void)setNumber:(NSInteger)number;
@end
