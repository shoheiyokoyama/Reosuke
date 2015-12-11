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

@interface HomeViewController ()<RNFrostedSidebarDelegate>
@property (nonatomic) RNFrostedSidebar *sidebar;
@property (nonatomic) UINavigationController *nav;
@end

@implementation HomeViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
//        self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
//        [self setRNFrostedSidebarSidebar];
        [self setRESideMenu];
//        [self getData];
        
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imageView.image = [UIImage imageNamed:@"tokyo"];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:imageView];
        
        
        
    }
    return self;
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

- (void)getData {
//    [self.manager getJsonData:^(NSMutableArray *items, NSError *error) {
//        //
//        if (error) {
//            //
//        }
//    }];
    
    [self.manager getAreaData:^(NSMutableArray *items, NSError *error) {
        //
    } area:@"豊田"];
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

@end
