//
//  CollectionViewController.h
//  TestAl
//
//  Created by apple on 15/7/4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetImage_selectGroupView.h"
#import "GetImage_DownView.h"
@interface CollectionViewController : UICollectionViewController

@property (nonatomic,strong)NSMutableArray * imageArray;
@property (nonatomic,strong)GetImage_DownView * downView;
@property (nonatomic,strong)GetImage_selectGroupView * selectGroupView;
- (void)ClickSelectGroup;
@end
