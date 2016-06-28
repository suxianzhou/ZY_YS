//
//  RWSubjectCarouselCell.m
//  ZhongYuSubjectHubKY
//
//  Created by RyeWhiskey on 16/4/27.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWSubjectCarouselCell.h"
#import "RWCarouselImageCell.h"

@interface RWSubjectCarouselCell ()

<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

{
    
    NSTimer *timer;
    
}

@property (nonatomic,strong)UICollectionView *carouseImage;

@property (nonatomic,strong)UIPageControl *imagePageBar;

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UIView *backView;

@property (nonatomic,strong)NSIndexPath *faceIndexPath;

@end

static NSString *const carouselCell = @"carouselCell";

@implementation RWSubjectCarouselCell

@synthesize carouseImage;
@synthesize imagePageBar;
@synthesize titleLabel;
@synthesize backView;
@synthesize faceIndexPath;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
       
        [self initDatas];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame: frame];
    
    if (frame.size.height == [[UIScreen mainScreen] bounds].size.width * 0.55)
    {
        if (!carouseImage)
        {
            [self initViews];
        }
        
        [self autoLayoutViews];
    }
    
}


- (void)autoLayoutViews {
    
    CGFloat h = self.frame.size.height / 6 * 5;
    
    backView.frame = CGRectMake(0, h, self.frame.size.width, self.frame.size.height - h);
}

- (void)setImages:(NSArray<UIImage *> *)images {
    
    _images = images;
    
    if (_images.count == _titles.count) {
        
        [self compositionPageAndTitles];
        
        [carouseImage reloadData];
        
        if (_images.count > 1)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [carouseImage scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        else if(_images.count == 1)
        {
            imagePageBar.currentPage = 0;
            imagePageBar.currentPageIndicatorTintColor = [UIColor whiteColor];
        }
        

    }
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    
    _titles = titles;
    
    if (_titles.count == _images.count) {
        
        [self compositionPageAndTitles];
        
        [carouseImage reloadData];
        
        if (_images.count > 1)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            
            [carouseImage scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        else if(_images.count == 1)
        {
            imagePageBar.currentPage = 0;
            imagePageBar.currentPageIndicatorTintColor = [UIColor whiteColor];
        }

    }
}

- (void)compositionPageAndTitles {
    
    CGFloat h = self.frame.size.height / 6 * 5;
    
    CGFloat w = 20 * _images.count;
    
    imagePageBar.frame = CGRectMake(self.frame.size.width - w - 20, h, w, self.frame.size.height - h);
    
    imagePageBar.numberOfPages = _images.count;
    imagePageBar.currentPage = 0;
    
    if (imagePageBar.numberOfPages > 1)
    {
        imagePageBar.currentPageIndicatorTintColor = [UIColor blackColor];
    }
    
    imagePageBar.pageIndicatorTintColor = [UIColor whiteColor];
    
    titleLabel.frame = CGRectMake(20, h, imagePageBar.frame.origin.x - 30, self.frame.size.height - h);
}

#pragma mark - Lazy Loading

- (void)initDatas {
    
    _images = [[NSArray alloc] init];
    _titles = [[NSArray alloc] init];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(carouse) userInfo:nil repeats:YES];
    
    [timer setFireDate:[NSDate distantFuture]];
    
    _isStartCarouse = NO;
}

- (void)carouseStart
{
    if (_images.count > 1)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        
        [carouseImage scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        
        [timer setFireDate:[NSDate distantPast]];
        
        _isStartCarouse = YES;
    }
    
    
}

- (void)carouseStop
{
    [timer setFireDate:[NSDate distantFuture]];
    
    if (_images.count > 1)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [carouseImage scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        
        imagePageBar.currentPage = 0;
    }
    else if(_images.count == 1)
    {
        imagePageBar.currentPage = 0;
        imagePageBar.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    
    _isStartCarouse = NO;
}

- (void)carouse {
    
    if (faceIndexPath) {
        
        if (faceIndexPath.row == _images.count ) {
            
            NSIndexPath *toIndexPath = [NSIndexPath indexPathForItem:faceIndexPath.row + 1 inSection:0];
            
            [carouseImage scrollToItemAtIndexPath:toIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            
            titleLabel.text = _titles[0];
            imagePageBar.currentPage = 0;
            
        }else {
         
            NSIndexPath *toIndexPath = [NSIndexPath indexPathForItem:faceIndexPath.row + 1 inSection:0];
            
            [carouseImage scrollToItemAtIndexPath:toIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            
            imagePageBar.currentPage += 1;
        }
    }
}

- (void)initViews {
    
    carouseImage = [self collectionView];

    backView     = [self view];

    imagePageBar = [self pageControl];

    titleLabel   = [self label];
    
    if (_images.count > 1)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [carouseImage scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    else if(_images.count == 1)
    {
        imagePageBar.currentPage = 0;
        imagePageBar.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
}

- (UIPageControl *)pageControl {
    
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    
    [self addSubview:pageControl];
    
    return pageControl;
}

- (UILabel *)label {
    
    UILabel *label = [[UILabel alloc]init];
    
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    
    [self addSubview:label];
    
    return label;
}

- (UIView *)view {
    
    UIView *view = [[UIView alloc]init];
    
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    
    [self addSubview:view];
    
    return view;
}

- (UICollectionView *)collectionView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:
                                        CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                                                         collectionViewLayout:
                                                                            flowLayout];
    
    collectionView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:collectionView];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    collectionView.bounces = NO;
    
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    
    collectionView.pagingEnabled = YES;
    
    [collectionView registerClass:[RWCarouselImageCell class] forCellWithReuseIdentifier:carouselCell];
    
    return collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (_images.count > 1)
    {
        return _images.count + 2;
    }
    else
    {
        return _images.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RWCarouselImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:carouselCell forIndexPath:indexPath];
    
    if (_images.count > 1)
    {
        if (indexPath.row == 0)
        {
            cell.image = [_images lastObject];
            titleLabel.text = [_titles lastObject];
        }
        else if(indexPath.row == _images.count+1)
        {
            cell.image = _images[0];
            titleLabel.text = _titles[0];
        }
        else
        {
            cell.image = _images[indexPath.row - 1];
            titleLabel.text = _titles[indexPath.row - 1];
        }
    }
    else if (_images.count == 1)
    {
        cell.image = _images[indexPath.row];
        titleLabel.text = _titles[indexPath.row];
    }
    
    faceIndexPath = indexPath;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.frame.size.width, self.frame.size.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGPoint pt = scrollView.contentOffset;
    CGFloat w = self.frame.size.width;
    NSInteger currnet = pt.x / w;
    
    if (currnet == _images.count+1)
    {
        imagePageBar.currentPage = 0;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [carouseImage scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    else if(currnet == 0)
    {
        imagePageBar.currentPage = _images.count - 1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_images.count inSection:0];
        [carouseImage scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    else
    {
        imagePageBar.currentPage = currnet-1;
        titleLabel.text = _titles[currnet-1];
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _images.count
        && faceIndexPath.row == _images.count + 1
        && _images.count > 1) {
        
        [carouseImage scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_images.count > 1 && indexPath.row != 0 && indexPath.row != _images.count +1)
    {
        [self.delegate carousel:self DidSelectWithIndex:indexPath.row - 1];
    }
    else if (_images.count == 1)
    {
        [self.delegate carousel:self DidSelectWithIndex:indexPath.row];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
