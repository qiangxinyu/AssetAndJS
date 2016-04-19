//
//  GetImage_selectThemeViewController.m
//  TestAl
//
//  Created by apple on 15/7/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "GetImage_selectThemeViewController.h"
#import "ThemeCollectionViewCell.h"

#import "UIImageView+WebCache.h"

@interface GetImage_selectThemeViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIWebViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong)UIImageView * imageView;

@property (nonatomic,strong)UIWebView * webView;

@property (nonatomic,strong)UICollectionView * collectionView;
@property (nonatomic,strong)UICollectionViewFlowLayout * flowLayout;

@property (nonatomic,strong)NSMutableArray * groupArray;


@property (nonatomic,strong)UIButton * nextBtn;


@property (nonatomic,strong)NSString * themeID;

@property (nonatomic,strong)UIView * themePrompt;

@end
@implementation GetImage_selectThemeViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    self.webView.hidden = NO;
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"x2_edit_back_left_btn_nor"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(10, 20, 30, 30);
    [btn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    
    self.imageView.hidden = NO;
    
    self.collectionView.hidden = NO;
    self.nextBtn.hidden = NO;
    
    [self requestData];
    
    NSArray * nameArray = @[@"萌萌哒",@"逗比",@"小清新",@"文艺范",@"大气",@"历史",@"简约",@"精致"];
    
    self.groupArray = @[].mutableCopy;
    for (int i = 1 ; i < 9 ; i ++) {
        [self.groupArray addObject:@{@"Thumbnail":@"http://cdn-img.easyicon.net/png/5837/583766.gif",
                                    @"ThemeName":nameArray[i - 1],
                                    @"SerialNumber":[NSString stringWithFormat:@"%d",i]}];
    }
}




- (void)clickBack
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)clickNextBtn
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"选定了主题，就不能更改了哟~" delegate:self cancelButtonTitle:@"额，再想想" otherButtonTitles:@"我确定了", nil];
    [alert show];
}


- (void)requestData
{
//    NSString * url = @"http://chuye.cloud7.com.cn/theme/themes?device=iOS&version=2.1&nettp=WIFI";
//    
//    NSURL * URL = [NSURL URLWithString:url];
//    
//    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:URL];
//    
//    [request setValue:@"_token 2854459f9e18982f3276fe48b7175aa6" forHTTPHeaderField:@"Authorization"];
//    
//    [request setValue:@"Mon, 13 Jul 2015 09:04:16 GMT" forHTTPHeaderField:@"Date"];
//    
//    
//    
//    
//    
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        
//        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        
//        NSArray * array = dic[@"data"];
//        
//        if (array) {
//            self.groupArray = [NSMutableArray arrayWithArray:array];
//        }
//        
//        [self.collectionView reloadData];
//    }];

}




#pragma mark ----------------------------------------------------------------------
#pragma mark ----------------------collection-------------------------------------
#pragma mark ----------------------------------------------------------------------


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.groupArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ThemeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"a" forIndexPath:indexPath];
    
    //Thumbnail
    //ThemeName
    NSDictionary * dic = self.groupArray[indexPath.row];
    
    [cell.imageVIew setImageWithURL:[NSURL URLWithString:dic[@"Thumbnail"]] placeholderImage:nil];
    cell.nameLabel.text = dic[@"ThemeName"];
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50, 65);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.themeID = self.groupArray[indexPath.row][@"SerialNumber"];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"theme-preview-deploy" ofType:@"html"]]]];
    self.imageView.hidden = YES;
    self.themePrompt.hidden = NO;
    self.nextBtn.backgroundColor = kRootColor;
    self.nextBtn.enabled = YES;
}

#pragma mark ----------------------------------------------------------------------
#pragma mark ----------------------webViewDelegate-------------------------------------
#pragma mark ----------------------------------------------------------------------
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setTheme(%@)",self.themeID]];
}


#pragma mark ----------------------------------------------------------------------
#pragma mark ----------------------alertViewDelegate-------------------------------------
#pragma mark ----------------------------------------------------------------------


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        NSLog(@"确定了");
    }
}


#pragma mark ----------------------------------------------------------------------
#pragma mark ----------------------lazyLoding-------------------------------------
#pragma mark ----------------------------------------------------------------------





- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * (368.0/640))];
        _imageView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
        _imageView.image  = [UIImage imageNamed:@"x2_theme_none_tip"];
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 110)];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"theme-preview-deploy" ofType:@"html"]]]];
        _webView.delegate = self;
        _webView.scrollView.bounces = NO;
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 40 - 75, kScreenWidth, 75) collectionViewLayout:_flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"ThemeCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:@"a"];
        _collectionView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}







- (UIButton *)nextBtn
{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.enabled = NO;
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        CGFloat numeber = 50;
        _nextBtn.backgroundColor = [UIColor colorWithRed:numeber/255.0 green:numeber/255.0 blue:numeber/255.0 alpha:1];
        _nextBtn.frame = CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40);
        [_nextBtn addTarget:self action:@selector(clickNextBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_nextBtn];
    }
    return _nextBtn;
}

- (NSMutableArray *)groupArray
{
    if (!_groupArray) {
        _groupArray = [NSMutableArray array];
    }
    return _groupArray;
}


- (UIView *)themePrompt
{
    if (!_themePrompt) {
        _themePrompt = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - self.collectionView.frame.size.height - self.nextBtn.frame.size.height - 50, kScreenWidth, 50)];
        
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        label.center = CGPointMake(kScreenWidth/2, 15);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = @"主题效果演示";
        label.font = [UIFont systemFontOfSize:14];
        [_themePrompt addSubview:label];
        
        for (int i = 0 ; i < 2 ; i ++) {
            UIView * viwe = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/4, 1)];
            
            if (i) {
                viwe.center = CGPointMake(kScreenWidth/2 + kScreenWidth/4/2 + 50, 15);
            }else
            {
                viwe.center = CGPointMake(kScreenWidth/2 - kScreenWidth/4/2 - 50, 15);
            }
            
            viwe.backgroundColor = [UIColor lightGrayColor];
            [label addSubview:viwe];
            [_themePrompt addSubview:viwe];
        }
        
        UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, kScreenWidth, 20)];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.textColor = [UIColor whiteColor];
        label1.font = [UIFont systemFontOfSize:12];
        label1.text = @"主题选择过后，字体和动画暂不支持更换";
        [_themePrompt addSubview:label1];
        
        [self.webView addSubview:_themePrompt];
        
    }
    return _themePrompt;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
