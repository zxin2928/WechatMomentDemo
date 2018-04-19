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

@property (strong, nonatomic) WMMomentHeadView *headerView;

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
    NSString *personKey = PERSON_FIRST;
    NSString *key = MOMENT_FIRST;
    NSMutableArray *datas = [[WMSql shared]queryMomentWithPage:0];
    if (datas.count > 0) {
        self.dataArray = datas;
        
        [self configTableView];
        
        key = MOMENT_HEAD;
        
        [_refreshHeader beginRefreshing];
    }else{
        key = MOMENT_FIRST;
    }
    
    WMPersonModel *personModel = [[WMSql shared]queryCurrentPerson];
    if (personModel) {
        personKey = PERSON_REFRESH;
    }else{
        personKey = PERSON_FIRST;
    }
    [self setupHeadView];

    [[WMRequestManager sharedManager]getPersonInfoWithKey:personKey delegate:self];
    [self requestMomentWithKey:key];
}

- (void)footerRefreshing
{
    int page = (int)self.dataArray.count / PAGE_NUM;
    NSMutableArray *newMomentArray = [[WMSql shared]queryMomentWithPage:page];
    WMMomentModel *lastNewModel = newMomentArray.lastObject;
    WMMomentModel *lastOldModel = self.dataArray.lastObject;
    if (lastNewModel.momentId == lastOldModel.momentId) {
        
    }else
    {
        for(WMMomentModel *model in newMomentArray){
            if(![self.dataArray containsObject:model]){
                [self.dataArray addObjectSafe:model];
            }
        }
    }
    [self.momentTable reloadData];
    
    if ([self.momentTable.mj_footer isRefreshing]) {
        [self.momentTable.mj_footer endRefreshing];
    }
    
    if (newMomentArray.count < PAGE_NUM || newMomentArray.count == 0)
    {
        [self.momentTable.mj_footer endRefreshingWithNoMoreData];
    }
    
}

-(void)requestMomentWithKey:(NSString*)key{
    [[WMRequestManager sharedManager]getMomentInfoWithKey:key delegate:self];
}

#pragma mark - setupHeadView
- (void)setupHeadView
{
    [self headerView];
}

#pragma -mark private method
-(void)configTableView{
    if (!_refreshHeader.superview) {
        
        _refreshHeader = [WMMomentRefreshView refreshHeaderWithCenter:CGPointMake(40, -15)];
        _refreshHeader.scrollView = self.momentTable;
        WS(weakSelf);
        [_refreshHeader setRefreshingBlock:^{
            [weakSelf requestMomentWithKey:MOMENT_HEAD];
        }];
        [self.momentTable.superview addSubview:_refreshHeader];
    } else {
        [self.momentTable.superview bringSubviewToFront:_refreshHeader];
    }
    [self addFooterRefreshWithView:self.momentTable];
}

#pragma -mark - WMRequestDelegate
-(void)requestSuccess:(WMRequest *)request data:(id)data url:(NSString *)url{

    if ([request.key isEqualToString:MOMENT_FIRST] || [request.key isEqualToString:MOMENT_HEAD]) {
        [_refreshHeader endRefreshing];
        [WMModelClass momentListWithData:data];
        if ([request.key isEqualToString:MOMENT_FIRST]) {
            self.dataArray = [[WMSql shared]queryMomentWithPage:0];
            
            [self configTableView];
        }
        
    }else if ([request.key isEqualToString:PERSON_FIRST] || [request.key isEqualToString:PERSON_REFRESH]){
        [WMModelClass personModelWithData:data];
        
        WMPersonModel *personModel = [[WMSql shared]queryCurrentPerson];
        self.headerView.model = personModel;
    }

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
    NSString *identifier = [NSString stringWithFormat:@"WMMomentCell-%zi-%zi",momentModel.images.count,indexPath.row];
    WMMomentCell *momentCell = [WMMomentCell cellWithTableView:tableView identifier:identifier];
    momentCell.model = momentModel;
        
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

#pragma -mark - headerView
-(WMMomentHeadView *)headerView{
    if (_headerView == nil) {
        _headerView = [[WMMomentHeadView alloc] init];
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, 260);
        [_headerView setIconButtonClick:^{
            
        }];
        self.momentTable.tableHeaderView = _headerView;
    }
    return _headerView;
}
@end
