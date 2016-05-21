//
//  TaxiViewController.h
//  MyCity
//
//  Created by Admin on 24/11/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface TaxiViewController : UIViewController
{
    NSMutableArray *arrayTaxi;
    NSString *imgpath;
    
}
@property (strong,nonatomic)NSMutableArray *arrayService;
@property (strong,nonatomic)NSString *strTitle;
@property (strong, nonatomic) IBOutlet UIImageView *imgbackk;

@property (strong, nonatomic) IBOutlet UIButton *btnbackk;

@property (strong, nonatomic) IBOutlet UILabel *lblPhoneNo;

@property (strong, nonatomic) IBOutlet UITableView *tbltaxi;

@property (strong, nonatomic) IBOutlet UIView *viewCall;
- (IBAction)funcCancelCall:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *funcSetCall;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentCtrl2;
//@property (strong, nonatomic) IBOutlet UISearchBar *SearchBox;
@property (strong, nonatomic) IBOutlet UILabel *lblParking;
@property (strong, nonatomic) IBOutlet UILabel *lblReading;
//@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *lblOffer;
//@property (strong,nonatomic)UIViewController *currentViewController;
- (IBAction)ActionSegmentChange:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblHome;
- (IBAction)FuncCallSetting:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblAB;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;






@end
