//
//  SplashViewController.m
//  MyCity
//
//  Created by Admin on 22/01/16.
//  Copyright © 2016 Syscraft. All rights reserved.
//

#import "SplashViewController.h"
#import "HomeViewController.h"
#import "AFnetworking.h"
#import "SSKeychain.h"
#import "AppDelegate.h"
#import "UIView+Toast.h"
#import <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>
@interface SplashViewController ()

@end

@implementation SplashViewController

-(BOOL)hidesBottomBarWhenPushed
{
 return YES;
 }

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
//    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSLog(@"Called");
}
- (UIStatusBarStyle) preferredStatusBarStyle

{
    return UIStatusBarStyleLightContent;
}
-(void)disssmisis
{
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"HomeTable" object:nil];
    [self callWebserviceForUserRegister];
    
}

- (NSString*) deviceName
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
    
    static NSDictionary* deviceNamesByCode = nil;
    
    if (!deviceNamesByCode) {
        
        deviceNamesByCode = @{@"i386"      :@"Simulator",
                              @"x86_64"    :@"Simulator",
                              @"iPod1,1"   :@"iPod Touch",      // (Original)
                              @"iPod2,1"   :@"iPod Touch",      // (Second Generation)
                              @"iPod3,1"   :@"iPod Touch",      // (Third Generation)
                              @"iPod4,1"   :@"iPod Touch",      // (Fourth Generation)
                              @"iPod7,1"   :@"iPod Touch",      // (6th Generation)
                              @"iPhone1,1" :@"iPhone",          // (Original)
                              @"iPhone1,2" :@"iPhone",          // (3G)
                              @"iPhone2,1" :@"iPhone",          // (3GS)
                              @"iPad1,1"   :@"iPad",            // (Original)
                              @"iPad2,1"   :@"iPad 2",          //
                              @"iPad3,1"   :@"iPad",            // (3rd Generation)
                              @"iPhone3,1" :@"iPhone 4",        // (GSM)
                              @"iPhone3,3" :@"iPhone 4",        // (CDMA/Verizon/Sprint)
                              @"iPhone4,1" :@"iPhone 4S",       //
                              @"iPhone5,1" :@"iPhone 5",        // (model A1428, AT&T/Canada)
                              @"iPhone5,2" :@"iPhone 5",        // (model A1429, everything else)
                              @"iPad3,4"   :@"iPad",            // (4th Generation)
                              @"iPad2,5"   :@"iPad Mini",       // (Original)
                              @"iPhone5,3" :@"iPhone 5c",       // (model A1456, A1532 | GSM)
                              @"iPhone5,4" :@"iPhone 5c",       // (model A1507, A1516, A1526 (China), A1529 | Global)
                              @"iPhone6,1" :@"iPhone 5s",       // (model A1433, A1533 | GSM)
                              @"iPhone6,2" :@"iPhone 5s",       // (model A1457, A1518, A1528 (China), A1530 | Global)
                              @"iPhone7,1" :@"iPhone 6 Plus",   //
                              @"iPhone7,2" :@"iPhone 6",        //
                              @"iPhone8,1" :@"iPhone 6S",       //
                              @"iPhone8,2" :@"iPhone 6S Plus",  //
                              @"iPad4,1"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Wifi
                              @"iPad4,2"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Cellular
                              @"iPad4,4"   :@"iPad Mini",       // (2nd Generation iPad Mini - Wifi)
                              @"iPad4,5"   :@"iPad Mini",       // (2nd Generation iPad Mini - Cellular)
                              @"iPad4,7"   :@"iPad Mini"        // (3rd Generation iPad Mini - Wifi (model A1599))
                              };
    }
    
    NSString* deviceName = [deviceNamesByCode objectForKey:code];
    
    if (!deviceName) {
        // Not found on database. At least guess main device type from string contents:
        
        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
        else {
            deviceName = @"Unknown";
        }
    }
    
    return deviceName;
    
}

- (NSString *)convertIntoMD5:(NSString *) string{
    const char *cStr = [string UTF8String];
    unsigned char digest[16];
    
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *resultString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [resultString appendFormat:@"%02x", digest[i]];
    return  resultString;
}

