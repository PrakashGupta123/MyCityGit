//
//  NotiDetailViewController.h
//  MyCity
//
//  Created by Pushpendra on 08/01/16.
//  Copyright © 2016 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotiDetailViewController : UIViewController
{
    CGRect heightofview;

}
@property (strong,nonatomic)NSMutableDictionary *dictData;
@property (strong,nonatomic)IBOutlet UITableView *tblNotification;

- (IBAction)funcSettingCall:(id)sender;
- (IBAction)btnBack:(id)sender;

@end
