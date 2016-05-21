//
//  OffersViewController.h
//  MyCity
//
//  Created by Admin on 30/12/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface OffersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate>

{
    NSMutableArray *arrayOffers,*arrayOffers1,*arrayTime,*arraycity1,*arraycity2,*arrayDropDown,*arrayDistance,*arraySearch,*arrayStore;
    NSArray *arraycategories,*arraySorting;
    NSString *strLat,*strLong,*sort;
     CLLocationManager *locationManager;
    CLLocation *LocationAtual;
     NSString *strTime;
    NSString *tempval;
}
@property (strong, nonatomic) IBOutlet UIButton *btnDropdown;
@property (strong, nonatomic) IBOutlet UITableView *tblOffers;
- (IBAction)funcDropDown:(id)sender;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBox;
@property (strong, nonatomic) IBOutlet UITextField *txtSearch;

- (IBAction)textSearcAction:(UITextField *)sender;
@property (strong, nonatomic) IBOutlet UITableView *tblCategories;
- (IBAction)funcCategory:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *tblSort;
-(void)OffersCallingWebService;
@end
