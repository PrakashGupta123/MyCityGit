//
//  AppDelegate.h
//  MyCity
//
//  Created by Admin on 05/11/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//http://183.182.87.171/svn/mycityapp/mycityapp/apis/DV
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ViewController.h"
#import "MBProgressHUD.h"
#import <Google/Analytics.h>

#define kNotificationShowMBProgressBar @"showProgress"
#define kNotificationHideMBProgressBar @"hideProgress"
//#define baseUrl @"http://54.229.16.245/apis/DV"
#import "OffersViewController.h"
#define baseUrl @"http://183.182.87.171/svn/mycityapp/mycityapp/apis/DV"
@class HomeViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,MBProgressHUDDelegate>
{
    CLLocationManager *locationManager;NSString *deviceToken;
    ViewController *vc;
     MBProgressHUD *HUD;
    NSTimer *timerBackGround;
 

}
-(BOOL)isCheckConnection;
@property (strong, nonatomic) HomeViewController *myViewController;
@property (strong, nonatomic) OffersViewController *offerVC;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic)BOOL isRegister,IsRefresh,Loader;
@property (strong, nonatomic)NSString *strLong;
@property (strong, nonatomic)NSString *strLat;
@property (strong,nonatomic)NSMutableArray *arrayData;
@property (strong, nonatomic) UITabBarController *tabBarControllerMain;
@property (strong,nonatomic)NSDictionary *dictyLocal;
-(void)SetBadgeViewWithBadgeValue:(NSString *)Str andView:(UIView *)View;

+(AppDelegate*)appDelegate;
-(void)showLoadingAlert:(UIView *)viewControllerName;
-(void)removeLoadingAlert:(UIView *)viewControllerName;
-(void)CheckNotEnabled;
-(void)CheckLocEnabled;
#define IS_IPHONE4 (([[UIScreen mainScreen] bounds].size.height-420)?NO:YES)

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

#define IS_IPHONE6 (([[UIScreen mainScreen] bounds].size.height-667)?NO:YES)

#define IS_IPHONE6plus (([[UIScreen mainScreen] bounds].size.height-736)?NO:YES)



@end

