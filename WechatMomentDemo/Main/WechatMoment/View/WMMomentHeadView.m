//
//  WMMomentHeadView.m
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/17.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "WMMomentHeadView.h"
#import "WMCommon.h"
#import "WMPersonModel.h"

@interface WMMomentHeadView()

@property (strong, nonatomic) UIView *backView;

@property (strong, nonatomic) UIImageView *backgroundImageView;

@property (strong, nonatomic) UIImageView *iconImageView;

@property (strong, nonatomic) UILabel *nameLabel;

@end

@implementation WMMomentHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _backView = [UIView new];
        _backView.backgroundColor = HEX_RGB(COLOR_BACKGROUND);
        [self addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.top.equalTo(self).offset(-40);
            make.bottom.equalTo(self).offset(-25);
        }];
        
        _backgroundImageView = [UIImageView new];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        WS(weakSelf);
        _iconImageView = [UIImageView new];
        _iconImageView.userInteractionEnabled = YES;
        _iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _iconImageView.layer.borderWidth = 3;
        [_iconImageView setTapActionWithBlock:^{
            weakSelf.iconButtonClick();
        }];
        
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentRight;
        _nameLabel.font = [UIFont boldSystemFontOfSize:15];
        
        [_backView addSubview:_backgroundImageView];
        [self addSubview:_iconImageView];
        [self addSubview:_nameLabel];
        
        [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backView).offset(0);
            make.leading.trailing.equalTo(self.backView);
            make.bottom.equalTo(self.backView);
        }];
        
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70, 70));
            make.right.equalTo(self.mas_right).offset(-15);
            make.bottom.equalTo(self);
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.iconImageView.mas_left).offset(-15);
            make.centerY.equalTo(self.iconImageView);
        }];
    }
    return self;
}

-(void)setModel:(WMPersonModel *)model{
    _model = model;
    [_backgroundImageView sd_setImageWithURL:[NSURL URLWithString:_model.profileImage] placeholderImage:[UIImage imageNamed:@"AlbumReflashIcon"]];
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.avatar] placeholderImage:[UIImage imageNamed:@"AlbumReflashIcon"]];


}

@end

