//
//  CustomCollectionViewCell.h
//  Reosuke
//
//  Created by Shohei Yokoyama on 2015/12/11.
//  Copyright © 2015年 Shohei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *shopImage;
@property (weak, nonatomic) IBOutlet UILabel *shopName;

@end
