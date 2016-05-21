

//
//  HomeViewController.m
//  MyCity
//
//  Created by Saycraft on 16/11/15.
//  Copyright (c) 2015 Syscraft. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
//#import "ViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "LondonTubeViewController.h"
#import "TaxiViewController.h"
#import "SettingViewController.h"
#import "ReadingViewController.h"
#import "SSKeychain.h"
#import "NotificationSummaryViewController.h"
#import "NotiDetailViewController.h"
#import "OffersDetailViewController.h"
#import "LondonTubeDetailViewController.h"
#import "SplashViewController.h"
#import  "NationalRailwayViewController.h"
#import "UIView+Toast.h"
#import <sys/utsname.h>
#import "MKNumberBadgeView.h"
#import <Google/Analytics.h>
#import <CommonCrypto/CommonDigest.h>


@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrayForBool;
    BOOL isHieght;
    UIView *backgrView;
    NSDictionary *dictNotiData;
    NSInteger intTmp;
    NSString *strNoti;
}

@end

@implementation HomeViewController
@synthesize tblHome;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[AppDelegate appDelegate] CheckNotEnabled];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showNoti:)
                                                 name:@"ShowPopupNotification" object:nil];
    isHieght = NO;
    //[[AppDelegate appDelegate] SetBadgeViewWithBadgeValue:@"33" andView:self.tabBarController.tabBar];
    
    intTmp = 1.0;
    [NSTimer scheduledTimerWithTimeInterval:intTmp target:self selector:@selector(testMethod:) userInfo:nil repeats:YES];

   // HomeTable
    
   /* [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(naviGateNotificatiion:)
                                                 name:@"HomeTable" object:nil];*/
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(naviGateNotification:)
                                                 name:@"navigateHome" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showPopUpNotification:)
                                                 name:@"TestNotification" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ResetBatch:)
                                                 name:@"ManageCount" object:nil];
    
    
    [self setNeedsStatusBarAppearanceUpdate];
    arrayForBool = [[NSMutableArray alloc] init];
    [arrayForBool removeAllObjects];
    arrayHome = [[NSMutableArray alloc] init];
    [arrayHome removeAllObjects];
   // arrayHomeData = [[NSMutableArray alloc] init];
   // [arrayHomeData removeAllObjects];
  /*  arrayHome = [NSMutableArray arrayWithObjects:@{@"Title":@"Notifications",@"ImageIcon":@"imgNotification",@"imageDots":@""},
  @{@"Title":@"London Tube",@"ImageIcon":@"imgLondonTube",@"imageDots":@""},@{@"Title":@"National Rail",@"ImageIcon":@"imgTakeMe",@"imageDots":@""}, nil];
     //[arrayForBool addObject:[NSNumber numberWithBool:NO]];
    for (int i=0; i<[arrayHome count]; i++) {
        if (i == 0) {
            [arrayForBool addObject:[NSNumber numberWithBool:YES]];

            
        }
        else{
        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
        }
    }
    
   */
    
    self.tblHome.dataSource = self;
    self.tblHome.delegate = self;
    
   
    //BOOL collapsed  = [[arrayForBool objectAtIndex:0] boolValue];
   // collapsed = !collapsed;
   // [arrayForBool replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:YES]];
    
    //reload specific section animated
    NSRange range   = NSMakeRange(0, 1);
    NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.tblHome reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
    
    
    if ([AppDelegate appDelegate].dictyLocal) {
        strNoti = @"NOTI";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowPopupNotification" object:nil userInfo:[AppDelegate appDelegate].dictyLocal];
        strNoti = nil;
        
        [AppDelegate appDelegate].dictyLocal = [[NSDictionary alloc] init];
        
    }

    //[tblHome setScrollEnabled:NO];ResetBatch
    
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


-(void)ResetBatch:(NSNotification *)note
{
    
    [self webserviceCarPark3];
}
-(void)showNoti:(NSNotification *)note {
    NSDictionary *userInfo = [note userInfo];
    //[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.tabBarControllerMain = self.tabBarController;
    appDelegate.tabBarControllerMain.selectedIndex=0;
     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
    if (strNoti == nil) {
       
        //    hud.mode=MBProgressHUDModeDeterminateHorizontalBar;
        hud.labelText = @"Loading ...";
        hud.dimBackground = NO;

    }
    else
    {
        [hud hide:YES];
    
    }
//    if([AppDelegate appDelegate].Loader==NO)
//    {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
//        //    hud.mode=MBProgressHUDModeDeterminateHorizontalBar;
//      //  hud.labelText = @"Loading ...";
//       // hud.dimBackground = NO;
//        [hud hide:YES];
//        
//        
//    }
  

    if([[[[userInfo valueForKey:@"aps"]valueForKey:@"notification_type"] lowercaseString]isEqualToString:@"londontube"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:[userInfo valueForKey:@"aps"] forKey:@"LTexpire"];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        LondonTubeDetailViewController *obj=[mainStoryboard instantiateViewControllerWithIdentifier:@"LondonTubeDetailViewController"];
        
        [[NSUserDefaults standardUserDefaults]setValue:[[userInfo valueForKey:@"aps"] valueForKey:@"message"] forKey:@"reason"];
        [[NSUserDefaults standardUserDefaults]setValue:[[userInfo valueForKey:@"aps"]valueForKey:@"severity"] forKey:@"stationImage"];
        
        [[NSUserDefaults standardUserDefaults]setValue:[[userInfo valueForKey:@"aps"] valueForKey:@"title"] forKey:@"stationName"];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.navigationController pushViewController: obj animated:YES];
//            
//        });


        [self.navigationController pushViewController:obj animated:YES];
        
    }
   else if([[[[userInfo valueForKey:@"aps"]valueForKey:@"notification_type"] lowercaseString]isEqualToString:@"rdg_to_pad"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:[userInfo valueForKey:@"aps"] forKey:@"rdg_to_pad"];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        NationalRailwayViewController *obj=[mainStoryboard instantiateViewControllerWithIdentifier:@"NationalRailwayViewController"];
      [self.navigationController pushViewController:obj animated:YES];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.navigationController pushViewController: obj animated:YES];
//            
//        });

        
        
    }
   else if([[[[userInfo valueForKey:@"aps"]valueForKey:@"notification_type"]lowercaseString]isEqualToString:@"pad_to_rdg"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:[userInfo valueForKey:@"aps"] forKey:@"pad_to_rdg"];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        NationalRailwayViewController *obj=[mainStoryboard instantiateViewControllerWithIdentifier:@"NationalRailwayViewController"];
        [self.navigationController pushViewController:obj animated:YES];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.navigationController pushViewController: obj animated:YES];
