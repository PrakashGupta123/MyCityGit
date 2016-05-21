//
//  AppDelegate.m
//  MyCity
//
//  Created by Admin on 05/11/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "IQActionSheetPickerView.h"

@import GoogleMaps;
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "ViewController.h"
#import "HomeViewController.h"
#import "LondonTubeViewController.h"
#import "LondonTubeDetailViewController.h"
#import "NationalRailwayViewController.h"
#import "OffersDetailViewController.h"
#import "Reachability.h"
#import "SSKeychain.h"
#import "OffersViewController.h"


@interface AppDelegate ()<UIAlertViewDelegate>
{
   
    BOOL isCalled,isFirst;
    
    
}

@end

@implementation AppDelegate
@synthesize IsRefresh;

-(void)CheckLocEnabled
{

    {
        
        if([CLLocationManager locationServicesEnabled] &&
           [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
        {
            
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
            
            //_viewLocation.hidden=YES;
                    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                    [tracker set:kGAIScreenName value:@"Location Enabled"];
                    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
            
            
        }
        
        else
        {
           
             id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                    [tracker set:kGAIScreenName value:@"Location Disabled"];
                    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
            
        }
        
    }

}
-(void)CheckNotEnabled
{
UIUserNotificationType types =[[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    if (types == UIUserNotificationTypeNone)
    {
        NSLog(@"Disabled");
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Notifications Disabled"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    }
    else
    {
         NSLog(@"Enabled");
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Notifications Enabled"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    }

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //[[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"firstL"];
    _Loader=NO;
    // Override point for customization after application launch.
    [Fabric with:@[[Crashlytics class]]];
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    [[GAI sharedInstance] setTrackUncaughtExceptions:YES];

    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // Optional: set debug to YES for extra debugging information.
    // Create tracker instance.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-74731313-1"];
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
    IsRefresh = NO;
      //[[[[self.tabBarControllerMain tabBar ]items]objectAtIndex:0]setBadgeValue:@"1"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showProgressBar:) name:kNotificationShowMBProgressBar object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideProgressBar:) name:kNotificationHideMBProgressBar object:nil];

    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    //[[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"ALLexpire"];
    //[[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"cexpire"];
   
    
//  [[((UITabBarController *)self.window.rootViewController) viewControllers] objectAtIndex:3];
    
   NSDictionary *localNotif =
    [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
  //  NSDictionary *localNotif = @{@"aps" : @{@"notification_type":@"General"}};
   // self.dictyLocal = localNotif;
    
    if (localNotif)
        
    {
        
            [UIApplication sharedApplication].applicationIconBadgeNumber=0;
            [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"ALLexpire"];
            [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"cexpire"];
            self.dictyLocal = localNotif;
        
    }

    if (launchOptions != nil) {
        
         isFirst = YES;
       
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    isCalled = NO;
    _isRegister = NO;
    isFirst = NO;

 
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:7.0/255.0 green:42.0/255.0 blue:65.0/255.0 alpha:1.0]];
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0],
                                                        NSForegroundColorAttributeName : [UIColor whiteColor]
                                                        } forState:UIControlStateNormal];
    
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0],
                                                        NSForegroundColorAttributeName : [UIColor whiteColor]
                                                        } forState:UIControlStateSelected];
    CGRect screenSize = [[UIScreen mainScreen] applicationFrame];
    int count  = 5;
    float width  = screenSize.size.width/count;
    [[UITabBar appearance] setItemWidth:width];

    
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -15)];
    
    UIImage *selTab = [[UIImage imageNamed:@"imgTap"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    CGRect screen = [[UIScreen mainScreen] bounds];

   CGSize tabSize = CGSizeMake(CGRectGetWidth(screen)/5, 49);
   
    UIGraphicsBeginImageContext(tabSize);
    [selTab drawInRect:CGRectMake(0, 0, tabSize.width, tabSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    UITabBar.appearance.selectionIndicatorImage = UIImage().makeImageWithColorAndSize(UIColor.blueColor(), size: CGSizeMake(tabBar.frame.width/CGFloat(tabBar.items!.count), tabBar.frame.height));
//     [[UITabBar appearance] setSelectionIndicatorImage:uiima
   
    [[UITabBar appearance] setSelectionIndicatorImage:reSizeImage];
   
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
        [self->locationManager requestWhenInUseAuthorization];
        
        [locationManager startUpdatingLocation];
        [locationManager startUpdatingLocation];
        
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [locationManager requestWhenInUseAuthorization];
        }
        
    }
    
    
      //  [];
    
    //-- Set Notification
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
        
      /*  UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];*/
        
        
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    
    
    [GMSServices provideAPIKey:@"AIzaSyAq9DK4eiHNC21JfKmFBc1ppBvDXJkQVkE"];
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
    // [self.myViewController ca];


    //sleep(1.0);
   
    return YES;
}


-(void)callAppDelegateWebservice
{
    
}
- (void)viewWillLayoutSubviews {
//    CGRect tabFrame = self.tabBar.frame;
//    tabFrame.size.height = 80;
//    tabFrame.origin.y = clabel.frame.size.height - 80;
//    self.tabBar.frame = tabFrame;
}

+(AppDelegate*)appDelegate
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}



