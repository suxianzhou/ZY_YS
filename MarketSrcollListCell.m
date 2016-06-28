//
//  MarketSrcollListCell.m
//  HXBusiness
//
//  Created by RyeWhiskey on 16/2/13.
//  Copyright © 2016年 RyeVishkey. All rights reserved.
//

#import "MarketSrcollListCell.h"
#import "SrcollBoardCell.h"

@interface MarketSrcollListCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

{
    UICollectionView *scrollBoard;
    NSMutableArray *scrollDataSource;
    CGRect infoFrame;
    NSInteger contOffset_y;
    NSNotificationCenter *notiCenter;
    BOOL tentativeDisruption;
}

@end

static NSString *scrCell = @"scrCell";

@implementation MarketSrcollListCell

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    infoFrame = frame;
    scrollBoard.frame = CGRectMake(infoFrame.size.width/4, 0, infoFrame.size.width/4*3, infoFrame.size.height);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _dataSource = [[MarketBlockModel alloc]init];
        scrollDataSource = [[NSMutableArray alloc]init];
        _rwContentOffset = CGPointMake(0, 0);
        tentativeDisruption = YES;
        notiCenter = [NSNotificationCenter defaultCenter];
        
        [notiCenter addObserverForName:@"stop" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            tentativeDisruption = NO;
        }];
        
        [notiCenter addObserverForName:@"start" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            tentativeDisruption = YES;
        }];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(4, 4, 4, 4);
        scrollBoard = [[UICollectionView alloc]initWithFrame:CGRectMake(infoFrame.size.width/4, 0, infoFrame.size.width/4*3, infoFrame.size.height) collectionViewLayout:flowLayout];
        [self addSubview:scrollBoard];
        scrollBoard.backgroundColor = [UIColor whiteColor];
        scrollBoard.delegate = self;
        scrollBoard.dataSource = self;
        scrollBoard.showsHorizontalScrollIndicator = NO;
        scrollBoard.showsVerticalScrollIndicator = NO;
        scrollBoard.bounces = NO;
        scrollBoard.contentOffset = _rwContentOffset;
        
        [scrollBoard registerClass:[SrcollBoardCell class] forCellWithReuseIdentifier:scrCell];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, infoFrame.size.width/4, infoFrame.size.height/2)];
        [self addSubview:_nameLabel];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:15];
        
        _codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, infoFrame.size.height/2, infoFrame.size.width/4, infoFrame.size.height/2)];
        [self addSubview:_codeLabel];
        _codeLabel.textAlignment = NSTextAlignmentCenter;
        _codeLabel.font = [UIFont systemFontOfSize:11];
        _codeLabel.textColor = [UIColor grayColor];
    }
    return self;
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return scrollDataSource.count;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SrcollBoardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:scrCell forIndexPath:indexPath];
    
    cell.showLabel.text = scrollDataSource[indexPath.row];
    if (indexPath.row == 1) {
        if ([_dataSource.upOrDownFlag isEqualToString:@"-"]) {
            cell.showLabel.backgroundColor = [UIColor colorWithRed:84.0f/255.0f
                                                             green:139.0f/255.0f
                                                              blue:84.0f/255.0f
                                                             alpha:1.0];
        }else {
            cell.showLabel.backgroundColor = [UIColor redColor];
        }
        cell.showLabel.textColor = [UIColor whiteColor];
    }else {
        cell.showLabel.backgroundColor = [UIColor whiteColor];
        cell.showLabel.textColor = [UIColor blackColor];
    }
    scrollBoard.contentOffset = _rwContentOffset;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(infoFrame.size.width/4-8, infoFrame.size.height-8);
}

//collectionView 滚动时将 偏移量和当前分组传入 调用代理的方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (tentativeDisruption) {
        [self.delegate cellChainReaction:scrollView.contentOffset WithSection:_faceSection];
    }
}

/*
 "code": "600515",
 "Name": "海航基础",
 "Price": "12.84",
 "UpDownRate": "+10.03%",
 "UpDown": "+1.17",
 "excode": "SSE",
 "upOrDownFlag": "+",
 "id": "1598"
 */

// 重组数据源
- (void)setDataSource:(MarketBlockModel *)dataSource{
    _dataSource = dataSource;
    [scrollDataSource removeAllObjects];
    [scrollDataSource addObject:_dataSource.price];
    [scrollDataSource addObject:_dataSource.upDownRate];
    [scrollDataSource addObject:_dataSource.upDown];
    [scrollDataSource addObject:@"/"];
    [scrollDataSource addObject:@"/"];
    [scrollDataSource addObject:@"/"];
    [scrollBoard reloadData];
}
// 更新collestView 的偏移量
- (void)setRwContentOffset:(CGPoint)rwContentOffset{
    _rwContentOffset = rwContentOffset;
    scrollBoard.contentOffset = _rwContentOffset;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
