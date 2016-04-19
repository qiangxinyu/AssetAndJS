//
//  GetImageTableViewController.m
//  TestAl
//
//  Created by apple on 15/7/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "GetImageTableViewController.h"
#import "GetImageTableViewCell.h"
#import <Photos/Photos.h>
#import "CollectionViewController.h"
@interface GetImageTableViewController ()

@property (nonatomic,strong)NSIndexPath * oldIndexPath;

@end

@implementation GetImageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"GetImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"1"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.oldIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)setGroupArray:(NSMutableArray *)groupArray
{
    _groupArray = groupArray;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.groupArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GetImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"1" forIndexPath:indexPath];
    
    [cell unSelect];
    
    if ([self.oldIndexPath isEqual:indexPath]) {
        [cell select];
    }
    

    cell.myData = self.groupArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GetImageTableViewCell * cell = (GetImageTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell select];
    
    cell = (GetImageTableViewCell *)[tableView cellForRowAtIndexPath:self.oldIndexPath];
    [cell unSelect];

    self.oldIndexPath = indexPath;
    
    ((CollectionViewController *)self.collectionView).imageArray = nil;
    
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        [kPhotoManager filterImageWithGroup:self.groupArray[indexPath.row][@"collection"]];
    }else
    {
        PHAssetCollection * collection = self.groupArray[indexPath.row][@"collection"];
        [kPhotoManager getImageWithCollection:collection];

    }
    
    
    [((CollectionViewController *)self.collectionView).selectGroupView setText:[[self.groupArray[indexPath.row][@"name"] componentsSeparatedByString:@"（"] firstObject]];
    [((CollectionViewController *)self.collectionView) ClickSelectGroup];
    ((CollectionViewController *)self.collectionView).selectGroupView.isOpen = NO;
    [UIView animateWithDuration:.3 animations:^{
        ((CollectionViewController *)self.collectionView).selectGroupView.imageView.transform = CGAffineTransformMakeRotation(0);
    }];

    
   


}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
