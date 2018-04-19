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

@implementation WMMomentImageContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _imageViews = [NSMutableArray array];
    }
    return self;
}

- (void)setImageUrls:(NSArray *)imageUrls
{
    _imageUrls = imageUrls;
    [self removeAllSubviews];
    [_imageViews removeAllObjects];
    CGRect frame;
    for (int i = 0; i < imageUrls.count; i ++)
    {
        if (self.imageUrls.count == 4)
        {
            frame = CGRectMake((self.imageWidth + 5 ) * (i % 2), (self.imageHeight + 5) * (i / 2 ), self.imageWidth, self.imageHeight);
        }
        else
        {
            frame = CGRectMake((self.imageWidth + 5 ) * (i % 3), (self.imageHeight + 5) * (i / 3 ), self.imageWidth, self.imageHeight);
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = [UIImage imageNamed:@"AlbumReflashIcon"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.tag = i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)];
        [imageView addGestureRecognizer:tap];
        
        [self addSubview:imageView];
        
        WMImageModel *imageModel = [imageUrls objectAtIndexSafe:i];
        NSString *urlStr = imageModel.url;;
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"AlbumReflashIcon"]];

        
        [_imageViews addObject:imageView];
    }
}

- (void)clickImageView:(UITapGestureRecognizer *)tap
{
    if (self.imageBlock)
    {
        self.imageBlock(self.imageViews, tap.view.tag);
    }
}


@end
