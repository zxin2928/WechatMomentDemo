//
//  WMMomentHeadView.m
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/17.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "WMMomentHeadView.h"
#import "WMCommon.h"

@interface WMMomentHeadView()

@property (strong, nonatomic) UIImageView *backgroundImageView;

@property (strong, nonatomic) UIImageView *iconImageView;

@property (strong, nonatomic) UILabel *nameLabel;

@end

@implementation WMMomentHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor yellowColor];
        
        _backgroundImageView = [UIImageView new];
        _backgroundImageView.image = [UIImage imageNamed:@"AlbumReflashIcon"];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        WS(weakSelf);
        _iconImageView = [UIImageView new];
        _iconImageView.userInteractionEnabled = YES;
        _iconImageView.image = [UIImage imageNamed:@"AlbumReflashIcon"];
        _iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _iconImageView.layer.borderWidth = 3;
        [_iconImageView setTapActionWithBlock:^{
            weakSelf.iconButtonClick();
        }];
        
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentRight;
        _nameLabel.font = [UIFont boldSystemFontOfSize:15];
        
        [self addSubview:_backgroundImageView];
        [self addSubview:_iconImageView];
        [self addSubview:_nameLabel];
        
        [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(-20);
            make.leading.trailing.equalTo(self);
            make.bottom.equalTo(self).offset(-40);
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


- (void)updateHeight:(CGFloat)height
{
    self.height = height;
    
    if (self.height == 200) {
        _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    }else{
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    [self layoutIfNeeded];
}
@end

