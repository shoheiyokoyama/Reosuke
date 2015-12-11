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
//             NSLog(@"success: %@", responseObject);
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

- (void)getAreaData:(GetRemoteCompletionHandler)completionHandler area:(NSString *)area {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *requestUrl = @"http://api.gnavi.co.jp/master/GAreaSmallSearchAPI/20150630/?keyid=082e52122cf9bcb16db72b44f446a294&format=json";
    NSString* encodeString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:encodeString
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject){
             //             NSLog(@"success: %@", responseObject);
             
             NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
             NSError *error = nil;
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&error];
             
             NSArray *areaArr = dic[@"garea_small"];
             
             for (NSDictionary *result in areaArr) {
                 NSString *areaName = result[@"garea_middle"][@"areaname_m"];
                 NSLog(@"%@", areaName);
                 
                 if ([result[@"garea_middle"][@"areaname_m"] isEqual: area]) {
                     //areacode_m -> AREAM5502
                     //areaname_m -> 札幌駅
                     
                     [self getAreaStore:^(NSMutableArray *items, NSError *error) {
                         if (completionHandler) {
                             completionHandler(items, nil);
                         }
                         
                     } areacode:result[@"garea_middle"][@"areacode_m"]];
                     
                 }
                 
                 
                 
                 if ([result[@"areacode_s"]  isEqual: @"AREAS5502"]) {
                     //
                 }
                 
                 if (result[@"pref"]) {
                     //pref_code ->PREF01
                     //pref_name ->北海道
                 }
                 
                 if ([result[@"areaname_s"]  isEqual: @"札幌駅"]) {
                     //
                 }
                 
                 if (result[@"garea_large"]) {
                     //areacode_l　-> AREAL5500
                     //areaname_l -> 札幌駅・大通・すすきの
                 }
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"error: %@", error);
             
             if (completionHandler) {
                 completionHandler(nil, error);
             }
         }];
}

- (void)getAreaStore:(GetRemoteCompletionHandler)completionHandler areacode:(NSString *)areacode {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *requestOriginalUrl = @"http://api.gnavi.co.jp/RestSearchAPI/20150630/?keyid=082e52122cf9bcb16db72b44f446a294&format=json&areacode_m=";
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",requestOriginalUrl,areacode];
    NSString* encodeString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:encodeString
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject){
//             NSLog(@"success: %@", responseObject);
             self.items = [NSMutableArray array];
             
             NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
             NSError *error = nil;
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&error];
             
             NSMutableArray *shops = dic[@"rest"];
             
             if (completionHandler) {
                 completionHandler(shops, nil);
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
