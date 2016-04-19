//
//  ViewController.m
//  TestAl
//
//  Created by apple on 15/7/4.
//  Copyright (c) 2015年 apple. All rights reserved.
//
//

#import "ViewController.h"

#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "CollectionViewController.h"

@interface ViewController ()



@property (nonatomic,strong)CollectionViewController * collection;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [PHAsset fetchAssetsWithOptions:nil];
}


- (IBAction)click:(id)sender {
    
    UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc]init];
    
    self.collection = [[CollectionViewController alloc]initWithCollectionViewLayout:flow];
    
    UINavigationController * na = [[UINavigationController alloc]initWithRootViewController:_collection];
    
    [self presentViewController:na animated:YES completion:nil];
    _collection.collectionView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight  - 41);
   
}
 


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
