//
//  RWQuackViewController.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/6/23.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWQuackViewController.h"
#import "MJRefresh.h"
#import "MarketScrollBlockCell.h"
#import "MarketBlockTableViewCell.h"
#import "MarketSrcollListCell.h"
#import "MarketPlainTableViewCell.h"
#import "RWScrollHeader.h"
#import <AFNetworking.h>

typedef enum RWLayoutMark{
    
    RWLayoutStyleSrcollBlock = 1,
    RWLayoutStyleBlock = 3,
    RWLayoutStylePlain = 5,
    RWLayoutStyleSrcollBlockAndBlock = 1+3,
    RWLayoutStyleSrcollBlockAndPlain = 1+5,
    RWLayoutStyleBlockAndPlain = 3+8,
    RWLayoutStyleAllStyles = 1+3+5
    
}RWLayoutStyle;

typedef enum {
    
    RWMarketStyleScrollBlock = 0,
    RWMarketStyleBlock = 1,
    RWMarketStylePlain = 2,
    RWMarketStyleMoneyFund = 3
    
}RWMarketStyle;

#define MARKET_STYLE @[@"MarketIndex",@"Plate",@"Plain",@"MoneyFund"]

#define WIDTH self.view.frame.size.width

#define MARKET_HANDERS @[@[@"",@"热门版块",@"地域板块",@"沪市A股",@"深市A股",@"中小板",@"创业板",@"沪市B股",@"深市B股"],@[@"开放式基金涨幅榜",@"封闭式基金涨幅榜",@"货币式基金涨幅榜"],@[@"",@"港股主板",@"红筹股",@"蓝筹股",@"国企股",@"创业板"],@[@"沪市A股涨幅榜",@"深市A股涨幅榜",@"中小板涨幅榜",@"创业板涨幅榜",@"沪市B股涨幅榜",@"深市B股涨幅榜"],@[@"国债",@"企业债",@"转债"]]

static NSString *scrollBlock = @"scrollBlock";
static NSString *blockCell = @"blockCell";
static NSString *scrollList = @"scrollList";
static NSString *plainCell = @"plainCell";
static NSString *blockHeader = @"blockHeader";

@interface RWQuackViewController ()

<
    UITableViewDataSource,
    UITableViewDelegate,
    RWSrcollListCellDelegate,
    RWSrcollHeaderDelegate
>

@property (nonatomic,strong)UITableView *marketList;

@property (nonatomic,strong)MJRefreshNormalHeader *refreshHander;

@property (nonatomic,assign)NSInteger layoutMark;

@property (nonatomic,assign)NSInteger faceSection;

@property (nonatomic,assign)CGPoint offset;

@property (nonatomic,assign)NSInteger beforeSection;

@property (nonatomic,strong)NSNotificationCenter *notiCenter;

@property (nonatomic,strong)NSArray *srcollBlockData;

@property (nonatomic,strong)NSArray *blockData;

@property (nonatomic,strong)NSArray *plainData;

@property (nonatomic,strong)NSArray *headerArr;

@property (nonatomic,strong)NSIndexPath *faceIndexPath;

@end

@implementation RWQuackViewController

- (void)requestData
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    static NSString *const url = @"http://wapi.hexun.com/Api_getMarketData.cc?flag=hs_market";
    
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *datas = [self analysisForMarketsJSON:responseObject];

        [self assignData:datas];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
}

- (NSDictionary *)analysisForMarketsJSON:(NSData *)responseObject
{
    
    NSDictionary *markets = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    
    NSArray *allKeys = [markets allKeys];
    
    NSMutableDictionary *dataPackage = [[NSMutableDictionary alloc]init];
    NSMutableArray *plainData = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < allKeys.count; i++) {
        
        if ([allKeys[i] isEqualToString:MARKET_STYLE[RWMarketStyleScrollBlock]]) {
            NSArray *arr = [self combinationMarketElement:[markets valueForKey:allKeys[i]]];
            if (arr != nil) {
                [dataPackage setValue:arr forKey:MARKET_STYLE[RWMarketStyleScrollBlock]];
            }
        }else if ([allKeys[i] isEqualToString:MARKET_STYLE[RWMarketStyleBlock]]) {
            NSArray *arr = [self combinationMarketPackage:[markets valueForKey:allKeys[i]]];
            if (arr != nil) {
                [dataPackage setValue:arr forKey:MARKET_STYLE[RWMarketStyleBlock]];
            }
        }else {
            if ([allKeys[i]isEqualToString:MARKET_STYLE[RWMarketStyleMoneyFund]]) {
                NSArray *arr = [self combinationMarketElement:[markets valueForKey:allKeys[i]]];
                [plainData addObject:arr];
                //NSLog(@"%@",arr);
            }else {
                NSArray *arr = [self combinationMarketPackage:[markets valueForKey:allKeys[i]]];
                for (int i = 0; i < arr.count; i++) {
                    [plainData addObject:arr[i]];
                }
            }
            
        }
    }
    if (plainData.count != 0) {
        [dataPackage setValue:plainData forKey:MARKET_STYLE[RWMarketStylePlain]];
    }
    return dataPackage;
}

