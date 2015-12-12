//
//  CustomCollectionViewCell.m
//  Reosuke
//
//  Created by Shohei Yokoyama on 2015/12/11.
//  Copyright © 2015年 Shohei. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@implementation CustomCollectionViewCell

- (void)awakeFromNib {
    [self.backButton addTarget:self action:@selector(tapBackButton:) forControlEvents:UIControlEventTouchDown];
    [self.nextButton addTarget:self action:@selector(tapNextButton:) forControlEvents:UIControlEventTouchDown];
    
    self.okLabel.layer.cornerRadius = 5.0f;
}

#pragma -mark Tap Action
-(void)tapBackButton:(UIButton*)button{
    if ([self.delegate respondsToSelector:@selector(tappedBack)]) {
        [self.delegate tappedBack];
    }
}

-(void)tapNextButton:(UIButton*)button{
    if ([self.delegate respondsToSelector:@selector(tappedNext)]) {
        [self.delegate tappedNext];
    }
}



@end
