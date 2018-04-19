//
//  WMMomentCell.m
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/17.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "WMMomentCell.h"
#import "WMCommon.h"
#import "WMMomentImageContainerView.h"
#import "WMMomentModel.h"
#import "WMCommentTableView.h"
#import "WMCommentTableViewCell.h"
#import "WMMomentLayout.h"

@interface WMMomentCell ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIImageView * portrait;
@property (strong, nonatomic) YYLabel * nameLabel;
@property (strong, nonatomic) YYLabel * contentLabel;
@property (strong, nonatomic) UIButton * moreLessDetailBtn;
@property (strong, nonatomic) WMMomentImageContainerView *picContainerView;

@property (strong, nonatomic) UIView *bottomLineView;
@end

@implementation WMMomentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *view = self.contentView;
        view.backgroundColor = HEX_RGB(white);
        
        [view addSubview:self.portrait];
        [view addSubview:self.nameLabel];
        [view addSubview:self.contentLabel];
        [view addSubview:self.moreLessDetailBtn];
        [view addSubview:self.picContainerView];
        [view addSubview:self.bottomLineView];

    }
    return self;
}

-(void)setLayout:(WMMomentLayout *)layout
{
    UIView * lastView;
    _layout = layout;
    WMMomentModel * model = layout.model;
    
    //头像
    _portrait.left = kDynamicsNormalPadding;
    _portrait.top = kDynamicsNormalPadding;
    _portrait.size = CGSizeMake(kDynamicsPortraitWidthAndHeight, kDynamicsPortraitWidthAndHeight);
    [_portrait sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    
    //昵称
    _nameLabel.text = model.nick;
    _nameLabel.top = kDynamicsNormalPadding;
    _nameLabel.left = _portrait.right + kDynamicsPortraitNamePadding;
    CGSize nameSize = [_nameLabel sizeThatFits:CGSizeZero];
    _nameLabel.width = nameSize.width;
    _nameLabel.height = kDynamicsNameHeight;
    
    
    //动态
    _contentLabel.left = _nameLabel.left;
    _contentLabel.top = _nameLabel.bottom + kDynamicsNameDetailPadding;
    _contentLabel.width = kScreenWidth - kDynamicsNormalPadding * 2 - kDynamicsPortraitNamePadding - kDynamicsPortraitWidthAndHeight;
    _contentLabel.height = layout.detailLayout.textBoundingSize.height;
    _contentLabel.textLayout = layout.detailLayout;
    lastView = _contentLabel;
    
    //展开/收起按钮
    _moreLessDetailBtn.left = _nameLabel.left;
    _moreLessDetailBtn.top = _contentLabel.bottom + kDynamicsNameDetailPadding;
    _moreLessDetailBtn.height = kDynamicsMoreLessButtonHeight;
    [_moreLessDetailBtn sizeToFit];
    
    if (model.shouldShowMoreButton) {
        _moreLessDetailBtn.hidden = NO;
        
        if (model.isOpening) {
            [_moreLessDetailBtn setTitle:@"收起" forState:UIControlStateNormal];
        }else{
            [_moreLessDetailBtn setTitle:@"全文" forState:UIControlStateNormal];
        }
        
        lastView = _moreLessDetailBtn;
    }else{
        _moreLessDetailBtn.hidden = YES;
    }
    //图片集
    if (model.images.count != 0) {
        _picContainerView.hidden = NO;
        
        _picContainerView.left = _nameLabel.left;
        _picContainerView.top = lastView.bottom + kDynamicsNameDetailPadding;
        _picContainerView.width = layout.photoContainerSize.width;
        _picContainerView.height = layout.photoContainerSize.height;
        _picContainerView.picPathStringsArray = model.images;
        
        lastView = _picContainerView;
    }else{
        _picContainerView.hidden = YES;
    }
    
}

-(void)clickMorelessDetailButton:(UIButton*)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(DidClickMoreLessInDynamicsCell:)]) {
        [self.delegate DidClickMoreLessInDynamicsCell:self];
    }
}

#pragma mark - getter
-(UIImageView *)portrait
{
    if(!_portrait){
        _portrait = [UIImageView new];
        _portrait.userInteractionEnabled = YES;
        _portrait.backgroundColor = [UIColor grayColor];
    }
    return _portrait;
}

-(YYLabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [YYLabel new];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = [UIColor blueColor];
    }
    return _nameLabel;
}

-(YYLabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [YYLabel new];
        _contentLabel.textAlignment = NSTextAlignmentJustified;

    }
    return _contentLabel;
}
-(UIButton *)moreLessDetailBtn
{
    if (!_moreLessDetailBtn) {
        _moreLessDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreLessDetailBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_moreLessDetailBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _moreLessDetailBtn.hidden = YES;
        [_moreLessDetailBtn addTarget:self action:@selector(clickMorelessDetailButton:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _moreLessDetailBtn;
}
-(WMMomentImageContainerView *)picContainerView
{
    if (!_picContainerView) {
        _picContainerView = [WMMomentImageContainerView new];
        _picContainerView.hidden = YES;
    }
    return _picContainerView;
}

-(UIView *)bottomLineView{
    if (_bottomLineView == nil) {
        _bottomLineView = [UIView new];
        _bottomLineView.backgroundColor = [UIColor lightGrayColor];
        _bottomLineView.alpha = 0.3;
    }
    return _bottomLineView;
}

+(instancetype)cellWithTableView:(UITableView*)tableView identifier:(NSString*)identifier
{
    WMMomentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[WMMomentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

#pragma -mark - UITableViewDelegate and UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _layout.model.comments.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WMCommentModel *commentModel = [self.layout.model.comments objectAtIndexSafe:indexPath.row];
    WMCommentTableViewCell *commentCell = [WMCommentTableViewCell cellWithTableView:tableView identifier:@"WMCommentTableViewCell"];
    commentCell.model = commentModel;
    return commentCell;
}

@end
