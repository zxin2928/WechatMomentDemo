//
//  WMCommentView.m
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/19.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "WMCommentView.h"
#import "WMCommon.h"
#import "WMMomentModel.h"
#import "WMMomentLayout.h"
#import "WMMomentCell.h"

#define kPopupTriangleHeigh 5
#define kPopupTriangleWidth 6
#define kPopupTriangleTopPointX 3 * (self.frame.size.width - kPopupTriangleWidth)/20.0f
#define kBorderOffset       0

@interface WMCommentView ()<UITableViewDelegate, UITableViewDataSource>


@end

@implementation WMCommentView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth - kDynamicsNormalPadding * 2 - kDynamicsPortraitNamePadding - kDynamicsPortraitWidthAndHeight;;
        frame.size.height = 0;
    }
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.commentTable];
    }
    return self;
}

- (void)setCommentArr:(NSMutableArray *)commentArr WMMomentLayout:(WMMomentLayout *)layout
{
    self.commentArray = layout.commentLayoutArr;
    _layout = layout;
    if (_commentArray.count != 0) {
        _commentTable.hidden = NO;
        _commentTable.left = 0;
        _commentTable.top = 10;
        _commentTable.width = self.frame.size.width;
        _commentTable.height = _layout.commentHeight;
        
        [_commentTable reloadData];
    }else{
        _commentTable.hidden = YES;
    }
    
}

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
    CGContextSetFillColorWithColor(context, HEX_RGB(COLOR_BACKGROUND).CGColor);
    
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

#pragma mark - TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYTextLayout * layout = self.commentArray[indexPath.row];
    return layout.textBoundingSize.height + kDynamicsGrayPicPadding*2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"commentCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    YYTextLayout * layout = [self.commentArray objectAtIndexSafe:indexPath.row];
    
    YYLabel * label;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        label = [YYLabel new];
        [cell addSubview:label];
    }
    
    label.top = kDynamicsGrayPicPadding;
    label.left = kDynamicsNameDetailPadding;
    label.width = self.frame.size.width - kDynamicsNameDetailPadding*2;
    label.height = layout.textBoundingSize.height;
    label.textLayout = layout;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

-(UITableView *)commentTable
{
    if (!_commentTable) {
        _commentTable = [UITableView new];
        _commentTable.dataSource = self;
        _commentTable.delegate = self;
        _commentTable.scrollEnabled = NO;
        _commentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _commentTable.backgroundColor = [UIColor clearColor];
    }
    return _commentTable;
}

@end
