//
//  RWTabBarViewController.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/5.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWTabBarViewController.h"
#import "RWMainViewController.h"
#import "RWInformationViewController.h"
#import "RWMoreViewController.h"
#import "RWSubjectCatalogueController.h"
#import "UMCommunity.h"
#import "RWQuackViewController.h"

@interface RWTabBarViewController ()

@property (nonatomic,strong)UIView *coverLayer;

@property (nonatomic,strong)NSArray *names;

@property (nonatomic,strong)NSArray *images;

@property (nonatomic,strong)NSArray *selectImages;

@end

@implementation RWTabBarViewController

@synthesize coverLayer;

- (void)toRootViewController
{
    for (int i = 0; i < 5; i++)
    {
        if (i == 2)
        {
            continue;
        }
        
        UIImageView *imageItem = (UIImageView *)[self.view viewWithTag:(i + 1)*10];
        
        imageItem.image = _images[i];
        
        UILabel *nameX = (UILabel *)[self.view viewWithTag:(i + 1)*100];
        
        nameX.textColor = [UIColor grayColor];
    }
    
    [self selectWithTag:1];
    
    self.selectedIndex = 0;
}

- (void)addHiddenBarObserver
{
    [[NSNotificationCenter defaultCenter] addObserverForName:HIDDEN_NOTIFICATION
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note)
     {
         self.tabBar.translucent = YES;
         self.tabBar.hidden = YES;
     }];
}

- (void)addUnhiddenBarObserver
{
    [[NSNotificationCenter defaultCenter] addObserverForName:UNHIDDEN_NOTIFICATION
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note)
     {
         self.tabBar.translucent = NO;
         self.tabBar.hidden = NO;
     }];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initResource];
    
    [self compositonViewControllers];
    
    [self compositionCoverLayer];
    
    [self compositionButton];
    
    [self addHiddenBarObserver];
    
    [self addUnhiddenBarObserver];
}

- (void)initResource
{
    _names = @[@"资讯",@"题目练习",@"",@"直播课",@"更多"];
    
    _images = @[[UIImage imageNamed:@"noti"],
                [UIImage imageNamed:@"main"],
                [UIImage imageNamed:@"noti"],
                [UIImage imageNamed:@"media"],
                [UIImage imageNamed:@"set"]];
    
    _selectImages = @[[UIImage imageNamed:@"noti_s"],
                      [UIImage imageNamed:@"mian_s"],
                      [UIImage imageNamed:@"noti"],
                      [UIImage imageNamed:@"media_s"],
                      [UIImage imageNamed:@"set_s"]];
}

- (void)compositionCoverLayer
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    coverLayer = [[UIView alloc] initWithFrame:
                                    CGRectMake(0, 0, self.tabBar.frame.size.width,
                                                     self.tabBar.frame.size.height)];
    
    [self.tabBar addSubview:coverLayer];
    
    coverLayer.backgroundColor = [UIColor whiteColor];
}

- (void)compositonViewControllers
{
    
    RWMainViewController *main = [[RWMainViewController alloc]init];
    
    UINavigationController *mainNav = [[UINavigationController alloc]initWithRootViewController:main];
    
    RWSubjectCatalogueController *catalogue =
                                        [[RWSubjectCatalogueController alloc]init];
    
    UINavigationController *catalogueNav = [[UINavigationController alloc]initWithRootViewController:catalogue];
    
    RWInformationViewController *information = [[RWInformationViewController alloc]init];
    
    UINavigationController *notiNav = [[UINavigationController alloc]initWithRootViewController:information];
    
    RWMoreViewController *more = [[RWMoreViewController alloc]init];
    
    UINavigationController *moreNav = [[UINavigationController alloc]initWithRootViewController:more];
    
    
    self.viewControllers = @[mainNav,catalogueNav,notiNav,moreNav];
    
}

- (void)compositionButton
{
    CGFloat w = self.tabBar.frame.size.width / 5;
    
    CGFloat h = self.tabBar.frame.size.height;
    
    for (int i = 0; i < 5; i++)
    {
        if (i == 2)
        {
            continue;
        }
        
        [self tabBarButtonWithFrame:CGRectMake(w * i, 0, w, h) AndTag:i+1];
    }
    
    [self selectWithTag:1];
    
    UIView *community = [[UIView alloc] initWithFrame:CGRectMake(0, 0, h, h)];
    
    community.center = CGPointMake(self.tabBar.frame.size.width / 2, h /2);
    
    community.tag = 3;
    
    [coverLayer addSubview:community];
    
    [self viewAddTapGesture:community];
    
    UIImageView *communityLogo = [[UIImageView alloc] init];
    
    [community addSubview:communityLogo];
    
    [communityLogo mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(community.mas_left).offset(5);
        make.right.equalTo(community.mas_right).offset(-5);
        make.bottom.equalTo(community.mas_bottom).offset(-5);
        make.top.equalTo(community.mas_top).offset(5);
    }];
    
    communityLogo.image = [UIImage imageNamed:@"communityHome"];
    
    communityLogo.layer.shadowColor = [[UIColor blackColor] CGColor];
    communityLogo.layer.shadowOffset = CGSizeMake(0, 0);
    communityLogo.layer.shadowRadius = 2;
    communityLogo.layer.shadowOpacity = 1;
    
    community.layer.borderWidth = 3;
    community.layer.borderColor = [[UIColor whiteColor] CGColor];
    community.layer.shadowColor = [[UIColor blackColor] CGColor];
    community.layer.shadowOffset = CGSizeMake(10, 10);
    community.layer.shadowRadius = 10;
    community.layer.shadowOpacity = 1;
    community.layer.masksToBounds = YES;
    community.backgroundColor = MAIN_COLOR;
    
    community.layer.cornerRadius = self.tabBar.frame.size.height / 2;
    
    community.clipsToBounds = YES;
}

