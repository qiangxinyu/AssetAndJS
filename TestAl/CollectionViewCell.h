//
//  CollectionViewCell.h
//  TestAl
//
//  Created by apple on 15/7/4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyImageView.h"
@interface CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet MyImageView *selectImageView;

@property (nonatomic,assign)BOOL  isSelect;

- (void)setHeadimage:(UIImage *)image;
- (void)select;
- (void)unSelect;


- (void)selectImage;
- (void)unSelectImage;

@end
