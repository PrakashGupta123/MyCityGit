//
//  SettingViewController.h
//  MyCity
//
//  Created by Admin on 23/11/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController
{
    NSString *Val;

}
@property (strong, nonatomic) IBOutlet UILabel *lblAppVersion;
- (IBAction)funcBack:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *viewSetting;
- (IBAction)funcLocation:(id)sender;
- (IBAction)funcNotification:(id)sender;
- (IBAction)funcNotificationSound:(id)sender;
- (IBAction)funcOpenMail:(id)sender;
- (IBAction)funcOpenWebView:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIImageView *imgSet;
@property (strong, nonatomic) IBOutlet UIWebView *webViewHTML;

@end
