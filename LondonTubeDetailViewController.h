//
//  LondonTubeDetailViewController.h
//  MyCity
//
//  Created by Admin on 09/12/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LondonTubeDetailViewController : UIViewController
{
NSString *stnName,*strImageStatus;
}
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblHeading;
@property (strong, nonatomic) IBOutlet UIImageView *imsStatusImage;
@property (strong, nonatomic) IBOutlet UILabel *lblStatusDescription;
- (IBAction)funcBack:(id)sender;
- (IBAction)funSettingCall:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *viewStatusDescription;
@property (strong, nonatomic) IBOutlet UIView *viewCurrentStatus;

@end
