//
//  WMSql.m
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/18.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "WMSql.h"
#import <FMDB.h>
#import "WMPersonModel.h"
#import "WMMomentModel.h"
#import "WMCommon.h"
const NSString * TABLE_PERSON = @"table_person";

const NSString * TABLE_MOMENT = @"table_moment";
const NSString * TABLE_IMAGE = @"table_image";
const NSString * TABLE_COMMENT = @"table_comment";

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
    [self creatPersonTable];
    
    [self creatMomentTable];
    [self creatCommentTable];
    [self creatImageTable];
    
    [self upgradeDB];
}

-(BOOL)creatPersonTable{
    
    __block BOOL result  = NO ;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString * sqlstr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (personId integer primary key,profileImage text,avatar text,username text,nick text)",TABLE_PERSON];
            
            result = [db executeUpdate:sqlstr];
            if (result) {
                NSLog(@"创建TABLE_PERSON数据表成功");
            }else{
                NSLog(@"创建TABLE_PERSON数据表失败");
            }
            
        }else{
            
            result = NO ;
            NSLog(@"数据库打开失败");
        }
        [db close ];
    }];
    return result ;
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
            NSString * sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (commentId integer primary key,momentId integer,content text,avatar text,username text,nick text)",TABLE_COMMENT];
            result = [db executeUpdate:sql];
            if (result) {
                
                NSLog(@"创建TABLE_COMMENT数据表成功");
                
            }else{
                
                NSLog(@"创建TABLE_COMMENT数据表失败");
            }
            
        }else{
            
            result = NO ;
            NSLog(@"数据库打开失败");
        }
        
        [db close ];
        
    }];
    
    return result ;
}

-(BOOL)creatImageTable{
    
    __block BOOL result  = NO ;
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString * sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (imageId integer primary key,momentId integer,url text)",TABLE_IMAGE];
            result = [db executeUpdate:sql];
            if (result) {
                
                NSLog(@"创建TABLE_IMAGE数据表成功");
                
            }else{
                
                NSLog(@"创建TABLE_IMAGE数据表失败");
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


#pragma mark - 插入表
-(BOOL)insertPerson:(WMPersonModel*)personModel
{
    __block BOOL result = NO ;
    [self.queue inDatabase:^(FMDatabase *db) {
        
        if ([db open]) {
            personModel.profileImage = [personModel.profileImage stringByReplacingOccurrencesOfString:@"'" withString:@""];
            
            NSString *sql = [NSString stringWithFormat:@"insert or replace into table_person (personId,profileImage,avatar,username,nick) values (%d,'%@','%@','%@','%@')",personModel.personId,personModel.profileImage,personModel.avatar,personModel.username,personModel.nick];
            result = [db executeUpdate:sql];
            
            if (result) {
                NSLog(@"插入WMPersonModel数据成功");
            }else{
                NSLog(@"插入WMPersonModel数据失败");
            }
        }else{
            result = NO ;
            NSLog(@"数据插入失败");
        }
        
        [db close];
    }];
    
    return result;
}

-(BOOL)insertMoment:(WMMomentModel*)momentModel
{
    __block BOOL result = NO ;
    [self.queue inDatabase:^(FMDatabase *db) {
        
        if ([db open]) {
            momentModel.content = [momentModel.content stringByReplacingOccurrencesOfString:@"'" withString:@""];

            NSString *sql = [NSString stringWithFormat:@"insert or replace into table_moment (momentId,content,avatar,username,nick) values (%d,'%@','%@','%@','%@')",momentModel.momentId,momentModel.content,momentModel.avatar,momentModel.username,momentModel.nick];
            result = [db executeUpdate:sql];
            
            if (result) {
                NSLog(@"插入WMMomentModel数据成功");
            }else{
                NSLog(@"插入WMMomentModel数据失败");
            }
        }else{
            result = NO ;
            NSLog(@"数据插入失败");
        }
        
        [db close];
    }];
    
    return result;
}

-(BOOL)insertMomentComent:(WMCommentModel*)comentModel
{
    __block BOOL result = NO ;
    [self.queue inDatabase:^(FMDatabase *db) {
        
        if ([db open]) {
            NSString *sql = [NSString stringWithFormat:@"insert or replace into table_comment (commentId,momentId,content,avatar,username,nick) values (%d,%d,'%@','%@','%@','%@')",comentModel.commentId,comentModel.momentId,comentModel.content,comentModel.avatar,comentModel.username,comentModel.nick];
            result = [db executeUpdate:sql];
            
            if (result) {
                NSLog(@"插入WMCommentModel数据成功");
            }else{
                NSLog(@"插入WMCommentModel数据失败");
            }
        }else{
            result = NO ;
            NSLog(@"数据插入失败");
        }
        
        [db close];
    }];
    
    return result;
}

-(BOOL)insertMomentImage:(WMImageModel*)imageModel
{
    __block BOOL result = NO ;
    [self.queue inDatabase:^(FMDatabase *db) {
        
        if ([db open]) {
            NSString *sql = [NSString stringWithFormat:@"insert or replace into table_image (imageId,momentId,url) values (%d,%d,'%@')",imageModel.imageId,imageModel.momentId,imageModel.url];
            result = [db executeUpdate:sql];
            
            if (result) {
                NSLog(@"插入WMImageModel数据成功");
            }else{
                NSLog(@"插入WMImageModel数据失败");
            }
        }else{
            result = NO ;
            NSLog(@"数据插入失败");
        }
        
        [db close];
    }];
    
    return result;
}

#pragma -mark - 查询表
-(WMPersonModel*)queryCurrentPerson{
    __block WMPersonModel *personModel;
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql = [NSString stringWithFormat:@"select * from table_person"];
            FMResultSet * set = [db executeQuery:sql];
            
            while ([set next]) {
                personModel = [WMPersonModel new];
                personModel.personId = [set intForColumn:@"personId"];
                personModel.profileImage = [set stringForColumn:@"profileImage"];
                personModel.avatar = [set stringForColumn:@"avatar"];
                personModel.username = [set stringForColumn:@"username"];
                personModel.nick = [set stringForColumn:@"nick"];
            }
        }else{
            
        }
        [db close];
    }];
    return personModel;
}

