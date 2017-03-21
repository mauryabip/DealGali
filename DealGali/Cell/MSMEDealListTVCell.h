//
//  MSMEDealListTVCell.h
//  DealGali
//
//  Created by Virinchi Software on 15/09/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSMEDealListTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *catNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *viewLbl;
@property (weak, nonatomic) IBOutlet UILabel *distanceLbl;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgVwHT;

@end
