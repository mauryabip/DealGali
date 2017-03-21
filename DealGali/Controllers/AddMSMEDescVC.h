//
//  AddMSMEDescVC.h
//  DealGali
//
//  Created by Virinchi Software on 06/09/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface AddMSMEDescVC : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSArray *catArray;
    NSArray *msmeCatArray;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;

@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end
