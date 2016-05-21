//
//  NationalRailwayViewController.h
//  MyCity
//
//  Created by Admin on 15/12/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NationalRailwayViewController : UIViewController
{
    NSMutableArray *arrayNatRail,*arrN1,*arrN2;
    NSArray *ary1,*ary2;
    NSTimer *timer;
}
@property (strong, nonatomic) IBOutlet UISegmentedControl *segSwitchStation;
- (IBAction)funcSegmentChange:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tblNatRail;
@property (strong, nonatomic) IBOutlet UILabel *lblUpdate;

- (IBAction)funcSettingCall:(id)sender;
- (IBAction)funcBack:(id)sender;


@end
