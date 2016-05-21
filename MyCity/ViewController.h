//
//  ViewController.h
//  MyCity
//
//  Created by Admin on 05/11/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define kNotificationGotoDetailAppointment @"gotoPageDetail"
@protocol SampleProtocolDelegate <NSObject>
@required
//- (void) processCompleted;
@end
@import GoogleMaps;



@interface ViewController : UIViewController<GMSMapViewDelegate>
{
    UILabel *label,*lbl2,*lblTitle;
    UILabel *klabel;
    CGFloat currentZoom;
      NSMutableArray *arrayData,*arrayStore;
    CLLocationManager *locationManager;
     id <SampleProtocolDelegate> _delegate;
    NSUInteger nav;
    NSTimer *timer;
    float  zoomLevel;
    NSString *zoomer;
    
    
}

@property (nonatomic,strong) id delegate;
@property (strong, nonatomic) IBOutlet UIView *viewLocation;
//@property (nonatomic, weak) id <> delegate;
@property (strong,nonatomic)IBOutlet UITableView *tblParking;
@property (strong,nonatomic)NSMutableArray *arrayTable;

@property (strong,nonatomic)IBOutlet UIView *roundview;

@property (strong, nonatomic) IBOutlet UIImageView *imgSearch2;
-(void)startSampleProcess;

- (IBAction)funcEnableLocation:(id)sender;


@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentCtrl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentCtrl2;
- (IBAction)funcCallSetting:(id)sender;


@property (strong, nonatomic) IBOutlet UISearchBar *SearchBox;
@property (strong, nonatomic) IBOutlet UILabel *lblParking;
- (IBAction)ActionSegmentControl:(UISegmentedControl *)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblReading;
@property (strong, nonatomic) IBOutlet UIView *ViewMap;
@property (strong, nonatomic) IBOutlet UIView *ViewList;
@property (strong, nonatomic) IBOutlet UILabel *lblOffer;
@property (strong,nonatomic)UIViewController *currentViewController;
- (IBAction)ActionSegmentChange:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblHome;
@property (strong, nonatomic) IBOutlet UILabel *lblAB;
@property (strong, nonatomic) IBOutlet GMSMapView *GMap;
- (IBAction)funcCloseLocationView:(id)sender;



@end

