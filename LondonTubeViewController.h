//
//  LondonTubeViewController.h
//  MyCity
//
//  Created by Admin on 21/11/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LondonTubeDetailViewController.h"
@interface LondonTubeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrayLondonData;
    NSString *localTime;
}
- (IBAction)backBtnAction:(id)sender;
- (IBAction)funcSettingAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tblLondonTube;
@property (strong, nonatomic) IBOutlet UILabel *lblUpdatedTime;
@end
