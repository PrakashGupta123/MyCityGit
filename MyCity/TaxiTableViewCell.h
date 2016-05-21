//
//  TaxiTableViewCell.h
//  MyCity
//
//  Created by Admin on 24/11/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaxiTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblPhoneNo;
@property (strong, nonatomic) IBOutlet UIImageView *btnCall;
@property (strong, nonatomic) IBOutlet UILabel *lblHeadingTaxi;
@property (strong, nonatomic) IBOutlet UILabel *lblUrl;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UIImageView *imgTaxi;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet UIButton *btnOpenLink;
@property (strong, nonatomic) IBOutlet UIButton *btnCallNo;
@property (strong, nonatomic) IBOutlet UIButton *btnCall2;

@end
