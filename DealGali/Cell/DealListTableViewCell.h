//
//  DealListTableViewCell.h
//  DealGali
//
//  Created by Virinchi Software on 21/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface DealListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *dealHeading;
@property (weak, nonatomic) IBOutlet UILabel *dealDescrpt;
@property (weak, nonatomic) IBOutlet UILabel *dealPrice;
 
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UIButton *appointmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *companyLogoBtn;
@property (weak, nonatomic) IBOutlet UILabel *viewsLbl;
@property (weak, nonatomic) IBOutlet UIImageView *companyLogoImgView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgVwHT;
@end
