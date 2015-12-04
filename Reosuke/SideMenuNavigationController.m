//
//  SideMenuNavigationController.m
//  Reosuke
//
//  Created by Shoehi Yokoyama on 2015/12/02.
//  Copyright © 2015年 Shohei. All rights reserved.
//

#import "SideMenuNavigationController.h"
#import "MenuViewController.h"
#import "UIViewController+REFrostedViewController.h"

@interface SideMenuNavigationController ()
@property (strong, readwrite, nonatomic) MenuViewController *menuViewController;
@end

@implementation SideMenuNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showMenu
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController panGestureRecognized:sender];
}

@end