//            
//        });

        
    }
  else  if([[[[userInfo valueForKey:@"aps"]valueForKey:@"notification_type"] lowercaseString]isEqualToString:@"offer"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:[[userInfo valueForKey:@"aps"]valueForKey:@"offer_id"] forKey:@"Offer"];
        //[AppDelegate appDelegate].tabBarControllerMain = self.tabBarController;
        
        //[ [AppDelegate appDelegate].tabBarControllerMain setSelectedIndex:3];
        OffersDetailViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"OffersDetailViewController"];
        [self.navigationController pushViewController:obj animated:YES];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.navigationController pushViewController: obj animated:YES];
//            
//        });
    }
  else
  {

      NotiDetailViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"NotiDetailViewController"];
      [self.navigationController pushViewController: obj animated:YES];
      
      
  }

    
}

-(void)methodName
{
     [self dismissViewControllerAnimated:NO completion:nil];

}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [AppDelegate appDelegate].Loader=NO;
   
}


-(void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
     [AppDelegate appDelegate].Loader=YES;
     [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"splashArray"];

}
- (void)ProcessDidComplete:(NSNotification *)notification {
    
    //[myTableView reloadData];
    //[self callWebserviceForUserRegister];
}

- (void) addTriangleTipToLayer: (UIView *) view{
     CALayer *targetLayer = view.layer;
    [targetLayer setBackgroundColor: [UIColor whiteColor].CGColor];
    
    CGFloat side = targetLayer.frame.size.height;
    
    CGPoint startPoint = CGPointMake(targetLayer.frame.size.width / 2 - side / 2, side);
    CGPoint endPoint = CGPointMake(targetLayer.frame.size.width / 2 + side / 2, side);
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    
    CGFloat middleX = targetLayer.frame.size.width / 2;
    CGFloat middleY = (side / 2) * tan(M_PI / 3) + side;
    CGPoint middlePoint = CGPointMake(middleX, middleY);
    
    [trianglePath moveToPoint:startPoint];
    [trianglePath addLineToPoint:middlePoint];
    [trianglePath addLineToPoint:endPoint];
    [trianglePath closePath];
    
    CAShapeLayer *triangleLayer = [CAShapeLayer layer];
    [triangleLayer setFillColor: [UIColor whiteColor].CGColor];
    [triangleLayer setPath:trianglePath.CGPath];
    [targetLayer addSublayer:triangleLayer];
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [[AppDelegate appDelegate] CheckLocEnabled];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Home Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    [super viewWillAppear:animated];

    arrayHome = [[NSMutableArray alloc] init];
    [arrayHome removeAllObjects];
     arrayForBool = [[NSMutableArray alloc] init];
     [arrayForBool removeAllObjects];
    arrayHome = [NSMutableArray arrayWithObjects:@{@"Title":@"Notifications",@"ImageIcon":@"imgNotification",@"imageDots":@""},
                 @{@"Title":@"London Tube",@"ImageIcon":@"imgLondonTube",@"imageDots":@""},@{@"Title":@"Reading",@"ImageIcon":@"imgNRL",@"imageDots":@""}, nil];
    [arrayForBool addObject:[NSNumber numberWithBool:YES]];
    for (int i=1; i<[arrayHome count]; i++) {
        
        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
        
    }
    

     if([[NSUserDefaults standardUserDefaults]valueForKey:@"splashArray"]!=nil)
     {
         arrayHomeData=[[NSMutableArray alloc]init];
         [arrayHomeData removeAllObjects];
         arrayHomeData=[[NSUserDefaults standardUserDefaults]valueForKey:@"splashArray"];
         
         
         
         
         
         if (arrayHomeData.count != 0) {
             
             
             isHieght = YES;
             
             int lastIndex =[[[NSUserDefaults standardUserDefaults]valueForKey:@"indexPathReload"] intValue];
             
             
             
             if (lastIndex == 0) {
                 
                 
                 //BOOL collapsed  = [[arrayForBool objectAtIndex:lastIndex] boolValue];
                 //collapsed = !collapsed;
                 // [arrayForBool replaceObjectAtIndex:lastIndex withObject:[NSNumber numberWithBool:YES]];
                 
                 //reload specific section animated
                 NSRange range   = NSMakeRange(0, 1);
                 NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
                 [self.tblHome reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
             }
             
             
             
         }
         else
         {
             isHieght = YES;
             BOOL collapsed  = [[arrayForBool objectAtIndex:0] boolValue];
             collapsed = !collapsed;
             [arrayForBool replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:NO]];
             
             //reload specific section animated
             NSRange range   = NSMakeRange(0, 1);
             NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
             [self.tblHome reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
         }

         [tblHome reloadData];
        
         //badgeC
         NSString *strBadge=[[NSUserDefaults standardUserDefaults]valueForKey:@"BadgeValue"];
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
        if([AppDelegate appDelegate].isCheckConnection){
           
            //Internet Connection Not Available Please Try Again
            [self.view makeToast:NSLocalizedString(@"Internet Connection Not Available Please Try Again", nil) duration:3.0 position:CSToastPositionCenter];
            
            
        }
        else
        {
            [self callWebserviceForUserRegister];
            
            
            /*if([[[NSUserDefaults standardUserDefaults]valueForKey:@"Register"]isEqualToString:@"1"])
            {

                [self webserviceCarPark3];
                
            }
            else
            {
                [self callWebserviceForUserRegister];

            
            }*/
        }
    }
     //[self performSelector:@selector(callWebserviceForUserRegister) withObject:nil afterDelay:0.00];
    
    //[self callWebserviceForUserRegister];

   // [self.tblHome reloadData];
    
    
    
    
}


- (UIStatusBarStyle) preferredStatusBarStyle

{
    return UIStatusBarStyleLightContent;
}

-(void)showPopUpNotification:(NSNotification *)note{
    backgrView=[[UIView alloc]init];
    [backgrView removeFromSuperview];
    //backgrView.alpha = 0.6;
    NSDictionary *dict = [note object];
   
   
    dictNotiData = dict;
    
    
         backgrView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, [[UIScreen mainScreen] bounds].size.width, 70.0)];
         backgrView.backgroundColor = [UIColor grayColor];
  
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(NavigateForNotificationView:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    button.frame = CGRectMake(0, 0, backgrView.frame.size.width, backgrView.frame.size.height);
    
    /*UIImageView *iconimg = [[UIImageView alloc] init];
    iconimg.frame = CGRectMake(8, 10, 50, 50);
    iconimg.image = [UIImage imageNamed:@"imgNoti"];
    iconimg.layer.borderColor=[UIColor blackColor].CGColor;
    iconimg.layer.borderWidth=1.0;
    iconimg.layer.cornerRadius=24.0;
    iconimg.layer.masksToBounds=YES;*/
    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.frame = CGRectMake(10, 8, 250, 21);
    if([[dict valueForKey:@"notification_type"]isEqualToString:@"rdg_to_pad"]||[[dict valueForKey:@"notification_type"]isEqualToString:@"pad_to_rdg"])
    {
        
    lblTitle.text = @"National Rail";
    }
   else if([[dict valueForKey:@"notification_type"]isEqualToString:@"londontube"]||[[dict valueForKey:@"notification_type"]isEqualToString:@"london tube"])
    {
        
        lblTitle.text = @"London Tube";
    }
   else if([[dict valueForKey:@"notification_type"]isEqualToString:@"Offer"])
   {
       
       lblTitle.text = @"Offer";
   }

    
   // lblTitle.text = @"Lorem Ispum";
    lblTitle.textColor =[UIColor whiteColor];
    lblTitle.font = [UIFont boldSystemFontOfSize:15.0];
    
    UILabel *lblDesc = [[UILabel alloc] init];
    lblDesc.frame = CGRectMake(10, 34, [[UIScreen mainScreen] bounds].size.width-40, 30);
  
    lblDesc.text=[dict valueForKey:@"message"];
     //lblDesc.text = @"Lorem Ispum Lorem IspumLorem IspumLorem IspumLorem IspumLorem IspumLorem IspumLorem Ispumfgldhgjhfdghkkdjh";
    lblDesc.textColor =[UIColor whiteColor];
    lblDesc.font = [UIFont systemFontOfSize:12.0];
    lblDesc.numberOfLines = 0;
    
    UIButton *buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonCancel addTarget:self
               action:@selector(CancelActionForNotificationView:)
     forControlEvents:UIControlEventTouchUpInside];
    [buttonCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    buttonCancel.frame = CGRectMake(self.view.frame.size.width-40, 12, 46, 46);
    

    UIImageView *imgCancel = [[UIImageView alloc] init];
    imgCancel.frame = CGRectMake(8, 10, 20, 20);
    imgCancel.image = [UIImage imageNamed:@"imgClose"];
    imgCancel.center = CGPointMake(buttonCancel.center.x, buttonCancel.center.y);
    
    backgrView.tag = 1212145454;
    [backgrView addSubview:button];
    //[backgrView addSubview:iconimg];
    [backgrView addSubview:lblTitle];
    [backgrView addSubview:lblDesc];
    [backgrView addSubview:buttonCancel];
    [backgrView addSubview:imgCancel];


    [[[UIApplication sharedApplication] keyWindow] addSubview:backgrView];
   
    //[self perfor`mSelector:@selector(showView) withObject:nil afterDelay:5.0];

    
}


