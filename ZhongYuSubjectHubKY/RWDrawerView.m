//
//  RWDrawerView.m
//  NetworkTest
//
//  Created by RyeWhiskey on 16/2/21.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWDrawerView.h"

@interface RWDrawerView ()

<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (nonatomic,strong)UIView *topView;

@property (nonatomic,strong)UITableView *menuBar;

@end

static NSString *const menuCell = @"menuCell";

@implementation RWDrawerView

@synthesize topView;
@synthesize menuBar;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        if (!topView)
        {
            topView = [[UIView alloc]init];
            
            [self compositionMenuBar];
        }
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (!topView)
    {
        topView = [[UIView alloc]init];
        
        [self compositionMenuBar];
    }
    
    menuBar.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    [menuBar reloadData];
}

- (void)compositionMenuBar
{
    menuBar = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)
                                          style:UITableViewStylePlain];
    
    [self addSubview:menuBar];
    
    menuBar.backgroundColor = [UIColor clearColor];
    
    menuBar.showsHorizontalScrollIndicator = NO;
    menuBar.showsVerticalScrollIndicator = NO;
    
    menuBar.bounces = NO;
    
    menuBar.delegate = self;
    menuBar.dataSource = self;
    
    [menuBar registerClass:[UITableViewCell class] forCellReuseIdentifier:menuCell];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.delegate numberOfRowsInMenuBar:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCell forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.textLabel.text = [self.delegate menuBar:self StringForRow:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.delegate menuBar:self heightForRow:indexPath.row];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.frame.size.height - 50 * 5 - 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *clearView = [[UIView alloc]init];
    
    clearView.backgroundColor = [UIColor clearColor];
    
    return clearView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc]init];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:
                                        CGRectMake(20, 60,self.frame.size.width-40, 40)];
    
    textLabel.textColor = [UIColor whiteColor];
    
    textLabel.text = @"电话：4008-355-366";
    
    textLabel.textAlignment = NSTextAlignmentRight;
    
    textLabel.font = [UIFont systemFontOfSize:14];
    
    [footer addSubview:textLabel];
    
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate menuBar:self didSelectRow:indexPath.row];
}

- (void)setAddTopView:(BOOL)addTopView
{
    _addTopView = addTopView;
    
    if (_addTopView)
    {
        [self addSubview:topView];
        
        topView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/4);
        menuBar.frame = CGRectMake(0,  self.frame.size.height/4, self.frame.size.width, self.frame.size.height/4*3);
        
    }
    else
    {
        
        [topView removeFromSuperview];
        
        menuBar.frame = CGRectMake(0,  0, self.frame.size.width, self.frame.size.height);
    }
    
    [menuBar reloadData];
}

- (void)addViewForTopView:(UIView __kindof*)view
{
    [topView addSubview:view];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    
    menuBar.backgroundView = [[UIImageView alloc] initWithImage:_backgroundImage];
}

- (void)reloadData
{
    [menuBar reloadData];
}


@end
