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
#import "WMMomentLayout.h"

@interface WMMomentViewController ()<UITableViewDelegate, UITableViewDataSource,WMMomentCellDelegate>

@property (strong, nonatomic) UITableView *momentTable;

@property (strong, nonatomic) WMMomentHeadView *headerView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) NSMutableArray *layoutsArr;

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

-(NSMutableArray*)getDataArrayWithDatas:(NSMutableArray*)array{
    NSMutableArray *layoutArray = [NSMutableArray array];
    for (int i = 0; i<array.count; i++) {
        WMMomentModel *momentModel = [array objectAtIndexSafe:i];
        WMMomentLayout *layout = [[WMMomentLayout alloc]initWithModel:momentModel];
        [layoutArray addObjectSafe:layout];
    }
    return layoutArray;
}

- (void)firstAppear{
    NSString *personKey = PERSON_FIRST;
    NSString *key = MOMENT_FIRST;
    NSMutableArray *datas = [[WMSql shared]queryMomentWithPage:0];
    if (datas.count > 0) {
        self.dataArray = datas;
        self.layoutsArr = [self getDataArrayWithDatas:datas];

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
        self.layoutsArr = [self getDataArrayWithDatas:self.dataArray];

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
            self.layoutsArr = [self getDataArrayWithDatas:self.dataArray];

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

#pragma -mark - WMMomentCellDelegate
-(void)DidClickMoreLessInDynamicsCell:(WMMomentCell *)cell
{
    NSIndexPath * indexPath = [self.momentTable indexPathForCell:cell];
    WMMomentLayout * layout = [self.layoutsArr objectAtIndexSafe:indexPath.row];
    layout.model.isOpening = !layout.model.isOpening;
    [layout resetLayout];
    CGRect cellRect = [self.momentTable rectForRowAtIndexPath:indexPath];
    
    [self.momentTable reloadData];
    
    if (cellRect.origin.y < self.momentTable.contentOffset.y + 64) {
        [self.momentTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

#pragma -mark - UITableViewDelegate and UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.layoutsArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WMMomentLayout *layout = [self.layoutsArr objectAtIndexSafe:indexPath.row];
    return layout.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WMMomentLayout *layout = [self.layoutsArr objectAtIndexSafe:indexPath.row];
    WMMomentCell * momentCell = [tableView dequeueReusableCellWithIdentifier:@"WMMomentCell"];
    momentCell.delegate = self;
    momentCell.layout = layout;
        
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
        [_momentTable registerClass:[WMMomentCell class] forCellReuseIdentifier:@"WMMomentCell"];

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

#pragma -mark - layoutsArr
-(NSMutableArray *)layoutsArr
{
    if (!_layoutsArr) {
        _layoutsArr = [NSMutableArray array];
    }
    return _layoutsArr;
}
@end
