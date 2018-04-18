//
//  WMSql.m
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/18.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "WMSql.h"
#import <FMDB.h>
#import "WMMomentModel.h"

const NSString * TABLE_MOMENT = @"table_moment";
const NSString * TABLE_SENDER = @"table_sender";
const NSString * TABLE_COMENT = @"table_coment";

@interface WMSql ()

@property(nonatomic,strong) FMDatabaseQueue * queue ;

@end

@implementation WMSql
+(instancetype)shared{
    static WMSql * sqlService = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sqlService = [[WMSql alloc] init];
    });
    
    return sqlService;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        NSArray *docmentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
        NSString *datebaseFilePath = [[docmentsPaths objectAtIndex:0] stringByAppendingPathComponent:@"SqlServiceData.db"];
        
        NSLog(@"SqlServiceData - DBPATH  %@",datebaseFilePath);
        
        self.queue = [FMDatabaseQueue databaseQueueWithPath:datebaseFilePath];
    }
    
    return self ;
}

#pragma mark - 创建表
-(void)createTables
{
    [self creatMomentTable];
    [self creatCommentTable];
    
    [self upgradeDB];
}

-(BOOL)creatMomentTable{
    
    __block BOOL result  = NO ;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        //1 打开路径
        if ([db open]) {
            //2 准备并执行sql语句
            NSString * sqlstr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (momentId integer primary key,content text,avatar text,username text,nick text)",TABLE_MOMENT];
            
            result = [db executeUpdate:sqlstr];
            if (result) {
                NSLog(@"创建TABLE_MOMENT数据表成功");
            }else{
                NSLog(@"创建TABLE_MOMENT数据表失败");
            }
            
        }else{
            
            result = NO ;
            NSLog(@"数据库打开失败");
        }
        //3 关闭
        [db close ];
    }];
    return result ;
}



-(BOOL)creatCommentTable{
    
    __block BOOL result  = NO ;
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString * sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (commentId integer primary key,momentId integer,avatar text,username text,nick text)",TABLE_COMENT];
            result = [db executeUpdate:sql];
            if (result) {
                
                NSLog(@"创建TABLE_COMENT数据表成功");
                
            }else{
                
                NSLog(@"创建TABLE_COMENT数据表失败");
            }
            
        }else{
            
            result = NO ;
            NSLog(@"数据库打开失败");
        }
        
        [db close ];
        
    }];
    
    return result ;
}

#pragma mark - 数据库升级处理
- (void)upgradeDB {
    //1、 取出沙盒中存储的上次使用软件的版本号
    NSString *key = @"CFBundleShortVersionString";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults stringForKey:key];
    
    // 2、获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    // 3、判断版本号
    if ([currentVersion isEqualToString:lastVersion])
    {
        // 旧版本
        
    }else{
        
        // 存储新版本
        [defaults setObject:currentVersion forKey:key];
    }
    
    //升级
    [self upgrade:[lastVersion integerValue]];
    
}

- (void)upgrade:(NSInteger)oldVersion
{
    NSString *key = @"CFBundleShortVersionString";
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    if (oldVersion >= [currentVersion integerValue]) {
        return;
    }
    
    switch (oldVersion) {
        case 0:
            break;

        default:
            break;
    }
    oldVersion ++;
    
    // 递归判断是否需要升级
    [self upgrade:oldVersion];
}

@end
