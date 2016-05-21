//
//  OffersCell.h
//  MyCity
//
//  Created by Admin on 30/12/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OffersCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTotalViews;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblShortDes;
@property (strong, nonatomic) IBOutlet UILabel *lblOfferName;
@property (strong, nonatomic) IBOutlet UIImageView *imgOffer;
@property (strong, nonatomic) IBOutlet UIImageView *imgOfferIcon;
@property (strong, nonatomic) IBOutlet UILabel *lblBrandName;

@end
