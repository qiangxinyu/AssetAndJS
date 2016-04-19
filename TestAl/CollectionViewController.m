//
//  CollectionViewController.m
//  TestAl
//
//  Created by apple on 15/7/4.
//  Copyright (c) 2015年 apple. All rights reserved.
//


/*
 
 
 
 
 
 */





#import "CollectionViewController.h"
#import "GetImageTableViewController.h"

#import "CollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>


#import "GetImage_selectThemeViewController.h"


@interface CollectionViewController () <UICollectionViewDelegateFlowLayout,PhotosManagerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>


@property (nonatomic,strong)GetImageTableViewController * getImageTVC;



@property (nonatomic,strong)NSMutableArray * cellStateArray;


@property (nonatomic,strong)NSMutableArray * assetArray;

@property (nonatomic,assign)NSInteger selectCount;
@property (nonatomic,strong)NSMutableArray * selectAsset;

//tableView data
@property (nonatomic,strong)NSMutableArray * groupArray;

@property (nonatomic,strong)NSMutableArray * selectImagesArray;

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"Cell";
- (BOOL)shouldAutorotate {
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.groupArray = [NSMutableArray array];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"x2_close_carema"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 20, 20);
    [btn addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
 
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    [self.navigationController.navigationBar addSubview:self.selectGroupView];
    
    self.downView.hidden = NO;
    
    
    kPhotoManager.delegate = self;

    
    [kPhotoManager getAllImage];
    
}

#pragma mark ----------------------------------------------------------------------
#pragma mark ----------------------click-------------------------------------
#pragma mark ----------------------------------------------------------------------

- (void)clickClose
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)ClickSelectGroup
{
    self.getImageTVC.tableView.hidden = NO;
    CGFloat y = (kScreenHeight + 64)/2 ;
    if (self.selectGroupView.isOpen) {
        y = - y;
    }
    
    [UIView animateWithDuration:.3 animations:^{
        self.getImageTVC.tableView.center = CGPointMake(kScreenWidth/2, y);
    }];
    
}





- (void)clickSelectFinish:(MyView *)myView
{
    if (![myView.backgroundColor isEqual:kRootColor]) {
        return;
    }
    
    
    
    [kPhotoManager getSelectImageWithAssets:self.selectAsset];
    
    
    
    GetImage_selectThemeViewController * selectThemeVC = [[GetImage_selectThemeViewController alloc]init];
    
    [self.navigationController pushViewController:selectThemeVC animated:YES];
    selectThemeVC.navigationController.navigationBarHidden = YES;
}


#pragma mark ----------------------------------------------------------------------
#pragma mark ----------------------collection delegate-------------------------------------
#pragma mark ----------------------------------------------------------------------


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    
    [cell setHeadimage:self.imageArray[indexPath.row]];
    

    if (indexPath.row) {
        NSString * cellState = self.cellStateArray[indexPath.row - 1];
        if ([cellState isEqualToString:@"0"]) {
            [cell unSelectImage];
        }else
        {
            [cell selectImage];
        }
    }
    
    
    
    
    if (!indexPath.row) {
        cell.selectImageView.hidden = YES;
    }else
    {
        cell.selectImageView.hidden = NO;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth / 3 - 10, kScreenWidth / 3 - 10);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.row) {
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        
            UIImagePickerController * pick = [[UIImagePickerController alloc] init];//初始化
            pick.delegate = self;
            pick.sourceType = UIImagePickerControllerSourceTypeCamera;
            pick.showsCameraControls = YES;
            [self presentViewController:pick animated:YES completion:nil];//进入照相界面
        }

        return;
    }
    
    
    
    CollectionViewCell * cell = (CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSString * cellState = self.cellStateArray[indexPath.row-1];
    
    if ([cellState isEqualToString:@"1"]) {
        self.selectCount --;
        [cell unSelect];
        cell.isSelect = NO;
        
        [self.cellStateArray removeObjectAtIndex:indexPath.row - 1];
        [self.cellStateArray insertObject:@"0" atIndex:indexPath.row -1];
        [self.selectAsset removeObject:self.assetArray[indexPath.row-1]];
    }else
    {
        cellState = @"1";
        self.selectCount ++;
        [cell select];
        cell.isSelect = YES;
        [self.cellStateArray removeObjectAtIndex:indexPath.row - 1];
        [self.cellStateArray insertObject:@"1" atIndex:indexPath.row -1];
        [self.selectAsset addObject:self.assetArray[indexPath.row-1]];
    }
    
    
    [self.downView setNumber:self.selectCount];
    
}

#pragma mark ----------------------------------------------------------------------
#pragma mark ----------------------imagePicker delegate-------------------------------------
#pragma mark ----------------------------------------------------------------------



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage * image = info[@"UIImagePickerControllerOriginalImage"];

    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        
    
    
    [kPhotoManager.assetsLibrary writeImageToSavedPhotosAlbum:image.CGImage metadata:info[@"UIImagePickerControllerMediaMetadata"] completionBlock:^(NSURL *assetURL, NSError *error) {
        [kPhotoManager.assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
           
            NSLog(@"---- %@",asset);
            
            NSDictionary * dic = self.groupArray.firstObject;
            if ([self.selectGroupView.nameLabel.text isEqualToString:@"相机胶卷"]) {
                [self.assetArray insertObject:asset atIndex:0];
                [self.imageArray insertObject:[UIImage imageWithCGImage:asset.aspectRatioThumbnail] atIndex:1];
                [self.cellStateArray insertObject:@"0" atIndex:0];
                [self.collectionView reloadData];
            }
            
            NSMutableDictionary * newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            
            NSString * name = dic[@"name"];
            
            name = [name componentsSeparatedByString:@"（"].lastObject;
            name = [name componentsSeparatedByString:@"）"].firstObject;
            
            [newDic setObject:[NSString stringWithFormat:@"相机胶卷（%d）",name.intValue + 1] forKey:@"name"];
            
            [self.groupArray removeObjectAtIndex:0];
            [self.groupArray insertObject:newDic atIndex:0];
            [self.getImageTVC.tableView reloadData];
            
                                          
        } failureBlock:^(NSError *error) {
            
        }];
        
    }];

        return;
    }
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
    
   

    
    
}

