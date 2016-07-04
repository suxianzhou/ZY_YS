//
//  RWWelcomeController.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/14.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWWelcomeController.h"
#import "RWWelcomeImageCell.h"
#import "RWRegisterViewController.h"

@interface RWWelcomeController ()

<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic,strong)UICollectionView *welcomeView;

@property (nonatomic,strong)NSArray *imageSource;

@property (nonatomic,strong)UIPageControl *imagePage;

@property (nonatomic,strong)UIButton *toLogin;

@end

static NSString *const welcomeCell = @"welcomeCell";

@implementation RWWelcomeController

@synthesize welcomeView;
@synthesize imageSource;
@synthesize imagePage;
@synthesize toLogin;

- (void)initDataSource
{
    imageSource = @[[UIImage imageNamed:@"welcome1"],
                    [UIImage imageNamed:@"welcome2"],
                    [UIImage imageNamed:@"welcome3"],
                    [UIImage imageNamed:@"welcome4"],
                    [UIImage imageNamed:@"welcome5"]];
}

- (void)initLoginButton
{
    toLogin = [[UIButton alloc] init];
    
    [toLogin setTitle:@"立即体验" forState:UIControlStateNormal];
    
    [toLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    toLogin.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    toLogin.layer.borderWidth = 1;
    
    toLogin.layer.cornerRadius = 5;
    
    toLogin.backgroundColor = [UIColor clearColor];
    
    toLogin.titleLabel.font = [UIFont systemFontOfSize:17];
    
    [toLogin addTarget:self
                action:@selector(toRegisterView)
      forControlEvents:UIControlEventTouchUpInside];
    
    if (imageSource.count == 1)
    {
        [self.view addSubview:toLogin];
        
        [toLogin mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(@(120));
            make.height.equalTo(@(50));
            make.centerX.equalTo(self.view.mas_centerX).offset(0);
            make.bottom.equalTo(imagePage.mas_top).offset(-50);
        }];
    }
}

- (void)toRegisterView
{
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [[RWDeployManager defaultManager] setDeployValue:[NSNumber numberWithBool:NO]
                                              forKey:FIRST_OPEN_APPILCATION];
}

- (void)initImagePage
{
    imagePage = [[UIPageControl alloc]init];
    
    imagePage.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:imagePage];
    
    [imagePage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo([NSNumber numberWithInteger:30 * imageSource.count]);
        make.height.equalTo(@(20));
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
    }];
    
    imagePage.currentPage = 0;
    imagePage.numberOfPages = imageSource.count;
    imagePage.pageIndicatorTintColor = [UIColor whiteColor];
    
    if (imageSource.count > 1)
    {
        imagePage.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    }
}

- (void)initWelcomeView
{
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(width, height);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    welcomeView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, width, height) collectionViewLayout:flowLayout];
    
    [self.view addSubview:welcomeView];
    
    welcomeView.showsVerticalScrollIndicator = NO;
    welcomeView.showsHorizontalScrollIndicator = NO;
    
    welcomeView.delegate = self;
    welcomeView.dataSource = self;
    
    welcomeView.bounces = NO;
    welcomeView.pagingEnabled = YES;
    
    [welcomeView registerClass:[RWWelcomeImageCell class]
    forCellWithReuseIdentifier:welcomeCell];
    
    [self initImagePage];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imageSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RWWelcomeImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:welcomeCell forIndexPath:indexPath];
    
    cell.image = imageSource[indexPath.row];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    imagePage.currentPage = scrollView.contentOffset.x / self.view.frame.size.width;
    
    if (imagePage.currentPage == imageSource.count - 1)
    {
        [self.view addSubview:toLogin];
        
        [toLogin mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.width.equalTo(@(90));
            make.height.equalTo(@(35));
            make.centerX.equalTo(self.view.mas_centerX).offset(0);
            make.bottom.equalTo(imagePage.mas_top).offset(0);
        }];
    }
    else
    {
        [toLogin removeFromSuperview];
    }
}

#pragma mark - Life Cycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!welcomeView)
    {
        [self initDataSource];
        
        [self initWelcomeView];
        
        [self initLoginButton];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = MAIN_COLOR;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
