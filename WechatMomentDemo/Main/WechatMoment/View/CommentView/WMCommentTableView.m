//
//  WMCommentTableView.m
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/17.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "WMCommentTableView.h"
#import "WMCommon.h"

#define kPopupTriangleHeigh 5
#define kPopupTriangleWidth 6
#define kPopupTriangleTopPointX 3 * (self.frame.size.width - kPopupTriangleWidth)/20.0f
#define kBorderOffset       0

@implementation WMCommentTableView

-(void)drawRect:(CGRect)rect{
    CGFloat viewW = rect.size.width;
    CGFloat viewH = rect.size.height;
    
    CGFloat strokeWidth = 0.2;
    CGFloat borderRadius = 5;
    CGFloat offset = strokeWidth + kBorderOffset;
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetLineJoin(context,kCGLineJoinRound); 
    CGContextSetLineWidth(context, strokeWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetFillColorWithColor(context, HEX_RGB(COLOR_BACKGROUND).CGColor);// 设置填充颜色
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, borderRadius+offset,kPopupTriangleHeigh + offset);
    CGContextAddLineToPoint(context,kPopupTriangleTopPointX - kPopupTriangleWidth /2.0 + offset,kPopupTriangleHeigh + offset);
    CGContextAddLineToPoint(context, kPopupTriangleTopPointX, offset);
    CGContextAddLineToPoint(context,kPopupTriangleTopPointX + kPopupTriangleWidth /2.0 +offset,kPopupTriangleHeigh+offset);
    
    CGContextAddArcToPoint(context, viewW-offset,kPopupTriangleHeigh+offset, viewW-offset, kPopupTriangleHeigh+offset + borderRadius, borderRadius-strokeWidth);
    CGContextAddArcToPoint(context, viewW-offset, viewH - offset, viewW-borderRadius-offset, viewH - offset, borderRadius-strokeWidth);
    CGContextAddArcToPoint(context, offset, viewH - offset, offset, viewH - borderRadius - offset, borderRadius-strokeWidth);
    CGContextAddArcToPoint(context, offset, kPopupTriangleHeigh + offset, viewW - borderRadius - offset, kPopupTriangleHeigh + offset, borderRadius-strokeWidth);
    CGContextClosePath(context);
    CGContextDrawPath(context,kCGPathFillStroke);
}

@end
