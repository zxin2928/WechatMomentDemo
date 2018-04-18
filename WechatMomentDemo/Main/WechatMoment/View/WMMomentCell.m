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

@interface WMMomentCell ()<MLEmojiLabelDelegate, UITableViewDelegate, UITableViewDataSource>

/**  发布人头像 */
@property (strong, nonatomic) UIImageView *avatarImageView;
/** 发布人昵称 */
@property (strong, nonatomic) UIButton *nicknameButton;
/** 发布文本内容 */
@property (strong, nonatomic) MLEmojiLabel *contentLab;
/** 全文/收起 */
@property (strong, nonatomic) UIButton *moreButton;
/** 图片容器 */
@property (strong, nonatomic) WMMomentImageContainerView *imageContainerView;
/** 底部分割线 */
@property (strong, nonatomic) UIView *bottomlineView;
/** 评论部分 */
@property (strong, nonatomic) WMCommentTableView *commentTable;

@end

@implementation WMMomentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *view = self.contentView;
        view.backgroundColor = HEX_RGB(white);
        
        _avatarImageView = [UIImageView new];
        _avatarImageView.backgroundColor = HEX_RGB(black);
        [view addSubview:_avatarImageView];
        [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(view).offset(10);
            make.top.equalTo(view).offset(6);
            make.width.height.mas_equalTo(40);
        }];
        
        _nicknameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nicknameButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _nicknameButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_nicknameButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [view addSubview:_nicknameButton];
        [_nicknameButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.avatarImageView.mas_trailing).offset(10);
            make.width.mas_lessThanOrEqualTo(kScreenWidth - 15 - 40);
            make.top.equalTo(self.avatarImageView);
            make.height.mas_equalTo(18);
        }];
        
        _contentLab = [MLEmojiLabel new];
        _contentLab.textColor = HEX_RGB(black);
        _contentLab.numberOfLines = 6;
        _contentLab.textAlignment = NSTextAlignmentJustified;
        _contentLab.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
        _contentLab.font = [UIFont systemFontOfSize:14];
        _contentLab.backgroundColor = [UIColor clearColor];
        _contentLab.isNeedAtAndPoundSign = YES;
        _contentLab.delegate = self;
        [view addSubview:_contentLab];
 
        
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_moreButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _moreButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_moreButton addTarget:self action:@selector(clickMoreButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:_moreButton];
        
        _imageContainerView = [[WMMomentImageContainerView alloc]init];
        [view addSubview:_imageContainerView];
        
        _bottomlineView = [UIView new];
        _bottomlineView.backgroundColor = [UIColor lightGrayColor];
        [view addSubview:_bottomlineView];
        [_bottomlineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(view);
            make.height.mas_equalTo(0.5);
        }];
        
        _commentTable = [[WMCommentTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [view addSubview:_commentTable];

        _commentTable.delegate = self;
        _commentTable.dataSource = self;
        _commentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _commentTable.scrollsToTop = NO;
        _commentTable.showsHorizontalScrollIndicator = NO ;
        _commentTable.showsVerticalScrollIndicator = NO ;
        
        if (@available(iOS 11.0, *)) {
            _commentTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _commentTable.estimatedRowHeight = 0;
            _commentTable.estimatedSectionFooterHeight = 0;
            _commentTable.estimatedSectionHeaderHeight = 0;
        }
        _commentTable.scrollIndicatorInsets = _commentTable.contentInset;
    }
    return self;
}

-(void)setModel:(WMMomentModel *)model{
    _model = model;
    
    NSString *nickName = _model.nick ? _model.nick : (_model.username ? _model.username : @"");
    
    [_nicknameButton setTitle:nickName forState:UIControlStateNormal];
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:_model.avatar] placeholderImage:[UIImage imageNamed:@"AlbumReflashIcon"]];

    _contentLab.text = _model.content;
    
    _imageContainerView.imageWidth = _model.imageWidth;
    _imageContainerView.imageHeight = _model.imageHeight;
    _imageContainerView.imageUrls = _model.images;
    _imageContainerView.imageBlock = _imageBlock;
    
    if (_model.isOpening) {
        _contentLab.numberOfLines = 0;
        [_moreButton setTitle:@"收起" forState:UIControlStateNormal];
    }else{
        _contentLab.numberOfLines = 6;
        [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
    }
    
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nicknameButton);
        make.trailing.equalTo(self).offset(-15);
        make.top.equalTo(self.nicknameButton.mas_bottom).offset(8);
    }];
    
    if (_model.isShowMoreButton) {
        [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.avatarImageView.mas_trailing).offset(10);
            make.width.mas_lessThanOrEqualTo(kScreenWidth - 15 - 40);
            make.top.equalTo(self.contentLab.mas_bottom);
            make.height.mas_equalTo(20);
        }];

    }else{
        [_moreButton setTitle:@"" forState:UIControlStateNormal];
        [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.avatarImageView.mas_trailing).offset(10);
            make.width.mas_lessThanOrEqualTo(kScreenWidth - 15 - 40);
            make.top.equalTo(self.contentLab.mas_bottom);
            make.height.mas_equalTo(1);
        }];
    }
    
    [_imageContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nicknameButton);
        make.trailing.equalTo(self).offset(-10);
        make.top.equalTo(self.moreButton.mas_bottom).offset(10);
        make.height.mas_equalTo(self.model.imageContainerHeight);
    }];

    
    [_commentTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageContainerView.mas_bottom);
        make.leading.equalTo(self.nicknameButton);
        make.trailing.equalTo(self).offset(-10);
        make.height.mas_equalTo(self.model.commentHeight);
    }];
    

}

- (void)clickMoreButton:(UIButton*)button{
    if (_model.isOpening) {
        [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
    }else{
        [_moreButton setTitle:@"收起" forState:UIControlStateNormal];
    }
    
    if (self.moreBlock) {
        self.moreBlock(!_model.isOpening);
    }
    
    _model.isOpening = !_model.isOpening;
}

#pragma -mark - MLEmojiLabelDelegate
- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    if (self.linkBlock)
    {
        self.linkBlock();
    }
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
    return _model.comments.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WMCommentModel *commentModel = [self.model.comments objectAtIndexSafe:indexPath.row];
    return commentModel.commentCellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WMCommentModel *commentModel = [self.model.comments objectAtIndexSafe:indexPath.row];
    WMCommentTableViewCell *commentCell = [WMCommentTableViewCell cellWithTableView:tableView identifier:@"WMCommentTableViewCell"];
    commentCell.model = commentModel;
    return commentCell;
}

@end
