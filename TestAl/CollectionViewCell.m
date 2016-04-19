//
//  CollectionViewCell.m
//  TestAl
//
//  Created by apple on 15/7/4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CollectionViewCell.h"


@implementation CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)selectImage
{
     self.selectImageView.image = [UIImage imageNamed:@"uzysAP_ico_photo_thumb_check"];
}

- (void)unSelectImage
{
    self.selectImageView.image = [UIImage imageNamed:@"uzysAP_ico_photo_thumb_uncheck"];

}


- (void)select
{
    [self selectImage];
    [self animation];
}

- (void)unSelect
{
    [self unSelectImage];
    [self animation];
}

- (void)setHeadimage:(UIImage *)image
{

    self.imageView.image = image;
}


- (void)animation
{
    CGAffineTransform transform = self.transform;

    [UIView animateWithDuration:.1 animations:^{
        self.transform = CGAffineTransformScale(transform, .98, .98);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.3 animations:^{
            self.transform = CGAffineTransformScale(transform, 1, 1);
        }];
    }];
}


@end