-(void)testMethod:(NSTimer *)pTmpTimer
{
    //[[AppDelegate appDelegate] SetBadgeViewWithBadgeValue:@"" andView:self.tabBarController.tabBar];
    //intTmp += 0.1;
    //[pTmpTimer invalidate];
//    [self  badgeViews:^(UIView *badgeView, UILabel *badgeLabel, UIView *badgeBackground) {
//        
//    }];
    
    NSString *strBadge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"BadgeValue"]];
    //strBadge=@"99";
    if([strBadge isKindOfClass:[NSNull class]]|| [strBadge isEqual: [NSNull null]])
    {
        NSLog(@"NULl");
        [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"BadgeValue"];
        [[self.tabBarController.tabBar.items objectAtIndex:0] setBadgeValue:nil];
        _clabel.text=@"(0)";
        [[AppDelegate appDelegate] SetBadgeViewWithBadgeValue:@"" andView:self.tabBarController.tabBar];
        [UIApplication sharedApplication].applicationIconBadgeNumber=0;
        
    }
    else
    {
        
        if (![strBadge isEqualToString:@""] && ![strBadge isEqualToString:@"0"]&&![strBadge isEqual: [NSNull null]]&& !(strBadge==nil)) {
            [[NSUserDefaults standardUserDefaults]setValue:strBadge forKey:@"BadgeValue"];
            [UIApplication sharedApplication].applicationIconBadgeNumber=[[[NSUserDefaults standardUserDefaults] valueForKey:@"BadgeValue"]integerValue];
            _clabel.text=[NSString stringWithFormat:@"(%@)",strBadge];
           
         [[AppDelegate appDelegate] SetBadgeViewWithBadgeValue:strBadge andView:self.tabBarController.tabBar];
            
            
            //[[self.tabBarController.tabBar.items objectAtIndex:0] setBadgeValue:strBadge];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"BadgeValue"];
            [UIApplication sharedApplication].applicationIconBadgeNumber=[[[NSUserDefaults standardUserDefaults] valueForKey:@"BadgeValue"]integerValue];
            [[self.tabBarController.tabBar.items objectAtIndex:0] setBadgeValue:nil];
            _clabel.text=@"(0)";
            [[AppDelegate appDelegate] SetBadgeViewWithBadgeValue:@"" andView:self.tabBarController.tabBar];

        }
    }

    [self tableView:tblHome viewForHeaderInSection:0];
    }





