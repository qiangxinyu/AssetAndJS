//
//  FileManager.m
//  TestAl
//
//  Created by apple on 15/7/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "FileManager.h"

#define kImagePath @"images"

@implementation FileManager


+ (FileManager *)shareFileManager
{
    static FileManager * manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[FileManager alloc]init];
        manager.fileManager = [[NSFileManager alloc]init];
    });
    return manager;
}



- (void)writeImageWithImage:(UIImage *)image imageName:(NSString *)imageName
{
    NSString * imagePath = [[self getDocument_ImagesFilePath] stringByAppendingPathComponent:imageName];
    
    
    
}



- (UIImage *)getImageWithImageName:(NSString *)imageName
{
    return nil;
}




- (NSString *)getDocument_ImagesFilePath
{
    NSString * documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    NSString * imagesPath = [documentPath stringByAppendingPathComponent:kImagePath];
    
    if (![self.fileManager fileExistsAtPath:imagesPath]) {
        [self.fileManager createDirectoryAtPath:imagesPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return imagesPath;
}


@end
