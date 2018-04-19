//
//  WMMomentImageContainerView.m
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/17.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "WMMomentImageContainerView.h"
#import "WMCommon.h"
#import "WMMomentModel.h"


@interface WMMomentImageContainerView ()

@property (nonatomic, strong) NSArray *imageViewsArray;

@end

@implementation WMMomentImageContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        NSMutableArray *temp = [NSMutableArray new];
        
        for (int i = 0; i < 9; i++) {
            UIImageView *imageView = [UIImageView new];
            [self addSubview:imageView];
            imageView.userInteractionEnabled = YES;
            imageView.tag = i;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.backgroundColor = HEX_RGB(COLOR_BACKGROUND);
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
            [imageView addGestureRecognizer:tap];
            [temp addObject:imageView];
        }
        
        self.imageViewsArray = temp;
    }
    return self;
}

- (void)setPicPathStringsArray:(NSArray *)picPathStringsArray
{
    _picPathStringsArray = picPathStringsArray;
    
    for (long i = _picPathStringsArray.count; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    
    if (_picPathStringsArray.count == 0) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 0, 0);
        return;
    }
    
    CGFloat itemW = [self itemWidthForPicPathArray:_picPathStringsArray];
    CGFloat itemH = 0;
    if (_picPathStringsArray.count == 1) {
        itemH = itemW;
    } else {
        itemH = itemW;
    }
    long perRowItemCount = [self perRowItemCountForPicPathArray:_picPathStringsArray];
    CGFloat margin = 5;
    
    WS(weakSelf);
    [_picPathStringsArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        long columnIndex = idx % perRowItemCount;
        long rowIndex = idx / perRowItemCount;
        UIImageView *imageView = [weakSelf.imageViewsArray objectAtIndex:idx];
        imageView.hidden = NO;
        imageView.image = [UIImage imageNamed:@"AlbumReflashIcon"];
        WMImageModel *imageModel = [weakSelf.picPathStringsArray objectAtIndexSafe:idx];
        [imageView downloadImageWithURL:imageModel.url];
                
        imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
    }];
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(_picPathStringsArray.count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, w, h);
}

#pragma mark - private actions

- (void)tapImageView:(UITapGestureRecognizer *)tap
{

}

- (CGFloat)itemWidthForPicPathArray:(NSArray *)array
{
    if (array.count == 1) {
        return 120;
    } else {
        if (_customImgWidth != 0) {
            return _customImgWidth;
        }else{
            CGFloat w = kScreenWidth > 320 ? 80 : 70;
            return w;
        }
    }
}

- (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array
{
    if (array.count < 4) {
        return array.count;
    } else if (array.count <= 4) {
        return 2;
    } else {
        return 3;
    }
}

+ (CGSize)getContainerSizeWithPicPathStringsArray:(NSArray *)picPathStringsArray
{
    CGFloat itemW = picPathStringsArray.count == 1 ? 120 : 80;
    CGFloat itemH = 0;
    if (picPathStringsArray.count == 1) {
        itemH = itemW;
    } else {
        itemH = itemW;
    }
    long perRowItemCount;
    if (picPathStringsArray.count < 4) {
        perRowItemCount = picPathStringsArray.count;
    } else if (picPathStringsArray.count == 4) {
        perRowItemCount = 2;
    } else {
        perRowItemCount = 3;
    }
    CGFloat margin = 5;
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(picPathStringsArray.count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
    
    return CGSizeMake(w, h);
}

@end

