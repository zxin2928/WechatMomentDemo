//
//  WMDiscoverCell.m
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/16.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "WMDiscoverCell.h"
#import "WMCommon.h"

@interface WMDiscoverCell()
@property (strong, nonatomic) UIImageView *momentImageView;
@property (strong, nonatomic) UILabel *titleLab;

@end

@implementation WMDiscoverCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *view = self.contentView;
        
        view.backgroundColor = HEX_RGB(white);
        
        _momentImageView = [UIImageView new];
        _momentImageView.image = [UIImage imageNamed:@"AlbumReflashIcon"];
        [view addSubview:_momentImageView];
        [_momentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(view).offset(14);
            make.width.height.mas_equalTo(40);
            make.centerY.equalTo(view);
        }];
        
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.textColor = HEX_RGB(black);
        _titleLab.numberOfLines = 2;
        [view addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.momentImageView.mas_trailing).offset(14);
            make.trailing.equalTo(view).offset(-10);
            make.centerY.equalTo(view);
            make.height.mas_lessThanOrEqualTo(44);
        }];
    }
    return self;
}

-(void)setModel:(WMDicoverModel *)model{
    _model = model;
    _titleLab.text = _model.title;
}


+(instancetype)cellWithTableView:(UITableView*)tableView identifier:(NSString*)identifier
{
    
    WMDiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[WMDiscoverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

@end
