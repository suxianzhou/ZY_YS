//
//  RWAnswerViewController.m
//  ZhongYuSubjectHubKY
//
//  Created by RyeWhiskey on 16/4/28.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWAnswerViewController.h"
#import "RWCustomizeToolBar.h"
#import "RWDataBaseManager.h"
#import "RWAnimations.h"

static unsigned int const no_event = 0x11ffee;

RWAnimationLevel get_event(NSInteger count)
{
    switch (count)
    {
        case 10: return RWAnimationLv1;
        case 20: return RWAnimationLv2;
        case 30: return RWAnimationLv3;
        case 40: return RWAnimationLv4;
        case 50: return RWAnimationLv5;
        case 60: return RWAnimationLv6;
        case 70: return RWAnimationLv7;
        case 80: return RWAnimationLv8;
        case 90: return RWAnimationLv9;
        case 100:return RWAnimationLv10;
            
        default:return no_event;
    }
}

@interface RWAnswerViewController ()

<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    RWCustomizeToolBarClickDelegate,
    RWAnswerViewCellDelegate
>

@property (nonatomic,strong)UICollectionView *answerView;

@property (nonatomic,strong)RWCustomizeToolBar *toolBar;

@property (nonatomic,strong)NSIndexPath *faceIndexPath;

@property (nonatomic,strong)RWDataBaseManager *baseManager;

@property (nonatomic,assign)NSUInteger correctCounts;

@end

static NSString *const answerViewCell = @"answerViewCell";

@implementation RWAnswerViewController

@synthesize answerView;
@synthesize toolBar;
@synthesize faceIndexPath;
@synthesize displayType;
@synthesize baseManager;

- (void)notRegister
{
    NSString *header, *message, *responcedTitle, *cancelTitle;
    
    header = @"登录";
    message = @"立即登录免费获取更多题目\n\n继续体验，请点击取消按钮";
    responcedTitle = @"立即登录";
    cancelTitle = @"取消";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:header message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *registerAction = [UIAlertAction actionWithTitle:responcedTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        
        [SVProgressHUD show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           
                           RWDeployManager *deploy = [RWDeployManager defaultManager];
                           
                           [deploy setDeployValue:NOT_LOGIN forKey:LOGIN];
                       });
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    [alert addAction:registerAction];
    
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setCorrectCounts:(NSUInteger)correctCounts
{
    _correctCounts = correctCounts;

    if (get_event(_correctCounts) != no_event)
    {
        CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,
                                        [UIScreen mainScreen].bounds.size.height);
        
        [self.tabBarController.view addSubview:
                            [RWAnimations animation:fireworksAnimation
                                              Level:get_event(_correctCounts)
                                              Frame:frame]];
    }
}

- (void)initToolBar
{
    toolBar = [[RWCustomizeToolBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 49)];
    
    toolBar.delegate = self;
    
    toolBar.backgroundColor = [UIColor whiteColor];
}

- (void)initNavgationBar
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSString *title = @"清除记录";
        
    if (displayType == RWDisplayTypeCollect)
    {
        title = @"取消收藏";
    }
    else if (displayType == RWDisplayTypeNormal)
    {
        title = @"重新答题";
    }
        
    UIBarButtonItem *deleteBtn = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(deleteItem:)];
        
    self.navigationItem.rightBarButtonItem = deleteBtn;

}

