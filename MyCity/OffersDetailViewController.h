//
//  OffersDetailViewController.h
//  MyCity
//
//  Created by Admin on 30/12/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OffersDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{NSDictionary *arrayDetail;
  NSMutableArray *arraycustom,*arraycustom1,*arraycustom2,*arraycount,*arraycustom3,*arrayOpeningHours;
    NSMutableArray *title;
}
- (IBAction)funcBack:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblProductName;
@property (strong, nonatomic) IBOutlet UIImageView *imgProduct;
@property (strong, nonatomic) IBOutlet UILabel *lblProductDescription;

@property (strong, nonatomic) IBOutlet UITableView *tblCustom;
@property (strong, nonatomic) IBOutlet UITableView *tblOpeningHrs;
@property (strong, nonatomic) IBOutlet UIView *viewOuter;
@property (strong, nonatomic) IBOutlet UIView *viewInner;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblContact;
@property (strong, nonatomic) IBOutlet UILabel *lblEndDate;
@property (strong, nonatomic) IBOutlet UILabel *lblStartDate;
@property (strong, nonatomic) IBOutlet UIView *viewAddress;
@property (strong, nonatomic) IBOutlet UIView *viewWebsite;
@property (strong, nonatomic) IBOutlet UILabel *lblUrl;
@property (strong, nonatomic) IBOutlet UIView *ViewDate;

@property (strong, nonatomic) IBOutlet UILabel *lblPrice1;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet UILabel *lblPrice2;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice3;
@property (strong, nonatomic) IBOutlet UILabel *lblProductHeading;
@property (strong, nonatomic) IBOutlet UILabel *lblBrandName;
@property (strong, nonatomic) IBOutlet UIView *viewDate1;
@property (strong, nonatomic) IBOutlet UIView *viewWebsite1;
@property (strong, nonatomic) IBOutlet UIView *viewAddress1;
@property (strong, nonatomic) IBOutlet UILabel *lblEndDate1;
@property (strong, nonatomic) IBOutlet UIView *viewiOSUrl;
@property (strong, nonatomic) IBOutlet UIView *viewAndroidUrl;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalViews;
@property (strong, nonatomic) IBOutlet UILabel *lbliOSUrl;
@property (strong, nonatomic) IBOutlet UILabel *lblAndroidUrl;
@property (strong, nonatomic) IBOutlet UIView *viewiOSUrl1;
@property (strong, nonatomic) IBOutlet UIView *viewAndroidUrl2;
@property (strong, nonatomic) IBOutlet UIView *viewProductImage;

@property (strong, nonatomic) IBOutlet UILabel *lblimgDiscount;
@property (strong, nonatomic) IBOutlet UIView *viewFull;

@end
