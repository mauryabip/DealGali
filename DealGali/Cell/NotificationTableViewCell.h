//
//  NotificationTableViewCell.h
//  DealGali
//
//  Created by Virinchi Software on 21/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *dealHeading;
@property (weak, nonatomic) IBOutlet UILabel *dealDescrpt;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@end