-(void)NavigateForNotificationView:(UIButton *)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.tabBarControllerMain = self.tabBarController;
    appDelegate.tabBarControllerMain.selectedIndex=0;

    NSLog(@"BTN CLICKED");
    [self performSelector:@selector(hidePOPU) withObject:nil afterDelay:0.0];
     if([[dictNotiData valueForKey:@"notification_type"]isEqualToString:@"rdg_to_pad"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:dictNotiData  forKey:@"rdg_to_pad"];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        NationalRailwayViewController *obj=[mainStoryboard instantiateViewControllerWithIdentifier:@"NationalRailwayViewController"];
        
        //[self.navigationController pushViewController:obj animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController: obj animated:YES];
            
        });
        
        
        
    }
    else if([[dictNotiData valueForKey:@"notification_type"]isEqualToString:@"pad_to_rdg"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:dictNotiData forKey:@"pad_to_rdg"];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        NationalRailwayViewController *obj=[mainStoryboard instantiateViewControllerWithIdentifier:@"NationalRailwayViewController"];
        
       // [self.navigationController pushViewController:obj animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController: obj animated:YES];
            
        });
        
        
    }


       else if ([[dictNotiData valueForKey:@"notification_type"] isEqualToString:@"londontube"]||[[dictNotiData valueForKey:@"notification_type"] isEqualToString:@"london tube"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:dictNotiData  forKey:@"LTexpire"];
        [[NSUserDefaults standardUserDefaults]setValue:[dictNotiData  valueForKey:@"message"] forKey:@"reason"];
        [[NSUserDefaults standardUserDefaults]setValue:[dictNotiData valueForKey:@"severity"] forKey:@"stationImage"];
        
        [[NSUserDefaults standardUserDefaults]setValue:[dictNotiData  valueForKey:@"title"] forKey:@"stationName"];

        LondonTubeDetailViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"LondonTubeDetailViewController"];
       // [self.navigationController pushViewController:obj animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController: obj animated:YES];
            
        });
        

    }
    else if ([[dictNotiData valueForKey:@"notification_type"] isEqualToString:@"Offer"])
    {
       // AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
       // appDelegate.tabBarControllerMain = self.tabBarController;
        //[appDelegate.tabBarControllerMain setSelectedIndex:3];
        OffersDetailViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"OffersDetailViewController"];
        [[NSUserDefaults standardUserDefaults]setObject:[dictNotiData  valueForKey:@"offer_id"] forKey:@"offerid"];
       // [self.navigationController pushViewController:obj animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController: obj animated:YES];
            
        });
    }
    
    else
    {
        NotiDetailViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"NotiDetailViewController"];
        
       // [self.navigationController pushViewController:obj animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController: obj animated:YES];
            
        });
    
    
    }
    
    
}

-(void)CancelActionForNotificationView:(UIButton *)sender
{
    NSLog(@"Cancel Clicked");
    [self performSelector:@selector(hidePOPU) withObject:nil afterDelay:0.0];

}



/*
- (void) setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view{
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}
*/



- (void)animateViewHeight:(UIView*)animateView withAnimationType:(NSString*)animType {
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionPush];
    [animation setSubtype:animType];
    
    [animation setDuration:1.0];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[animateView layer] addAnimation:animation forKey:kCATransition];
    animateView.hidden = !animateView.hidden;
}




-(void)showView
{
  
      backgrView.frame = CGRectMake(0, -300, [[UIScreen mainScreen] bounds].size.width, 64.0);
    
    [self animateViewHeight:backgrView withAnimationType:kCATransitionFromTop];

    

    [self performSelector:@selector(HideViewOfPopUp) withObject:nil afterDelay:8.0];

    
    
}
-(void)hidePOPU{
    backgrView.hidden = YES;
    
    NSArray *viewsToRemove = [[[UIApplication sharedApplication] keyWindow] subviews];
    for (UIView *v in viewsToRemove) {
        if (v.tag == 1212145454) {
            
            [v removeFromSuperview];

        }
    }
    
}

-(void)HideViewOfPopUp
{
    backgrView.frame = CGRectMake(0, -300, [[UIScreen mainScreen] bounds].size.width, 64.0);
    
    [self animateViewHeight:backgrView withAnimationType:kCATransitionFromBottom];
}

-(void)naviGateNotificatiion:(NSNotification *)note
{
    [self callWebserviceForUserRegister];
}
-(void)naviGateNotification:(NSNotification *)note
{
    NSDictionary *dictt = [note object];
    NSDictionary *dict = [dictt valueForKey:@"Values"];

     NSLog(@"Navigate%@",dict);
    
    if ([[[dict valueForKey:@"Values"]valueForKey:@"type"]isEqualToString:@"Offer"]) {
        
        OffersDetailViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"OffersDetailViewController"];
        [[NSUserDefaults standardUserDefaults]setObject:[[dict valueForKey:@"Values"] valueForKey:@"offer_id"] forKey:@"offerid"];
       // [self.navigationController pushViewController:obj animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController: obj animated:YES];
            
        });
        
    }
    
    else if ([[[dict valueForKey:@"Values"]valueForKey:@"type"] isEqualToString:@"londontube"]||[[[dict valueForKey:@"Values"]valueForKey:@"type"] isEqualToString:@"london tube"]) {
        
        
        LondonTubeDetailViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"LondonTubeDetailViewController"];
        
        [[NSUserDefaults standardUserDefaults]setValue:[[dict valueForKey:@"Values"] valueForKey:@"message"] forKey:@"reason"];
        [[NSUserDefaults standardUserDefaults]setValue:[[dict valueForKey:@"Values"]valueForKey:@"severity"] forKey:@"stationImage"];
    
    [[NSUserDefaults standardUserDefaults]setValue:[[dict valueForKey:@"Values"] valueForKey:@"title"] forKey:@"stationName"];

      //  [self.navigationController pushViewController:obj animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController: obj animated:YES];
            
        });
        
    }
    else if([[[dict valueForKey:@"Values"]valueForKey:@"type"] isEqualToString:@"rdg_to_pad"]||[[[dict valueForKey:@"Values"]valueForKey:@"type"] isEqualToString:@"pad_to_rdg"])
    {
        NationalRailwayViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"NationalRailwayViewController"];
       // [self.navigationController pushViewController:obj animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController: obj animated:YES];
            
        });
        
        
    }
    

    else
    {
        NotiDetailViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"NotiDetailViewController"];
        obj.dictData = [dict valueForKey:@"Values"];
       // [self.navigationController pushViewController:obj animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController: obj animated:YES];
            
        });
    }
    
    }







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma Mark WebService For Register

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

-(void)callWebserviceForUserRegister
{
    NSString *uuid=[self getUniqueDeviceIdentifierAsString];
     NSString *hashStr = [self convertIntoMD5:uuid];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:[NSString stringWithFormat:@"Device id is %@",hashStr]];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    // uuid=@"A2CCEC75-DAF0–41CC-8CF7-7C786F848E1E";
