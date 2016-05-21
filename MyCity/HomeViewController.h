//
//  HomeViewController.h
//  MyCity
//
//  Created by Saycraft on 16/11/15.
//  Copyright (c) 2015 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController
{
    NSMutableArray *arrayHome,*arrayHomeData,*arraData;
    UILabel *label1;
    //UILabel *clabel;
    UIView *sectionView;
}

@property (strong, nonatomic) IBOutlet UITableView *tblHome;
@property (strong, nonatomic) NSString *DToken;
@property (strong, nonatomic) UILabel *clabel;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentCtrl2;
@property (strong, nonatomic) IBOutlet UISearchBar *SearchBox;
@property (strong, nonatomic) IBOutlet UILabel *lblParking;

@property (strong, nonatomic) IBOutlet UILabel *lblReading;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *lblOffer;
@property (strong,nonatomic)UIViewController *currentViewController;
- (IBAction)ActionSegmentChange:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblHome;
- (IBAction)FuncCallSetting:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblAB;
-(void)callWebserviceForUserRegister;
-(void)startSampleProcess; // Instance method

@end
