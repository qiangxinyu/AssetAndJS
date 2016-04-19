//
//  PhotosManager.h
//  TestAl
//
//  Created by apple on 15/7/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
@class PhotosManager;
@protocol PhotosManagerDelegate <NSObject>

- (void)photosManager:(PhotosManager *)photosManager getSelectImage:(UIImage *)selectImage;



- (void)photosManager:(PhotosManager *)photosManager getImage:(UIImage *)image asset:(id)asset;

- (void)photosManager:(PhotosManager *)photosManager getImage:(UIImage *)image collection:(PHAssetCollection *)collection;

- (void)photosManager:(PhotosManager *)photosManager getImageArray:(NSMutableArray *)imageArray groupArray:(NSMutableArray *)groupArray assetArray:(NSMutableArray *)assetArray;
@end



@interface PhotosManager : NSObject

@property (nonatomic,strong)ALAssetsLibrary* assetsLibrary;

@property (nonatomic,assign)id <PhotosManagerDelegate>  delegate;

+ (PhotosManager *)sharePhotosManager;

- (void)getSelectImageWithAssets:(NSArray *)assets;

- (void)getAllPictures;
- (void)filterImageWithGroup:(ALAssetsGroup *)group;

- (void)getAllImage;

- (void)getImageWithCollection:(PHAssetCollection *)collection;
@end
