//
//  RWScrollHeader.m
//  RealTime
//
//  Created by RyeWhiskey on 16/2/28.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWScrollHeader.h"
#import "SrcollBoardCell.h"
#import "Masonry.h"

@interface RWScrollHeader ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

{
  
    UICollectionView *scrollBoard;
    CGRect infoFrame;
    NSInteger contOffset_y;
    NSNotificationCenter *notiCenter;
    BOOL tentativeDisruption;
    
}

@end

static NSString *const headerCell = @"headerCell";

@implementation RWScrollHeader

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    infoFrame = frame;
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self compositionSrcollHeader];
    }
    return self;
}

- (void)compositionSrcollHeader{
    
    _dataSource = [[NSArray alloc]init];
    _rwContentOffset = CGPointMake(0, 0);
    tentativeDisruption = YES;
    notiCenter = [NSNotificationCenter defaultCenter];
    
    [notiCenter addObserverForName:@"stop" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        tentativeDisruption = NO;
    }];
    
    [notiCenter addObserverForName:@"start" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        tentativeDisruption = YES;
    }];
    
    _nameLabel = [[UILabel alloc]init];
    [self addSubview:_nameLabel];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont systemFontOfSize:13];
    _nameLabel.textColor = [UIColor grayColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    scrollBoard = [[UICollectionView alloc]initWithFrame:CGRectMake(infoFrame.size.width/4, 0, infoFrame.size.width/4*3, infoFrame.size.height) collectionViewLayout:flowLayout];
    [self addSubview:scrollBoard];
    scrollBoard.backgroundColor = [UIColor whiteColor];
    scrollBoard.delegate = self;
    scrollBoard.dataSource = self;
    scrollBoard.showsHorizontalScrollIndicator = NO;
    scrollBoard.showsVerticalScrollIndicator = NO;
    scrollBoard.bounces = NO;
    scrollBoard.contentOffset = _rwContentOffset;
    
    [scrollBoard registerClass:[SrcollBoardCell class] forCellWithReuseIdentifier:headerCell];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(-self.frame.size.width/4*3);
    }];
    [scrollBoard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.left.equalTo(_nameLabel.mas_right).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
    }];
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataSource.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SrcollBoardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:headerCell forIndexPath:indexPath];
    
    cell.showLabel.text = _dataSource[indexPath.row];
    cell.showLabel.font = [UIFont systemFontOfSize:13];
    cell.showLabel.textColor = [UIColor grayColor];
    
    scrollBoard.contentOffset = _rwContentOffset;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(infoFrame.size.width/4, infoFrame.size.height);
}

//collectionView 滚动时将 偏移量和当前分组传入 调用代理的方法
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (tentativeDisruption) {
//        [self.delegate headerChainReaction:scrollView.contentOffset];
//    }
//}

- (void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    [scrollBoard reloadData];
}




@end