//    = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    NSString *strVersion = [[UIDevice currentDevice] systemVersion];
   //NSString *deviceType = [UIDevice currentDevice].model;
     NSString *deviceType=[self deviceName];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *params;
    NSLog(@"uuid-----1%@",uuid);
    [[NSUserDefaults standardUserDefaults]setValue:uuid forKey:@"uuid"];
    
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
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"Basic c3lzY3JhZnQ6c2lzKjEyMw==" forHTTPHeaderField:@"Authorization"];
    
   
        [manager POST:baseUrl@"/users/user" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        NSLog(@"%@",responseObject);
        
  
         [self webserviceCarPark3];
        

        
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
       // UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Server Error Please Try Again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
       // [alert show];
        [self.view makeToast:NSLocalizedString(@"Server Error Please Try Again", nil) duration:3.0 position:CSToastPositionCenter];
        NSLog(@"%@",error);
       // [self autoOpen];

        
        
    }];
    
    
    
}





#pragma mark -
#pragma mark TableView DataSource and Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [arrayHome count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*************** Close the section, once the data is selected ***********************************/
    [arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:NO]];
    
    [self.tblHome reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
        if (isHieght == NO) {
            
            return 0;
        }
        else{
        if (arrayHomeData.count == 1) {
            
              return 70;
        }
        else if (arrayHomeData.count == 2)
        {
            return 130;

        }
        else if (arrayHomeData.count == 0)
        {
            return 0;
        }
        else if (arrayHomeData.count == 3)
        {
            return 190;
            
        }
        else if (arrayHomeData.count == 4)
        {
            return 250;
            
        }
        else if (arrayHomeData.count == 5)
        {
            return 310;
            
        }
        }
        
    }
    else{
        return 0;
    }
    
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 76;
}