-(void)callWebserviceForUserRegister
{
    NSString *uuid=[self getUniqueDeviceIdentifierAsString];
    NSString *hashStr = [self convertIntoMD5:uuid];
    NSLog(@"Encrypted device id is %@",hashStr);
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:[NSString stringWithFormat:@"Device id is %@",hashStr]];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    /*UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Device id" message:uuid delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];*/
    
   /* UIAlertView *alertt=[[UIAlertView alloc]initWithTitle:@"Device Token" message:[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertt show];*/


    ;
    NSString *strVersion = [[UIDevice currentDevice] systemVersion];
    
    //NSString *deviceType = [UIDevice currentDevice].model;
    NSString *deviceType=[self deviceName];
    
    
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *params;
    NSLog(@"uuid-----1%@",uuid);
    
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"Lat"] != nil && [[NSUserDefaults standardUserDefaults]valueForKey:@"Long"] != nil &&  [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"]!= nil) {
        
        params =  @{@"device_type":@"ios",@"device_token":[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"],@"device_id":uuid,@"latitude":[[NSUserDefaults standardUserDefaults]valueForKey:@"Lat"],@"longitude":[[NSUserDefaults standardUserDefaults]valueForKey:@"Long"],@"ios_version":strVersion,@"phone_model":deviceType,@"app_version":version};
        
    }
    
    else
    {
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"] == nil) {
            [[NSUserDefaults standardUserDefaults] setValue:@"hfdjgfhkgfjkdsfhfg" forKey:@"deviceToken"];
        }
        else
        {
            
            NSLog(@"PRAKSH");
            
        }
        
        params =  @{@"device_type":@"ios",@"device_token":[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"],@"device_id":uuid,@"latitude":@"22.7000",@"longitude":@"75.9000",@"ios_version":strVersion,@"phone_model":deviceType,@"app_version":version};
    }
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     [manager.requestSerializer setTimeoutInterval:5.0];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"Basic c3lzY3JhZnQ6c2lzKjEyMw==" forHTTPHeaderField:@"Authorization"];
    
    
    [manager POST:baseUrl@"/users/user" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {

     
        
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"Register"];
        NSLog(@"%@",responseObject);
        
        
        [self webserviceCarPark3];
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
      //  UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Server Error Please Try Again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        //[alert show];
//         [self.view makeToast:NSLocalizedString(@"Server Error Please Try Again", nil) duration:3.0 position:CSToastPositionCenter];
         [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"Register"];
         [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"BadgeValue"];
        
        [self performSegueWithIdentifier:@"showTabBar" sender:nil];
        NSLog(@"%@",error);
        // [self autoOpen];
        
        
        
    }];
    
    
    
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


-(void)webserviceCarPark3
{
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //
    //    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager.requestSerializer setTimeoutInterval:5.0];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"syscraft" password:@"sis*123"];
    //[httpclient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *uuid=[self getUniqueDeviceIdentifierAsString];
    NSLog(@"uuid-----1%@",uuid);
    NSLog(@"%@",uuid);
    NSString *url;
    //http://183.182.87.171/svn/mycityapp/mycityapp/apis/DV/notification/read_notifications/device_id/device_id_value
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"HasLaunchedOnce"]==NO)
    {
      url= [NSString stringWithFormat:baseUrl@"/notification/read_notifications/device_id/%@",uuid];
    }
    else
    {
    if([[NSUserDefaults standardUserDefaults]valueForKey:@"cexpire"]!=nil)
    {
        
      url= [NSString stringWithFormat:baseUrl@"/notification/home_notifications/device_id/%@/%@",uuid,@"refresh/1"];
    }
    else
    {
      url= [NSString stringWithFormat:baseUrl@"/notification/home_notifications/device_id/%@",uuid];
        
    }
    }
    
    
       
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"%@",responseObject);
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array removeAllObjects];
        NSMutableArray *array2 = [[NSMutableArray alloc] init];
        [array2 removeAllObjects];
        array = responseObject;
        
       // NSLog(@"count of array is %@",array.count);
        NSDictionary *dict = [array objectAtIndex:0];
        if ([[dict valueForKey:@"error"] isEqualToString:@"No Content Found"]) {
            
             [self.view makeToast:NSLocalizedString(@"Device Id is Not Valid", nil) duration:3.0 position:CSToastPositionCenter];
             [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"BadgeValue"];
            
        }
        
       else if ([[dict valueForKey:@"error"] isEqualToString:@""]) {
           array2=[dict valueForKey:@"data"];
           [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
            if(array2.count==0)
            {
                //firstL
               
                [self.view makeToast:NSLocalizedString(@"No Notifications Found", nil) duration:3.0 position:CSToastPositionCenter];
                 [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"BadgeValue"];
                
            }

           else
           {
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"cexpire"];
            arrayHomeData = [[NSMutableArray alloc] init];
            [arrayHomeData removeAllObjects];
            //arrayHomeData = [dict valueForKey:@"data"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array removeAllObjects];
            array = [dict valueForKey:@"data"];
               NSString *strBadge= [dict valueForKey:@"badge"];
               
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
               
               for (int i =0; i<array.count; i++) {
                   
                   if ([[array objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                       NSString *strDate1 = [[array objectAtIndex:i] valueForKey:@"date_added"];
                       
                       NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                       
                       [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                       NSDate *dateFromString = [[NSDate alloc] init];
                       
                       dateFromString = [dateFormatter dateFromString:strDate1];
                       NSString *strDate = [self StringFromDate:dateFromString];
                       NSDictionary *dict = @{@"Date":strDate ,@"Values":[array objectAtIndex:i]};
                       
                       [arrayHomeData addObject:dict];
                       [[NSUserDefaults standardUserDefaults]setObject:arrayHomeData forKey:@"splashArray"];
                       
                   }
               }
            
            
            
          
            
            
        }
//        else
//        {
//            [self performSegueWithIdentifier:@"showTabBar" sender:nil];
//        }
        //[[AppDelegate appDelegate]removeLoadingAlert:self.view];
        }
        
        
        [self performSegueWithIdentifier:@"showTabBar" sender:nil];
  
     
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"BadgeValue"];
        [self performSegueWithIdentifier:@"showTabBar" sender:nil];
        //[self changeRootViewController:newViewController];
        
        
    }];
    
    
    
    
}

