//
//  MapViewController.h
//  Reosuke
//
//  Created by Shohei Yokoyama on 2015/12/04.
//  Copyright © 2015年 Shohei. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MapView;
@protocol MapViewDelegate <NSObject>
@optional
- (void)tappedCell:(NSArray *)array;
@end

@interface MapViewController : UIViewController
@property (nonatomic, weak) id<MapViewDelegate> delegate;
@end
