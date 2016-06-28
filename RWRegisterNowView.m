//
//  RWRegisterNowView.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/17.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWRegisterNowView.h"
#import "RWLoginTableViewCell.h"
#import <SXColorGradientView.h>

@interface RWRegisterNowView ()

<
    UITableViewDelegate,
    UITableViewDataSource,
    RWButtonCellDelegate
>

@property (nonatomic,assign)id<RWRegisterNowViewDelegate> responceDeleagte;

@end

static NSString *const buttonCell = @"mytableView";

@implementation RWRegisterNowView

+ (instancetype)registerViewWithFrame:(CGRect)frame Delegate:(id)anyObject
{
    RWRegisterNowView *registerView = [[RWRegisterNowView alloc]initWithFrame:frame
                                                                        style:UITableViewStyleGrouped];
    
    registerView.responceDeleagte = anyObject;
    
    return registerView;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    
    if (self)
    {
        [self initSelf];
    }
    
    return self;
}

- (void)initSelf
{
    self.delegate = self;
    
    self.dataSource = self;
    
    self.backgroundView =
            [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.jpg"]];
    
    SXColorGradientView *gradientView = [SXColorGradientView createWithColorArray:
                                         @[[UIColor blackColor],Wonderful_WhiteColor10] frame:
                                         CGRectMake(20, 30,
                                                    self.frame.size.width - 40,
                                                    self.frame.size.height
                                                    * 0.3 + 200)
                                                                        direction:
                                         SXGradientToBottom];
    
    gradientView.alpha = 0.3;
    
    gradientView.layer.cornerRadius = 10;
    
    gradientView.clipsToBounds = YES;
    
    [self.backgroundView addSubview:gradientView];
    
    self.showsVerticalScrollIndicator = NO;
    
    self.showsHorizontalScrollIndicator = NO;
    
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self registerClass:[RWButtonCell class] forCellReuseIdentifier:buttonCell];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:buttonCell forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.title = @"立即登录";
    
    cell.delegate = self;
    
    return cell;
}

- (void)button:(UIButton *)button ClickWithTitle:(NSString *)title
{
    [_responceDeleagte registerView:self Click:button];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.frame.size.height/2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 0)
    {
        UIView *backView = [[UIView alloc]init];
        
        backView.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        
        titleLabel.text = [_responceDeleagte titleWithRegisterView];
        
        titleLabel.numberOfLines = 0;
        
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold"size:18];
        
        titleLabel.textColor = [UIColor whiteColor];
        
        [backView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(backView.mas_left).offset(40);
            make.right.equalTo(backView.mas_right).offset(-40);
            make.top.equalTo(backView.mas_top).offset(self.frame.size.height/ 2-100);
            make.bottom.equalTo(backView.mas_bottom).offset(-20);
        }];
        
        return backView;
    }
    
    return nil;
}

@end
