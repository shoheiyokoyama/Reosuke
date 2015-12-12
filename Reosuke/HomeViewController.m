//
//  HomeViewController.m
//  Reosuke
//
//  Created by Shohei Yokoyama on 2015/11/30.
//  Copyright © 2015年 Shohei. All rights reserved.
//

#import "HomeViewController.h"
#import "RNFrostedSidebar.h"
#import "ViewController.h"
#import "DataManager.h"
#import "SideMenuNavigationController.h"
#import "MapViewController.h"

@interface HomeViewController ()<RNFrostedSidebarDelegate, MapViewDelegate>
@property (nonatomic) RNFrostedSidebar *sidebar;
@property (nonatomic) UINavigationController *nav;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *placeLabel;
@property (nonatomic) UIButton *tapButton;
@property (nonatomic) UIImageView *imageView;
@end

@implementation HomeViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
//        self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
//        [self setRNFrostedSidebarSidebar];
        [self setRESideMenu];
        
        
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        self.imageView.image = [UIImage imageNamed:@"calendar1"];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:self.imageView];
        
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 325, 250, 30)];
        self.nameLabel.text = @"";
        self.nameLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.view addSubview:self.nameLabel];
        
        self.placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 345, 250, 30)];
        self.placeLabel.font = [UIFont systemFontOfSize:13];
        self.placeLabel.text = @"";
        [self.view addSubview:self.placeLabel];
        
        self.tapButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 330, 340, 120)];
//        self.tapButton.backgroundColor = [UIColor redColor];
        [self.tapButton addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchDown];
        self.tapButton.userInteractionEnabled = YES;
        [self.view addSubview:self.tapButton];
    }
    return self;
}

#pragma -mark Tap Action
-(void)tapped:(UIButton*)button{
    MapViewController *mapCon = [[MapViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:mapCon];
    mapCon.delegate = self;
    [self presentViewController:navi animated:YES completion:nil];
    
}

- (DataManager *)manager
{
    return [DataManager sharedManager];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setRESideMenu {
    UIImage *menuImage = [UIImage imageNamed:@"hunberger"];
    UIGraphicsBeginImageContext(CGSizeMake(30, 20));
    [menuImage drawInRect:CGRectMake(0, 0, 30, 20)];
    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:resizeImage
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(SideMenuNavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
//    SideMenuNavigationController.title = @"Reosuke";
    
}

- (void)setRNFrostedSidebarSidebar {
    
    NSArray *images = @[
                        [UIImage imageNamed:@"schedule"],
                        [UIImage imageNamed:@"schedule"],
                        [UIImage imageNamed:@"schedule"],
                        [UIImage imageNamed:@"schedule"],
                        [UIImage imageNamed:@"schedule"],
                        [UIImage imageNamed:@"schedule"]
                        ];
    self.sidebar = [[RNFrostedSidebar alloc] initWithImages:images];
    self.sidebar.delegate = self;
    
    
    
}

#pragma -mark MapViewDelegate
- (void)tappedCell:(NSArray *)array {
    self.nameLabel.text = array[0];
    self.placeLabel.text = array[1];
    self.imageView.image = [UIImage imageNamed:@"calendar2"];
}

@end
