//
//  WMMomentLayout.m
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/19.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "WMMomentLayout.h"
#import "WMMomentModel.h"
#import "WMMomentImageContainerView.h"

@implementation WMMomentLayout
- (instancetype)initWithModel:(WMMomentModel *)model
{
    self = [super init];
    if (self) {
        _model = model;
        [self resetLayout];
    }
    return self;
}

- (void)resetLayout
{
    _height = 0;
    
    [self.commentLayoutArr removeAllObjects];
    
    _height += kDynamicsNormalPadding;
    _height += kDynamicsNameHeight;
    _height += kDynamicsNameDetailPadding;
    
    [self layoutDetail];
    _height += _detailLayout.textBoundingSize.height;
    
    if (_model.shouldShowMoreButton) {
        _height += kDynamicsNameDetailPadding;
        _height += kDynamicsMoreLessButtonHeight;
    }
    if (_model.images.count != 0) {
        [self layoutPicture];
        _height += kDynamicsNameDetailPadding;
        _height += _photoContainerSize.height;
    }
    
    _height += kDynamicsPortraitNamePadding;
    _height += kDynamicsNameHeight;
    _height += kDynamicsPortraitNamePadding;
    
    if (_model.comments.count != 0) {
        [self layoutComment];
    }
    _height += _commentHeight;
    
}

- (void)layoutDetail
{
    _detailLayout = nil;
    
    NSMutableAttributedString * text = [[NSMutableAttributedString alloc] initWithString:_model.content];
    text.font = [UIFont systemFontOfSize:14];
    text.lineSpacing = kDynamicsLineSpacing;
    
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber | NSTextCheckingTypeLink error:nil];
    
    WS(weakSelf);
    [detector enumerateMatchesInString:_model.content
                               options:kNilOptions
                                 range:text.rangeOfAll
                            usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                
            if (result.URL) {
                YYTextHighlight * highLight = [YYTextHighlight new];
                [text setColor:[UIColor colorWithRed:69/255.0 green:88/255.0 blue:133/255.0 alpha:1] range:result.range];
                highLight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    if (weakSelf.clickUrlBlock) {
                        weakSelf.clickUrlBlock([text.string substringWithRange:range]);
                    }
                };
                [text setTextHighlight:highLight range:result.range];
            }
            if (result.phoneNumber) {
                YYTextHighlight * highLight = [YYTextHighlight new];
                [text setColor:[UIColor colorWithRed:69/255.0 green:88/255.0 blue:133/255.0 alpha:1] range:result.range];
                highLight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    if (weakSelf.clickPhoneNumBlock) {
                        weakSelf.clickPhoneNumBlock([text.string substringWithRange:range]);
                    }
                };
                [text setTextHighlight:highLight range:result.range];
            }
    }];
    
    NSInteger lineCount = 6;
    YYTextContainer * container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth - kDynamicsNormalPadding - kDynamicsPortraitWidthAndHeight - kDynamicsPortraitNamePadding - kDynamicsNormalPadding, _model.isOpening ? CGFLOAT_MAX : 16 * lineCount + kDynamicsLineSpacing * (lineCount - 1))];
    
    container.truncationType = YYTextTruncationTypeEnd;
    
    _detailLayout = [YYTextLayout layoutWithContainer:container text:text];
    
}
- (void)layoutPicture
{
    self.photoContainerSize = CGSizeZero;
    self.photoContainerSize = [WMMomentImageContainerView getContainerSizeWithPicPathStringsArray:_model.images];
}

- (void)layoutComment
{
    _commentHeight = 10;
    
    for (int i = 0; i < _model.comments.count; i++) {
        WMCommentModel * model = _model.comments[i];
        
        NSMutableAttributedString * text = [[NSMutableAttributedString alloc] init];
        
        NSMutableAttributedString * nick = [[NSMutableAttributedString alloc] initWithString:model.nick];
        nick.font = [UIFont boldSystemFontOfSize:13];
        YYTextHighlight * highLight = [YYTextHighlight new];
        [nick setColor:[UIColor colorWithRed:69/255.0 green:88/255.0 blue:133/255.0 alpha:1] range:nick.rangeOfAll];
        WS(weakSelf);
        highLight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        };
        [nick setTextHighlight:highLight range:nick.rangeOfAll];
        [text appendAttributedString:nick];
        
        NSMutableAttributedString * fhText = [[NSMutableAttributedString alloc] initWithString:@"："];
        fhText.font = [UIFont systemFontOfSize:13];
        [text appendAttributedString:fhText];
        NSMutableAttributedString * message = [[NSMutableAttributedString alloc] initWithString:model.content];
        message.font = [UIFont systemFontOfSize:13];
        [text appendAttributedString:message];
        
        //添加网址电话识别
        NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber | NSTextCheckingTypeLink error:nil];
        [detector enumerateMatchesInString:text.string
                                   options:kNilOptions
                                     range:text.rangeOfAll
                                usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                    
                                    if (result.URL) {
                                        YYTextHighlight * highLight = [YYTextHighlight new];
                                        [text setColor:[UIColor colorWithRed:69/255.0 green:88/255.0 blue:133/255.0 alpha:1] range:result.range];
                                        highLight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                                            if (weakSelf.clickUrlBlock) {
                                                weakSelf.clickUrlBlock([text.string substringWithRange:range]);
                                            }
                                        };
                                        [text setTextHighlight:highLight range:result.range];
                                    }
                                    if (result.phoneNumber) {
                                        YYTextHighlight * highLight = [YYTextHighlight new];
                                        [text setColor:[UIColor colorWithRed:69/255.0 green:88/255.0 blue:133/255.0 alpha:1] range:result.range];
                                        highLight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                                            if (weakSelf.clickPhoneNumBlock) {
                                                weakSelf.clickPhoneNumBlock([text.string substringWithRange:range]);
                                            }
                                        };
                                        [text setTextHighlight:highLight range:result.range];
                                    }
                                }];
        
        YYTextContainer * container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth - kDynamicsNormalPadding - kDynamicsPortraitWidthAndHeight - kDynamicsPortraitNamePadding - kDynamicsNameDetailPadding*2 - kDynamicsNormalPadding,CGFLOAT_MAX)];
        
        YYTextLayout * layout = [YYTextLayout layoutWithContainer:container text:text];
        _commentHeight += kDynamicsGrayPicPadding;//评论文字上边距
        _commentHeight += layout.textBoundingSize.height;//评论文字高度
        _commentHeight += kDynamicsGrayPicPadding;//评论文字下边距
        [self.commentLayoutArr addObject:layout];
        
    }
    
}

-(NSMutableArray *)commentLayoutArr
{
    if (!_commentLayoutArr) {
        _commentLayoutArr = [NSMutableArray array];
    }
    return _commentLayoutArr;
}

@end
