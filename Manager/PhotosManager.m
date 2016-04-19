//
//  PhotosManager.m
//  TestAl
//
//  Created by apple on 15/7/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "PhotosManager.h"

@implementation PhotosManager

+ (PhotosManager *)sharePhotosManager
{
    static PhotosManager * manager = nil;
    static dispatch_once_t onct;
    dispatch_once(&onct, ^{
        manager = [[PhotosManager alloc]init];
        manager.assetsLibrary = [[ALAssetsLibrary alloc]init];
    });
    return manager;
}


- (void)getSelectImageWithAssets:(NSArray *)assets
{
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        
        for ( ALAsset * result in assets) {
            ALAssetRepresentation * representation = [result defaultRepresentation];
            CGImageRef  ref = [representation fullResolutionImage];
            UIImage *image = [[UIImage alloc] initWithCGImage:ref];
            if ([self.delegate respondsToSelector:@selector(photosManager:getSelectImage:)]) {
                [self.delegate photosManager:self getSelectImage:image];
            }
        }
        return;
    }
    
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    for ( PHAsset * result in assets) {
        [imageManager requestImageDataForAsset:result options:nil resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
            UIImage * image =  [UIImage imageWithData:imageData];
            if ([self.delegate respondsToSelector:@selector(photosManager:getSelectImage:)]) {
                [self.delegate photosManager:self getSelectImage:image];
            }
        }];
    }
}



-(void)getAllPictures

{
    
    NSMutableArray * array =[NSMutableArray array];
    NSMutableArray * assetArray = [NSMutableArray array];
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        if([group numberOfAssets]) {
            [assetArray addObject:group];
            if ([[group valueForProperty:@"ALAssetsGroupPropertyName"] isEqualToString:@"相机胶卷"]) {
                
                [self filterImageWithGroup:group];
            }
            
        }else
        {
            
            NSMutableArray * groupArray = [NSMutableArray array];
            for (ALAssetsGroup * group in assetArray) {
                CGImageRef reg = group.posterImage;
                UIImage * image = [UIImage imageWithCGImage:reg];
                
                if (![[group valueForProperty:@"ALAssetsGroupPropertyName"] isEqualToString:@"相机胶卷"]) {
                    if ([group numberOfAssets]) {
                        [groupArray addObject:@{@"image":image,@"name":[NSString stringWithFormat:@"%@（%ld）",[group valueForProperty:@"ALAssetsGroupPropertyName"],[group numberOfAssets]],@"collection":group}];
                    }
                }else
                {
                    [groupArray insertObject:@{@"image":image,@"name":[NSString stringWithFormat:@"%@（%ld）",@"相机胶卷",[group numberOfAssets]],@"collection":group} atIndex:0];
                }
            }
            
            if ([self.delegate respondsToSelector:@selector(photosManager:getImageArray:groupArray:assetArray:)]) {
                [self.delegate photosManager:self getImageArray:array groupArray:groupArray assetArray:nil];
            }
        }
        
    } failureBlock:^(NSError *error) {NSLog(@"There is an error");}]; 
    
}


-(void)filterImageWithGroup:(ALAssetsGroup *)group
{
    NSMutableArray * array = [NSMutableArray array];
    NSMutableArray * assetArray = [NSMutableArray array];
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result != nil) {
            [assetArray addObject:result];
            if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                
                CGImageRef  ref = [result aspectRatioThumbnail];
                
                UIImage *image = [[UIImage alloc] initWithCGImage:ref];
                [array addObject:image];
            }
            
        }else
        {

            if ([self.delegate respondsToSelector:@selector(photosManager:getImageArray:groupArray: assetArray:)]) {
                [self.delegate photosManager:self getImageArray:array groupArray:nil assetArray:assetArray];
            }
        }
    }];
}




- (void)getAllImage
{
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getAllPictures];
        });
      
        return;
    }
    
    
    
    [self getImageWithCollection:nil];
    
    
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];

    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    
    [smartAlbums enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        PHAssetCollection * collection = obj;

        if ([collection.localizedTitle isEqualToString:@"相机胶卷"]) {
 
            __block UIImage * image = nil;
            PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
            PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
            [assetsFetchResults enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                PHAsset *asset = obj;
                [imageManager requestImageForAsset:asset targetSize:CGSizeMake(157, 157) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
                    if (!image) {
                        image = result;
                        if ([self.delegate respondsToSelector:@selector(photosManager:getImage:collection:)]) {
                            [self.delegate photosManager:self getImage:image collection:collection];
                        }
                        
                    }
                }];
            }];
        }
        
    }];
    
    
    
    [topLevelUserCollections enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAssetCollection * collection = obj;
        if (collection.estimatedAssetCount) {
            __block UIImage * image = nil;
            PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
            PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
            [assetsFetchResults enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                PHAsset *asset = obj;
                [imageManager requestImageForAsset:asset targetSize:CGSizeMake(157, 157) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
                    if (!image) {
                        image = result;
                        if ([self.delegate respondsToSelector:@selector(photosManager:getImage:collection:)]) {
                            [self.delegate photosManager:self getImage:image collection:collection];
                        }
                        
                    }
                }];
                
            }];
        }
    }];


}





- (void)getImageWithCollection:(PHAssetCollection *)collection
{
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    PHFetchResult * assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    if (collection) {
      assetsFetchResults  = [PHAsset fetchAssetsInAssetCollection:collection options:options];
    }
    
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    [assetsFetchResults enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAsset *asset = obj;
        
        
        __block BOOL isFitsr = YES;
        [imageManager requestImageForAsset:asset targetSize:CGSizeMake(157, 157) contentMode:1 options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
           
            if (isFitsr) {
                if ([self.delegate respondsToSelector:@selector(photosManager:getImage:asset:)]) {
                    [self.delegate photosManager:self getImage:result asset:asset];
                }
                isFitsr = NO;
            }
        }];
    }];

}



- (void)writeImageUseAL
{
    
    UIImage * image = nil;
    
    
    [self.assetsLibrary writeImageToSavedPhotosAlbum:image.CGImage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        
        [kPhotoManager.assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            
            NSLog(@"---- %@",asset);
            
//            NSDictionary * dic = self.groupArray.firstObject;
//            if ([self.selectGroupView.nameLabel.text isEqualToString:@"相机胶卷"]) {
//                [self.assetArray insertObject:asset atIndex:0];
//                [self.imageArray insertObject:[UIImage imageWithCGImage:asset.aspectRatioThumbnail] atIndex:1];
//                [self.cellStateArray insertObject:@"0" atIndex:0];
//                [self.collectionView reloadData];
//            }
//            
//            NSMutableDictionary * newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
//            
//            NSString * name = dic[@"name"];
//            
//            name = [name componentsSeparatedByString:@"（"].lastObject;
//            name = [name componentsSeparatedByString:@"）"].firstObject;
//            
//            [newDic setObject:[NSString stringWithFormat:@"相机胶卷（%d）",name.intValue + 1] forKey:@"name"];
//            
//            [self.groupArray removeObjectAtIndex:0];
//            [self.groupArray insertObject:newDic atIndex:0];
//            [self.getImageTVC.tableView reloadData];
            
            
        } failureBlock:^(NSError *error) {
            
        }];
        
    }];

}



@end
