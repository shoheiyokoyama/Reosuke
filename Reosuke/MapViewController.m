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
#import "SVProgressHUD.h"

@interface MapViewController ()<MKMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, CustomCollectionDelegate>
@property (nonatomic) MKMapView *mapView;
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSMutableArray *items;
@property (nonatomic) UIButton *olympicButton;
@property (nonatomic) UIButton *foodButton;
@property (nonatomic) UIButton *sightseeingButton;
@property (nonatomic) BOOL isOlypic;
@property (nonatomic) BOOL isSightseeing;
@property (nonatomic) BOOL firstLoad;
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

- (void)getData:(NSString *)string {
    self.firstLoad = YES;
    [SVProgressHUD showWithStatus:string maskType:SVProgressHUDMaskTypeGradient];
    [self.manager getAreaData:^(NSMutableArray *items, NSError *error) {
        [self displayAnnotation:items];
        [self.collectionView reloadData];
        self.olympicButton.hidden = NO;
        self.foodButton.hidden = NO;
        self.sightseeingButton.hidden = NO;
        
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"見つかりました！"];
    } area:@"新宿"];
}

- (void)setMapView {
    self.isSightseeing = NO;
    self.isOlypic = NO;
    self.firstLoad = NO;
    
    UIImage *menuImage = [UIImage imageNamed:@"hunberger"];
    UIGraphicsBeginImageContext(CGSizeMake(30, 20));
    [menuImage drawInRect:CGRectMake(0, 0, 30, 20)];
    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:resizeImage
//                                                                             style:UIBarButtonItemStylePlain
//                                                                            target:(SideMenuNavigationController *)self.navigationController
//                                                                            action:@selector(showMenu)];
    
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
    
    self.olympicButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 430.0f, 80.0f, 20.0f)];
    [self.olympicButton setTitle:@"olympic" forState:UIControlStateNormal];
    [self.olympicButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [self.olympicButton addTarget:self action:@selector(tapOlympicButton:) forControlEvents:UIControlEventTouchDown];
    self.olympicButton.backgroundColor = [UIColor colorWithRed:239.0f/255.0f green:72.0f/255.0f blue:54.0f/255.0f alpha:1.0f];
    self.olympicButton.layer.cornerRadius = 3.0f;
    [self.view addSubview:self.olympicButton];
    
    self.foodButton = [[UIButton alloc] initWithFrame:CGRectMake(80.0f, 430.0f, 80.0f, 20.0f)];
    [self.foodButton setTitle:@"food" forState:UIControlStateNormal];
    [self.foodButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [self.foodButton addTarget:self action:@selector(tapFoodButton:) forControlEvents:UIControlEventTouchDown];
    self.foodButton.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:120.0f/255.0f blue:75.0f/255.0f alpha:1.0f];
    self.foodButton.layer.cornerRadius = 3.0f;
    [self.view addSubview:self.foodButton];
    
    self.sightseeingButton = [[UIButton alloc] initWithFrame:CGRectMake(160.0f, 430.0f, 80.0f, 20.0f)];
    [self.sightseeingButton setTitle:@"sightseeing" forState:UIControlStateNormal];
    self.sightseeingButton.backgroundColor = [UIColor colorWithRed:65.0f/255.0f green:131.0f/255.0f blue:215.0f/255.0f alpha:1.0f];
    [self.sightseeingButton addTarget:self action:@selector(tapSightseeingButton:) forControlEvents:UIControlEventTouchDown];
    [self.sightseeingButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    self.sightseeingButton.layer.cornerRadius = 3.0f;
    [self.view addSubview:self.sightseeingButton];
    
    self.foodButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [self.view bringSubviewToFront:self.foodButton];
    
    self.olympicButton.hidden = YES;
    self.foodButton.hidden = YES;
    self.sightseeingButton.hidden = YES;
    
    self.olympicButton.alpha = 0.7f;
    self.foodButton.alpha = 1.0f;
    self.sightseeingButton.alpha = 0.7f;

}

#pragma -mark Tap Action
-(void)tapOlympicButton:(UIButton*)button{
    self.olympicButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
    self.foodButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
    self.sightseeingButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    [self.view bringSubviewToFront:self.olympicButton];
    [self.view sendSubviewToBack:self.foodButton];
    [self.view sendSubviewToBack:self.sightseeingButton];
    [self.view sendSubviewToBack:self.mapView];
    
    [self getData:@"パブリックビューイングの場所を探しています"];
    self.isSightseeing = NO;
    self.isOlypic = YES;
    
    self.olympicButton.alpha = 1.0f;
    self.foodButton.alpha = 0.7f;
    self.sightseeingButton.alpha = 0.7f;
}

-(void)tapFoodButton:(UIButton*)button{
    self.olympicButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
    self.foodButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
    self.sightseeingButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    [self.view bringSubviewToFront:self.foodButton];
    [self.view sendSubviewToBack:self.olympicButton];
    [self.view sendSubviewToBack:self.sightseeingButton];
    [self.view sendSubviewToBack:self.mapView];
    
    [self getData:@"あなたへのおすすめのお店を探しています"];
    self.isSightseeing = NO;
    self.isOlypic = NO;
    
    self.olympicButton.alpha = 0.7f;
    self.foodButton.alpha = 1.0f;
    self.sightseeingButton.alpha = 0.7f;
}

-(void)tapSightseeingButton:(UIButton*)button{
    self.olympicButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
    self.foodButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
    self.sightseeingButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
    
    [self.view bringSubviewToFront:self.sightseeingButton];
    [self.view sendSubviewToBack:self.olympicButton];
    [self.view sendSubviewToBack:self.foodButton];
    [self.view sendSubviewToBack:self.mapView];
    
    [self getData:@"あなたへのおすすめの観光地を探しています"];
    self.isSightseeing = YES;
    self.isOlypic = NO;
    
    self.olympicButton.alpha = 0.7f;
    self.foodButton.alpha = 0.7f;
    self.sightseeingButton.alpha = 1.0f;
}

#pragma -mark CustomCollectionViewCellDelegate
- (void)tappedBack {
    NSIndexPath *preIndexPath;
    for (CustomCollectionViewCell *cell in [self.collectionView visibleCells]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        preIndexPath = [NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:0];
        
    }
    [self.collectionView scrollToItemAtIndexPath:preIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
}

- (void)tappedNext {
    NSIndexPath *nextIndexPath;
    for (CustomCollectionViewCell *cell in [self.collectionView visibleCells]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        nextIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:0];
        
    }
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
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
    CustomCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCollectionViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    
    NSMutableDictionary *itemDic = self.items[indexPath.row];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:itemDic[@"image_url"][@"shop_image1"]]];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    imageView.image = [self trimSquareImage:[[UIImage alloc] initWithData:data]];
    cell.shopName.text = itemDic[@"name"];
    
    UIColor *backColor = [UIColor colorWithWhite:1.0f alpha:0.85f];
    cell.backgroundColor = backColor;
    [cell.okLabel.layer setCornerRadius:5.0f]; //??
    
    if (indexPath.row == 0) {
        cell.backButton.hidden = YES;
    } else {
        cell.backButton.hidden = NO;
    }
    
    if (indexPath.row == self.items.count - 1) {
        cell.nextButton.hidden = YES;
    } else {
        cell.nextButton.hidden = NO;
    }
    
    if (self.isOlypic) {
        imageView.image = [UIImage imageNamed:@"pablicView"];
        cell.shopName.text = @"東京パブリックビューイング会場";
    }
    
    if (self.isSightseeing) {
        imageView.image = [UIImage imageNamed:@"sightseeing"];
        cell.shopName.text = @"スカイツリー";
    }
    
    
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
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    NSMutableDictionary *itemDic = self.items[indexPath.row];
    
    [self showAlert:@"予定を確定しますか？" array:@[cell.shopName.text, itemDic[@"access"][@"station"]] title:cell.shopName.text];
    
    
}

- (void)showAlert:(NSString *)message array:(NSArray *)array title:(NSString *)title
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([self.delegate respondsToSelector:@selector(tappedCell:)]) {
            [self.delegate tappedCell:array];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
    if (!self.firstLoad) {
        [self getData:@"あなたへのおすすめのお店を探しています"];
    }
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
