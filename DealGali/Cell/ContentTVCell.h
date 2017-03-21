//
//  ContentTVCell.h
//  DealGali
//
//  Created by Virinchi Software on 11/08/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *headingLbl;
@property (weak, nonatomic) IBOutlet UILabel *headingDecLbl;
@property (weak, nonatomic) IBOutlet UILabel *specilityLbl;
@property (weak, nonatomic) IBOutlet UILabel *specilityDecLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *specilityTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headindDecHT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headingDecTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headingHT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *specilityHT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *specilityDecHT;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *specilityDecTOP;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headingTOPConst;


@property (weak, nonatomic) IBOutlet UIButton *callBackBtn;

@property (weak, nonatomic) IBOutlet UIButton *bookAppointmentBtn;

@property (weak, nonatomic) IBOutlet UIImageView *callBackImageView;
@property (weak, nonatomic) IBOutlet UIImageView *appointmentImgView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end
