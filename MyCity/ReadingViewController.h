//
//  ReadingViewController.h
//  MyCity
//
//  Created by Admin on 25/11/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrrayReading;
}

@property (strong, nonatomic) IBOutlet UITableView *tblReading;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentCtrl2;
@property (strong, nonatomic) IBOutlet UILabel *lblParking;

@property (strong, nonatomic) IBOutlet UILabel *lblReading;
@property (strong, nonatomic) IBOutlet UILabel *lblOffer;
- (IBAction)ActionSegmentChange:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblHome;
- (IBAction)FuncCallSetting:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblAB;



- (IBAction)ActionbackBtn:(id)sender;



@end