#pragma mark - Creating View for TableView Section

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tblHome.frame.size.width,76)];
    sectionView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconImg = [[UIImageView alloc] init];
    iconImg.frame = CGRectMake(sectionView.frame.origin.x+10, sectionView.frame.origin.y+18, 40, 40);
   
    
    
    
    UIImage *img=[UIImage imageNamed:[[arrayHome objectAtIndex:section]valueForKey:@"ImageIcon"]];
    iconImg.image = img;
    
    UIImageView *imgCollapse = [[UIImageView alloc] init];
    
    if(IS_IPHONE6)
    {
        imgCollapse.frame = CGRectMake(sectionView.frame.origin.x+310, sectionView.frame.origin.y+18, 40, 40);
    }
    else if (IS_IPHONE6plus)
    {
        imgCollapse.frame = CGRectMake(sectionView.frame.origin.x+340, sectionView.frame.origin.y+18, 40, 40);
        
        
    }
    else
    {
        imgCollapse.frame = CGRectMake(sectionView.frame.origin.x+270, sectionView.frame.origin.y+25, 30, 30);
    }
    
    imgCollapse.image = [UIImage imageNamed:@"imgCollapse"];
    [sectionView addSubview:iconImg];
    
    
    sectionView.tag=section;
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(sectionView.frame.origin.x+55, sectionView.frame.origin.y+18,120, 40);

   // label.font = [UIFont fontWithName:@"Times New Roman-BoldMT" size:14];
    label.textAlignment = NSTextAlignmentLeft;
    
    [sectionView addSubview:label];
    [sectionView addSubview:imgCollapse];
    
 
    /********** Add a custom
     Separator with Section view *******************/
    
    if(section==0 )
    {
        if (arrayHomeData.count != 0) {
            UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, self.tblHome.frame.size.width, 1)];
            
            separatorLineView.backgroundColor = [UIColor clearColor];
            
            separatorLineView.backgroundColor = [UIColor lightGrayColor];
            
            [sectionView addSubview:separatorLineView];
                        NSString *strBadge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"BadgeValue"]];
           
              //strBadge=@"999";
             _clabel = [[UILabel alloc] init];
            if([strBadge isEqualToString:@""]||[strBadge isEqualToString:@"0"])
            {
                [[self.tabBarController.tabBar.items objectAtIndex:0] setBadgeValue:nil];
                [UIApplication sharedApplication].applicationIconBadgeNumber=0;
                _clabel.textColor=[UIColor colorWithRed:37/255.0 green:96/255.0 blue:143/255.0 alpha:1.0];
               // clabel.textColor=[UIColor blueColor];
                _clabel.textAlignment=NSTextAlignmentCenter;
                // clabel.layer.cornerRadius=10.0;
                //clabel.layer.masksToBounds=YES;135,206,235
                //[clabel setBackgroundColor:[UIColor colorWithRed:173/255.0 green:216/255.0 blue:230/255.0 alpha:1.0]];
               // NSString *strval=[NSString stringWithFormat:@"(%@)",@"0"];
                 _clabel.text=@"(0)";
             /*   NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]  initWithString:strval];
                
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,1)];
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(2,1)];
              clabel.attributedText = attributedString;*/
                if(IS_IPHONE4 || IS_IPHONE5)
                {
                    
                    _clabel.frame = CGRectMake(self.view.frame.origin.x+250, self.view.frame.origin.y+29,30,20);
                }
                else if(IS_IPHONE6)
                {
                    
                    _clabel.frame = CGRectMake(self.view.frame.origin.x+292, self.view.frame.origin.y+26,30,20);
                }
                else if(IS_IPHONE6plus)
                {
                    
                    _clabel.frame = CGRectMake(self.view.frame.origin.x+317, self.view.frame.origin.y+26,45,20);
                }
                
                [sectionView addSubview:_clabel];

            }
            else if (![strBadge isEqualToString:@""]&&![strBadge isEqualToString:@"0"]&&![strBadge isEqual: [NSNull null]]&& !(strBadge==nil)) {
                //[[self.tabBarController.tabBar.items objectAtIndex:0] setBadgeValue:strBadge];
                [UIApplication sharedApplication].applicationIconBadgeNumber=[[[NSUserDefaults standardUserDefaults] valueForKey:@"BadgeValue"]integerValue];
                _clabel.textColor=[UIColor colorWithRed:37/255.0 green:96/255.0 blue:143/255.0 alpha:1.0];
               // clabel.textColor=[UIColor blueColor];
                _clabel.textAlignment=NSTextAlignmentCenter;
                // clabel.layer.cornerRadius=10.0;
                //clabel.layer.masksToBounds=YES;
                //[clabel setBackgroundColor:[UIColor colorWithRed:173/255.0 green:216/255.0 blue:230/255.0 alpha:1.0]];
                NSString *strval=[NSString stringWithFormat:@"(%@)",strBadge];
                _clabel.text=strval;
              //  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]  initWithString:strval];
                
                //[attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,1)];
               
                
                if([strBadge integerValue]<=9)
                {
                    //[attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(2,1)];
                    if(IS_IPHONE4 || IS_IPHONE5)
                    {
                   
                 _clabel.frame = CGRectMake(self.view.frame.origin.x+250, self.view.frame.origin.y+29,30,20);
                    }
                   else if(IS_IPHONE6)
                    {
                        
                        _clabel.frame = CGRectMake(self.view.frame.origin.x+292, self.view.frame.origin.y+26,30,20);
                    }
                   else if(IS_IPHONE6plus)
                    {
                        
                        _clabel.frame = CGRectMake(self.view.frame.origin.x+317, self.view.frame.origin.y+26,45,20);
                    }
                }
               else if([strBadge integerValue]<=99)
                {
                    //[attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(3,1)];
                    
                    if(IS_IPHONE4 || IS_IPHONE5)
                    {
                        
                        _clabel.frame = CGRectMake(self.view.frame.origin.x+242, self.view.frame.origin.y+29,35,20);
                    }
                    else if(IS_IPHONE6)
                    {
                        
                        _clabel.frame = CGRectMake(self.view.frame.origin.x+287, self.view.frame.origin.y+26,35,20);
                    }
                    else if(IS_IPHONE6plus)
                    {
                        
                        _clabel.frame = CGRectMake(self.view.frame.origin.x+317, self.view.frame.origin.y+26,35,20);
                    }
                }
                else
                {
                    //[attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(4,1)];
                    if(IS_IPHONE4 || IS_IPHONE5)
                    {
                        
                        _clabel.frame = CGRectMake(self.view.frame.origin.x+227, self.view.frame.origin.y+29,45,20);
                    }
                    else if(IS_IPHONE6)
                    {
                        
                        _clabel.frame = CGRectMake(self.view.frame.origin.x+277, self.view.frame.origin.y+28,45,20);
                    }
                    else if(IS_IPHONE6plus)
                    {
                        
                        _clabel.frame = CGRectMake(self.view.frame.origin.x+307, self.view.frame.origin.y+26,45,20);
                    }
                
                }
                
                
               // clabel.attributedText = attributedString;
                [sectionView addSubview:_clabel];
                
            }
            else
            {
                [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"BadgeValue"];
                [[self.tabBarController.tabBar.items objectAtIndex:0] setBadgeValue:nil];
                [UIApplication sharedApplication].applicationIconBadgeNumber=0;
                
            }

            
           
            
            
            //[sectionView addSubview:imgCollapse];
        }
        else
        {
            //[sectionView addSubview:iconNR];
            //[imgCollapse setImage:[UIImage imageNamed:@"imgCollapse"]];
            //[sectionView addSubview:imgCollapse];
            _clabel=[[UILabel alloc]init];
           // clabel.textColor=[UIColor blackColor];
            _clabel.textColor=[UIColor colorWithRed:37/255.0 green:96/255.0 blue:143/255.0 alpha:1.0];
            _clabel.textAlignment=NSTextAlignmentCenter;
            // clabel.layer.cornerRadius=10.0;
            //clabel.layer.masksToBounds=YES;
            [_clabel setBackgroundColor:[UIColor clearColor]];
           
           // NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]  initWithString:strval];
            
           // [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,1)];
            //[attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(2,1)];
            if(IS_IPHONE4 || IS_IPHONE5)
            {
                
                _clabel.frame = CGRectMake(self.view.frame.origin.x+250, self.view.frame.origin.y+29,30,20);
            }
            else if(IS_IPHONE6)
            {
                
                _clabel.frame = CGRectMake(self.view.frame.origin.x+292, self.view.frame.origin.y+26,30,20);
            }
            else if(IS_IPHONE6plus)
            {
                
                _clabel.frame = CGRectMake(self.view.frame.origin.x+317, self.view.frame.origin.y+26,45,20);
            }
            _clabel.textColor=[UIColor colorWithRed:37/255.0 green:96/255.0 blue:143/255.0 alpha:1.0];
            //clabel.textColor=[UIColor blueColor];
             _clabel.text=@"(0)";
            [sectionView addSubview:_clabel];
            
        }
        
        
        
    }
    else if(section==2)
    {
        
       // imgCollapse.image = [UIImage imageNamed:@"imgCollapse"];
       // [sectionView addSubview:imgCollapse];
        UIImageView *iconNR = [[UIImageView alloc] init];
        iconNR.frame = CGRectMake(sectionView.frame.origin.x+125, sectionView.frame.origin.y+18, 40, 40);
       
        iconNR.image =[UIImage imageNamed:@"imgNR"];
        UILabel *label2 = [[UILabel alloc] init];
        
        label2.frame = CGRectMake(sectionView.frame.origin.x+170, sectionView.frame.origin.y+18,120, 40);
        
        // label.font = [UIFont fontWithName:@"Times New Roman-BoldMT" size:14];
        label2.textAlignment = NSTextAlignmentLeft;
        label2.text=@"Paddington";
        [sectionView addSubview:iconNR];
        [sectionView addSubview:label2];


        
    }
    
    BOOL manyCells  = [[arrayForBool objectAtIndex:section] boolValue];
    
    if (!manyCells) {
        
        NSDictionary *content = [[NSMutableDictionary alloc] initWithDictionary:[arrayHome objectAtIndex:section]];
        label.text = [content valueForKey:@"Title"];
        
        
        
        
    }
    else
    {
        NSDictionary *content = [[NSMutableDictionary alloc] initWithDictionary:[arrayHome objectAtIndex:section]];
        label.text = [content valueForKey:@"Title"];
        
        
    }
    
    if (arrayHomeData.count == 0) {
          sectionView.layer.cornerRadius = 7.0;
    }
    /********** Add UITapGestureRecognizer to SectionView   **************/
    
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [sectionView addGestureRecognizer:headerTapped];
    // sectionView.layer.borderWidth = 2.0;
    if ([[arrayForBool objectAtIndex:section] boolValue] == YES) {
        UIBezierPath *maskPath;
        maskPath = [UIBezierPath bezierPathWithRoundedRect:sectionView.bounds
                                         byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                               cornerRadii:CGSizeMake(7.0, 7.0)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = sectionView.bounds;
        maskLayer.path = maskPath.CGPath;
        sectionView.layer.mask = maskLayer;
        //imgCollapse.image = [UIImage imageNamed:@"imgExpand"];
        
        
        
    }
    else
    {
     sectionView.layer.cornerRadius = 7.0;
    
    }
    
    
    
    
    return  sectionView;
    
    
}


