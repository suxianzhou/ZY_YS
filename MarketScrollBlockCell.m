//
//  MarketScrollBlockCell.m
//  HXBusiness
//
//  Created by RyeWhiskey on 16/2/13.
//  Copyright © 2016年 RyeVishkey. All rights reserved.
//

#import "MarketScrollBlockCell.h"
#import "SrcollBlockCell.h"
#import "MarketBlockModel.h"

@interface MarketScrollBlockCell ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>

{
    
    UICollectionView *scrollBlock;
    UIPageControl *page;
    CGRect infoFrame;
    
}

@end

@implementation MarketScrollBlockCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _dataSource = [[NSArray alloc]init];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        scrollBlock = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, infoFrame.size.width, infoFrame.size.height*0.8) collectionViewLayout:flowLayout];
        [self addSubview:scrollBlock];
        scrollBlock.backgroundColor = [UIColor whiteColor];
        scrollBlock.showsHorizontalScrollIndicator = NO;
        scrollBlock.showsVerticalScrollIndicator = NO;
        scrollBlock.pagingEnabled = YES;
        scrollBlock.delegate = self;
        scrollBlock.dataSource = self;
        
        [scrollBlock registerClass:[SrcollBlockCell class] forCellWithReuseIdentifier:@"scroll"];
        
        page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, infoFrame.size.height*0.8, infoFrame.size.width, infoFrame.size.height*0.2)];
        
    }
    
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SrcollBlockCell *scrollCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"scroll" forIndexPath:indexPath];
    MarketBlockModel *mod = _dataSource[indexPath.section];
    scrollCell.nameLabel.text = mod.name;
    scrollCell.indexLabel.text = mod.price;
    scrollCell.upDownLabel.text = [NSString stringWithFormat:@"%@  %@",mod.upDown,mod.upDownRate] ;
    
    if ([mod.upOrDownFlag isEqualToString:@"-"]) {
        scrollCell.backgroundColor = [UIColor colorWithRed:84.0f/255.0f
                                                     green:139.0f/255.0f
                                                      blue:84.0f/255.0f
                                                     alpha:1.0];
    }else {
        scrollCell.backgroundColor = [UIColor redColor];
    }
    
    return scrollCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger crack = 3*(_dataSource.count-_dataSource.count/3)/_dataSource.count;
    if (_dataSource.count < 3) {
        return CGSizeMake(infoFrame.size.width/_dataSource.count-crack, collectionView.frame.size.height);
    }else {
        return CGSizeMake(infoFrame.size.width/3-crack, collectionView.frame.size.height);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section%3 != 0) {
        return UIEdgeInsetsMake(0, 3, 0, 0);
    }else {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    infoFrame = frame;
    scrollBlock.frame = CGRectMake(0, 0, infoFrame.size.width, infoFrame.size.height*0.8);
    page.frame = CGRectMake(0, infoFrame.size.height*0.8, infoFrame.size.width, infoFrame.size.height*0.2);
}

- (void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    
    if (!_dataSource.count/3==0) {
        if (_dataSource.count%3==0) {
            page.numberOfPages = _dataSource.count/3;
        }else {
            page.numberOfPages = _dataSource.count/3+1;
        }
        page.currentPage = 0;
        page.currentPageIndicatorTintColor = [UIColor blackColor];
        page.pageIndicatorTintColor = [UIColor grayColor];
        [self addSubview:page];

    }else {
        [page removeFromSuperview];
    }
    [scrollBlock reloadData];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGPoint pt = scrollView.contentOffset;
    CGFloat w = infoFrame.size.width;
    NSInteger currnet = pt.x / w;
    page.currentPage = currnet;
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
