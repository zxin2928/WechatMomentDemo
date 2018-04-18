//
//  WMDiscoverViewController.m
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/16.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "WMDiscoverViewController.h"
#import "WMDicoverModel.h"
#import "WMCommon.h"
#import "WMDiscoverCell.h"
#import "WMMomentViewController.h"

@interface WMDiscoverViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *discoverTable;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation WMDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self discoverTable];
}

#pragma -mark - UITableViewDelegate and UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WMDicoverModel *model = [self.dataArray objectAtIndexSafe:indexPath.row];
    WMDiscoverCell *discoverCell = [WMDiscoverCell cellWithTableView:tableView identifier:@"PFNewsTextCell"];
    discoverCell.model = model;
    return discoverCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WMMomentViewController *momentVC = [WMMomentViewController new];
    [self.navigationController pushViewController:momentVC animated:YES];
}

#pragma -mark - dataArray
- (NSMutableArray *)dataArray{
    return [WMDicoverModel testTitleArray];
}

#pragma -mark - discoverTable
-(UITableView*)discoverTable{
    if (_discoverTable == nil)
    {
        _discoverTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_discoverTable];
        [_discoverTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        _discoverTable.delegate = self;
        _discoverTable.dataSource = self;
        _discoverTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _discoverTable.backgroundColor = HEX_RGB(COLOR_BACKGROUND);
        _discoverTable.scrollsToTop = NO;
        _discoverTable.showsHorizontalScrollIndicator = NO ;
        _discoverTable.showsVerticalScrollIndicator = YES ;
        
        if (@available(iOS 11.0, *)) {
            _discoverTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _discoverTable.estimatedRowHeight = 0;
            _discoverTable.estimatedSectionFooterHeight = 0;
            _discoverTable.estimatedSectionHeaderHeight = 0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
            
        }
        _discoverTable.scrollIndicatorInsets = _discoverTable.contentInset;
    }
    return _discoverTable;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