#pragma mark - Table header gesture tapped

- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
   
    if (gestureRecognizer.view.tag == 0) {
        
        if (arrayHomeData.count != 0) {
            
        }
        else
        {
            NSLog(@"Alert");
            
        }
        

        
            
        
        int lastIndex =[[[NSUserDefaults standardUserDefaults]valueForKey:@"indexPath"] intValue];
        NSIndexPath *indexPathLast = [NSIndexPath indexPathForRow:0 inSection:lastIndex];
        
        if (indexPathLast.row == 0 && [self isAllFalse] && (lastIndex !=gestureRecognizer.view.tag) ) {
            /*
            BOOL collapsed  = [[arrayForBool objectAtIndex:indexPathLast.section] boolValue];
            collapsed = !collapsed;
            [arrayForBool replaceObjectAtIndex:lastIndex withObject:[NSNumber numberWithBool:collapsed]];
            //reload specific section animated
            NSRange range   = NSMakeRange(indexPathLast.section, 1);
            NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.tblHome reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationFade];
             */
            
            NotiDetailViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"NotiDetailViewController"];
           // [self.navigationController pushViewController:obj animated:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController: obj animated:YES];
                
            });

            
            
            // [self collapseAllCells:(int)gestureRecognizer.view.tag];
            
        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
       // [[NSUserDefaults standardUserDefaults] setInteger:indexPath.section forKey:@"indexPath"];
        
       // [[NSUserDefaults standardUserDefaults] setInteger:indexPath.section forKey:@"indexPathReload"];
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"indexPath"];
        
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"indexPathReload"];

        
        
        //int lastIndex =[[[NSUserDefaults standardUserDefaults]valueForKey:@"indexPathReload"] intValue];
        
        if (indexPath.row == 0) {
            
            NotiDetailViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"NotiDetailViewController"];
            //[self.navigationController pushViewController:obj animated:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController: obj animated:YES];
                
            });
            
            /*
            BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
            collapsed = !collapsed;
            
            [arrayForBool replaceObjectAtIndex:gestureRecognizer.view.tag withObject:[NSNumber numberWithBool:collapsed]];
            
            //reload specific section animated
            NSRange range   = NSMakeRange(indexPath.section, 1);
            NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.tblHome reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationFade];
            
            // if (indexPath.section ==[ArrayOFNotification count]-1) {
            [self.tblHome scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            // }
            
             */
            
            // [self collapseAllCells:(int)gestureRecognizer.view.tag];
        }
        
           
    }
    
    else if (gestureRecognizer.view.tag == 1)
    
    {
        LondonTubeViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"LondonTubeViewController"];
        //[self.navigationController pushViewController:obj animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController: obj animated:YES];
            
        });
        return;

         //obj.hidesBottomBarWhenPushed = YES;
    }
    else if (gestureRecognizer.view.tag == 2)
        
    {
        NationalRailwayViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"NationalRailwayViewController"];
        
        //[self.navigationController pushViewController:obj animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController: obj animated:YES];
            
        });
       
    }

    
}

-(BOOL)isAllFalse{
    
    
    for (int j = 0;j<[arrayForBool count]; j++) {
        if ([[arrayForBool objectAtIndex:j] intValue] == [[NSNumber numberWithBool:YES] intValue]) {
            return YES;
        }
        
    }
    return NO;
    
    
}





- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer  = [[UIView alloc] initWithFrame:CGRectZero];
    footer.backgroundColor = [UIColor clearColor];
    return footer;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
            cell.clipsToBounds = YES;
        }
    }
    
    
    
    static NSString *simpleTableIdentifier = @"HomeTableViewCell";
    
    
    BOOL manyCells  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
    if (!manyCells) {
        
    } else
    {
        HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
        }
        NSMutableArray *data = [[NSMutableArray alloc] init];
        [data removeAllObjects];
        
        cell.backgroundColor = [UIColor whiteColor];
        if (indexPath.row == 0) {
            
            data=arrayHomeData;
            
            
            [cell setupCellWithData:data];
            NSLog(@"cell width is %f",cell.frame.size.width);
        }
        
        
        return cell;
        
        
    }
    
    return cell;
}


-(void)webserviceCarPark3
{
    if([[NSUserDefaults standardUserDefaults]valueForKey:@"foreground"])
    {
        
    }
    else
    {
    //[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowMBProgressBar object:@"Loading..."];
        //[[AppDelegate appDelegate] showLoadingAlert:self.view];
   
    }
    [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"foreground"];
    
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //
    //    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"syscraft" password:@"sis*123"];
    //[httpclient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *uuid=[self getUniqueDeviceIdentifierAsString];
       NSLog(@"uuid-----1%@",uuid);
    NSLog(@"%@",uuid);
    NSString *url;
    
    
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
    
    
    

    
    
   // NSString *strUrl = @"http://183.182.87.171/svn/mycityapp/mycityapp/apis/DV/notification/index/device_id/B0229273-6910-4370-858C-89D2755FD207/total/3";
    
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"%@",responseObject);
      //   [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array removeAllObjects];
        array = responseObject;
        NSDictionary *dict = [array objectAtIndex:0];
        
                 if ([[dict valueForKey:@"error"] isEqualToString:@""]) {
                     
                     
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
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
                     
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"splashArray"];
            arraData = [[NSMutableArray alloc] init];
            [arraData removeAllObjects];
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"cexpire"];
            arrayHomeData = [[NSMutableArray alloc] init];
            [arrayHomeData removeAllObjects];
            //arrayHomeData = [dict valueForKey:@"data"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array removeAllObjects];
            array = [dict valueForKey:@"data"];
            
            
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
                    
                }
            }

            
          
            
            
            if (arrayHomeData.count != 0) {
                
                
                isHieght = YES;
                
                int lastIndex =[[[NSUserDefaults standardUserDefaults]valueForKey:@"indexPathReload"] intValue];
                
                
                
                if (lastIndex == 0) {
                    
                    
                    //BOOL collapsed  = [[arrayForBool objectAtIndex:lastIndex] boolValue];
                    //collapsed = !collapsed;
                   // [arrayForBool replaceObjectAtIndex:lastIndex withObject:[NSNumber numberWithBool:YES]];
                    
                    //reload specific section animated
                    NSRange range   = NSMakeRange(0, 1);
                    NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
                    [self.tblHome reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
                }
                
                
                
            }
            else
            {
                isHieght = YES;
                BOOL collapsed  = [[arrayForBool objectAtIndex:0] boolValue];
                collapsed = !collapsed;
                [arrayForBool replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:NO]];
                
                //reload specific section animated
                NSRange range   = NSMakeRange(0, 1);
                NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
                [self.tblHome reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
            }

            [self.tblHome reloadData];
            
            
        }
        else
        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[dict valueForKey:@"error"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
             [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"BadgeValue"];
            
        }
         [[AppDelegate appDelegate]removeLoadingAlert:self.view];
       
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
       // [[AppDelegate appDelegate]removeLoadingAlert:self.view];
        //[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
        NSLog(@"%@",error);
       isHieght = YES;
         [self.view makeToast:NSLocalizedString(@"Server Error Please Try Again", nil) duration:3.0 position:CSToastPositionCenter];
