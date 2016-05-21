//
//  OffersViewController.m
//  MyCity
//
//  Created by Admin on 30/12/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import "OffersViewController.h"
#import "OffersCell.h"
#import "OffersDetailViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "LocationHelper.h"
#import "IQActionSheetPickerView.h"
#import <UIImageView+AFNetworking.h>
#import "SSKeychain.h"
#import "UIImageView+WebCache.h"
#import "UIView+Toast.h"

@interface OffersViewController ()<CLLocationManagerDelegate,IQActionSheetPickerViewDelegate,UITextFieldDelegate>
{
    NSString *strADDRES,*strDropSelect;
    BOOL  isSearching ;
}
@end

@implementation OffersViewController
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
  /*  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.tabBarControllerMain = self.tabBarController;*/
}
- (UIStatusBarStyle) preferredStatusBarStyle

{
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ChkClass:)
                                                 name:@"DetectController" object:nil];
     [[AppDelegate appDelegate] CheckLocEnabled];
     [[AppDelegate appDelegate] CheckNotEnabled];
    //[NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(refreshOffers) userInfo:nil repeats:NO];
    
    if ([AppDelegate appDelegate].IsRefresh == YES) {
        
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Offer"] != nil) {
            
            //NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"Offer"];
                          //  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"arrayOffers"];
                [AppDelegate appDelegate].IsRefresh = NO;
                
                
                
            
            
            
        }
    }
    

    
   /*  NSObject * object2=[[NSUserDefaults standardUserDefaults]objectForKey:@"arrayOffers"];
    if(object2 != nil)
    {
        arrayOffers=[[NSUserDefaults standardUserDefaults]valueForKey:@"arrayOffers"];
    }
    
    else
    {
        [self OffersCallingWebService];
    }*/
//[[NSNotificationCenter defaultCenter] postNotificationName: @"TestNotification" object:nil userInfo:nil];
    if([AppDelegate appDelegate].isCheckConnection){
        
        //Internet connection not available. Please try again.
        
        //        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Internate error" message:@"Internet connection not available. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alertView show];
        
        if([[NSUserDefaults standardUserDefaults] valueForKey:@"arrayOffers"] != nil)
        {
           // arrayOffers =[[NSUserDefaults standardUserDefaults] valueForKey:@"arrayOffers"];
            
           // [_tblOffers reloadData];
            
        }
        
        
        [self.view makeToast:NSLocalizedString(@"Internet Connection Not Available Please Try Again", nil) duration:3.0 position:CSToastPositionCenter];
     //   [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
        
    }

    else
    {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Offers Screen"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    [self OffersCallingWebService];
    }

}
- (void)ChkClass:(NSNotification *)note
{
    NSLog(@"hi");
    [self OffersCallingWebService22];

    UIViewController *vc = [[self.navigationController viewControllers] firstObject];
     NSLog(@"class is %@",[vc class]);
       if([NSStringFromClass([vc class])isEqualToString:@"OffersViewController"])
    {
       
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:@"Your current view controller:" message:@"offers VC" delegate:nil
//                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
//         [alert show];
       // [self cancelSheetPicker];
        //[self.actionSheetController dismissWithCompletion:nil];
        
    }

        // code here
//    }    if ([NSStringFromClass([currentVC class]) isEqualToString:@"OffersViewController"])
//    {
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:@"Your current view controller:" message:NSStringFromClass([currentVC class]) delegate:nil
//                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        
//
//    }
//

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 14, 14)];
    img.image = [UIImage imageNamed:@"icon_search.png"];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, _txtSearch.frame.size.height)];
    [paddingView addSubview:img];
    _txtSearch.leftView = paddingView;
    [_txtSearch setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _txtSearch.leftViewMode = UITextFieldViewModeAlways;
    sort=@"0";
    isSearching = NO;
    arraySearch=[[NSMutableArray alloc]init];
    [arraySearch removeAllObjects];
    NSString *start = @"2010-09-01";
    NSString *end = @"2010-09-03";
    // self.btnDropdown.layer.borderWidth = 1.0;
    self.btnDropdown.layer.cornerRadius = 5.0;
    self.txtSearch.delegate = self;
    
    UIButton *defaultClearButton = [UIButton appearanceWhenContainedIn:[UITextField class], nil];
    [defaultClearButton setBackgroundImage:[UIImage imageNamed:@"imgSea.png"] forState:UIControlStateNormal];
    
    
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [f dateFromString:start];
    NSDate *endDate = [f dateFromString:end];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:startDate toDate:endDate
                                                         options:NSCalendarWrapComponents];
    
    NSLog(@"day left %ld",(long)components.day);
    
    
    arrayOffers=[[NSMutableArray alloc]init];
    [arrayOffers removeAllObjects];
    arrayTime=[[NSMutableArray alloc]init];
    [arrayTime removeAllObjects];
    
    
  /*  NSObject * object2=[[NSUserDefaults standardUserDefaults]objectForKey:@"arrayOffers"];
    
    if(object2 != nil)
     {
     arrayOffers=[[NSUserDefaults standardUserDefaults]valueForKey:@"arrayOffers"];
     }
     
     else
     {
     [self OffersCallingWebService];
     }*/
    
    //[self OffersCallingWebService];
    
    
    
    
    // NSString *StrMy = [self getAddressFromLatLon:22.7000 withLongitude:75.9000];
    
    // NSString *StrMy2 = [self getAddressFromLatLon:23.2500 withLongitude:77.4167];
    
    // [self getTimeDurationFrom:StrMy andDestination:StrMy2];
    
    
    
    // Do any additional setup after loading the view.
    // [self CheckLocationService];
}

-(void)CheckLocationService
{
    
    
}



-(void)refreshOffers
{
   // [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"arrayOffers"];
}