- (NSArray *)combinationMarketPackage:(NSArray *)package{
    
    NSMutableArray *packageArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < package.count; i++) {
        [packageArr addObject:[self combinationMarketElement:package[i]]];
    }
    
    return packageArr;
}

- (NSArray *)combinationMarketElement:(NSArray *)element{
    
    NSMutableArray *elementArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < element.count; i++) {
        [elementArr addObject:[self analysisMarketElement:element[i]]];
    }
    
    return elementArr;
}

- (MarketBlockModel *)analysisMarketElement:(NSDictionary *)element{
    
    MarketBlockModel *market = [[MarketBlockModel alloc]init];
    
    if ([element valueForKey:@"fundCode"]) {
        market.code = [element valueForKey:@"fundCode"];
        market.name = [element valueForKey:@"fundName"];
        market.price = [element valueForKey:@"tThousands"];
        market.upDown = [element valueForKey:@"tDay7"];
        market.upOrDownFlag = [element valueForKey:@"upOrDownFlag"];
    }else {
        market.code = [element valueForKey:@"code"];
        market.name = [element valueForKey:@"Name"];
        market.price = [element valueForKey:@"Price"];
        market.upDownRate = [element valueForKey:@"UpDownRate"];
        market.upDown = [element valueForKey:@"UpDown"];
        market.excode = [element valueForKey:@"excode"];
        market.upOrDownFlag = [element valueForKey:@"upOrDownFlag"];
        market.marketID = [element valueForKey:@"id"];
        
    }
    
    return market;
}

- (NSMutableArray *)obtainPackageBlockData:(NSArray *)blockData{
    
    NSMutableArray *packageBlockData = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < blockData.count; i++) {
        [packageBlockData addObject:[self readjustPackage:blockData[i]]];
    }
    
    return [NSMutableArray arrayWithArray:packageBlockData];
}

- (NSArray *)readjustPackage:(NSArray *)package{
    
    NSMutableArray *newPackage = [[NSMutableArray alloc]init];
    
    if (package.count%3==0) {
        for (int i = 0; i < package.count/3; i++) {
            [newPackage addObject:@[package[i*3],package[i*3+1],package[i*3+2]]];
        }
    }else if(package.count%3==1){
        for (int i = 0; i < package.count/3+1; i++) {
            if (i == package.count-1) {
                [newPackage addObject:@[[package lastObject]]];
            }else {
                [newPackage addObject:@[package[i*3],package[i*3+1],package[i*3+2]]];
            }
        }
    }else if(package.count%3==2){
        for (int i = 0; i < package.count/3+1; i++) {
            if (i == package.count-1) {
                [newPackage addObject:@[package[package.count-2],[package lastObject]]];
            }else {
                [newPackage addObject:@[package[i*3],package[i*3+1],package[i*3+2]]];
            }
        }
        
    }
    return [NSArray arrayWithArray:newPackage];
}

- (void)assignData:(NSDictionary *)marketsSource{
    
    NSMutableArray *BSArr = [marketsSource valueForKey:MARKET_STYLE[RWMarketStyleScrollBlock]];
    NSMutableArray *BArr = [marketsSource valueForKey:MARKET_STYLE[RWMarketStyleBlock]];
    NSMutableArray *PlArr = [marketsSource valueForKey:MARKET_STYLE[RWMarketStylePlain]];
    
    if (BSArr != nil&&_faceIndexPath.row != 3)
    {
        _srcollBlockData =BSArr;
    }
    
    if (BArr != nil&&_faceIndexPath.row != 3) {
        
        _blockData = [self obtainPackageBlockData:BArr];
    }
    if (PlArr != nil){
        
        _plainData = PlArr;
    }
    
    [_marketList reloadData];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MAIN_NAV
    
    self.navigationItem.title = @"行情参考";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.translucent = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    _headerArr = MARKET_HANDERS[0];
    
    _notiCenter = [NSNotificationCenter defaultCenter];
    _faceIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    _marketList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    
    [self.view addSubview:_marketList];
    
    [_marketList mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    _marketList.showsHorizontalScrollIndicator = NO;
    _marketList.delegate = self;
    _marketList.dataSource = self;
    _marketList.allowsSelection = NO;
    
    _marketList.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNow)];
    
    [self registerCells];
}


