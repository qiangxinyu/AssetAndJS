//
//  FileManager.h
//  TestAl
//
//  Created by apple on 15/7/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

+ (FileManager *)shareFileManager;

@property (nonatomic,strong)NSFileManager * fileManager;

- (void)writeImageWithImage:(UIImage *)image imageName:(NSString *)imageName;
- (UIImage *)getImageWithImageName:(NSString *)imageName;


@end
