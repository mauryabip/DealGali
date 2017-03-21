/*

*/

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface RearViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate,SWRevealViewControllerDelegate>{
    NSArray *lblArr;
    NSArray *imgArray;
    NSArray *categoryDic;
    NSArray *dic;
    NSDictionary *imagDic;

}

@property (weak, nonatomic) IBOutlet UITableView *rearTableView;
@property (strong, nonatomic) SWRevealViewController *viewController;



@end