-(void)OffersCallingWebService22
{
    //[[AppDelegate appDelegate] showLoadingAlert:self.view];
    // [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowMBProgressBar object:@"Loading..."];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"syscraft" password:@"sis*123"];
    //[httpclient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:30.0];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSString *path;
    
    NSString *uuid=[self getUniqueDeviceIdentifierAsString];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Offer"]!=nil)
    {
        
        path=[NSString stringWithFormat:baseUrl@"/offers/index/refresh/1/device_id/%@",uuid];
        
    }
    else
    {
        path=[NSString stringWithFormat:baseUrl@"/offers/index/device_id/%@",uuid];
    }
    
    
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if ([[responseObject valueForKey:@"error"] isEqualToString:@"No Content Found"]) {
             
             [self.view makeToast:NSLocalizedString(@"Device Id is Not Valid", nil) duration:3.0 position:CSToastPositionCenter];
             
             
         }
         
         
         
         
         else if([[responseObject valueForKey:@"error"]isEqualToString:@""])
         {
             NSMutableArray *array = [[NSMutableArray alloc]init];
             [array removeAllObjects];
             
             array =[responseObject valueForKey:@"data"];
             if(array.count==0)
             {
                 
                 [self.view makeToast:NSLocalizedString(@"No Data Found", nil) duration:3.0 position:CSToastPositionCenter];
                 
             }
             else
             {
                 NSString *strBadge= [responseObject valueForKey:@"badge"];
                 if([strBadge isKindOfClass:[NSNull class]]|| [strBadge isEqual: [NSNull null]])
                 {
                     NSLog(@"NULl");
                     [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"BadgeValue"];
                     [UIApplication sharedApplication].applicationIconBadgeNumber=0;
                     
                 }
                 else
                 {
                     
                     if (![strBadge isEqualToString:@""] && ![strBadge isEqualToString:@"0"]&&![strBadge isEqual: [NSNull null]]&& !(strBadge==nil)) {
                         [[NSUserDefaults standardUserDefaults]setValue:strBadge forKey:@"BadgeValue"];
                         [UIApplication sharedApplication].applicationIconBadgeNumber=[[[NSUserDefaults standardUserDefaults] valueForKey:@"BadgeValue"]integerValue];
                     }
                     else
                     {
                         [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"BadgeValue"];
                         [UIApplication sharedApplication].applicationIconBadgeNumber=[[[NSUserDefaults standardUserDefaults] valueForKey:@"BadgeValue"]integerValue];
                         
                     }
                 }
                 //[[self.tabBarController.tabBar.items objectAtIndex:0] setBadgeValue:badgeC];
                 
                 [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"Offer"];
                 arrayOffers=[[NSMutableArray alloc]init];
                 [arrayOffers removeAllObjects];
                 
                 arrayOffers1=[[NSMutableArray alloc]init];
                 [arrayOffers1 removeAllObjects];
                 arrayDropDown=[[NSMutableArray alloc]init];
                 [arrayDropDown removeAllObjects];
                 
                 arrayDistance=[[NSMutableArray alloc]init];
                 [arrayDistance removeAllObjects];
                 
                 
                 
                 
                 if([CLLocationManager locationServicesEnabled] &&
                    [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
                 {
                     sort=@"0";
                     [arrayDropDown addObject:@"Distance"];
                     
                     
                     if([[[UIDevice currentDevice] systemVersion] floatValue] <= 7.0)
                     {
                         locationManager = [[CLLocationManager alloc] init];
                         [locationManager setDelegate:self];
                         [locationManager setDistanceFilter:kCLHeadingFilterNone];
                         //change the desired accuracy to kCLLocationAccuracyBest
                         [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
                         //SOLUTION: set setPausesLocationUpdatesAutomatically to NO
                         [locationManager setPausesLocationUpdatesAutomatically:NO];
                         [locationManager startUpdatingLocation];
                     }
                     else
                     {
                         
                         locationManager = [[CLLocationManager alloc] init];
                         locationManager.delegate = self;
                         locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                         [locationManager requestWhenInUseAuthorization];
                         
                         [locationManager startUpdatingLocation];
                         
                         if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
                         {
                             [locationManager requestWhenInUseAuthorization];
                         }
                         
                     }
                     
                     double lat=[[AppDelegate appDelegate].strLat doubleValue];
                     double lon=[[AppDelegate appDelegate].strLong doubleValue];
                     //double lat=23.2500;
                     //double lon=77.4167;
                     //lat=@"51.4594086";
                     //lon=@"-0.9731692";
                     
                     for(int i=0;i<[array count];i++)
                     {
                         
                         
                         CLLocation *locA = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
                         
                         double lat1=[[[array objectAtIndex:i ] valueForKey:@"offer_latitude"] floatValue];
                         
                         double lon1=[[[array objectAtIndex:i ] valueForKey:@"offer_longitude"] floatValue];
                         CLLocation *locB = [[CLLocation alloc] initWithLatitude:lat1  longitude:lon1];
                         
                         CLLocationDistance distance = [locA distanceFromLocation:locB];
                         
                         NSString *dis=[NSString stringWithFormat:@"%.1fmi",(distance/1609.344)];
                         NSLog(@"distancein Km is %@",dis);
                         NSDictionary *dict = [array objectAtIndex:i];
                         
                         NSString *lastViewedString = [[array objectAtIndex:i ] valueForKey:@"offer_end_date"];
                         
                         NSDateFormatter *f = [[NSDateFormatter alloc] init];
                         [f setDateFormat:@"yyyy-MM-dd"];
                         NSDate *startDate = [NSDate date];
                         NSDate *endDate = [f dateFromString:lastViewedString];
                         
                         NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                         NSDateComponents *components =[gregorianCalendar components:NSDayCalendarUnit
                                                                            fromDate:startDate toDate:endDate options:0];
                         
                         
                         
                         NSDictionary *dictData = @{@"Popularity":[[array objectAtIndex:i] valueForKey:@"total_views"],@"Distance":dis,@"Day Of Expiry":[NSString stringWithFormat:@"%ld",(long)[components day]],@"Alphabetically":[[array objectAtIndex:i] valueForKey:@"offer_name"],@"Values":dict};
                         
                         
                         [arrayOffers1 addObject:dictData];
                         
                         
                         
                     }
                     
                     NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Distance" ascending:YES];
                     arrayOffers = [[arrayOffers1 sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]mutableCopy];
                     
                     
                 }
                 
                 else
                 {
                     
                     
                     sort=@"1";
                     
                     for(int i=0;i<[array count];i++)
                     {
                         NSDictionary *dict = [array objectAtIndex:i];
                         NSDateFormatter *f=[[NSDateFormatter alloc] init];
                         [f setDateFormat:@"yyyy-MM-dd"];
                         NSString *start = [f stringFromDate:[NSDate date]];
                         
                         NSString *end = [[[array objectAtIndex:i]valueForKey:@"last_updated"]substringToIndex:9];
                         
                         NSDate *startDate = [f dateFromString:start];
                         NSDate *endDate = [f dateFromString:end];
                         
                         NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                         NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:startDate toDate:endDate
                                                                              options:NSCalendarWrapComponents];
                         NSLog(@"day left %ld",(long)components.day);
                         NSString *daysleft=[NSString stringWithFormat:@"%ld",(long)components.day];
                         
                         NSDictionary *dictData = @{@"Popularity":[[array objectAtIndex:i] valueForKey:@"total_views"],@"Distance":@"",@"Day Of Expiry":daysleft,@"Alphabetically":[[array objectAtIndex:i] valueForKey:@"offer_name"],@"Values":dict};
                         
                         
                         [arrayOffers1 addObject:dictData];
                         
                         
                         
                     }
                     NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Charcter" ascending:YES];
                     arrayOffers = [[arrayOffers1 sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]mutableCopy];
                     
                     
                 }
                 
                 [arrayDropDown addObject:@"Upcoming"];
                 [arrayDropDown addObject:@"Day Of Expiry"];
                 [arrayDropDown addObject:@"Alphabetically"];
                 [arrayDropDown addObject:@"Popularity"];
                 [arrayDropDown addObject:@"Date"];
                 
                 
                 [_tblOffers reloadData];
                 
                 [[NSUserDefaults standardUserDefaults]setObject:arrayOffers forKey:@"arrayOffers"];
             }
             
             
             NSLog(@"Offers Response: %@", arrayOffers);
             arrayStore=[[NSMutableArray alloc]init];
             [arrayStore removeAllObjects];
             arrayStore = arrayOffers;
         }
         //   [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
         //[[AppDelegate appDelegate] removeLoadingAlert:self.view];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         //[[AppDelegate appDelegate] removeLoadingAlert:self.view];
         [self.view makeToast:NSLocalizedString(@"Server Error Please Try Again", nil) duration:3.0 position:CSToastPositionCenter];
         if([[NSUserDefaults standardUserDefaults] valueForKey:@"arrayOffers"] != nil)
         {
             // arrayOffers =[[NSUserDefaults standardUserDefaults] valueForKey:@"arrayOffers"];
             
             // [_tblOffers reloadData];
             
         }
         //   [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
         [self.view makeToast:NSLocalizedString(@"Server Error Please Try Again", nil) duration:3.0 position:CSToastPositionCenter];
         
         
     }];
}
-(void)OffersCallingWebService
{
    [[AppDelegate appDelegate] showLoadingAlert:self.view];
    // [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowMBProgressBar object:@"Loading..."];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"syscraft" password:@"sis*123"];
    //[httpclient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:30.0];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSString *path;
    
    NSString *uuid=[self getUniqueDeviceIdentifierAsString];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Offer"]!=nil)
    {
       
        path=[NSString stringWithFormat:baseUrl@"/offers/index/refresh/1/device_id/%@",uuid];
        
    }
    else
    {
         path=[NSString stringWithFormat:baseUrl@"/offers/index/device_id/%@",uuid];
    }

    
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if ([[responseObject valueForKey:@"error"] isEqualToString:@"No Content Found"]) {
             
             [self.view makeToast:NSLocalizedString(@"Device Id is Not Valid", nil) duration:3.0 position:CSToastPositionCenter];
             
             
         }
         

         
         
         else if([[responseObject valueForKey:@"error"]isEqualToString:@""])
         {
             NSMutableArray *array = [[NSMutableArray alloc]init];
             [array removeAllObjects];
             
             array =[responseObject valueForKey:@"data"];
       if(array.count==0)
       {
           
           [self.view makeToast:NSLocalizedString(@"No Data Found", nil) duration:3.0 position:CSToastPositionCenter];
    
        }
             else
             {
                 NSString *strBadge= [responseObject valueForKey:@"badge"];
                 if([strBadge isKindOfClass:[NSNull class]]|| [strBadge isEqual: [NSNull null]])
                 {
                     NSLog(@"NULl");
                     [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"BadgeValue"];
                     [UIApplication sharedApplication].applicationIconBadgeNumber=0;
                     
                 }
                 else
                 {
                     
                     if (![strBadge isEqualToString:@""] && ![strBadge isEqualToString:@"0"]&&![strBadge isEqual: [NSNull null]]&& !(strBadge==nil)) {
                         [[NSUserDefaults standardUserDefaults]setValue:strBadge forKey:@"BadgeValue"];
                         [UIApplication sharedApplication].applicationIconBadgeNumber=[[[NSUserDefaults standardUserDefaults] valueForKey:@"BadgeValue"]integerValue];
                     }
                     else
                     {
                         [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"BadgeValue"];
                         [UIApplication sharedApplication].applicationIconBadgeNumber=[[[NSUserDefaults standardUserDefaults] valueForKey:@"BadgeValue"]integerValue];
                         
                     }
                 }
             //[[self.tabBarController.tabBar.items objectAtIndex:0] setBadgeValue:badgeC];
             
             [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"Offer"];
             arrayOffers=[[NSMutableArray alloc]init];
             [arrayOffers removeAllObjects];
             
             arrayOffers1=[[NSMutableArray alloc]init];
             [arrayOffers1 removeAllObjects];
             arrayDropDown=[[NSMutableArray alloc]init];
             [arrayDropDown removeAllObjects];
             
             arrayDistance=[[NSMutableArray alloc]init];
             [arrayDistance removeAllObjects];
             
             
             
             
             if([CLLocationManager locationServicesEnabled] &&
                [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
             {
                 sort=@"0";
                 [arrayDropDown addObject:@"Distance"];
                 
                 
                 if([[[UIDevice currentDevice] systemVersion] floatValue] <= 7.0)
                 {
                     locationManager = [[CLLocationManager alloc] init];
                     [locationManager setDelegate:self];
                     [locationManager setDistanceFilter:kCLHeadingFilterNone];
                     //change the desired accuracy to kCLLocationAccuracyBest
                     [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
                     //SOLUTION: set setPausesLocationUpdatesAutomatically to NO
                     [locationManager setPausesLocationUpdatesAutomatically:NO];
                     [locationManager startUpdatingLocation];
                 }
                 else
                 {
                     
                     locationManager = [[CLLocationManager alloc] init];
                     locationManager.delegate = self;
                     locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                     [locationManager requestWhenInUseAuthorization];
                     
                     [locationManager startUpdatingLocation];
                     
                     if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
                     {
                         [locationManager requestWhenInUseAuthorization];
                     }
                     
                 }
                 
                 double lat=[[AppDelegate appDelegate].strLat doubleValue];
                 double lon=[[AppDelegate appDelegate].strLong doubleValue];
                 //double lat=23.2500;
                 //double lon=77.4167;
                 //lat=@"51.4594086";
                 //lon=@"-0.9731692";
                 
                 for(int i=0;i<[array count];i++)
                 {
                     
                     
                     CLLocation *locA = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
                     
                     double lat1=[[[array objectAtIndex:i ] valueForKey:@"offer_latitude"] floatValue];
                     
                     double lon1=[[[array objectAtIndex:i ] valueForKey:@"offer_longitude"] floatValue];
                     CLLocation *locB = [[CLLocation alloc] initWithLatitude:lat1  longitude:lon1];
                     
                     CLLocationDistance distance = [locA distanceFromLocation:locB];
                     
                     NSString *dis=[NSString stringWithFormat:@"%.1fmi",(distance/1609.344)];
                     NSLog(@"distancein Km is %@",dis);
                     NSDictionary *dict = [array objectAtIndex:i];
                     
                     NSString *lastViewedString = [[array objectAtIndex:i ] valueForKey:@"offer_end_date"];
                     
                     NSDateFormatter *f = [[NSDateFormatter alloc] init];
                     [f setDateFormat:@"yyyy-MM-dd"];
                     NSDate *startDate = [NSDate date];
                     NSDate *endDate = [f dateFromString:lastViewedString];
                     
                     NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                     NSDateComponents *components =[gregorianCalendar components:NSDayCalendarUnit
                        fromDate:startDate toDate:endDate options:0];
                     
                     
                     
                     NSDictionary *dictData = @{@"Popularity":[[array objectAtIndex:i] valueForKey:@"total_views"],@"Distance":dis,@"Day Of Expiry":[NSString stringWithFormat:@"%ld",(long)[components day]],@"Alphabetically":[[array objectAtIndex:i] valueForKey:@"offer_name"],@"Values":dict};
                     
                     
                     [arrayOffers1 addObject:dictData];
                     
                     
                     
                 }
                 
                 NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Distance" ascending:YES];
                 arrayOffers = [[arrayOffers1 sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]mutableCopy];
                 
                 
             }
             
             else
             {
                 
                
                 sort=@"1";
                 
                 for(int i=0;i<[array count];i++)
                 {
                     NSDictionary *dict = [array objectAtIndex:i];
                     NSDateFormatter *f=[[NSDateFormatter alloc] init];
                     [f setDateFormat:@"yyyy-MM-dd"];
                     NSString *start = [f stringFromDate:[NSDate date]];
                     
                     NSString *end = [[[array objectAtIndex:i]valueForKey:@"last_updated"]substringToIndex:9];
                     
                     NSDate *startDate = [f dateFromString:start];
                     NSDate *endDate = [f dateFromString:end];
                     
                     NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                     NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:startDate toDate:endDate
                                                                          options:NSCalendarWrapComponents];
                     NSLog(@"day left %ld",(long)components.day);
                     NSString *daysleft=[NSString stringWithFormat:@"%ld",(long)components.day];
                     
                     NSDictionary *dictData = @{@"Popularity":[[array objectAtIndex:i] valueForKey:@"total_views"],@"Distance":@"",@"Day Of Expiry":daysleft,@"Alphabetically":[[array objectAtIndex:i] valueForKey:@"offer_name"],@"Values":dict};
                     
                     
                     [arrayOffers1 addObject:dictData];
                     
                     
                     
                 }
                 NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Charcter" ascending:YES];
                 arrayOffers = [[arrayOffers1 sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]mutableCopy];
                 
                 
             }
             
             [arrayDropDown addObject:@"Upcoming"];
             [arrayDropDown addObject:@"Day Of Expiry"];
             [arrayDropDown addObject:@"Alphabetically"];
             [arrayDropDown addObject:@"Popularity"];
             [arrayDropDown addObject:@"Date"];
             
             
             [_tblOffers reloadData];
             
             [[NSUserDefaults standardUserDefaults]setObject:arrayOffers forKey:@"arrayOffers"];
         }
         
         
         NSLog(@"Offers Response: %@", arrayOffers);
         arrayStore=[[NSMutableArray alloc]init];
         [arrayStore removeAllObjects];
         arrayStore = arrayOffers;
         }
      //   [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
        [[AppDelegate appDelegate] removeLoadingAlert:self.view];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         [[AppDelegate appDelegate] removeLoadingAlert:self.view];
          [self.view makeToast:NSLocalizedString(@"Server Error Please Try Again", nil) duration:3.0 position:CSToastPositionCenter];
         if([[NSUserDefaults standardUserDefaults] valueForKey:@"arrayOffers"] != nil)
         {
            // arrayOffers =[[NSUserDefaults standardUserDefaults] valueForKey:@"arrayOffers"];
             
            // [_tblOffers reloadData];
             
         }
      //   [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
         [self.view makeToast:NSLocalizedString(@"Server Error Please Try Again", nil) duration:3.0 position:CSToastPositionCenter];

         
     }];
}