- (void)deleteItem:(UIBarButtonItem *)item
{
    if (![item.title isEqualToString:@"重新答题"])
    {
        if ([item.title isEqualToString:@"取消收藏"])
        {
            [baseManager removeCollect:_subjectSource[faceIndexPath.row] State:RWCollectTypeOnlyCollect];
            
        }
        else if([item.title isEqualToString:@"清除记录"])
        {
            [baseManager removeCollect:_subjectSource[faceIndexPath.row] State:RWCollectTypeOnlyWrong];
        }
        
        [_subjectSource removeObjectAtIndex:faceIndexPath.row];
        
        if (_subjectSource.count == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [answerView reloadData];
        }
    }
    else
    {
        for (int i = 0; i < _subjectSource.count; i++)
        {
            [_subjectSource[i] setValue:[NSNumber numberWithInteger:RWAnswerStateNone] forKey:@"answerstate"];
            
            [_subjectSource[i] setValue:nil forKey:@"choose"];
            
            [baseManager updateEntity:_subjectSource[i]];
            
            [answerView reloadData];
            
            [answerView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
    }
}

- (void)initGestures
{
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(toNext)];
    
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [answerView addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(toPrevious)];
    
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    [answerView addGestureRecognizer:swipeRight];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavgationBar];
    
    _correctCounts = 0;
    
    baseManager = [RWDataBaseManager defaultManager];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    answerView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    
    [self.view addSubview:answerView];
    
    [self initGestures];
    
    answerView.backgroundColor = [UIColor whiteColor];
    
    answerView.scrollEnabled = NO;
    
    [answerView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
    }];
    
    answerView.delegate = self;
    answerView.dataSource = self;
    
    answerView.showsVerticalScrollIndicator = NO;
    answerView.showsHorizontalScrollIndicator = NO;
    
    answerView.pagingEnabled = YES;
    
    [answerView registerClass:[RWAnswerViewCell class] forCellWithReuseIdentifier:answerViewCell];
    
    [self initToolBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationItem.title = _headerTitle;
    
    [self.tabBarController.tabBar addSubview:toolBar];
    
    [answerView reloadData];
    
    [answerView scrollToItemAtIndexPath:_beginIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [toolBar removeFromSuperview];
    
    self.tabBarController.tabBar.translucent = NO;
}

#pragma mark - RWCustomizeToolBarClickDelegate

- (void)toolBar:(RWCustomizeToolBar *)bar ClickWithBotton:(RWToolsBarClick)botton
{
    switch (botton)
    {
        case RWToolsBarClickPrevious:
        {
            [self toPrevious];
        }
            break;
        case RWToolsBarClickShare:
        {
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            
            [SVProgressHUD showInfoWithStatus:@"暂不支持分享"];
        }
            break;
        case RWToolsBarClickCollect:
        {
            if (bar.isCollect)
            {
                BOOL sec = [baseManager removeCollect:_subjectSource[faceIndexPath.row] State:RWCollectTypeOnlyCollect];
                
                if (sec)
                {
                    [bar cancelWithBotton:RWToolsBarClickCollect];
                }
            }
            else
            {
                BOOL sec = [baseManager insertCollect:_subjectSource[faceIndexPath.row] AndType:RWCollectTypeOnlyCollect];
                
                if (sec)
                {
                    [bar didCollect];
                }
            }
        }
            break;
        case RWToolsBarClickCorrect:
        {
            if (!bar.isShowCorrectAnswer)
            {
                RWAnswerViewCell *cell = (RWAnswerViewCell *)[answerView cellForItemAtIndexPath:faceIndexPath];
                
                [cell showCorrectAnswer:^{
                  
                    [bar didShowCorrectAnswer];
                }];
            }
        }
            break;
        case RWToolsBarClickNext:
        {
            [self toNext];
        }
            break;
            
        default:
            break;
    }
}

- (void)toPrevious
{
    if (faceIndexPath.row != 0)
    {
        [answerView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:faceIndexPath.row - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        [toolBar replaceBottonState];
    }
    else
    {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        
        [SVProgressHUD showInfoWithStatus:@"已是第一题"];
    }
}

- (void)toNext
{
    RWDeployManager *deploy = [RWDeployManager defaultManager];
    
    if ([[deploy deployValueForKey:LOGIN] isEqualToString:NOT_LOGIN])
    {
        NSNumber *times = [deploy deployValueForKey:EXPERIENCE_TIMES];
        
        if (times && times.integerValue <= 0)
        {
            [self notRegister];
            
            return;
        }
    }
    
    if (faceIndexPath.row != _subjectSource.count - 1)
    {
        [answerView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:faceIndexPath.row + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        [toolBar replaceBottonState];
    }
    else
    {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        
        [SVProgressHUD showInfoWithStatus:@"已是最后一题"];
    }
}

#pragma mark - delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _subjectSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RWAnswerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:answerViewCell forIndexPath:indexPath];
    
    cell.subjectSource = _subjectSource[indexPath.row];
    
    if ([_subjectSource[indexPath.row] isKindOfClass:[RWSubjectsModel class]])
    {
        if ([[_subjectSource[indexPath.row] valueForKey:@"answerstate"] integerValue]
            != RWAnswerStateNone)
        {
            cell.isAnswer = YES;
            [cell answerDidSelect];
        }
        else
        {
            cell.isAnswer = NO;
        }
    }
    else
    {
        cell.isAnswer = NO;
    }
    
    cell.displayType = displayType;
    
    cell.delegate = self;
    
    if ([baseManager isExistCollectRecordWithModel:_subjectSource[indexPath.row]])
    {
        [toolBar didCollect];
    }
    else
    {
        [toolBar cancelWithBotton:RWToolsBarClickCollect];
    }
    
    faceIndexPath = indexPath;
    
    return cell;
}

- (void)answerCorrect
{
    if (faceIndexPath.row != _subjectSource.count - 1)
    {
        [answerView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:faceIndexPath.row + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        [toolBar replaceBottonState];
    }
    else
    {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        
        [SVProgressHUD showInfoWithStatus:@"已是最后一题"];
    }
    
    [self setCorrectCounts:_correctCounts+1];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    RWAnswerViewCell *answer = (RWAnswerViewCell *)[collectionView cellForItemAtIndexPath:faceIndexPath];
    
    [answer reloadAutoLayout];
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