- (void)registerCells{
    
    [_marketList registerClass:[MarketScrollBlockCell class] forCellReuseIdentifier:scrollBlock];
    
    [_marketList registerClass:[MarketBlockTableViewCell class] forCellReuseIdentifier:blockCell];
    
    [_marketList registerClass:[MarketSrcollListCell class] forCellReuseIdentifier:scrollList];
    
    [_marketList registerClass:[MarketPlainTableViewCell class] forCellReuseIdentifier:plainCell];
    
    [_marketList registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:blockHeader];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self requestData];
}

- (void)refreshNow{
    
    [self requestData];
    
    [_marketList.mj_header endRefreshing];
}

- (void)obtainLayoutMark{
    
    _layoutMark = 0;
    
    if (_srcollBlockData.count > 0) {
        _layoutMark += RWLayoutStyleSrcollBlock;
    }
    if (_blockData.count > 0) {
        _layoutMark += RWLayoutStyleBlock;
    }
    if (_plainData.count > 0) {
        _layoutMark += RWLayoutStylePlain;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (_srcollBlockData.count != 0)
    {
        return _plainData.count + _blockData.count + 1;
    }
    return _plainData.count + _blockData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self obtainLayoutMark];
    
    switch (_layoutMark) {
        case RWLayoutStyleSrcollBlock:
            return 100;
        case RWLayoutStyleBlock:
            return 100;
        case RWLayoutStylePlain:
            return 44;
        case RWLayoutStyleSrcollBlockAndBlock:
            return 100;
        case RWLayoutStyleSrcollBlockAndPlain:
            if (indexPath.section==0) {
                return 100;
            }else{
                return 44;
            }
        case RWLayoutStyleBlockAndPlain:
            if (indexPath.section<_blockData.count) {
                return 100;
            }else{
                return 44;
            }
        case RWLayoutStyleAllStyles:
            if (indexPath.section <= _blockData.count) {
                return 100;
            }else {
                return 44;
            }
        default:
            return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    [self obtainLayoutMark];
    
    switch (_layoutMark) {
        case RWLayoutStyleSrcollBlock:
            return 1;
        case RWLayoutStyleBlock:
            return [_blockData[section] count];
        case RWLayoutStylePlain:
            return [_plainData[section] count];
        case RWLayoutStyleSrcollBlockAndBlock:
            if (section==0) {
                return 1;
            }else{
                return [_blockData[section-1] count];
            }
        case RWLayoutStyleSrcollBlockAndPlain:
            if (section==0) {
                return 1;
            }else{
                return [_plainData[section-1] count];
            }
        case RWLayoutStyleBlockAndPlain:
            if (section<=_blockData.count) {
                return [_blockData[section] count];
            }else{
                return [_plainData[section-_blockData.count] count];
            }
        case RWLayoutStyleAllStyles:
            if (section == 0) {
                return 1;
            }else if (section <= _blockData.count) {
                return [_blockData[section-1] count];
            }else {
                return [_plainData[section-1-_blockData.count] count];
            }
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self obtainLayoutMark];
    
    switch (_layoutMark) {
        case RWLayoutStyleSrcollBlock:
            return [self obtainScrollBlockCellWithTableView:tableView AndIndexPath:indexPath AndDataArr:_srcollBlockData];
        case RWLayoutStyleBlock:
            return [self obtainBlockCellWithTableView:tableView AndIndexPath:indexPath AndDataArr:_blockData[indexPath.section][indexPath.row]];
        case RWLayoutStylePlain:
            if (_faceIndexPath.row == 3) {
                return [self obtainScrollListCellWithTableView:tableView AndIndexPath:indexPath AndModel:_plainData[indexPath.section][indexPath.row]];
            }else {
                return [self obtainPlainCellWithTableView:tableView AndIndexPath:indexPath AndModel:_plainData[indexPath.section][indexPath.row]];
            }
        case RWLayoutStyleSrcollBlockAndBlock:
            if (indexPath.section==0) {
                return [self obtainScrollBlockCellWithTableView:tableView AndIndexPath:indexPath AndDataArr:_srcollBlockData];
            }else{
                return [self obtainBlockCellWithTableView:tableView AndIndexPath:indexPath AndDataArr:_blockData[indexPath.section-1][indexPath.row]];
            }
        case RWLayoutStyleSrcollBlockAndPlain:
            if (indexPath.section==0) {
                return [self obtainScrollBlockCellWithTableView:tableView AndIndexPath:indexPath AndDataArr:_srcollBlockData];
            }else{
                return [self obtainPlainCellWithTableView:tableView AndIndexPath:indexPath AndModel:_plainData[indexPath.section-1][indexPath.row]];
            }
        case RWLayoutStyleBlockAndPlain:
            if (indexPath.section<=_blockData.count) {
                return [self obtainBlockCellWithTableView:tableView AndIndexPath:indexPath AndDataArr:_blockData[indexPath.section][indexPath.row]];
            }else{
                return [self obtainPlainCellWithTableView:tableView AndIndexPath:indexPath AndModel:_plainData[indexPath.section-_blockData.count][indexPath.row]];
            }
        case RWLayoutStyleAllStyles:
            if (indexPath.section == 0) {
                return [self obtainScrollBlockCellWithTableView:tableView AndIndexPath:indexPath AndDataArr:_srcollBlockData];
            }else if (indexPath.section <= _blockData.count) {
                return [self obtainBlockCellWithTableView:tableView AndIndexPath:indexPath AndDataArr:_blockData[indexPath.section-1][indexPath.row]];
            }else {
                if (_faceIndexPath.row == 3) {
                    return [self obtainScrollListCellWithTableView:tableView AndIndexPath:indexPath AndModel:_plainData[indexPath.section-_blockData.count-1][indexPath.row]];
                }else {
                    return [self obtainPlainCellWithTableView:tableView AndIndexPath:indexPath AndModel:_plainData[indexPath.section-_blockData.count-1][indexPath.row]];
                }
            }
        default:
            return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_faceIndexPath.row == 0||_faceIndexPath.row == 2) {
        if (section == 0) {
            return 1;
        }else{
            if (_faceIndexPath.row == 0) {
                if (section <3) {
                    return 30;
                }else {
                    return 60;
                }
            }else {
                if (section <1) {
                    return 30;
                }else {
                    return 60;
                }
            }
        }
    }else {
        return 60;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (_faceIndexPath.row == 0||_faceIndexPath.row == 2) {
        if (section == 0) {
            return nil;
        }else{
            if (_faceIndexPath.row == 0) {
                if (section <3) {
                    return [self obtainPlainHeaderViewWithSection:section];
                }else {
                    return [self obtainHeaderPlusViewWithSection:section];
                }
            }else {
                if (section <1) {
                    return [self obtainPlainHeaderViewWithSection:section];
                }else {
                    return [self obtainHeaderPlusViewWithSection:section];
                }
            }
        }
    }else {
        if (_faceIndexPath.row == 3) {
            return [self obtainScrollHeaderViewWithSection:section];
        }else {
            return [self obtainHeaderPlusViewWithSection:section];
        }
    }
}

- (MarketScrollBlockCell *)obtainScrollBlockCellWithTableView:(UITableView *)tableView AndIndexPath:(NSIndexPath *)indexPath AndDataArr:(NSArray *)dataArr{
    MarketScrollBlockCell *cell = [tableView dequeueReusableCellWithIdentifier:scrollBlock forIndexPath:indexPath];
    cell.dataSource = dataArr;
    return cell;
}

- (MarketBlockTableViewCell *)obtainBlockCellWithTableView:(UITableView *)tableView AndIndexPath:(NSIndexPath *)indexPath AndDataArr:(NSArray *)dataArr{
    MarketBlockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:blockCell forIndexPath:indexPath];
    cell.dataSource = dataArr;
    return cell;
}

- (MarketPlainTableViewCell *)obtainPlainCellWithTableView:(UITableView *)tableView AndIndexPath:(NSIndexPath *)indexPath AndModel:(MarketBlockModel *)model{
    MarketPlainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:plainCell forIndexPath:indexPath];
    cell.dataSource = model;
    return cell;
}