- (void)savedPhotoImage:(UIImage*)image didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo
{
    [self.cellStateArray insertObject:@"0" atIndex:0];
    [self.assetArray removeAllObjects];
    self.imageArray = nil;
    
    
    NSDictionary * dic = self.groupArray.firstObject;
    PHAssetCollection * collection = dic[@"collection"];
    NSString * name = dic[@"name"];
    
    name = [name componentsSeparatedByString:@"（"].lastObject;
    name = [name componentsSeparatedByString:@"）"].firstObject;
    
    [self.groupArray removeObjectAtIndex:0];
    
    [self.groupArray insertObject:@{@"name":[NSString stringWithFormat:@"相机胶卷（%d）",name.intValue + 1],@"image":dic[@"image" ],@"collection":dic[@"collection"]} atIndex:0];
    
    [kPhotoManager getImageWithCollection:collection];
    
    [self.getImageTVC.tableView reloadData];
}

#pragma mark ----------------------------------------------------------------------
#pragma mark ----------------------photo delegate-------------------------------------
#pragma mark ----------------------------------------------------------------------


- (void)photosManager:(PhotosManager *)photosManager getSelectImage:(UIImage *)selectImage
{
    NSLog(@"%@",NSStringFromCGSize(selectImage.size));
    [self.selectImagesArray addObject:selectImage];
}

- (void)photosManager:(PhotosManager *)photosManager getImageArray:(NSMutableArray *)imageArray groupArray:(NSMutableArray *)groupArray assetArray:(NSMutableArray *)assetArray
{
    if (imageArray) {
        for (UIImage * image in imageArray) {
            [self.imageArray insertObject:image atIndex:1];
            [self.cellStateArray addObject:@"0"];
        }
    }
    
    if (groupArray) {
        self.groupArray = groupArray;
    }
    if (assetArray) {
        for (id asset in assetArray) {
            [self.assetArray insertObject:asset atIndex:0];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];

    });
}


- (void)photosManager:(PhotosManager *)photosManager getImage:(UIImage *)image asset:(id)asset
{
    if (image) {
        [self.imageArray addObject:image];
        [self.cellStateArray addObject:@"0"];
    }
    [self.collectionView reloadData];
    
    if (asset) {
        [self.assetArray addObject:asset];
    }
    
    
}

- (void)photosManager:(PhotosManager *)photosManager getImage:(UIImage *)image collection:(PHAssetCollection *)collection
{
   
    NSUInteger count = collection.estimatedAssetCount;
    if ([collection.localizedTitle isEqualToString:@"相机胶卷"]) {
        count = self.imageArray.count;
    }
    
    [self.groupArray addObject:@{@"image":image,@"name":[NSString stringWithFormat:@"%@（%ld）",collection.localizedTitle,(unsigned long)count],@"collection":collection}];
    
}



#pragma mark ----------------------------------------------------------------------
#pragma mark ----------------------lazy loading-------------------------------------
#pragma mark ----------------------------------------------------------------------


- (GetImage_selectGroupView *)selectGroupView
{
    if (!_selectGroupView) {
        _selectGroupView = [[GetImage_selectGroupView alloc]init];
        [_selectGroupView setText:@"相机胶卷"];
        [_selectGroupView addTarget:self action:@selector(ClickSelectGroup)];
        
    }
    return _selectGroupView;
}




- (GetImageTableViewController *)getImageTVC
{
    if (!_getImageTVC) {
        _getImageTVC = [[GetImageTableViewController alloc]init];
        _getImageTVC.tableView.frame = CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight - 64);
        [self.view addSubview:_getImageTVC.tableView];
        _getImageTVC.collectionView = self;
        
        
        self.getImageTVC.groupArray = self.groupArray;
        
        
    }
    return _getImageTVC;
}


- (GetImage_DownView *)downView
{
    if (!_downView) {
        _downView = [[GetImage_DownView alloc]init];
        [self.view addSubview:_downView];
        [_downView.selectFinishView addTarget:self action:@selector(clickSelectFinish:)];
    }
    return _downView;
}


- (NSMutableArray *)assetArray
{
    if (!_assetArray) {
        _assetArray = [NSMutableArray array];
    }
    return _assetArray;
}


- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
        [_imageArray insertObject:[UIImage imageNamed:@"x2_carema"] atIndex:0];
        
        
        
        [self.cellStateArray removeAllObjects];
        [self.selectAsset removeAllObjects];
        self.selectCount = 0;
        [self.downView setNumber:self.selectCount];
    }
    return _imageArray;
}

- (NSMutableArray *)selectAsset
{
    if (!_selectAsset) {
        _selectAsset = [NSMutableArray array];
        
    }
    return _selectAsset;
}


- (NSMutableArray *)cellStateArray
{
    if (!_cellStateArray) {
        _cellStateArray = [NSMutableArray array];
        
    }
    return _cellStateArray;
}

- (NSMutableArray *)selectImagesArray
{
    if (!_selectImagesArray) {
        _selectImagesArray = [NSMutableArray array];
    }
    return _selectImagesArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
