//
//  ListCell.h
//  MyCity
//
//  Created by Pushpendra on 06/11/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *viewCell;
@property (strong,nonatomic)IBOutlet UILabel *lblParkName;
@property (strong,nonatomic)IBOutlet UILabel *lblPrice;
@property (strong,nonatomic)IBOutlet UILabel *lblDistance;
@property (strong,nonatomic)IBOutlet UILabel *lblcapacity;
@property (strong,nonatomic)IBOutlet UIView *viewBorder;

@property (strong,nonatomic)IBOutlet UIView  *roundviewtable;





@end
