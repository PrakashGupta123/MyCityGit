//
//  LondonTubeViewController.m
//  MyCity
//
//  Created by Admin on 21/11/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import "LondonTubeViewController.h"
#import "AppDelegate.h"
#import <AFNetworking.h>
#import "MBProgressHUD.h"
#import "LondonTubeCell.h"
#import "HomeViewController.h"
#import "SSKeychain.h"
#import "UIView+Toast.h"
#import "SettingViewController.h"
@interface LondonTubeViewController ()

@end

@implementation LondonTubeViewController
{
    UIRefreshControl *rc;
    NSString *showLoader;

}
- (UIStatusBarStyle) preferredStatusBarStyle

{
    return UIStatusBarStyleLightContent;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
  //  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  //  appDelegate.tabBarControllerMain = self.tabBarController;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [[AppDelegate appDelegate] CheckNotEnabled];
     [[AppDelegate appDelegate] CheckLocEnabled];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"LondonTube  Screen"];
    if([AppDelegate appDelegate].isCheckConnection){
        
        //Internet connection not available. Please try again.
        
        //        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Internate error" message:@"Internet connection not available. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alertView show];
        
        if([[NSUserDefaults standardUserDefaults] valueForKey:@"arrayLondonData"] != nil)
        {
            //arrayLondonData =[[NSUserDefaults standardUserDefaults] valueForKey:@"arrayLondonData"];
           // [_tblLondonTube reloadData];
            
        }
        
        
        [self.view makeToast:NSLocalizedString(@"Internet Connection Not Available Please Try Again", nil) duration:3.0 position:CSToastPositionCenter];
       // [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
        
    }
    else
    {
        [self LondonTubeWebservice];
    
    }
    
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//     [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"arrayLondonData"];
    //[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(funccurrentController) userInfo:nil repeats:NO];
   
         //self.tblLondonTube.contentInset = UIEdgeInsetsMake(-10, 0, 0, 0);
    rc=[[UIRefreshControl alloc]init];
    
    //_lblUpdatedTime.text=@"";UpdatedTime
  
    
    [rc addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
   [_tblLondonTube addSubview:rc];
    if ([AppDelegate appDelegate].IsRefresh == YES) {
        
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"LTexpire"] != nil) {
            
          //  NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"LTexpire"];
                            //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"arrayLondonData"];
                [AppDelegate appDelegate].IsRefresh = NO;
                
                

          
        
        }
    }
    
      // NSObject * object=[[NSUserDefaults standardUserDefaults]objectForKey:@"arrayLondonData"];
    
    
   /* if(object != nil)
      {
        arrayLondonData=[[NSUserDefaults standardUserDefaults]valueForKey:@"arrayLondonData"];
        [_tblLondonTube reloadData];
          NSObject * object1=[[NSUserDefaults standardUserDefaults]objectForKey:@"UpdatedTime"];
          if(object1 !=nil)
          {
              _lblUpdatedTime.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"UpdatedTime"];
              
          }


        }
    
        else
        {
        [self LondonTubeWebservice];
        }*/
     
    //[self LondonTubeWebservice];
    
    
    
    // Do any additional setup after loading the view.
}
-(void)funccurrentController
{
    NSLog(@"calling");
 /*   UIViewController *currentVC = self.navigationController.visibleViewController;
    if ([NSStringFromClass([currentVC class]) isEqualToString:@"LondonTubeViewController"])
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Your current view controller:" message:NSStringFromClass([currentVC class]) delegate:nil
                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }*/
       [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"arrayLondonData"];
    //[self LondonTubeWebservice];
}
-(IBAction)funcSettingAction:(id)sender
{
           SettingViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
            [self.navigationController pushViewController:vc animated:YES];


}
- (void)refresh:(id)sender
{
    showLoader=@"NO";
    [self LondonTubeWebservice];
    
   }
- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==12)
    {
//        HomeViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
//        [self.navigationController pushViewController:vc animated:YES];
        UITabBarController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBar"];
        
        [self presentViewController:tbc animated:YES completion:nil];

    }
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
-(void)LondonTubeWebservice
{
    _lblUpdatedTime.text=@"";
    if([showLoader isEqualToString:@"NO"])
    {}
    else
    {
    [[AppDelegate appDelegate] showLoadingAlert:self.view];
       // [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowMBProgressBar object:@"Loading..."];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //[manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"syscraft" password:@"sis123"];
    // manager.responseSerializer = [AFJSONResponseSerializer serializer];
  
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"syscraft" password:@"sis*123"];
    NSString *path;
    NSString *uuid=[self getUniqueDeviceIdentifierAsString];
//    NSString *urlpath=[NSString stringWithFormat:baseUrl@"/offers/offer_detail/offer_id/%@/device_id/%@",offerid,uuid];
     if ([[NSUserDefaults standardUserDefaults] valueForKey:@"LTexpire"]!=nil)
    {
       path= [NSString stringWithFormat:baseUrl@"/status/londonTube/refresh/1/device_id/%@",uuid];
       // path=baseUrl@"/status/londonTube/refresh/1";
    
    }
    else
    {
        path= [NSString stringWithFormat:baseUrl@"/status/londonTube/device_id/%@",uuid];
    }
     manager.requestSerializer.timeoutInterval=0.0;
    NSLog(@"Id is %@", [[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"]);
    //    params =  @{@"device_type":@"ios",@"device_token":[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"]};
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if ([[responseObject valueForKey:@"error"] isEqualToString:@"No Content Found"]) {
             
             [self.view makeToast:NSLocalizedString(@"Device Id is Not Valid", nil) duration:3.0 position:CSToastPositionCenter];
             
             
         }

        else if([[responseObject valueForKey:@"error"]isEqualToString:@""])
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
             arrayLondonData=[[NSMutableArray alloc]init];
             [arrayLondonData removeAllObjects];
             arrayLondonData=[responseObject valueForKey:@"data"];
             if(arrayLondonData.count==0)
             {
                 [self.view makeToast:NSLocalizedString(@"No Data Found", nil) duration:3.0 position:CSToastPositionCenter];
                 
                 
             }
             else
             {
             [[NSUserDefaults standardUserDefaults]setObject:arrayLondonData forKey:@"arrayLondonData"];
             [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"LTexpire"];
             
            // [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
             [[AppDelegate appDelegate] removeLoadingAlert:self.view];
            [self.tblLondonTube reloadData];
            // NSDate *currentDate = [NSDate date];
             
             
            // NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            // [dateFormat setDateFormat:@"dd-MMM-yyyy HH:mm"];
             //NSString *stringFromDate =[NSString stringWithFormat:@"%@",[dateFormat dateFromString:localTime]];
             localTime=[responseObject valueForKey:@"last_updated"];
                 
             NSArray *array = [localTime componentsSeparatedByString:@" "];
             NSString *totaltime=[array objectAtIndex:1];
              NSArray *array1 = [totaltime componentsSeparatedByString:@":"];
             _lblUpdatedTime.text = [NSString stringWithFormat:@"Updated on %@ at %@:%@",[array objectAtIndex:0],[array1 objectAtIndex:0],[array1 objectAtIndex:1]];
             [[NSUserDefaults standardUserDefaults]setObject:_lblUpdatedTime.text forKey:@"UpdatedTime"];

             [rc endRefreshing];
         }
         
        
         
         }
         
        // [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
         [[AppDelegate appDelegate] removeLoadingAlert:self.view];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
       //  [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
         NSLog(@"Error: %@", error);

         if([[NSUserDefaults standardUserDefaults]valueForKey:@"arrayLondonData"]!=nil)
         {
            // arrayLondonData=[[NSUserDefaults standardUserDefaults]valueForKey:@"arrayLondonData"];
            // [_tblLondonTube reloadData];
         }
         [self.view makeToast:NSLocalizedString(@"Server Error Please Try Again", nil) duration:3.0 position:CSToastPositionCenter];
         [[AppDelegate appDelegate] removeLoadingAlert:self.view];
         
         
     }];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strReason;
    NSString *strColorCode = [[self->arrayLondonData objectAtIndex:indexPath.row] valueForKey:@"name"];
    
    NSString *strImageStatus =  [[[[self->arrayLondonData objectAtIndex:indexPath.row] valueForKey:@"lineStatuses"] objectAtIndex:0] valueForKey:@"statusSeverityDescription"];
    if ([strImageStatus isEqualToString:@"Good Service"])
    {
         strReason=@"No disruptions,good service through out the line";
         [[NSUserDefaults standardUserDefaults]setValue:strReason forKey:@"reason"];
        
    }
    else if ([strImageStatus isEqualToString:@"Closed"]) {
       strReason=[[[[self->arrayLondonData objectAtIndex:indexPath.row] valueForKey:@"lineStatuses"] objectAtIndex:0] valueForKey:@"reason"];
        [[NSUserDefaults standardUserDefaults]setValue:strReason forKey:@"reason"];
        
        
    }
    else if ([strImageStatus isEqualToString:@"Suspended"]) {
       strReason =  [[[[self->arrayLondonData objectAtIndex:indexPath.row] valueForKey:@"lineStatuses"] objectAtIndex:0] valueForKey:@"reason"];
        [[NSUserDefaults standardUserDefaults]setValue:strReason forKey:@"reason"];
        
        
    }
    
    else if ([strImageStatus isEqualToString:@"Part Closure"])
    {
         strReason =  [[[[self->arrayLondonData objectAtIndex:indexPath.row] valueForKey:@"lineStatuses"] objectAtIndex:0] valueForKey:@"reason"];
         [[NSUserDefaults standardUserDefaults]setValue:strReason forKey:@"reason"];
       
        
    }
    
    else if ([strImageStatus isEqualToString:@"Minor Delays"])
    {
        strReason =  [[[[self->arrayLondonData objectAtIndex:indexPath.row] valueForKey:@"lineStatuses"] objectAtIndex:0] valueForKey:@"reason"];
        [[NSUserDefaults standardUserDefaults]setValue:strReason forKey:@"reason"];
        
        
    }
    else if ([strImageStatus isEqualToString:@"Severe Delays"]) {
        strReason =  [[[[self->arrayLondonData objectAtIndex:indexPath.row] valueForKey:@"lineStatuses"] objectAtIndex:0] valueForKey:@"reason"];
        [[NSUserDefaults standardUserDefaults]setValue:strReason forKey:@"reason"];
        
        
    }
    else if ([strImageStatus isEqualToString:@"Service Closed"]) {
        strReason =  [[[[self->arrayLondonData objectAtIndex:indexPath.row] valueForKey:@"lineStatuses"] objectAtIndex:0] valueForKey:@"reason"];
        [[NSUserDefaults standardUserDefaults]setValue:strReason forKey:@"reason"];
        
        
    }
    else if ([strImageStatus isEqualToString:@"Part Suspended"]) {
        strReason =  [[[[self->arrayLondonData objectAtIndex:indexPath.row] valueForKey:@"lineStatuses"] objectAtIndex:0] valueForKey:@"reason"];
        [[NSUserDefaults standardUserDefaults]setValue:strReason forKey:@"reason"];
        
        
    }
    else if ([strImageStatus isEqualToString:@"Special Service"]) {
        strReason =  [[[[self->arrayLondonData objectAtIndex:indexPath.row] valueForKey:@"lineStatuses"] objectAtIndex:0] valueForKey:@"reason"];
        [[NSUserDefaults standardUserDefaults]setValue:strReason forKey:@"reason"];
        
    }
    else if ([strImageStatus isEqualToString:@"Planned Closure"]) {
        strReason =  [[[[self->arrayLondonData objectAtIndex:indexPath.row] valueForKey:@"lineStatuses"] objectAtIndex:0] valueForKey:@"reason"];
        [[NSUserDefaults standardUserDefaults]setValue:strReason forKey:@"reason"];
        
    }
    else if ([strImageStatus isEqualToString:@"Reduced Service"]) {
        strReason =  [[[[self->arrayLondonData objectAtIndex:indexPath.row] valueForKey:@"lineStatuses"] objectAtIndex:0] valueForKey:@"reason"];
        [[NSUserDefaults standardUserDefaults]setValue:strReason forKey:@"reason"];
        
        
    }
    else if ([strImageStatus isEqualToString:@"Bus Service"]) {
        strReason =  [[[[self->arrayLondonData objectAtIndex:indexPath.row] valueForKey:@"lineStatuses"] objectAtIndex:0] valueForKey:@"reason"];
        [[NSUserDefaults standardUserDefaults]setValue:strReason forKey:@"reason"];
        
        
    }
    else if ([strImageStatus isEqualToString:@"Part Closed"]) {
        strReason =  [[[[self->arrayLondonData objectAtIndex:indexPath.row] valueForKey:@"lineStatuses"] objectAtIndex:0] valueForKey:@"reason"];
        [[NSUserDefaults standardUserDefaults]setValue:strReason forKey:@"reason"];
        
        
    }
    else if ([strImageStatus isEqualToString:@"Exist Only"]) {
        strReason =  [[[[self->arrayLondonData objectAtIndex:indexPath.row] valueForKey:@"lineStatuses"] objectAtIndex:0] valueForKey:@"reason"];
        [[NSUserDefaults standardUserDefaults]setValue:strReason forKey:@"reason"];
        
    }
    else if ([strImageStatus isEqualToString:@"No Step Free Access"]) {
    strReason =  [[[[self->arrayLondonData objectAtIndex:indexPath.row] valueForKey:@"lineStatuses"] objectAtIndex:0] valueForKey:@"reason"];
        [[NSUserDefaults standardUserDefaults]setValue:strReason forKey:@"reason"];
        
        
    }
    else if ([strImageStatus isEqualToString:@"Change of frequency"]) {
        strReason =  [[[[self->arrayLondonData objectAtIndex:indexPath.row] valueForKey:@"lineStatuses"] objectAtIndex:0] valueForKey:@"reason"];
        [[NSUserDefaults standardUserDefaults]setValue:strReason forKey:@"reason"];
        
        
    }
    else if ([strImageStatus isEqualToString:@"Diverted"]) {
    strReason =  [[[[self->arrayLondonData objectAtIndex:indexPath.row] valueForKey:@"lineStatuses"] objectAtIndex:0] valueForKey:@"reason"];
        [[NSUserDefaults standardUserDefaults]setValue:strReason forKey:@"reason"];
        
        
    }
    else if ([strImageStatus isEqualToString:@"Not Running"]) {
        strReason =  [[[[self->arrayLondonData objectAtIndex:indexPath.row] valueForKey:@"lineStatuses"] objectAtIndex:0] valueForKey:@"reason"];
        [[NSUserDefaults standardUserDefaults]setValue:strReason forKey:@"reason"];
        
        
    }
    else if ([strImageStatus isEqualToString:@"Issues Reported"]) {
        strReason =  [[[[self->arrayLondonData objectAtIndex:indexPath.row] valueForKey:@"lineStatuses"] objectAtIndex:0] valueForKey:@"reason"];
        [[NSUserDefaults standardUserDefaults]setValue:strReason forKey:@"reason"];
        
        
    }
    else if ([strImageStatus isEqualToString:@"No Issues"]) {
    strReason =  [[[[self->arrayLondonData objectAtIndex:indexPath.row] valueForKey:@"lineStatuses"] objectAtIndex:0] valueForKey:@"reason"];
        [[NSUserDefaults standardUserDefaults]setValue:strReason forKey:@"reason"];
        
        
    }
    else if ([strImageStatus isEqualToString:@"Information"]) {
        strReason =  [[[[self->arrayLondonData objectAtIndex:indexPath.row] valueForKey:@"lineStatuses"] objectAtIndex:0] valueForKey:@"reason"];
        [[NSUserDefaults standardUserDefaults]setValue:strReason forKey:@"reason"];
        
        
    }



    [[NSUserDefaults standardUserDefaults]setValue:strImageStatus forKey:@"stationImage"];
   
    [[NSUserDefaults standardUserDefaults]setValue:strColorCode forKey:@"stationName"];
    LondonTubeDetailViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"LondonTubeDetailViewController"];
   // [self.navigationController pushViewController:obj animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController: obj animated:YES];
        
    });
    
    /*if ([strImageStatus isEqualToString:@"Good Service"]) {
        [cell.imgLondoncell setBackgroundImage:[UIImage imageNamed:@"imgOk"] forState:UIControlStateNormal];
        
    }
    
    else if ([strImageStatus isEqualToString:@"Part Closure"]) {
        [cell.imgLondoncell setBackgroundImage:[UIImage imageNamed:@"imgWarning2"] forState:UIControlStateNormal];
        cell.lblDescription.text=@"Part Closure";
        cell.lblDescription.textColor=[UIColor redColor];
        
    }
    
    else if ([strImageStatus isEqualToString:@"Minor Delays"]) {
        [cell.imgLondoncell setBackgroundImage:[UIImage imageNamed:@"imgWarning1"] forState:UIControlStateNormal];
        
    }*/

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    return [ arrayLondonData count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"LondonTubeCell";
    
    LondonTubeCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
            cell = [[LondonTubeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
   //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //cell.txtView.text = [[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"message"];
  cell.lblHeading.text = [[self->arrayLondonData objectAtIndex:indexPath.row] valueForKey:@"name"];
    NSString *strColorCode = [[self->arrayLondonData objectAtIndex:indexPath.row] valueForKey:@"name"];
    
    if ([strColorCode isEqualToString:@"Bakerloo"]) {
        cell.viewCOLOR.backgroundColor =[UIColor colorWithRed:123/255.0 green:70/255.0 blue:32/255.0 alpha:1.0];
       /* UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(cell.viewBorder.frame.origin.x, cell.viewBorder.frame.origin.y, cell.viewBorder.frame.size.width,2.0f)];
        lbl.layer.borderColor=[UIColor colorWithRed:27/255.0 green:90/255.0 blue:123/255.0 alpha:1.0].CGColor;
        lbl.layer.borderWidth=0.6;
        [cell addSubview:lbl];*/
     //  cell.viewHide.hidden=NO;
       // cell.layer.borderWidth=0.6;
      // cell.viewHide.backgroundColor=[UIColor colorWithRed:27/255.0 green:90/255.0 blue:123/255.0 alpha:1.0];
        
        
        
        
        
    }
    
    if ([strColorCode isEqualToString:@"Central"]) {
        cell.viewCOLOR.backgroundColor = [UIColor colorWithRed:197/255.0 green:32/255.0 blue:27/255.0 alpha:1.0];
        
    }
    

    if ([strColorCode isEqualToString:@"Circle"]) {
      cell.viewCOLOR.backgroundColor = [UIColor colorWithRed:229/255.0 green:185/255.0 blue:0/255.0 alpha:1.0];
    }
    

    if ([strColorCode isEqualToString:@"District"]) {
       cell.viewCOLOR.backgroundColor = [UIColor colorWithRed:0/255.0 green:102/255.0 blue:36/255.0 alpha:1.0];
        
    }
    

    if ([strColorCode isEqualToString:@"Hammersmith & City"]) {
        cell.viewCOLOR.backgroundColor = [UIColor colorWithRed:193/255.0 green:137/255.0 blue:157/255.0 alpha:1.0];

        
    }
    

    if ([strColorCode isEqualToString:@"Jubilee"]) {
        cell.viewCOLOR.backgroundColor = [UIColor colorWithRed:95/255.0 green:102/255.0 blue:107/255.0 alpha:1.0];
        
    }
    

    if ([strColorCode isEqualToString:@"Metropolitan"]) {
        cell.viewCOLOR.backgroundColor = [UIColor colorWithRed:105/255.0 green:14/255.0 blue:77/255.0 alpha:1.0];
        
    }
    

    if ([strColorCode isEqualToString:@"Northern"]) {
        cell.viewCOLOR.backgroundColor = [UIColor blackColor];
        
        
    }
    

    if ([strColorCode isEqualToString:@"Piccadilly"]) {
        cell.viewCOLOR.backgroundColor = [UIColor colorWithRed:0/255.0 green:18/255.0 blue:127/255.0 alpha:1.0];
        
        
    }
    

    if ([strColorCode isEqualToString:@"Victoria"]) {
       cell.viewCOLOR.backgroundColor = [UIColor colorWithRed:0/255.0 green:143/255.0 blue:203/255.0 alpha:1.0];
        
        
    }
    

    if ([strColorCode isEqualToString:@"Waterloo & City"]) {
       cell.viewCOLOR.backgroundColor = [UIColor colorWithRed:106/255.0 green:189/255.0 blue:169/255.0 alpha:1.0];
       /* UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(cell.viewBorder.frame.origin.x, cell.viewBorder.frame.origin.y+cell.viewBorder.frame.size.height-2,self.view.frame.size.width-30,2.0f)];
        lbl.layer.borderColor=[UIColor colorWithRed:27/255.0 green:90/255.0 blue:123/255.0 alpha:1.0].CGColor;
        lbl.layer.borderWidth=0.6;
        [cell addSubview:lbl];*/
       // cell.viewhide2.hidden=NO;
       // cell.viewhide2.layer.backgroundColor=[UIColor colorWithRed:27/255.0 green:90/255.0 blue:123/255.0 alpha:0.3].CGColor;
//        cell.viewhide2.hidden=NO;
//        cell.layer.borderWidth=0.6;
//        cell.viewhide2.layer.borderColor=[UIColor colorWithRed:27/255.0 green:90/255.0 blue:123/255.0 alpha:1.0].CGColor;
        
    }
    
    //cell.lblDescription.text = [[self->arrayLondonData objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.lblDescription.text=@"";
    
    
    NSString *strImageStatus =  [[[[self->arrayLondonData objectAtIndex:indexPath.row] valueForKey:@"lineStatuses"] objectAtIndex:0] valueForKey:@"statusSeverityDescription"];
    
    
    if ([strImageStatus isEqualToString:@"Good Service"]) {
        [cell.imgLondoncell setBackgroundImage:[UIImage imageNamed:@"imgOk2"] forState:UIControlStateNormal];
        
    }
    
    else if ([strImageStatus isEqualToString:@"Part Closure"]) {
         [cell.imgLondoncell setBackgroundImage:[UIImage imageNamed:@"imgWarning2"] forState:UIControlStateNormal];
        cell.lblDescription.text=@"Part Closure";
        cell.lblDescription.textColor=[UIColor redColor];
        
    }
    
   else if ([strImageStatus isEqualToString:@"Minor Delays"]) {
         [cell.imgLondoncell setBackgroundImage:[UIImage imageNamed:@"imgWarning1"] forState:UIControlStateNormal];
       cell.lblDescription.text=@"Minor Delays";
       cell.lblDescription.textColor=[UIColor redColor];

        
    }
   else if ([strImageStatus isEqualToString:@"Severe Delays"]) {
       [cell.imgLondoncell setBackgroundImage:[UIImage imageNamed:@"imgWarning2"] forState:UIControlStateNormal];
       cell.lblDescription.text=@"Severe Delays";
       cell.lblDescription.textColor=[UIColor redColor];
       
       
   }

   else if ([strImageStatus isEqualToString:@"Service Closed"]) {
       [cell.imgLondoncell setBackgroundImage:[UIImage imageNamed:@"imgSClosed"] forState:UIControlStateNormal];
       cell.lblDescription.text=@"Service Closed";
       cell.lblDescription.textColor=[UIColor redColor];
       
       
   }
   else if ([strImageStatus isEqualToString:@"Closed"]) {
       [cell.imgLondoncell setBackgroundImage:[UIImage imageNamed:@"imgWarning1"] forState:UIControlStateNormal];
       cell.lblDescription.text=@"Closed";
       cell.lblDescription.textColor=[UIColor redColor];
       
       
   }
    
    //"Part Suspended"Special Service
    
   else if ([strImageStatus isEqualToString:@"Part Suspended"]) {
       [cell.imgLondoncell setBackgroundImage:[UIImage imageNamed:@"imgWarning2"] forState:UIControlStateNormal];
       cell.lblDescription.text=@"Part Suspended";
       cell.lblDescription.textColor=[UIColor redColor];
       
       
   }
    
   else if ([strImageStatus isEqualToString:@"Suspended"]) {
       [cell.imgLondoncell setBackgroundImage:[UIImage imageNamed:@"imgWarning2"] forState:UIControlStateNormal];
       cell.lblDescription.text=@"Suspended";
       cell.lblDescription.textColor=[UIColor redColor];
       
       
   }
   else if ([strImageStatus isEqualToString:@"Special Service"]) {
       [cell.imgLondoncell setBackgroundImage:[UIImage imageNamed:@"imgWarning1"] forState:UIControlStateNormal];
       cell.lblDescription.text=@"Special Service";
       cell.lblDescription.textColor=[UIColor redColor];
       
       
   }
   else if ([strImageStatus isEqualToString:@"Planned Closure"]) {
       [cell.imgLondoncell setBackgroundImage:[UIImage imageNamed:@"imgWarning1"] forState:UIControlStateNormal];
       cell.lblDescription.text=@"Planned Closure";
       cell.lblDescription.textColor=[UIColor redColor];
       
       
   }
   else if ([strImageStatus isEqualToString:@"Reduced Service"]) {
       [cell.imgLondoncell setBackgroundImage:[UIImage imageNamed:@"imgWarning1"] forState:UIControlStateNormal];
       cell.lblDescription.text=@"Reduced Service";
       cell.lblDescription.textColor=[UIColor redColor];
       
       
   }//Exist OnlyBus Service
   else if ([strImageStatus isEqualToString:@"Bus Service"]) {
       [cell.imgLondoncell setBackgroundImage:[UIImage imageNamed:@"imgWarning1"] forState:UIControlStateNormal];
       cell.lblDescription.text=@"Bus Service";
       cell.lblDescription.textColor=[UIColor redColor];
       
       
   }
   else if ([strImageStatus isEqualToString:@"Part Closed"]) {
       [cell.imgLondoncell setBackgroundImage:[UIImage imageNamed:@"imgWarning1"] forState:UIControlStateNormal];
       cell.lblDescription.text=@"Part Closed";
       cell.lblDescription.textColor=[UIColor redColor];
       
       
   }
   else if ([strImageStatus isEqualToString:@"Exist Only"]) {
       [cell.imgLondoncell setBackgroundImage:[UIImage imageNamed:@"imgWarning1"] forState:UIControlStateNormal];
       cell.lblDescription.text=@"Exist Only";
       cell.lblDescription.textColor=[UIColor redColor];
       
       
   }
   else if ([strImageStatus isEqualToString:@"No Step Free Access"]) {
       [cell.imgLondoncell setBackgroundImage:[UIImage imageNamed:@"imgWarning1"] forState:UIControlStateNormal];
       cell.lblDescription.text=@"No Step Free Access";
       cell.lblDescription.textColor=[UIColor redColor];
       
       
   }
   else if ([strImageStatus isEqualToString:@"Change of frequency"]) {
       [cell.imgLondoncell setBackgroundImage:[UIImage imageNamed:@"imgWarning1"] forState:UIControlStateNormal];
       cell.lblDescription.text=@"Change of frequency";
       cell.lblDescription.textColor=[UIColor redColor];
       
       
   }
   else if ([strImageStatus isEqualToString:@"Diverted"]) {
       [cell.imgLondoncell setBackgroundImage:[UIImage imageNamed:@"imgWarning1"] forState:UIControlStateNormal];
       cell.lblDescription.text=@"Diverted";
       cell.lblDescription.textColor=[UIColor redColor];
       
       
   }
   else if ([strImageStatus isEqualToString:@"Not Running"]) {
       [cell.imgLondoncell setBackgroundImage:[UIImage imageNamed:@"imgWarning1"] forState:UIControlStateNormal];
       cell.lblDescription.text=@"Not Running";
       cell.lblDescription.textColor=[UIColor redColor];
       
       
   }
   else if ([strImageStatus isEqualToString:@"Issues Reported"]) {
       [cell.imgLondoncell setBackgroundImage:[UIImage imageNamed:@"imgWarning1"] forState:UIControlStateNormal];
       cell.lblDescription.text=@"Issues Reported";
       cell.lblDescription.textColor=[UIColor redColor];
       
       
   }
   else if ([strImageStatus isEqualToString:@"No Issues"]) {
       [cell.imgLondoncell setBackgroundImage:[UIImage imageNamed:@"imgWarning1"] forState:UIControlStateNormal];
       cell.lblDescription.text=@"No Issues";
       cell.lblDescription.textColor=[UIColor redColor];
       
       
   }
   else if ([strImageStatus isEqualToString:@"Information"]) {
       [cell.imgLondoncell setBackgroundImage:[UIImage imageNamed:@"imgWarning1"] forState:UIControlStateNormal];
       cell.lblDescription.text=@"Information";
       cell.lblDescription.textColor=[UIColor redColor];
       
       
   }
  

   
    return cell;
    
}


//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return CGFLOAT_MIN;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
