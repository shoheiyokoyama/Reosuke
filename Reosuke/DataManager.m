//
//  DataManager.m
//  Reosuke
//
//  Created by Shohei Yokoyama on 2015/11/30.
//  Copyright © 2015年 Shohei. All rights reserved.
//

#import "DataManager.h"
#import "AFNetworking.h"

#define APIKEY @"082e52122cf9bcb16db72b44f446a294"

@interface DataManager()
@property (nonatomic) NSMutableArray *items;
@end

@implementation DataManager

static DataManager *sharedManager = nil;
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[DataManager alloc] init];
    });
    return sharedManager;
}

- (void)getJsonData:(GetRemoteCompletionHandler)completionHandler {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *requestUrl = @"http://api.gnavi.co.jp/master/GAreaSmallSearchAPI/20150630/?keyid=082e52122cf9bcb16db72b44f446a294&format=json";
    NSString* encodeString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:encodeString
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject){
             NSLog(@"success: %@", responseObject);
             self.items = [NSMutableArray array];
             
             NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
             NSError *error = nil;
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&error];
//             NSString *count = dic[@"total_hit_count"];
//             NSDictionary *result = dic[@"rest"];
             
//             NSLog(@"success: %@", dic);
             if (completionHandler) {
                 completionHandler(_items, nil);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"error: %@", error);
             
             if (completionHandler) {
                 completionHandler(nil, error);
             }
         }];
}

- (void)getAreaData:(GetRemoteCompletionHandler)completionHandler {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *requestUrl = @"http://api.gnavi.co.jp/master/GAreaSmallSearchAPI/20150630/?keyid=082e52122cf9bcb16db72b44f446a294&format=json";
    NSString* encodeString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:encodeString
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject){
             NSLog(@"success: %@", responseObject);
             self.items = [NSMutableArray array];
             
             NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
             NSError *error = nil;
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&error];

             NSDictionary *areaDic = dic[@"garea_small"];
             
             if (completionHandler) {
                 completionHandler(_items, nil);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"error: %@", error);
             
             if (completionHandler) {
                 completionHandler(nil, error);
             }
         }];
}

@end
