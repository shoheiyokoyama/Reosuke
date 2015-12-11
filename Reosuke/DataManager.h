//
//  DataManager.h
//  Reosuke
//
//  Created by Shohei Yokoyama on 2015/11/30.
//  Copyright © 2015年 Shohei. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataManager : NSObject
typedef void (^GetRemoteCompletionHandler)(NSMutableArray *items, NSError *error);
- (void)getJsonData:(GetRemoteCompletionHandler)completionHandler;
+ (instancetype)sharedManager;
- (void)getAreaData:(GetRemoteCompletionHandler)completionHandler area:(NSString *)area;
@end
