//
//  DetailViewController.h
//  MyCity
//
//  Created by Pushpendra on 05/11/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrayPrice,*arrayPricename,*arrayPriveval;
    NSMutableArray *arrayRestPrice;
    NSInteger hidden;

}
@property (strong, nonatomic) IBOutlet UIView *viewContainer;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollDetail;

@property (strong, nonatomic) IBOutlet UILabel *lblParkingPrice;

@property (strong, nonatomic) IBOutlet UITableView *tblParkingPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblOpeningHours;
@property (strong, nonatomic) IBOutlet UILabel *lblAvailableSpaces;
@property (strong, nonatomic) IBOutlet UILabel *lblOpeningHrs2;

@property (strong, nonatomic) IBOutlet UILabel *lblRestHours;
@property (strong,nonatomic)NSMutableDictionary *dictData;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectPrice;
@property (strong, nonatomic) IBOutlet UISearchBar *Detailsearch;
@property (strong, nonatomic) IBOutlet UILabel *lblOpenHeading;

@property (strong, nonatomic) IBOutlet UIView *roundview;
@property (strong, nonatomic) IBOutlet UIImageView *imgParkingView;
@property (strong, nonatomic) IBOutlet UILabel *lblDetailSpace;

@property (strong, nonatomic) IBOutlet UIView *priceview;

@property (strong, nonatomic) IBOutlet UIView *distanceview;

@property (strong, nonatomic) IBOutlet UIView *capacityview;


@property (strong, nonatomic) IBOutlet UIView *viewprice2;

@property (strong, nonatomic) IBOutlet UIView *viewTable;
@property (strong, nonatomic) IBOutlet UIView *viewOpeningHrs2;

@property (strong, nonatomic) IBOutlet UIView *viewdistance2;
@property (strong, nonatomic) IBOutlet UIView *viewParkingName;
@property (strong, nonatomic) IBOutlet UIView *viewParkingHeader;
@property (strong, nonatomic) IBOutlet UIView *viewOpeninghrs;

@property (strong, nonatomic) IBOutlet UIView *viewaddress;

@property (strong, nonatomic) IBOutlet UIView *viewAll;
@property (strong, nonatomic) IBOutlet UILabel *lblParkingName;

@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblDistance;
@property (strong, nonatomic) IBOutlet UILabel *lblDisabledSpaces;
@property (strong, nonatomic) IBOutlet UILabel *lblPayment;

@property (strong, nonatomic) IBOutlet UILabel *lblCapacity;

@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UITableView *tblRestHours;
@property (strong, nonatomic) IBOutlet UIView *viewRest1;
@property (strong, nonatomic) IBOutlet UIView *viewRestContainer;

@property (strong, nonatomic) IBOutlet UIView *viewRest2;
@property (strong, nonatomic) IBOutlet UIView *viewSpace1;
@property (strong, nonatomic) IBOutlet UIView *viewSpace2;
@property (strong, nonatomic) IBOutlet UIView *viewPayment1;
@property (strong, nonatomic) IBOutlet UIView *viewAddress2;
@property (strong, nonatomic) IBOutlet UIView *viewpayment2;
@property (strong, nonatomic) IBOutlet UIView *viewAddress1;

- (IBAction)productSizeActionBtn:(id)sender;
- (IBAction)funcSettingCall:(id)sender;

- (IBAction)btnBack:(id)sender;


@end
