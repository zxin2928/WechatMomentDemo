//
//  WMCommentTableViewCell.m
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/17.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "WMCommentTableViewCell.h"
#import "WMCommon.h"
#import "WMMomentModel.h"

@interface WMCommentTableViewCell ()<MLEmojiLabelDelegate>

@property (strong, nonatomic) MLEmojiLabel *contentLab;

@end

@implementation WMCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *view = self.contentView;
        self.backgroundColor = [UIColor clearColor];
        view.backgroundColor = [UIColor clearColor];
        
        _contentLab = [MLEmojiLabel new];
        _contentLab.textColor = HEX_RGB(black);
        _contentLab.numberOfLines = 0;
        _contentLab.textAlignment = NSTextAlignmentJustified;
        _contentLab.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
        _contentLab.font = [UIFont systemFontOfSize:14];
        _contentLab.backgroundColor = [UIColor clearColor];
        _contentLab.isNeedAtAndPoundSign = YES;
        _contentLab.delegate = self;
        [view addSubview:_contentLab];
        [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.bottom.top.equalTo(view);
            make.leading.equalTo(view).offset(4);
        }];
    }
    return self;
}

-(void)setModel:(WMCommentModel *)model{
    _model = model;    

    
    _contentLab.attributedText = [self generateAttributedStringWithCommentModel:_model];
}

#pragma mark - private method
- (NSMutableAttributedString *)generateAttributedStringWithCommentModel:(WMCommentModel *)model
{
    NSString *nickName = _model.nick ? _model.nick : (_model.username ? _model.username : @"");
    NSString *text = nickName;

    if (nickName) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"：%@", _model.content]];
    }
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor *highLightColor = [UIColor blueColor];
    [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : nickName} range:[text rangeOfString:nickName]];

    return attString;
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
    WMCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[WMCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

@end
