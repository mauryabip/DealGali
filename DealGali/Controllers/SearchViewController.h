//
//  SearchViewController.h
//  DealGali
//
//  Created by Virinchi Software on 23/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SearchViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    bool searchBarActive;
    NSMutableArray *dic;
    NSDictionary *dic1;
}

@property (weak, nonatomic) IBOutlet UILabel *resultLbl;
@end
