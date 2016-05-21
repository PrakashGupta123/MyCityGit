//
//  NotiDetailViewController.m
//  MyCity
//
//  Created by Pushpendra on 08/01/16.
//  Copyright © 2016 Syscraft. All rights reserved.
//

#import "NotiDetailViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AppDelegate.h"
#import "SSKeychain.h"
#import "NotiDetailCell.h"
#import "UIView+Toast.h"
#import "HomeViewController.h"
#import "SettingViewController.h"

@interface NotiDetailViewController ()
{
    NSMutableArray *arraData;
    
}
@end

@implementation NotiDetailViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
   // AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   // appDelegate.tabBarControllerMain = self.tabBarController;
}
- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    HomeViewController *obj=[[HomeViewController alloc]init];
    [obj startSampleProcess];
    self.tabBarController.tabBar.hidden = YES;
    
 
     [[AppDelegate appDelegate] CheckLocEnabled];
     [[AppDelegate appDelegate] CheckNotEnabled];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"All Notifications Screen"];
    //[NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(NotRefresh) userInfo:nil repeats:NO];
    
    if ([AppDelegate appDelegate].IsRefresh == YES) {
        
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"ALLexpire"]!=nil) {
            
            //[[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"arrayNot"];
            [AppDelegate appDelegate].IsRefresh = NO;
            
            }
    }
   // NSObject * object2=[[NSUserDefaults standardUserDefaults]objectForKey:@"arrayNot"];
    
    
    /*if(object2 != nil)
    {
        arraData=[[NSUserDefaults standardUserDefaults]valueForKey:@"arrayNot"];
        
        [_tblNotification reloadData];
        for (int j =0; j<arraData.count; j++) {
            
            if ([[[arraData objectAtIndex:j] valueForKey:@"type"] isEqualToString:[self.dictData valueForKey:@"type"]] && [[[arraData objectAtIndex:j] valueForKey:@"message"] isEqualToString:[self.dictData valueForKey:@"message"]]) {
                
                
                [self.tblNotification scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                
                break;
                
                
            }
        }
    }
    
    else
    {
        [self WebserviceForNotificationList];
    }*/
       //
     }


-(void)NotRefresh
{
    
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"arrayNot"];


}
- (UIStatusBarStyle) preferredStatusBarStyle

{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.dictData);

    
    if([AppDelegate appDelegate].isCheckConnection){
        
        //Internet connection not available. Please try again.
        
        //        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Internate error" message:@"Internet connection not available. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alertView show];
        
//        if([[NSUserDefaults standardUserDefaults] valueForKey:@"arrayNot"] != nil)
//        {
//             arraData =[[NSUserDefaults standardUserDefaults] valueForKey:@"arrayNot"];
//            
//             [_tblNotification reloadData];
//            
//        }
        
        _tblNotification.hidden=YES;
        [self.view makeToast:NSLocalizedString(@"Internet Connection Not Available Please Try Again", nil) duration:3.0 position:CSToastPositionCenter];
        //[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
        
    }
    else
    {
       
         _tblNotification.hidden=NO;
        if([[NSUserDefaults standardUserDefaults] valueForKey:@"arrayNot"] != nil)
        {
//            arraData =[[NSUserDefaults standardUserDefaults] valueForKey:@"arrayNot"];
//            
//            [_tblNotification reloadData];
            
        }

        [self performSelector:@selector(WebserviceForNotificationList) withObject:nil afterDelay:0.1];

    }

    
   
    
   //[self WebserviceForNotificationList];

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

