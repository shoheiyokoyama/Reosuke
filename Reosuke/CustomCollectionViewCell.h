//
//  CustomCollectionViewCell.h
//  Reosuke
//
//  Created by Shohei Yokoyama on 2015/12/11.
//  Copyright © 2015年 Shohei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomCollection;
@protocol CustomCollectionDelegate <NSObject>
@optional
- (void)tappedBack;
- (void)tappedNext;
@end

@interface CustomCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *shopImage;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic, weak) id<CustomCollectionDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *okLabel;

@end
