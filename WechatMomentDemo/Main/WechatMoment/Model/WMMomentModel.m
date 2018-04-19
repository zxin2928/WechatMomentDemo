//
//  WMMomentModel.m
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/16.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "WMMomentModel.h"
#import "WMCommon.h"

@implementation WMSenderModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"WMSenderModel找不到Key----------------------------%@",key);
}
@end

@implementation WMImageModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"WMImageModel找不到Key----------------------------%@",key);
}

@end

@implementation WMCommentModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"WMCommentModel找不到Key----------------------------%@",key);
}

@end

@implementation WMMomentModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"WMMomentModel找不到Key----------------------------%@",key);
}

-(BOOL)isEqual:(id)object{
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[WMMomentModel class]]) {
        return NO;
    }
    
    WMMomentModel *model = (WMMomentModel *)object;
    if (model.momentId == self.momentId) {
        return YES;
    } else {
        return NO;
    }
}

-(NSString *)content
{
    if (_content == nil) {
        _content = @"";
    }
    NSMutableAttributedString * text = [[NSMutableAttributedString alloc] initWithString:_content];
    text.font = [UIFont systemFontOfSize:14];
    
    YYTextContainer * container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth - 15 - 45 - 10 - 15, CGFLOAT_MAX)];
    
    YYTextLayout * layout = [YYTextLayout layoutWithContainer:container text:text];
    
    if (layout.rowCount <= 6) {
        _shouldShowMoreButton = NO;
    }else{
        _shouldShowMoreButton = YES;
    }
    
    return _content;
}
- (void)setIsOpening:(BOOL)isOpening
{
    if (!_shouldShowMoreButton) {
        _isOpening = NO;
    } else {
        _isOpening = isOpening;
    }
}

@end

