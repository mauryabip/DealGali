//
//  NotificationViewController.h
//  DealGali
//
//  Created by Virinchi Software on 21/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface NotificationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSArray *notificationArr;
    UIRefreshControl *refreshControl;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *notiLBL;

@end