-(void)showLoadingAlert:(UIView *)viewControllerName
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    //    hud.mode=MBProgressHUDModeDeterminateHorizontalBar;
    hud.labelText = @"Loading ...";
    hud.dimBackground = NO;
    
}
-(void)removeLoadingAlert:(UIView *)viewControllerName {
    [MBProgressHUD hideHUDForView:self.window animated:YES];
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    UIBackgroundTaskIdentifier bgTask = 0;
//    UIApplication  *app = [UIApplication sharedApplication];
//    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
//        [app endBackgroundTask:bgTask];
//    }];
 
    
    
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    timerBackGround = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(BadgeReset:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timerBackGround forMode:NSRunLoopCommonModes];
    
    
    
    
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

-(void)BadgeReset:(NSTimer *)pTmpTimer

{
    NSLog(@"BackGrouund Method Called");
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager.requestSerializer setTimeoutInterval:30.0];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"syscraft" password:@"sis*123"];
    //[httpclient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSString *uuid=[self getUniqueDeviceIdentifierAsString];
    //http://183.182.87.171/svn/mycityapp/mycityapp/apis/DV/notification/badgecount/device_id/
    NSString *path=[NSString stringWithFormat:baseUrl@"/notification/badgecount/device_id/%@",uuid];
    
    manager.requestSerializer.timeoutInterval=10.0;
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSArray *array = responseObject;
         
         if([[[array objectAtIndex:0] valueForKey:@"error"]isEqualToString:@""])
         {
                         NSString *strBadge= [[array objectAtIndex:0] valueForKey:@"badge"];
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
                    }
         else
         {
             
         }
         NSLog(@"BadgeCount  Response: %@", responseObject);
         //[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
         //[[AppDelegate appDelegate] removeLoadingAlert:clabel];
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         NSLog(@"Error:");
         
     }];



}

//- (void)cancelSheetPicker {
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:.50];
//    [UIView commitAnimations];
//}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
//    [vc startSampleProcess ];
    [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"foreground"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationEnabled" object:nil];
   
   // [self cancelSheetPicker];
[[NSNotificationCenter defaultCenter] postNotificationName:@"ManageCount" object:nil];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"DetectController" object:nil];
   
//    self.offerVC = [[OffersViewController alloc] init];
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [appDelegate.offerVC OffersCallingWebService];
    
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
//        self.offerVC = [[OffersViewController alloc] init];
//  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        [appDelegate.offerVC OffersCallingWebService];
    }
    
    [self CheckLocEnabled];
    [self CheckNotEnabled];
    
    
}

-(BOOL)isCheckConnection {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        return YES;
    } else {
        NSLog(@"There IS internet connection");
        return NO;
    }
}


- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions
{
    
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"updateRoot" object:nil];

    return YES;

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
        if (isFirst == YES) {
        
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"indexPathReload"];
        
        [UIApplication sharedApplication].applicationIconBadgeNumber=0;
        NSLog(@"Called");
        

    }
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"indexPathReload"];

    [timerBackGround invalidate];
       [UIApplication sharedApplication].applicationIconBadgeNumber=0;
       // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken{
    
    deviceToken = [[[[devToken description]
                               stringByReplacingOccurrencesOfString:@"<"withString:@""]
                              stringByReplacingOccurrencesOfString:@">" withString:@""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
    [[NSUserDefaults standardUserDefaults] setValue:deviceToken forKey:@"deviceToken"];
    HomeViewController *obj=[[HomeViewController alloc]init];
    obj.DToken=deviceToken;
    
    isCalled=NO;
    
    
    NSLog(@"deviceToken----->%@",deviceToken);
    
    //     UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Message" message:deviceToken delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //    [alertView show];
    
    
    UIApplicationState state = [application applicationState];
    
    
    if (state == UIApplicationStateActive) {
        // UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Message" message:deviceToken delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //[alertView show];
    }
}

- (void) logUser {
    // TODO: Use the current user's information
    // You can call any combination of these three methods
    [CrashlyticsKit setUserIdentifier:@"12345"];
    [CrashlyticsKit setUserEmail:@"user@fabric.io"];
    [CrashlyticsKit setUserName:@"Test User"];
}




/***Failed to Register for Remote Notifications*/
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [[NSUserDefaults standardUserDefaults] setValue:@"hfdjgfhkgfjkdsfhfg" forKey:@"deviceToken"];
    NSLog(@"error---->%@",error);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    isFirst = NO;
   
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    NSDictionary *dict =[userInfo valueForKey:@"aps"];
    
    
       NSLog(@"Notification---->%@",userInfo);
    if(!([dict valueForKey:@"badge"]==[NSNull null]))
    {
    [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKey:@"badge"] forKey:@"BadgeValue"];
    }
    
    
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"indexPathReload"];
    
    IsRefresh = YES;
    
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        //NSString *cancelTitle = @"Close";
        //  NSString *showTitle = @"Show";
        //NSString *message = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName: @"TestNotification" object:dict userInfo:nil];
        
        [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"cexpire"];
         [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"ALLexpire"];
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"deletecache"];
         [UIApplication sharedApplication].applicationIconBadgeNumber=0;
        
        
    }
    else
    {
        [UIApplication sharedApplication].applicationIconBadgeNumber=0;
        [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"ALLexpire"];
        [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"cexpire"];
        
    
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowPopupNotification" object:nil userInfo:userInfo];
        
        
    
    
}
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
   // [errorAlert show];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            // do some error handling
        }
            break;
        default:{
            [self->locationManager startUpdatingLocation];
        }
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    
    if (currentLocation != nil) {
        _strLong= [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        _strLat = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        
        [[NSUserDefaults standardUserDefaults] setValue:_strLat forKey:@"Lat"];
        [[NSUserDefaults standardUserDefaults] setValue:_strLong forKey:@"Long"];
        
        if (isCalled == NO) {
        
       
            
            
        }
        NSLog(@"%@,%@",_strLat,_strLong);
        
    }
}




-(void)showProgressBar:(NSNotification *)notification
{
    HUD = [[MBProgressHUD alloc] initWithView:self.window];
    [self.window addSubview:HUD];
    HUD.labelText = (NSString*)[notification object];
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    //HUD.mode = MBProgressHUDModeCustomView;
    [HUD show:YES];
}

-(void)hideProgressBar:(NSNotification *)notification
{
    [HUD hide:YES];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    
    HUD = nil;
}

-(void)SetBadgeViewWithBadgeValue:(NSString *)strBadge andView:(UIView *)View
{
   // strBadge=@"";
    UILabel *clabel=[[UILabel alloc]init];
    clabel.tag = 1212145454;
    clabel.text = strBadge;
    clabel.textAlignment=NSTextAlignmentCenter;
    if([strBadge integerValue]<=9)
    {
        //[attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(2,1)];
        if(IS_IPHONE4 || IS_IPHONE5)
        {
            
            clabel.frame = CGRectMake(35, 0,30,20);
        }
        else if(IS_IPHONE6)
        {
            
            clabel.frame = CGRectMake(35, 0,30,20);
        }
        else if(IS_IPHONE6plus)
        {
            
            clabel.frame = CGRectMake(35,0,30,20);
        }
    }
    else if([strBadge integerValue]<=99)
    {
       
        
        if(IS_IPHONE4 || IS_IPHONE5)
        {
            
            clabel.frame = CGRectMake(35,0,35,20);;
        }
        else if(IS_IPHONE6)
        {
            
            clabel.frame = CGRectMake(35,0,35,20);
        }
        else if(IS_IPHONE6plus)
        {
            
            clabel.frame = CGRectMake(35,0,35,20);
        }
    }
    else
    {
        
        if(IS_IPHONE4 || IS_IPHONE5)
        {
            
            clabel.frame = CGRectMake(35,0,45,20);
        }
        else if(IS_IPHONE6)
        {
            
            clabel.frame = CGRectMake(35,0,45,20);
        }
        else if(IS_IPHONE6plus)
        {
            
           clabel.frame = CGRectMake(35,0,45,20);
        }
        
    }
    clabel.layer.cornerRadius=10.0;
    clabel.textColor=[UIColor whiteColor];
    clabel.layer.masksToBounds = YES;
    clabel.backgroundColor=[UIColor redColor];
    [View addSubview:clabel];

    if([strBadge isEqualToString:@""])
    {
       
        NSArray *viewsToRemove = [View subviews];
        for (UILabel *v in viewsToRemove) {
            if (v.tag == 1212145454) {
                
                [v removeFromSuperview];
                
            }
        }
        
        
   
    
    }
    else
    {
         clabel.hidden=NO;
    }

    
}


@end