-(NSString *)ChangeToUTC:(NSString*)Date
{
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter1 dateFromString:Date];
    // NSLog(@"date : %@",date);
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:date];
    NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:date];
    NSTimeInterval gmtInterval = currentGMTOffset - gmtOffset;
    NSDate *destinationDate = [[NSDate alloc] initWithTimeInterval:gmtInterval sinceDate:date];
    
    NSDateFormatter *dateFormatters = [[NSDateFormatter alloc] init];
    [dateFormatters setDateFormat:@"yyyy-MM-dd"];
    //[dateFormatters setDateStyle:NSDateFormatterFullStyle];
    //[dateFormatters setTimeStyle:NSDateFormatterMediumStyle];
    // [dateFormatters setDoesRelativeDateFormatting:YES];
    [dateFormatters setTimeZone:[NSTimeZone systemTimeZone]];
    NSString * dateStr = [dateFormatters stringFromDate: destinationDate];
    // NSLog(@"DateString : %@", dateStr);
    return dateStr;
}




- (IBAction)textSearcAction:(UITextField *)sender
{
    if ([sender.text length] == 0)
    {
        
    }
    else
    {
        isSearching=YES;
        
        [self isTableSearchingEnable:sender.text];
        
        sender.text = @"";
        
    }
    
    
}


