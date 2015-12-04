//
//  MapViewController.m
//  Reosuke
//
//  Created by Shohei Yokoyama on 2015/12/04.
//  Copyright © 2015年 Shohei. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "SideMenuNavigationController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setMapView];
    }
    return self;
}

- (void)setMapView {
    UIImage *menuImage = [UIImage imageNamed:@"hunberger"];
    UIGraphicsBeginImageContext(CGSizeMake(30, 20));
    [menuImage drawInRect:CGRectMake(0, 0, 30, 20)];
    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:resizeImage
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(SideMenuNavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
    
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    mapView.frame = self.view.bounds;
    [self.view addSubview:mapView];
    
    CLLocationCoordinate2D co;
    co.latitude = 35.68664111; // 経度
    co.longitude = 139.6948839; // 緯度
    [mapView setCenterCoordinate:co animated:NO];
    
    MKCoordinateRegion cr = mapView.region;
    cr.center = co;
    cr.span.latitudeDelta = 0.5;
    cr.span.longitudeDelta = 0.5;
    [mapView setRegion:cr animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