- (void)viewAddTapGesture:(UIView *)view
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toCommunityViewController)];
    
    tap.numberOfTapsRequired = 1;
    
    [view addGestureRecognizer:tap];
}

- (void)toCommunityViewController
{
    UIViewController *communityController = [UMCommunity getFeedsModalViewController];
    [self presentViewController:communityController animated:YES completion:nil];

}

- (UIView *)tabBarButtonWithFrame:(CGRect)frame AndTag:(NSInteger)tag
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    view.tag = tag;
    
    [coverLayer addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    imageView.tag = tag * 10;
    imageView.image = _images[tag-1];
    
    [view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(view.mas_top).offset(2);
        make.width.equalTo(@(30));
        make.height.equalTo(@(30));
        make.centerX.equalTo(view.mas_centerX).offset(0);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    
    nameLabel.text = _names[tag-1];
    nameLabel.tag = tag * 100;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:10];
    nameLabel.textColor = [UIColor grayColor];
    
    [view addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(imageView.mas_bottom).offset(0);
        make.left.equalTo(view.mas_left).offset(0);
        make.right.equalTo(view.mas_right).offset(0);
        make.bottom.equalTo(view.mas_bottom).offset(-3);
    }];
    
    [self addGestureRecognizerToView:view];
    
    return view;
}

- (void)addGestureRecognizerToView:(UIView *)view
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cutViewControllerWithGesture:)];
    
    tap.numberOfTapsRequired = 1;
    
    [view addGestureRecognizer:tap];
}

- (void)cutViewControllerWithGesture:(UITapGestureRecognizer *)tapGesture
{
    for (int i = 0; i < 5; i++)
    {
        if (i == 2)
        {
            continue;
        }
        
        UIImageView *imageItem = (UIImageView *)[self.view viewWithTag:(i + 1)*10];
        
        imageItem.image = _images[i];
        
        UILabel *nameX = (UILabel *)[self.view viewWithTag:(i + 1)*100];
        
        nameX.textColor = [UIColor grayColor];
    }
    
    [self selectWithTag:tapGesture.view.tag];
}

- (void)selectWithTag:(NSInteger)tag
{
    UIImageView *imageItem =
                    (UIImageView *)[self.view viewWithTag:tag * 10];
    
    imageItem.image = _selectImages[tag - 1];
    
    UILabel *nameLabel = [self.view viewWithTag:tag * 100];
    
    nameLabel.textColor = MAIN_COLOR;
    
    if (tag < 3)
    {
        self.selectedIndex = tag - 1;
    }
    else if (tag > 3)
    {
        self.selectedIndex = tag - 2;
    }
}

- (void)quack
{
    RWQuackViewController *quack = [[RWQuackViewController alloc] init];
    
    UINavigationController *notiNav = [[UINavigationController alloc]initWithRootViewController:quack];
    
    NSMutableArray *arr = [self.viewControllers mutableCopy];
    
    [arr removeObjectAtIndex:2];
    [arr insertObject:notiNav atIndex:2];
    
    self.viewControllers = [arr copy];
    
    [self.tabBar addSubview:coverLayer];

    _names = @[@"资讯",@"题目练习",@"",@"行情参考",@"更多"];
    
    _images = @[[UIImage imageNamed:@"noti"],
                [UIImage imageNamed:@"main"],
                [UIImage imageNamed:@"noti"],
                [UIImage imageNamed:@"error"],
                [UIImage imageNamed:@"set"]];
    
    _selectImages = @[[UIImage imageNamed:@"noti_s"],
                      [UIImage imageNamed:@"mian_s"],
                      [UIImage imageNamed:@"noti"],
                      [UIImage imageNamed:@"error_s"],
                      [UIImage imageNamed:@"set_s"]];
    
    UIView *view = [self.view viewWithTag:4];
    
    [self addGestureRecognizerToView:view];
    
    UIImageView *imageItem = (UIImageView *)[self.view viewWithTag:40];
    
    imageItem.image = [UIImage imageNamed:@"error"];
    
    UILabel *nameLabel = [self.view viewWithTag:400];
    
    nameLabel.text = @"行情参考";
    
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
