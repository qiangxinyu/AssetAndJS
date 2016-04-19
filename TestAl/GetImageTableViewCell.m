//
//  GetImageTableViewCell.m
//  TestAl
//
//  Created by apple on 15/7/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "GetImageTableViewCell.h"

@implementation GetImageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMyData:(NSDictionary *)myData
{
    _myData = myData;
    
    if ([myData[@"image"] isKindOfClass:[UIImage class]]) {
        self.headImageView.image = myData[@"image"];

    }
    self.nameLabel.text = myData[@"name"];
    
}



- (void)select
{
    self.selectImageView.image = [UIImage imageNamed:@"uzysAP_ico_checkMark"];
}

- (void)unSelect
{
     self.selectImageView.image = nil;
}

@end
