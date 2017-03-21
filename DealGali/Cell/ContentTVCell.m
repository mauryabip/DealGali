//
//  ContentTVCell.m
//  DealGali
//
//  Created by Virinchi Software on 11/08/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "ContentTVCell.h"

@implementation ContentTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headingLbl.textColor=[UIColor DGPurpleColor];
    self.headingLbl.font=[UIFont DGTextFieldFont];
    self.specilityLbl.textColor=[UIColor DGPinkColor];
    self.specilityLbl.font=[UIFont DGTextFieldFont];
    self.headingDecLbl.textColor=[UIColor DGDarkGrayColor];
    self.headingDecLbl.font=[UIFont DGTextHome11Font];
    self.specilityDecLbl.textColor=[UIColor DGDarkGrayColor];
    self.specilityDecLbl.font=[UIFont DGTextHome11Font];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
