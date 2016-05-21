//
//  NationalCell.h
//  MyCity
//
//  Created by Admin on 15/12/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NationalCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblFrom;
@property (strong, nonatomic) IBOutlet UILabel *lblDuration;
@property (strong, nonatomic) IBOutlet UILabel *lblDelayed;
@property (strong, nonatomic) IBOutlet UIImageView *imgStatus;

@end
