//
//  MarketBlockTableViewCell.m
//  HXBusiness
//
//  Created by RyeWhiskey on 16/2/13.
//  Copyright © 2016年 RyeVishkey. All rights reserved.
//

#import "MarketBlockTableViewCell.h"
#import "MarketBlockModel.h"

@interface MarketBlockTableViewCell ()

{
    UILabel *nameLabel0;
    UILabel *nameLabel1;
    UILabel *nameLabel2;
    UILabel *indexLabel0;
    UILabel *indexLabel1;
    UILabel *indexLabel2;
    UILabel *upDownLabel0;
    UILabel *upDownLabel1;
    UILabel *upDownLabel2;
    CGRect infoFrame;
}

@end

@implementation MarketBlockTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _dataSource = [[NSArray alloc]init];
        
        [self obtainNameLabel];
        [self obtainIndexLabel];
        [self obtainupDownLabel];
        
    }
    
    return self;
}

- (void)obtainNameLabel{
    nameLabel0 = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, infoFrame.size.width/3-20,infoFrame.size.height/2)];
    [self addSubview:nameLabel0];
    nameLabel0.font = [UIFont systemFontOfSize:13];
    nameLabel0.textColor = [UIColor blackColor];
    
    nameLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(infoFrame.size.width/3+20, 0, infoFrame.size.width/3-20,infoFrame.size.height/2)];
    [self addSubview:nameLabel1];
    nameLabel1.font = [UIFont systemFontOfSize:13];
    nameLabel1.textColor = [UIColor blackColor];
    
    nameLabel2 = [[UILabel alloc]initWithFrame:CGRectMake( infoFrame.size.width/3*2+20, 0, infoFrame.size.width/3-20,infoFrame.size.height/2)];
    [self addSubview:nameLabel2];
    nameLabel2.font = [UIFont systemFontOfSize:13];
    nameLabel2.textColor = [UIColor blackColor];
}

- (void)obtainIndexLabel{
    indexLabel0 = [[UILabel alloc]initWithFrame:CGRectMake(20, infoFrame.size.height/2, infoFrame.size.width/3-20, infoFrame.size.height/4)];
    [self addSubview:indexLabel0];
    indexLabel0.font = [UIFont systemFontOfSize:18];
    
    indexLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(infoFrame.size.width/3+20, infoFrame.size.height/2, infoFrame.size.width/3-20, infoFrame.size.height/4)];
    [self addSubview:indexLabel1];
    indexLabel1.font = [UIFont systemFontOfSize:18];
    
    indexLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(infoFrame.size.width/3*2+20, infoFrame.size.height/2, infoFrame.size.width/3-20, infoFrame.size.height/4)];
    [self addSubview:indexLabel2];
    indexLabel2.font = [UIFont systemFontOfSize:18];
}

- (void)obtainupDownLabel{
    upDownLabel0 = [[UILabel alloc]initWithFrame:CGRectMake(20, infoFrame.size.height/4*3, infoFrame.size.width/3-20, infoFrame.size.height/7)];
    [self addSubview:upDownLabel0];
    upDownLabel0.font = [UIFont systemFontOfSize:12];
    
    upDownLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(infoFrame.size.width/3+20, infoFrame.size.height/4*3, infoFrame.size.width/3-20, infoFrame.size.height/7)];
    [self addSubview:upDownLabel1];
    upDownLabel1.font = [UIFont systemFontOfSize:12];
    
    upDownLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(infoFrame.size.width/3*2+20, infoFrame.size.height/4*3, infoFrame.size.width/3-20, infoFrame.size.height/7)];
    [self addSubview:upDownLabel2];
    upDownLabel2.font = [UIFont systemFontOfSize:12];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    infoFrame = frame;
    
    nameLabel0.frame = CGRectMake(20, 0, infoFrame.size.width/3-20,infoFrame.size.height/2);
    nameLabel1.frame = CGRectMake(infoFrame.size.width/3+20, 0, infoFrame.size.width/3-20,infoFrame.size.height/2);
    nameLabel2.frame = CGRectMake(infoFrame.size.width/3*2+20, 0, infoFrame.size.width/3-20,infoFrame.size.height/2);
    
    indexLabel0.frame = CGRectMake(20, infoFrame.size.height/2, infoFrame.size.width/3-20, infoFrame.size.height/4);
    indexLabel1.frame = CGRectMake(infoFrame.size.width/3+20, infoFrame.size.height/2, infoFrame.size.width/3-20, infoFrame.size.height/4);
    indexLabel2.frame = CGRectMake(infoFrame.size.width/3*2+20, infoFrame.size.height/2, infoFrame.size.width/3-20, infoFrame.size.height/4);
    
    upDownLabel0.frame = CGRectMake(20, infoFrame.size.height/4*3, infoFrame.size.width/3-20, infoFrame.size.height/7);
    upDownLabel1.frame = CGRectMake(infoFrame.size.width/3+20, infoFrame.size.height/4*3, infoFrame.size.width/3-20, infoFrame.size.height/7);
    upDownLabel2.frame = CGRectMake(infoFrame.size.width/3*2+20, infoFrame.size.height/4*3, infoFrame.size.width/3-20, infoFrame.size.height/7);
}

- (void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    if (_dataSource.count >3) {
        return;
    }
    for (int i = 0 ; i < _dataSource.count; i++) {
        MarketBlockModel *mod = _dataSource[i];
        UILabel *name = [self valueForKey:[NSString stringWithFormat:@"nameLabel%d",i]];
        UILabel *index = [self valueForKey:[NSString stringWithFormat:@"indexLabel%d",i]];
        UILabel *upDown = [self valueForKey:[NSString stringWithFormat:@"upDownLabel%d",i]];
        name.text = mod.name;
        index.text = mod.price;
        upDown.text = mod.upDown;
        
        if ([mod.upOrDownFlag isEqualToString:@"-"]) {
            index.textColor = [UIColor colorWithRed:84.0f/255.0f
                                              green:139.0f/255.0f
                                               blue:84.0f/255.0f
                                              alpha:1.0];
            
            upDown.textColor = [UIColor colorWithRed:84.0f/255.0f
                                               green:139.0f/255.0f
                                                blue:84.0f/255.0f
                                               alpha:1.0];
        }else {
            index.textColor = [UIColor redColor];
            upDown.textColor = [UIColor redColor];
        }
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