-(void)WebserviceForNotificationList
{
     [[AppDelegate appDelegate] showLoadingAlert:self.view];
    NSString *uuid=[self getUniqueDeviceIdentifierAsString];

    NSLog(@"uuid-----1%@",uuid);
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer.timeoutInterval=60.0;
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"syscraft" password:@"sis*123"];
    //[httpclient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSString *strUrl;
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
     if ([[NSUserDefaults standardUserDefaults] valueForKey:@"ALLexpire"]!=nil) {
       
         
          strUrl= [NSString stringWithFormat:baseUrl@"/notification/index/device_id/%@/%@",uuid,@"refresh/1"];
         
     }
    else
    {
    
     strUrl= [NSString stringWithFormat:baseUrl@"/notification/index/device_id/%@",uuid];
    }
    
    [manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"JSON: %@", responseObject);
         
         //No Content Found
         NSArray *arrayRes = responseObject;
         
        if ([[[arrayRes objectAtIndex:0] valueForKey:@"error"] isEqualToString:@"No Content Found"]) {
            
            [self.view makeToast:NSLocalizedString(@"Device Id is Not Valid", nil) duration:3.0 position:CSToastPositionCenter];
        }
        else if ([[[arrayRes objectAtIndex:0] valueForKey:@"error"] isEqualToString:@""]) {
             NSMutableArray *array = [[NSMutableArray alloc] init];
             [array removeAllObjects];
             array = [[arrayRes objectAtIndex:0] valueForKey:@"data"];
            NSLog(@"Count is %lu",(unsigned long)array.count);
            
               if(array.count==0)
               {
               [self.view makeToast:NSLocalizedString(@"No Data Found", nil) duration:3.0 position:CSToastPositionCenter];
               }
             else
             {
             NSString *strBadge= [[arrayRes objectAtIndex:0] valueForKey:@"badge"];
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
            
             [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"ALLexpire"];
             arraData = [[NSMutableArray alloc] init];
             [arraData removeAllObjects];
             
             
             
             for (int i =0; i<array.count; i++) {
//                 
//                 if ([[array objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                     NSString *strDate1 = [[array objectAtIndex:i] valueForKey:@"date_added"];
                     
                     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                     
                     [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                     NSDate *dateFromString = [[NSDate alloc] init];
                     
                     dateFromString = [dateFormatter dateFromString:strDate1];
                     NSString *strDate = [self StringFromDate:dateFromString];
                     NSDictionary *dict = @{@"Date":strDate ,@"Values":[array objectAtIndex:i]};
                     
                       [arraData addObject:dict];
                     
                // }
                 }
             
             
             
            NSMutableArray *arrayOffers = [[NSMutableArray alloc] init];
             [arrayOffers removeAllObjects];
             
             
             NSSortDescriptor *sortDescriptor =
             [NSSortDescriptor sortDescriptorWithKey:@"Date" ascending:NO selector:@selector(localizedStandardCompare:)];
             
             arrayOffers = [[arraData sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]mutableCopy];
             
             arraData = [[NSMutableArray alloc] init];
             [arraData removeAllObjects];

             arraData = arrayOffers;
             
             [[NSUserDefaults standardUserDefaults]setObject:arraData forKey:@"arrayNot"];
             
             [self.tblNotification reloadData];

             
             for (int j =0; j<arraData.count; j++) {
                 NSDictionary *dict = [[arraData objectAtIndex:j] valueForKey:@"Values"];
                 
                 
                 if ([[dict valueForKey:@"type"] isEqualToString:[self.dictData valueForKey:@"type"]] && [[dict valueForKey:@"message"] isEqualToString:[self.dictData valueForKey:@"message"]]) {
                     
                     
                     [self.tblNotification scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                     
                     break;
                     
                     
                 }
             }
             
             
         }
         }
         [[AppDelegate appDelegate] removeLoadingAlert:self.view];
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
       //[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
        /* if([[NSUserDefaults standardUserDefaults] valueForKey:@"arrayNot"] != nil)
         {
             arraData =[[NSUserDefaults standardUserDefaults] valueForKey:@"arrayNot"];
             
             [_tblNotification reloadData];
             
         }*/
         
          _tblNotification.hidden=YES;
         [self.view makeToast:NSLocalizedString(@"Server Error Please Try Again", nil) duration:3.0 position:CSToastPositionCenter];
         [[AppDelegate appDelegate] removeLoadingAlert:self.view];
         
         
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


#pragma MARK:-

#pragma Table View Delegate & DataSource


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    return [arraData count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"NotiDetailCell";
    
    NotiDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {

        cell = [[NotiDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSDictionary *dict = [[arraData objectAtIndex:indexPath.row] valueForKey:@"Values"];
    if([[dict valueForKey:@"type"]isEqualToString:@"Offer"])
    {
        cell.lblTitle.text = @"Offer";
    }

   else if([[dict valueForKey:@"type"]isEqualToString:@"nationalrail"])
    {
    cell.lblTitle.text = @"National Rail";
    }
   else if([[dict valueForKey:@"type"]isEqualToString:@"londontube"])
    {
        cell.lblTitle.text = @"London Tube";
    }
   else if([[dict valueForKey:@"type"]isEqualToString:@"rdg_to_pad"])
   {
       //cell.lblTitle.text = [dict valueForKey:@"title"];
        cell.lblTitle.text=@"National Rail";
   }
   else if([[dict valueForKey:@"type"]isEqualToString:@"pad_to_rdg"])
   {
       //cell.lblTitle.text = [dict valueForKey:@"title"];
        cell.lblTitle.text=@"National Rail";
   }
   else if([[dict valueForKey:@"type"]isEqualToString:@"general"])
   {
       cell.lblTitle.text = @"General";
   }

    else
    {
    cell.lblTitle.text = [dict valueForKey:@"type"];
    }
    
    cell.lblDate.text = [[arraData objectAtIndex:indexPath.row] valueForKey:@"Date"];
    
    
    NSLog(@"dict %@",dict);
    
   // cell.lblDescription.text = [dict valueForKey:@"message"];
    
    NSString *strAddress1 = [[dict valueForKey:@"message"]stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *strAddress=  [strAddress1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//    [style setLineBreakMode:NSLineBreakByWordWrapping];
//    
//    CGRect rect = [strAddress boundingRectWithSize:CGSizeMake(self.view.frame.size.width-20 , FLT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor blackColor],  NSParagraphStyleAttributeName : style,NSFontAttributeName: [UIFont systemFontOfSize:12.0f]} context:nil];
//    CGSize expectedLabelSizee = rect.size;        //adjust the label the the new height.
//    CGRect newFramee = cell.lblDescription.frame;
//    newFramee.size.height = expectedLabelSizee.height;
//    cell.lblDescription.frame = CGRectMake(cell.lblDescription.frame.origin.x, cell.lblDescription.frame.origin.y,self.view.frame.size.width-20,expectedLabelSizee.height);
 
    
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentJustified;
    style.firstLineHeadIndent = 10.0f;
    style.headIndent = 10.0f;
    style.tailIndent = -10.0f;
   
  
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:strAddress attributes:@{ NSParagraphStyleAttributeName : style}];

    cell.lblDescription.attributedText = attrText;
    cell.lblDescription.numberOfLines=0;
    [cell.lblDescription sizeToFit];
   // NSLog(@"Pushpendra%@%d",NSStringFromCGRect(cell.lblDescription.frame),indexPath.row);
    
      return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSDictionary *dict = [arraData objectAtIndex:indexPath.row];
    
    NSString *strAddress1 = [[[dict valueForKey:@"Values"] valueForKey:@"message"]stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *strAddress=  [strAddress1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect rect = [strAddress boundingRectWithSize:CGSizeMake(self.view.frame.size.width-20 , FLT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor blackColor],  NSParagraphStyleAttributeName : style,NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
    CGSize expectedLabelSizee = rect.size;
    
    CGFloat height;
    NSLog(@"Height for row is %@",NSStringFromCGSize(expectedLabelSizee));
    if(IS_IPHONE4||IS_IPHONE5)
    {
     return    height = MAX(expectedLabelSizee.height+50, 57);
    }
   else if(IS_IPHONE6)
    {
      return   height = MAX(expectedLabelSizee.height+50, 57);
    }
   else if(IS_IPHONE6plus)
   {
     return  height = MAX(expectedLabelSizee.height+50, 57);
   }
    else
    {
    return  height = MAX(expectedLabelSizee.height+50, 57);
    }
    return 0;
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)funcSettingCalling:(id)sender
{
    SettingViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
