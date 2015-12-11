//
//  CustomAnnotation.h
//  Reosuke
//
//  Created by Shoehi Yokoyama on 2015/12/06.
//  Copyright © 2015年 Shohei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface CustomAnnotation : NSObject
@property (readwrite, nonatomic) CLLocationCoordinate2D coordinate;
@property (readwrite, nonatomic, strong) NSString* title;
@property (readwrite, nonatomic, strong) NSString* subtitle;
@property (readwrite, nonatomic, strong) NSString* sample;
@end