-(NSMutableArray*)queryMomentWithPage:(int)page
{
    int startNum = PAGE_NUM*page;
    int num = PAGE_NUM;
    
    NSMutableArray *momentArray = [NSMutableArray array];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        if ([db open]) {
            NSString *sql = [NSString stringWithFormat:@"select * from table_moment limit %d,%d",startNum,num];
            FMResultSet * set   = [db executeQuery:sql];
            
            while ([set next]) {
                WMMomentModel *momentModel = [[WMMomentModel alloc]init];
                
                momentModel.momentId = [set intForColumn:@"momentId"];
                momentModel.content = [set stringForColumn:@"content"];
                momentModel.avatar = [set stringForColumn:@"avatar"];
                momentModel.username = [set stringForColumn:@"username"];
                momentModel.nick = [set stringForColumn:@"nick"];

                [momentArray addObject:momentModel];
            }
        }else{
            
        }
        [db close];
    }];
    
    NSMutableArray *returnArray = [NSMutableArray array];
    for (int i = 0; i<momentArray.count; i++) {
        WMMomentModel *momentModel = [momentArray objectAtIndexSafe:i];
        
        NSMutableArray *imageArray = [NSMutableArray array];
        [self.queue inDatabase:^(FMDatabase *db) {
            
            if ([db open]) {
                NSString *sqlcoment = [NSString stringWithFormat:@"select * from table_image where momentId = %d",momentModel.momentId];
                FMResultSet * set = [db executeQuery:sqlcoment];
                
                while ([set next]) {
                    WMImageModel *imageModel = [[WMImageModel alloc]init];
                    
                    imageModel.imageId = [set intForColumn:@"imageId"];
                    imageModel.momentId = [set intForColumn:@"momentId"];
                    imageModel.url = [set stringForColumn:@"url"];
                    
                    [imageArray addObject:imageModel];
                }
            }else{
            }
            
            [db close];
        }];
        momentModel.images = imageArray;

        
        NSMutableArray *commentArray = [NSMutableArray array];
        [self.queue inDatabase:^(FMDatabase *db) {
            
            if ([db open]) {
                NSString *sqlcoment = [NSString stringWithFormat:@"select * from table_comment where momentId = %d",momentModel.momentId];
                FMResultSet * set   = [db executeQuery:sqlcoment];
                
                while ([set next]) {
                    WMCommentModel *commentModel = [[WMCommentModel alloc]init];
                    
                    commentModel.commentId = [set intForColumn:@"commentId"];
                    commentModel.momentId = [set intForColumn:@"momentId"];
                    commentModel.content = [set stringForColumn:@"content"];
                    commentModel.avatar = [set stringForColumn:@"avatar"];
                    commentModel.username = [set stringForColumn:@"username"];
                    commentModel.nick = [set stringForColumn:@"nick"];
                    
                    [commentArray addObject:commentModel];
                }
            }else{
                
            }
            [db close];
        }];
        momentModel.comments = [NSMutableArray arrayWithArray:commentArray];
        
        [returnArray addObjectSafe:momentModel];
    }
    
    return returnArray;
}

@end
