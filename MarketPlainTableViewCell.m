//
//  MarketPlainTableViewCell.m
//  HXBusiness
//
//  Created by RyeWhiskey on 16/2/13.
//  Copyright © 2016年 RyeVishkey. All rights reserved.
//

#import "MarketPlainTableViewCell.h"

@interface MarketPlainTableViewCell ()

{
    
    UILabel *nameLabel;
    UILabel *codeLabel;
    UILabel *priceLabel;
    UILabel *upDownLabel;
    CGRect infoFrame;
}

@end

@implementation MarketPlainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _dataSource = [[MarketBlockModel alloc]init];
        
        CGFloat y = infoFrame.size.height*0.1;
        CGFloat h = infoFrame.size.height*0.8;
        CGFloat w = infoFrame.size.width*0.2;
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, y, w, h*0.6)];
        [self addSubview:nameLabel];
        
        codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, y+h*0.6, w, h*0.4)];
        [self addSubview:codeLabel];
        codeLabel.textColor = [UIColor grayColor];
        codeLabel.font = [UIFont systemFontOfSize:12];
        
        priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(infoFrame.size.width/2-w/2, y, w, h)];
        [self addSubview:priceLabel];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        
        upDownLabel = [[UILabel alloc]initWithFrame:CGRectMake(infoFrame.size.width-20-w, y, w, h)];
        [self addSubview:upDownLabel];
        upDownLabel.textColor = [UIColor whiteColor];
        upDownLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    infoFrame = frame;
    CGFloat y = infoFrame.size.height*0.1;
    CGFloat h = infoFrame.size.height*0.8;
    CGFloat w = infoFrame.size.width*0.2;
    nameLabel.frame = CGRectMake(15, y, w, h*0.6);
    codeLabel.frame = CGRectMake(15, y+h*0.6, w, h*0.4);
    priceLabel.frame = CGRectMake(infoFrame.size.width/2-w/2, y, w, h);
    upDownLabel.frame = CGRectMake(infoFrame.size.width-20-w, y, w, h);
}

- (void)setDataSource:(MarketBlockModel *)dataSource{
    _dataSource = dataSource;

    nameLabel.text = _dataSource.name;
    codeLabel.text = _dataSource.code;
    priceLabel.text = _dataSource.price;
    upDownLabel.text = _dataSource.upDown;
    
    if ([_dataSource.upOrDownFlag isEqualToString:@"-"]) {
        priceLabel.textColor = [UIColor colorWithRed:84.0f/255.0f
                                               green:139.0f/255.0f
                                                blue:84.0f/255.0f
                                               alpha:1.0];
        
        upDownLabel.backgroundColor = [UIColor colorWithRed:84.0f/255.0f
                                                      green:139.0f/255.0f
                                                       blue:84.0f/255.0f
                                                      alpha:1.0];
    }else {
        priceLabel.textColor = [UIColor redColor];
        upDownLabel.backgroundColor = [UIColor redColor];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