-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    if ([textField.text length] == 0) {
        
        
    }
    else
    {
        textField.text = @"";
        [self.view endEditing:YES];
        
        if([arrayStore count]>0)
        {
            arrayOffers=[[NSMutableArray alloc]init];
            [arrayOffers removeAllObjects];
            
            arrayOffers=arrayStore;
            [_tblOffers reloadData];
        }
        isSearching = NO;
        
        
    }
    return NO;
    
}


-(void)isTableSearchingEnable:(NSString *)str
{
    //[self.view endEditing:YES];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array removeAllObjects];
    
    for (int i = 0; i<arrayOffers.count; i++) {
        
        [array addObject:[[arrayOffers objectAtIndex:i] valueForKey:@"Charcter"]];
        
        
    }
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",str]; // if you need case sensitive search avoid '[c]' in the predicate
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    [results removeAllObjects];
    results = [[array filteredArrayUsingPredicate:predicate] mutableCopy];
    
    NSMutableArray *ArrayResults = [[NSMutableArray alloc] init];
    [ArrayResults removeAllObjects];
    
    if (results.count != 0) {
        
        
        for (int i = 0; i<results.count; i++) {
            
            for (int j = 0; j<arrayOffers.count; j++) {
                
                if ([[results objectAtIndex:i] isEqualToString:[[arrayOffers objectAtIndex:j] valueForKey:@"Charcter"]]) {
                    
                    [ArrayResults addObject:[arrayOffers objectAtIndex:j]];
                    
                }
            }
            
            
        }
        
    }
    
    
    NSLog(@"ArrayResults --->%@",ArrayResults);
    if (ArrayResults.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"No results found." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alert.tag = 121;
        
        [alert show];
        
        
    }
    else
    {
        arrayOffers = [[NSMutableArray alloc] init];
        [arrayOffers removeAllObjects];
        arrayOffers = ArrayResults;
        [self.tblOffers reloadData];
        
    }
    
    
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    if(IS_IPHONE6 || IS_IPHONE6plus)
        
    {
        return 300;
    }
    else
    {
        return 252;
    }
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [arraySearch count];
    }
    else
    {
        return [ arrayOffers count];
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"OffersCell";
    OffersCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[OffersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
    }
    
    /* NSDictionary *dict = [arrayOffers objectAtIndex:indexPath.row];
     NSString *strDist = [dict valueForKey:@"location"];
     
     dispatch_async(dispatch_get_main_queue(), ^{
     
     LocationHelper *location = [[LocationHelper alloc] init];
     [location getReturnString:strADDRES andStrDestination:strDist];
     
     
     NSLog(@"%@",location.dictData);
     
     });*/
    
    
    
    
    // NSInteger tagval=indexPath.row;
    //NSString *strtimee= [self getTimeDurationFrom:@"indore" andDestination:@"bhopal"];
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        if([sort isEqualToString:@"0"])
        {
            cell.lblTime.text=[[arraySearch objectAtIndex:indexPath.row] valueForKey:@"Distance"];
        }
        else if([sort isEqualToString:@"1"])
        {
            if([[[arraySearch objectAtIndex:indexPath.row] valueForKey:@"Days"] isEqualToString:@"0"])
            {
                cell.lblTime.text=[NSString stringWithFormat:@"%@ Day Left",[[arraySearch objectAtIndex:indexPath.row] valueForKey:@"Days"]];
            }
            else
            {
                cell.lblTime.text=[NSString stringWithFormat:@"%@ Days Left",[[arraySearch objectAtIndex:indexPath.row] valueForKey:@"Days"]];
                
            }
            
        }
        cell.lblOfferName.text=[[[arraySearch objectAtIndex:indexPath.row] valueForKey:@"Values"]valueForKey:@"offer_name"];
        cell.lblShortDes.text=[[[arraySearch objectAtIndex:indexPath.row] valueForKey:@"Values"]valueForKey:@"offer_short_desc"];
        NSURL *imgPath=[[NSURL alloc]initFileURLWithPath:[[[arraySearch objectAtIndex:indexPath.row]valueForKey:@"Values"]valueForKey:@"offer_image"]];
        [cell.imgOffer sd_setImageWithURL:imgPath placeholderImage:nil];
        cell.lblBrandName.text=[[[arraySearch objectAtIndex:indexPath.row]valueForKey:@"Values"]valueForKey:@"offer_brand"];
        cell.lblTotalViews.text=[NSString stringWithFormat:@"Total Views:%@",[[[arraySearch objectAtIndex:indexPath.row]valueForKey:@"Values"]valueForKey:@"total_views"]];
         NSURL *imgPathh=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[arraySearch objectAtIndex:indexPath.row]valueForKey:@"Values"]valueForKey:@"icon_image"]]];
      [cell.imgOfferIcon sd_setImageWithURL:imgPathh placeholderImage:nil];
        cell.imgOfferIcon.layer.cornerRadius=8.0;
               cell.imgOfferIcon.layer.masksToBounds=YES;
        
    }
    else
    {
        
       
        if([sort isEqualToString:@"0"])
        {
            cell.lblTime.text=[[arrayOffers objectAtIndex:indexPath.row] valueForKey:@"Distance"];
        }
        else if([sort isEqualToString:@"1"])
        {
            if([[[arrayOffers objectAtIndex:indexPath.row] valueForKey:@"Day Of Expiry"] isEqualToString:@"0"]|| [[[arrayOffers objectAtIndex:indexPath.row] valueForKey:@"Day Of Expiry"] integerValue]<=0)
            {
                
                cell.lblTime.text=[NSString stringWithFormat:@"0 Day Left"];
                
                
            }
            else
            {
                cell.lblTime.text=[NSString stringWithFormat:@"%@ Days Left",[[arrayOffers objectAtIndex:indexPath.row] valueForKey:@"Day Of Expiry"]];
                
            }
            
            
        }
        cell.lblTotalViews.text=[NSString stringWithFormat:@"Total Views:%@",[[[arrayOffers objectAtIndex:indexPath.row]valueForKey:@"Values"]valueForKey:@"total_views"]];
        cell.lblOfferName.text=[[[arrayOffers objectAtIndex:indexPath.row] valueForKey:@"Values"]valueForKey:@"offer_name"];
        cell.lblShortDes.text=[[[arrayOffers objectAtIndex:indexPath.row] valueForKey:@"Values"]valueForKey:@"offer_short_desc"];
        
        NSURL *imgPath=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[arrayOffers objectAtIndex:indexPath.row]valueForKey:@"Values"]valueForKey:@"offer_image"]]];
        
        NSURL *imgPathh=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[arrayOffers objectAtIndex:indexPath.row]valueForKey:@"Values"]valueForKey:@"icon_image"]]];
        [cell.imgOffer sd_setImageWithURL:imgPath placeholderImage:nil];

        cell.lblBrandName.text=[[[arrayOffers objectAtIndex:indexPath.row]valueForKey:@"Values"]valueForKey:@"offer_brand"];
        [cell.imgOfferIcon sd_setImageWithURL:imgPathh placeholderImage:[UIImage imageNamed:@""]];
      
        cell.imgOfferIcon.layer.cornerRadius=8.0;
        
        cell.imgOfferIcon.layer.masksToBounds=YES;
    }
    NSString *strAddress1 = [[[[arrayOffers objectAtIndex:indexPath.row] valueForKey:@"Values"]valueForKey:@"offer_short_desc"]stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *strAddress=  [strAddress1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect rect = [strAddress boundingRectWithSize:CGSizeMake(self.view.frame.size.width-142 , FLT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor blackColor],  NSParagraphStyleAttributeName : style,NSFontAttributeName: [UIFont systemFontOfSize:11.0f]} context:nil];
    CGSize expectedLabelSizee = rect.size;        //adjust the label the the new height.
    CGRect newFramee = cell.lblShortDes.frame;
    NSLog(@"expected width is %f",expectedLabelSizee.width);;
    NSLog(@"expected height is %f",expectedLabelSizee.height);;

   // NSLog(@"view width is %f",self.view.frame.size.width-142);

    newFramee.size.height = expectedLabelSizee.height;
              //NSLog(@"expected height is %f",expectedLabelSizee.height);;
   
   
   // cell.lblShortDes.translatesAutoresizingMaskIntoConstraints=YES;
    cell.lblShortDes.numberOfLines=2;
    
     cell.lblShortDes.text = strAddress;
    //[cell.lblShortDes sizeToFit];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isSearching==YES)
    {
        NSString *offerid=[[[arraySearch objectAtIndex:indexPath.row]valueForKey:@"Values"]valueForKey:@"offer_id"];
        [[NSUserDefaults standardUserDefaults]setObject:offerid forKey:@"offerid"];
    }
    else
    {
        NSString *offerid=[[[arrayOffers objectAtIndex:indexPath.row]valueForKey:@"Values"]valueForKey:@"offer_id"];
        [[NSUserDefaults standardUserDefaults]setObject:offerid forKey:@"offerid"];
    }
    
    
    OffersDetailViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"OffersDetailViewController"];
    /* NSMutableArray *array = [[NSMutableArray alloc] init];
     [array removeAllObjects];
     array = [[arrrayReading objectAtIndex:indexPath.row] valueForKey:@"service_providers"];
     obj.arrayService = array;
     obj.strTitle =[[arrrayReading objectAtIndex:indexPath.row] valueForKey:@"menu_name"];*/
    
    //[self.navigationController pushViewController:obj animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController: obj animated:YES];
        
    });
    
    
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)funcDropDown:(id)sender {
    arrayDropDown=[[NSMutableArray alloc]init];
    [arrayDropDown removeAllObjects];
    
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        [arrayDropDown addObject:@"Distance"];
        
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] <= 7.0)
        {
            locationManager = [[CLLocationManager alloc] init];
            [locationManager setDelegate:self];
            [locationManager setDistanceFilter:kCLHeadingFilterNone];
            //change the desired accuracy to kCLLocationAccuracyBest
            [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            //SOLUTION: set setPausesLocationUpdatesAutomatically to NO
            [locationManager setPausesLocationUpdatesAutomatically:NO];
            [locationManager startUpdatingLocation];
        }
        else
        {
            
            locationManager = [[CLLocationManager alloc] init];
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            [locationManager requestWhenInUseAuthorization];
            
            [locationManager startUpdatingLocation];
            
            if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            {
                [locationManager requestWhenInUseAuthorization];
            }
            
        }
    }
    
    [arrayDropDown addObject:@"Upcoming"];
    [arrayDropDown addObject:@"Day Of Expiry"];
    [arrayDropDown addObject:@"Alphabetically"];
    [arrayDropDown addObject:@"Popularity"];
    
    [self.view endEditing:YES];
    IQActionSheetPickerView *picker2 = [[IQActionSheetPickerView alloc] initWithTitle:@"Single Picker" delegate:self];
    [picker2 setTag:5];
    [picker2 setActionSheetPickerStyle:IQActionSheetPickerStyleTextPicker];
    
    if (arrayDropDown == nil || arrayDropDown == (id)[NSNull null])
    {
        
    }else{
        
        
        [picker2 setTitlesForComponenets:[NSArray arrayWithObject:arrayDropDown]];
    }
    [picker2 show];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 0;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 0;
}

- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didChangeRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.50];
    [UIView commitAnimations];
}

- (void)cancelSheetPicker {
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.50];
    [UIView commitAnimations];
}

- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray*)titles {
    //sort=@"0";
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        
        
         sort=@"0";
        if([[[UIDevice currentDevice] systemVersion] floatValue] <= 7.0)
        {
            locationManager = [[CLLocationManager alloc] init];
            [locationManager setDelegate:self];
            [locationManager setDistanceFilter:kCLHeadingFilterNone];
            //change the desired accuracy to kCLLocationAccuracyBest
            [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            //SOLUTION: set setPausesLocationUpdatesAutomatically to NO
            [locationManager setPausesLocationUpdatesAutomatically:NO];
            [locationManager startUpdatingLocation];
        }
        else
        {
            
            locationManager = [[CLLocationManager alloc] init];
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            [locationManager requestWhenInUseAuthorization];
            
            [locationManager startUpdatingLocation];
            
            if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            {
                [locationManager requestWhenInUseAuthorization];
            }
            
        }
    }
    else
    {
    sort=@"1";
    }
    if(pickerView.tag==5)
    {
       
        
        
        //NSLog(@"element at index is %@",[zonekeys objectAtIndex:row]);
        NSString *str = [titles componentsJoinedByString:@" - "];
        [self.btnDropdown setTitle:str forState:UIControlStateNormal];
        
        if ([str isEqualToString:@"Upcoming"]) {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSDate *date = [NSDate date];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            arrayOffers = [[NSMutableArray alloc] init];
            [arrayOffers removeAllObjects];
            
            for (int i = 0; i<arrayOffers1.count; i++) {
                
                
                NSString *dateString = [[[arrayOffers1 objectAtIndex:i] valueForKey:@"Values"] valueForKey:@"offer_start_date"];
                NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
                [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
                NSDate *date1 = [dateFormatter1 dateFromString:dateString];
                
                
                
                if ([date compare:date1] == NSOrderedDescending) {
                    NSLog(@"date1 is later than date2");
                    
                } else if ([date compare:date1] == NSOrderedAscending) {
                    NSLog(@"date1 is earlier than date2");
                    
                    [arrayOffers addObject:[arrayOffers1 objectAtIndex:i]];
                    
                    
                } else {
                    NSLog(@"dates are the same");
                    
                }
                
                
                
            }
            
            if (arrayOffers.count == 0) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Upcoming Offers." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            
            [self.tblOffers reloadData];
            
            return;
            
            
            
        }
        
        BOOL status;
        
        if ([str isEqualToString:@"Popularity"]) {
            
            status = NO;
            
        }
        else
        {
            status = YES;
            
        }
        if ([str isEqualToString:@"Day Of Expiry"]) {
            sort=@"1";
        }
        
        if ([str isEqualToString:@"Date"]) {
            
            
            IQActionSheetPickerView *picker2 = [[IQActionSheetPickerView alloc] initWithTitle:@"Date Picker" delegate:self];
            [picker2 setTag:7];
            [picker2 setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
            
            [picker2 setMinimumDate:[NSDate date]];
            
            [picker2 show];
            return;
            
            
            
        }
        
        
        NSSortDescriptor *sortDescriptor =
        [NSSortDescriptor sortDescriptorWithKey:str ascending:status selector:@selector(localizedStandardCompare:)];
        
        arrayOffers = [[NSMutableArray alloc] init];
        [arrayOffers removeAllObjects];
        
        arrayOffers = [[arrayOffers1 sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]mutableCopy];
        
        
        [_tblOffers reloadData];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.50];
        [UIView commitAnimations];
    }
    else if (pickerView.tag == 6)
    {
        arrayDropDown = [[NSMutableArray alloc] init];
        [arrayDropDown removeAllObjects];
        
        
        arrayOffers1 = [[NSMutableArray alloc] init];
        [arrayOffers1 removeAllObjects];
        arrayOffers1 = arrayStore;
        
        
        NSString *str = [titles componentsJoinedByString:@" - "];
        NSLog(@"%@",str);
        
        NSLog(@"%@",arrayOffers1);
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array removeAllObjects];
        
        if ([str isEqualToString:@"All"]) {
            
            
            if([CLLocationManager locationServicesEnabled] &&
               [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
            {
                [arrayDropDown addObject:@"Distance"];
                [arrayDropDown addObject:@"Upcoming"];
                [arrayDropDown addObject:@"Day Of Expiry"];
                [arrayDropDown addObject:@"Alphabetically"];
                [arrayDropDown addObject:@"Popularity"];
                [arrayDropDown addObject:@"Date"];
                
                
                
                NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Distance" ascending:YES];
                arrayOffers = [[arrayOffers1 sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]mutableCopy];
                
                
                
                [self.tblOffers reloadData];
                
            }
            else
            {
                arrayOffers = [[NSMutableArray alloc] init];
                [arrayOffers removeAllObjects];
               
                
                array =  arrayOffers1;
                NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Charcter" ascending:YES];
                arrayOffers = [[arrayOffers1 sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]mutableCopy];
                
                [arrayDropDown addObject:@"Upcoming"];
                [arrayDropDown addObject:@"Day Of Expiry"];
                [arrayDropDown addObject:@"Alphabetically"];
                [arrayDropDown addObject:@"Popularity"];
                [arrayDropDown addObject:@"Date"];
                
                
                [_tblOffers reloadData];
                
                
                
            }
            
            return;
        }
        
        for (int i = 0; i<arrayOffers1.count; i++){
            
            if ([str isEqualToString:[[[arrayOffers1 objectAtIndex:i] valueForKey:@"Values"] valueForKey:@"category_name"]]) {
                [array addObject:[arrayOffers1 objectAtIndex:i]];
                
            }
        }
        
        
        if (array.count == 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Offers." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        else
        {
            arrayOffers = [[NSMutableArray alloc] init];
            [arrayOffers removeAllObjects];
            arrayOffers1 = [[NSMutableArray alloc] init];
            [arrayOffers1 removeAllObjects];
            arrayOffers1 =  array;
            
            if([CLLocationManager locationServicesEnabled] &&
               [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
            {
                [arrayDropDown addObject:@"Distance"];
                [arrayDropDown addObject:@"Upcoming"];
                [arrayDropDown addObject:@"Day Of Expiry"];
                [arrayDropDown addObject:@"Alphabetically"];
                [arrayDropDown addObject:@"Popularity"];
                [arrayDropDown addObject:@"Date"];
                
                
                
                NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Distance" ascending:YES];
                arrayOffers = [[arrayOffers1 sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]mutableCopy];
                
                
                
                [self.tblOffers reloadData];
                
            }
            else
            {
                arrayOffers = [[NSMutableArray alloc] init];
                [arrayOffers removeAllObjects];
                arrayOffers1 = [[NSMutableArray alloc] init];
                [arrayOffers1 removeAllObjects];
                
                arrayOffers1 =  array;
                NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Charcter" ascending:YES];
                arrayOffers = [[arrayOffers1 sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]mutableCopy];
                
                [arrayDropDown addObject:@"Upcoming"];
                [arrayDropDown addObject:@"Day Of Expiry"];
                [arrayDropDown addObject:@"Alphabetically"];
                [arrayDropDown addObject:@"Popularity"];
                [arrayDropDown addObject:@"Date"];
                
                
                [_tblOffers reloadData];
                
                
            }
        }
    }
    else if (pickerView.tag == 7)
    {
        
        NSString *dateString = [titles componentsJoinedByString:@" - "];
        NSLog(@"%@",dateString);
        
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
        NSDate *date1 = [dateFormatter1 dateFromString:dateString];
        arrayOffers = [[NSMutableArray alloc] init];
        [arrayOffers removeAllObjects];
        
        
        for (int i = 0; i<arrayOffers1.count; i++) {
            
            
            NSString *dateString = [[[arrayOffers1 objectAtIndex:i] valueForKey:@"Values"] valueForKey:@"offer_start_date"];
            NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
            NSDate *dateStart = [dateFormatter1 dateFromString:dateString];
            
            
            NSString *dateString2 = [[[arrayOffers1 objectAtIndex:i] valueForKey:@"Values"] valueForKey:@"offer_end_date"];
            NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
            [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
            NSDate *DateEnd = [dateFormatter1 dateFromString:dateString2];
            
            BOOL isDate = [self isDate:date1 inRangeFirstDate:dateStart lastDate:DateEnd];
            
            if (isDate == YES) {
                
                NSLog(@"YES");
                [arrayOffers addObject:[arrayOffers1 objectAtIndex:i]];
                
                
                
                
            }
            else
            {
                NSLog(@"NO");
            }
            
        }
        
        [self.tblOffers reloadData];
        
        
        
        
        
    }
}




- (BOOL)isDate:(NSDate *)date inRangeFirstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate {
    return [date compare:firstDate] == NSOrderedDescending &&
    [date compare:lastDate]  == NSOrderedAscending;
}





- (IBAction)funcCategory:(id)sender
{
    [self offersCallingWebserviceForCategery];
    
}

-(NSString *)getUniqueDeviceIdentifierAsString

{
    
    
    
    NSString *appName=[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    
    
    NSString *strApplicationUUID = [SSKeychain passwordForService:appName account:@"incoding"];
    
    if (strApplicationUUID == nil)
        
    {
        
        strApplicationUUID  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        [SSKeychain setPassword:strApplicationUUID forService:appName account:@"incoding"];
        
    }
    
    
    
    return strApplicationUUID;
    
}



-(void)offersCallingWebserviceForCategery
{
    
    [[AppDelegate appDelegate] showLoadingAlert:self.view];
     //[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowMBProgressBar object:@"Loading..."];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"syscraft" password:@"sis*123"];
    //[httpclient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:30.0];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    
    [manager GET:baseUrl@"/offers/categories_list" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if ([[responseObject valueForKey:@"error"] isEqualToString:@"No Content Found"]) {
             
             [self.view makeToast:NSLocalizedString(@"Device Id is Not Valid", nil) duration:3.0 position:CSToastPositionCenter];
             
             
         }
         
         else if([[responseObject valueForKey:@"error"]isEqualToString:@""])
         {
             
             
             NSMutableArray *newArray = [[NSMutableArray alloc]init];
             [newArray removeAllObjects];
              newArray =[responseObject valueForKey:@"data"];
             if(newArray.count==0)
             {
             [self.view makeToast:NSLocalizedString(@"No Data Found", nil) duration:3.0 position:CSToastPositionCenter];
             
             }
             else
             {
             
             NSMutableArray *secondArray = [[NSMutableArray alloc]init];
             [secondArray removeAllObjects];
             [secondArray addObject:@"All"];
            
             
             NSArray *array=[secondArray arrayByAddingObjectsFromArray:newArray];
             
             
             IQActionSheetPickerView *picker2 = [[IQActionSheetPickerView alloc] initWithTitle:@"Single Picker" delegate:self];
             [picker2 setTag:6];
             [picker2 setActionSheetPickerStyle:IQActionSheetPickerStyleTextPicker];
             
             [picker2 setTitlesForComponenets:[NSArray arrayWithObject:array]];
             [picker2 show];
             
         }
      //   [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
         [[AppDelegate appDelegate] removeLoadingAlert:self.view];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
      //   [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
         [[AppDelegate appDelegate] removeLoadingAlert:self.view];
         
         
     }];
    
    
}



@end
