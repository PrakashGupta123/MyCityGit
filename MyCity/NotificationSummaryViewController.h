//
//  NotificationSummaryViewController.h
//  MyCity
//
//  Created by Admin on 22/12/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationSummaryViewController : UIViewController
- (IBAction)funcNotAll:(id)sender;
- (IBAction)funcBack:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblNotHeading;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet UIView *viewDescription;
@property (strong, nonatomic) IBOutlet UIView *viewNotSummary;
@property (strong, nonatomic) NSMutableDictionary *dictDes;

@end