//        NSRange range   = NSMakeRange(0, 1);
//        NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
//        [self.tblHome reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
        
        
    }];
    
    
    
    
}

-(void)callAppDelegateWebservice
{
    
//    [_delegate respondsToSelector:@selector(callWebserviceForUserRegister)];
    
    [self callWebserviceForUserRegister];
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
    NSString *suffix_string = @"|st|nd|rd|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|st|nd|rd|th|th|th|th|th|th|th|st";
    NSArray *suffixes = [suffix_string componentsSeparatedByString: @"|"];
    NSString *suffix = [suffixes objectAtIndex:date_day];
    
    prefixDateString = [prefixDateString stringByReplacingOccurrencesOfString:@"." withString:suffix];
    NSString *dateString =prefixDateString;
    //  NSLog(@"%@", dateString);
    return dateString;
}


- (IBAction)ActionSegmentChange:(UISegmentedControl *)sender {
    if(_segmentCtrl2.selectedSegmentIndex==0)
    {
        NSLog(@"0");
        
        _lblHome.backgroundColor=[UIColor colorWithRed:7.0/255.0 green:42.0/255.0 blue:65.0/255.0 alpha:1.0];
        
        _lblParking.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:67.0/255.0 blue:93.0/255.0 alpha:1.0];
        
        //[UIColor colorWithRed:26.0 green:67.0 blue:93.0 alpha:0.0];
        _lblOffer.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:67.0/255.0 blue:93.0/255.0 alpha:1.0];
        _lblReading.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:67.0/255.0 blue:93.0/255.0 alpha:1.0];
        _lblAB.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:67.0/255.0 blue:93.0/255.0 alpha:1.0];
    }
    else if(_segmentCtrl2.selectedSegmentIndex==1)
    {
        NSLog(@"1");
        
        _lblParking.backgroundColor=[UIColor colorWithRed:7.0/255.0 green:42.0/255.0 blue:65.0/255.0 alpha:1.0];
        _lblHome.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:67.0/255.0 blue:93.0/255.0 alpha:1.0];
        
        //[UIColor colorWithRed:26.0 green:67.0 blue:93.0 alpha:0.0];
        _lblOffer.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:67.0/255.0 blue:93.0/255.0 alpha:1.0];
        _lblReading.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:67.0/255.0 blue:93.0/255.0 alpha:1.0];
        _lblAB.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:67.0/255.0 blue:93.0/255.0 alpha:1.0];
        ViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        
       // [self.navigationController pushViewController:obj animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController: obj animated:YES];
            
        });
        
    }
    else  if(_segmentCtrl2.selectedSegmentIndex==2)
    {
        NSLog(@"2");
        
        _lblAB.backgroundColor=[UIColor colorWithRed:7.0/255.0 green:42.0/255.0 blue:65.0/255.0 alpha:1.0];
        _lblHome.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:67.0/255.0 blue:93.0/255.0 alpha:1.0];
        
        //[UIColor colorWithRed:26.0 green:67.0 blue:93.0 alpha:0.0];
        _lblOffer.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:67.0/255.0 blue:93.0/255.0 alpha:1.0];
        _lblReading.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:67.0/255.0 blue:93.0/255.0 alpha:1.0];
        _lblParking.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:67.0/255.0 blue:93.0/255.0 alpha:1.0];
        
    }
    else if(_segmentCtrl2.selectedSegmentIndex==3)
    {
        NSLog(@"3");
        
        _lblOffer.backgroundColor=[UIColor colorWithRed:7.0/255.0 green:42.0/255.0 blue:65.0/255.0 alpha:1.0];
        _lblAB.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:67.0/255.0 blue:93.0/255.0 alpha:1.0];
        _lblHome.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:67.0/255.0 blue:93.0/255.0 alpha:1.0];
        _lblReading.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:67.0/255.0 blue:93.0/255.0 alpha:1.0];
        _lblParking.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:67.0/255.0 blue:93.0/255.0 alpha:1.0];
        
    }
    else  if(_segmentCtrl2.selectedSegmentIndex==4)
    {
        NSLog(@"4");
        
        _lblReading.backgroundColor=[UIColor colorWithRed:7.0/255.0 green:42.0/255.0 blue:65.0/255.0 alpha:1.0];
        _lblOffer.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:67.0/255.0 blue:93.0/255.0 alpha:1.0];
        _lblAB.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:67.0/255.0 blue:93.0/255.0 alpha:1.0];
        _lblHome.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:67.0/255.0 blue:93.0/255.0 alpha:1.0];
        //_lblReading.backgroundColor=[UIColor colorWithRed:67.0/255.0 green:67.0/255.0 blue:93.0/255.0 alpha:1.0];
        _lblParking.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:67.0/255.0 blue:93.0/255.0 alpha:1.0];
        ReadingViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"ReadingViewController"];
       // [self.navigationController pushViewController:obj animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController: obj animated:YES];
            
        });
        return;
        
    }
    
}

-(void)startSampleProcess
{
    self.clabel.text = @"10";
}


- (IBAction)FuncCallSetting:(id)sender
{
    SettingViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    //[self.navigationController pushViewController:obj animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController: obj animated:YES];
        
    });
    return;
    
}

+ (void)updatedisplay:(ViewController *)vc
{

}
@end
