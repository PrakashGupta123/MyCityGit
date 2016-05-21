//
//  NotiDetailCell.h
//  MyCity
//
//  Created by Pushpendra on 08/01/16.
//  Copyright © 2016 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotiDetailCell : UITableViewCell
@property (strong,nonatomic)IBOutlet UILabel *lblTitle;
@property (strong,nonatomic)IBOutlet UILabel *lblDate;
@property (strong,nonatomic)IBOutlet UILabel *lblDescription;

@property (strong, nonatomic) IBOutlet UIView *viewDescription;

@end
