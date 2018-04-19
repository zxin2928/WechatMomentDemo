//
//  UIImageView+Download.m
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/19.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "UIImageView+Download.h"

@implementation UIImageView (Download)
-(void)downloadImageWithURL:(NSString *)urlString{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [NSString stringWithFormat:@"%ld",(unsigned long)urlString.hash];
    NSString *documentsPath = [NSString stringWithFormat:@"%@/Images",path[0]];
    NSString *documentsImage = [NSString stringWithFormat:@"%@/%@",documentsPath,documents];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:documentsPath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:documentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    UIImage *image = [UIImage imageWithContentsOfFile:documentsImage];
    if (image) {
        self.image = image;
    }else{
        self.image = [UIImage imageNamed:@"background.png"];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        if ([user boolForKey:@"imageFlag"]) {
            return;
        }
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
        NSURLSessionDataTask *task = [delegateFreeSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                NSLog(@"error = %@",error.debugDescription);
            }else if (data != nil){
                UIImage *webImage = [UIImage imageWithData:data];
                self.image = webImage;
                [data writeToFile:documentsImage atomically:YES];
            }
        }];
        [task resume];
    }
}

@end