- (MarketSrcollListCell *)obtainScrollListCellWithTableView:(UITableView *)tableView AndIndexPath:(NSIndexPath *)indexPath AndModel:(MarketBlockModel *)model{
    MarketSrcollListCell *cell = [tableView dequeueReusableCellWithIdentifier:scrollList forIndexPath:indexPath];
    
    cell.nameLabel.text = model.name;
    cell.codeLabel.text = model.code;
    cell.dataSource = model;
    cell.faceSection = indexPath.section;
    if (_faceSection == indexPath.section) {
        cell.rwContentOffset = _offset;
    }else {
        cell.rwContentOffset = CGPointMake(0, 0);
    }
    cell.delegate = self;
    return cell;
}

- (UIView *)obtainPlainHeaderViewWithSection:(NSInteger)section{
    UIView *backView = [[UIView alloc]init];
    
    UILabel *header = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, WIDTH-30, 30)];
    header.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:14];
    
    if (_headerArr.count >= section+1) {
        header.text = _headerArr[section];
    }
    [backView addSubview:header];
    
    return backView;
}

- (UIView *)obtainHeaderPlusViewWithSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc]init];
    
    UILabel *header = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, WIDTH-30, 30)];
    header.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:14];
    
    if (_headerArr.count >= section+1) {
        header.text = _headerArr[section];
    }
    [backView addSubview:header];
    
    UILabel *back = [[UILabel alloc]initWithFrame:CGRectMake(0, header.frame.size.height, WIDTH-30, 30)];
    [backView addSubview:back];
    back.backgroundColor = [UIColor whiteColor];
    
    UILabel *plusTwo = [[UILabel alloc]init];
    [backView addSubview:plusTwo];
    plusTwo.backgroundColor = [UIColor whiteColor];
    plusTwo.textAlignment = NSTextAlignmentCenter;
    plusTwo.text = @"最新";
    plusTwo.font = [UIFont systemFontOfSize:14];
    plusTwo.textColor = [UIColor grayColor];
    [plusTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header.mas_bottom).offset(0);
        make.bottom.equalTo(backView.mas_bottom).offset(0);
        make.left.equalTo(backView.mas_left).offset(self.view.frame.size.width/3);
        make.right.equalTo(backView.mas_right).offset(-self.view.frame.size.width/3);
    }];
    
    UILabel *plusOne = [[UILabel alloc]init];
    [backView addSubview:plusOne];
    plusOne.backgroundColor = [UIColor whiteColor];
    plusOne.textAlignment = NSTextAlignmentCenter;
    plusOne.text = @"简称";
    plusOne.font = [UIFont systemFontOfSize:14];
    plusOne.textColor = [UIColor grayColor];
    [plusOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header.mas_bottom).offset(0);
        make.bottom.equalTo(backView.mas_bottom).offset(0);
        make.left.equalTo(backView.mas_left).offset(0);
        make.right.equalTo(plusTwo.mas_left).offset(-20);
    }];
    
    UILabel *plusThree = [[UILabel alloc]init];
    [backView addSubview:plusThree];
    plusThree.backgroundColor = [UIColor whiteColor];
    plusThree.textAlignment = NSTextAlignmentCenter;
    plusThree.text = @"涨幅%";
    plusThree.font = [UIFont systemFontOfSize:14];
    plusThree.textColor = [UIColor grayColor];
    [plusThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header.mas_bottom).offset(0);
        make.bottom.equalTo(backView.mas_bottom).offset(0);
        make.left.equalTo(plusTwo.mas_right).offset(20);
        make.right.equalTo(backView.mas_right).offset(0);
    }];
    
    return backView;
}

