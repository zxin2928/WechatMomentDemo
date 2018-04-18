//
//  WMMomentViewController.m
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/16.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "WMMomentViewController.h"
#import "WMMomentCell.h"
#import "WMMomentModel.h"
#import "WMMomentRefreshView.h"
#import "WMMomentHeadView.h"

@interface WMMomentViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *momentTable;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (nonatomic, weak) WMMomentHeadView *headerView;

@end

@implementation WMMomentViewController
{
    WMMomentRefreshView *_refreshHeader;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"朋友圈";
    // Do any additional setup after loading the view.
    [self addLeftBarButtonItemWithType:WMNavigationBarType_BACK];
    [self addRightBarButtonItemWithType:WMNavigationBarType_CAPTURE];
    
    self.dataArray = [NSMutableArray array];
    
    [self firstAppear];
}

- (void)firstAppear{
    [[WMRequestManager sharedManager]getMomentInfoWithKey:MOMENT_FIRST delegate:self];
}

- (void)footerRefreshing
{
    
}

#pragma mark - setupHeadView
- (void)setupHeadView
{
    WS(weakSelf);
    WMMomentHeadView *headerView = [[WMMomentHeadView alloc] init];
    headerView.frame = CGRectMake(0, 0, kScreenWidth, 260);
    [headerView setIconButtonClick:^{

    }];
    self.headerView = headerView;
    self.momentTable.tableHeaderView = headerView;
}

#pragma -mark private method


#pragma -mark - WMRequestDelegate
-(void)requestSuccess:(WMRequest *)request data:(id)data url:(NSString *)url{
    NSMutableArray *datas = [WMModelClass momentListWithData:data];
    [self.dataArray addObjectsFromArray:datas];
    
    if ([request.key isEqualToString:MOMENT_FIRST]) {
        if (!_refreshHeader.superview) {
            
            _refreshHeader = [WMMomentRefreshView refreshHeaderWithCenter:CGPointMake(40, -15)];
            _refreshHeader.scrollView = self.momentTable;
            WS(weakSelf);
            __weak typeof(_refreshHeader) weakHeader = _refreshHeader;
            [_refreshHeader setRefreshingBlock:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakHeader endRefreshing];
                });
            }];
            [self.momentTable.superview addSubview:_refreshHeader];
        } else {
            [self.momentTable.superview bringSubviewToFront:_refreshHeader];
        }
    }
    [self setupHeadView];
    [self addFooterRefreshWithView:self.momentTable];
    [self.momentTable reloadData];
}

-(void)requestFail:(WMRequest *)request error:(NSError *)error url:(NSString *)url{
    
}

#pragma -mark - UITableViewDelegate and UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WMMomentModel *momentModel = [self.dataArray objectAtIndexSafe:indexPath.row];
    return momentModel.cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WMMomentModel *momentModel = [self.dataArray objectAtIndexSafe:indexPath.row];
    NSString *identifier = [NSString stringWithFormat:@"WMMomentCell-%zi-%zi",momentModel.images.count,momentModel.comments.count];
    WMMomentCell *momentCell = [WMMomentCell cellWithTableView:tableView identifier:identifier];
    momentCell.model = momentModel;
    
    __weak typeof(momentCell) cell = momentCell;
    momentCell.moreBlock = ^(BOOL isToOpening) {
        momentModel.cellHeight = 0;
        momentModel.isOpening = isToOpening;
        [momentModel caculateCellHeight];
        [tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];

    };
    
    return momentCell;
}

#pragma -mark - momentTable
-(UITableView*)momentTable{
    if (_momentTable == nil)
    {
        _momentTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_momentTable];
        [_momentTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        _momentTable.delegate = self;
        _momentTable.dataSource = self;
        _momentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _momentTable.backgroundColor = HEX_RGB(COLOR_BACKGROUND);
        _momentTable.scrollsToTop = NO;
        _momentTable.showsHorizontalScrollIndicator = NO ;
        _momentTable.showsVerticalScrollIndicator = YES ;
        
        if (@available(iOS 11.0, *)) {
            _momentTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _momentTable.estimatedRowHeight = 0;
            _momentTable.estimatedSectionFooterHeight = 0;
            _momentTable.estimatedSectionHeaderHeight = 0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
            
        }
        _momentTable.scrollIndicatorInsets = _momentTable.contentInset;
        
    }
    return _momentTable;
}

@end