- (void)changeRootViewController:(UIViewController*)viewController {
    
    
    if (![AppDelegate appDelegate].window.rootViewController) {
        [AppDelegate appDelegate].window.rootViewController = viewController;
        return;
    }
    
    UIView *snapShot = [[AppDelegate appDelegate].window snapshotViewAfterScreenUpdates:YES];
    
    [viewController.view addSubview:snapShot];
    
    [AppDelegate appDelegate].window.rootViewController = viewController;
    
    [UIView animateWithDuration:0.5 animations:^{
        snapShot.layer.opacity = 0;
        snapShot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
    } completion:^(BOOL finished) {
        [snapShot removeFromSuperview];
    }];
}

-(NSString *)StringFromDate:(NSDate *)DateLocal{
    
    NSDateFormatter *prefixDateFormatter = [[NSDateFormatter alloc] init] ;
    [prefixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [prefixDateFormatter setDateFormat:@"d. MMM, HH:mm"];//June 13th, 2013
    NSString * prefixDateString = [prefixDateFormatter stringFromDate:DateLocal];
    NSDateFormatter *monthDayFormatter = [[NSDateFormatter alloc] init] ;
    [monthDayFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [monthDayFormatter setDateFormat:@"d"];
    int date_day = [[monthDayFormatter stringFromDate:DateLocal] intValue];
    NSString *suffix_string =@"|st|nd|rd|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|st|nd|rd|th|th|th|th|th|th|th|st";
    NSArray *suffixes = [suffix_string componentsSeparatedByString: @"|"];
    NSString *suffix = [suffixes objectAtIndex:date_day];
    
    prefixDateString = [prefixDateString stringByReplacingOccurrencesOfString:@"." withString:suffix];
    NSString *dateString =prefixDateString;
    //  NSLog(@"%@", dateString);
    return dateString;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showTabBar"]) {
        
        [AppDelegate appDelegate].tabBarControllerMain = [segue destinationViewController];
    }
}
@end
