//
//  ThemeCollectionViewCell.m
//  TestAl
//
//  Created by apple on 15/7/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ThemeCollectionViewCell.h"

@implementation ThemeCollectionViewCell

- (void)awakeFromNib {

    self.imageVIew.layer.cornerRadius = self.imageVIew.frame.size.height/2;
    
}

@end