- (UIView *)obtainScrollHeaderViewWithSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc]init];
    
    UILabel *header = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, WIDTH-30, 30)];
    header.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:14];
    
    if (_headerArr.count >= section+1) {
        header.text = _headerArr[section];
    }
    [backView addSubview:header];
    
    RWScrollHeader *scrHeader = [[RWScrollHeader alloc]initWithFrame:CGRectMake(0, header.frame.size.height, self.view.frame.size.width,30)];
    scrHeader.userInteractionEnabled = NO;
    scrHeader.rwContentOffset = CGPointMake(0, 0);
    [backView addSubview:scrHeader];
    scrHeader.nameLabel.text = @"简称";
    scrHeader.dataSource = @[@"最新",@"涨幅%",@"涨跌",@"/",@"/",@"/"];
    scrHeader.delegate = self;
    
    return backView;
}

#pragma mark RWSrcollListCellDelegate 同组cell的滚动视图联动
- (void)cellChainReaction:(CGPoint)contentOffset WithSection:(NSInteger)section{
    
    _faceSection = section;
    _offset = contentOffset;
    NSInteger cellNumber = [_marketList numberOfRowsInSection:section];
    for (int i = 0; i < cellNumber; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        MarketSrcollListCell *cell = [_marketList cellForRowAtIndexPath:indexPath];
        cell.rwContentOffset = contentOffset;
    }
}

#pragma mark tableView 的SrcollViewDelagate 当tableView上下滚动时中断上面代理方法

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_notiCenter postNotificationName:@"stop" object:nil];
}
#pragma mark tableView 的SrcollViewDelagate 当tableView上下滚动结束重启上面代理方法

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_notiCenter postNotificationName:@"start" object:nil];
}

- (void)reloadData
{
    [_marketList reloadData];
}

@end
