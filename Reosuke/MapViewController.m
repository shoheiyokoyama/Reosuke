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
#import "DataManager.h"
#import "CustomAnnotation.h"
#import "CustomCollectionViewCell.h"

@interface MapViewController ()<MKMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic) MKMapView *mapView;
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSMutableArray *items;
@end

@implementation MapViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.items = [NSMutableArray array];
        [self setMapView];
    }
    return self;
}

- (DataManager *)manager
{
    return [DataManager sharedManager];
}

- (void)getData {
    [self.manager getAreaData:^(NSMutableArray *items, NSError *error) {
        [self displayAnnotation:items];
        [self.collectionView reloadData];
    } area:@"新宿"];
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
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.mapView.frame = self.view.bounds;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    CLLocationCoordinate2D co;
//    co.latitude = 35.68664111; // 経度
//    co.longitude = 139.6948839; // 緯度
    //新宿
    co.latitude = 35.691638;
    co.longitude = 139.704616;
    

    [self.mapView setCenterCoordinate:co animated:NO];
    
    MKCoordinateRegion cr = self.mapView.region;
    cr.center = co;
    cr.span.latitudeDelta = 0.016;
    cr.span.longitudeDelta = 0.016;
    [self.mapView setRegion:cr animated:NO];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 4.0f;//アイテム同士の間隔
    layout.minimumLineSpacing = 12.0f;//セクションとアイテムの間隔
    layout.itemSize = CGSizeMake(self.view.frame.size.width, 116);
    float a = self.view.frame.size.width;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 450, self.view.frame.size.width, 120) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.pagingEnabled = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
//    self.collectionView.backgroundColor = [UIColor redColor];
//    [self.collectionView registerClass:[UICollectionViewCell class]forCellWithReuseIdentifier:@"UICollectionViewCell"];
    UINib *nib = [UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"CustomCollectionViewCell"];
    [self.mapView addSubview:self.collectionView];
    
    
    
}

- (void)displayAnnotation:(NSMutableArray *)arrays {
    self.items = arrays;
    
    NSMutableArray *locationArrays = [NSMutableArray array];
    
    for (NSMutableDictionary *dictionary in arrays) {
        NSString *latitude = dictionary[@"latitude"];
        NSString *longitude = dictionary[@"longitude"];
        
        CustomAnnotation* an = [[CustomAnnotation alloc] init];
        an.coordinate = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
        an.title = dictionary[@"name"];
        an.subtitle = dictionary[@"name_kana"];
        an.sample = dictionary[@"category"];
        [locationArrays addObject:an];
    }
    
    [self.mapView addAnnotations:locationArrays];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSString *cellId = @"UICollectionViewCell";
//    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    
    CustomCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCollectionViewCell" forIndexPath:indexPath];
    
    NSMutableDictionary *itemDic = self.items[indexPath.row];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:itemDic[@"image_url"][@"shop_image1"]]];
//    UIImageView *cellImage = [[UIImageView alloc] initWithImage:[self trimSquareImage:[[UIImage alloc] initWithData:data]]];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    imageView.image = [self trimSquareImage:[[UIImage alloc] initWithData:data]];
    cell.shopName.text = itemDic[@"name"];
    
    return cell;
}

- (UIImage *)trimSquareImage:(UIImage *)image
{
    if (image.size.height > image.size.width) {
        CGRect cropRegion = CGRectMake(0, (image.size.height - image.size.width) / 2, image.size.width, image.size.width);
        CGImageRef squareImageRef = CGImageCreateWithImageInRect(image.CGImage, cropRegion);
        UIImage *squareImage = [UIImage imageWithCGImage:squareImageRef];
        CGImageRelease(squareImageRef);
        return squareImage;
    } else if (image.size.height < image.size.width) {
        CGRect cropRegion = CGRectMake((image.size.width - image.size.height) / 2, 0, image.size.height, image.size.height);
        CGImageRef squareImageRef = CGImageCreateWithImageInRect(image.CGImage, cropRegion);
        UIImage *squareImage = [UIImage imageWithCGImage:squareImageRef];
        CGImageRelease(squareImageRef);
        return squareImage;
    } else {
        return image;
    }
    return image;
}

#pragma mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // tap action
}


#pragma mark MKAnnotationViewDelegate
- (MKAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id)annotation {
    static NSString *PinIdentifier = @"Pin";
    MKPinAnnotationView *pav = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:PinIdentifier];
    
    if(pav == nil){
        pav = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:PinIdentifier];
        pav.animatesDrop = YES;
        pav.pinTintColor = [UIColor redColor];
        pav.canShowCallout = YES;
    }
    return pav;
}

#pragma mark MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    // add detail disclosure button to callout
    [views enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        ((MKAnnotationView*)obj).rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }];
}

-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    [self getData];
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    // create right accessory view
    UILabel* sample = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 100.f, 32.f)];
    sample.backgroundColor = [UIColor clearColor];
    sample.font = [UIFont fontWithName:@"Helvetica" size: 13];
    sample.text = ((CustomAnnotation*)view.annotation).sample;
    sample.textColor = [UIColor lightGrayColor];
    
    // add view to callout
    view.rightCalloutAccessoryView = nil;
    view.rightCalloutAccessoryView = sample;
    
    view.highlighted = YES;
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
}

@end
