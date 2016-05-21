//
//  NationalRailwayViewController.m
//  MyCity
//
//  Created by Admin on 15/12/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import "NationalRailwayViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "NationalCell.h"
#import "AppDelegate.h"
#import "SettingViewController.h"
#import "SSKeychain.h"
#import "UIView+Toast.h"



@interface NationalRailwayViewController ()
{
    NSString *strUrl,*Loadershow;
     UIRefreshControl *rc;
    
}
@end

@implementation NationalRailwayViewController
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   // AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //appDelegate.tabBarControllerMain = self.tabBarController;
}
- (UIStatusBarStyle) preferredStatusBarStyle

{
    return UIStatusBarStyleLightContent;
}
- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[AppDelegate appDelegate] CheckLocEnabled];
 [[AppDelegate appDelegate] CheckNotEnabled];
        self.tabBarController.tabBar.hidden = YES;
   
    if([AppDelegate appDelegate].isCheckConnection){
        
        //Internet connection not available. Please try again.
        
//        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Internate error" message:@"Internet connection not available. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alertView show];
        
        if([[NSUserDefaults standardUserDefaults] valueForKey:@"rdg_to_pad"] != nil)
        {
            if([[NSUserDefaults standardUserDefaults] valueForKey:@"arrN1"]!=nil)
            {
           // arrayNatRail =[[NSUserDefaults standardUserDefaults] valueForKey:@"arrN1"];
                // [_tblNatRail reloadData];
            }
            
            
            [self.segSwitchStation setSelectedSegmentIndex:0];
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            [tracker set:kGAIScreenName value:@"Reading to Padington Screen"];
            [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
            
        }
        else if([[NSUserDefaults standardUserDefaults] valueForKey:@"pad_to_rdg"] != nil)
        {
            if([[NSUserDefaults standardUserDefaults] valueForKey:@"arrN2"]!= nil)
            {
          //  arrayNatRail =[[NSUserDefaults standardUserDefaults] valueForKey:@"arrN2"];
                // [_tblNatRail reloadData];
            }
            [self.segSwitchStation setSelectedSegmentIndex:1];
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            [tracker set:kGAIScreenName value:@"Padington to Reading Screen"];
            [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
            
        }
        
    
    else
    {
        if([[NSUserDefaults standardUserDefaults] valueForKey:@"arrN1"]!= nil)
        {
            //arrayNatRail =[[NSUserDefaults standardUserDefaults] valueForKey:@"arrN1"];
            // [_tblNatRail reloadData];
        }

        
        
        [self.segSwitchStation setSelectedSegmentIndex:0];
        
    }
   
    [self.view makeToast:NSLocalizedString(@"Internet Connection Not Available Please Try Again", nil) duration:3.0 position:CSToastPositionCenter];
   // [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
        
    }
    
    else
    {
        
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"rdg_to_pad"] != nil ||[[NSUserDefaults standardUserDefaults] valueForKey:@"rdg_to_pad"] != nil) {
        
        
        //[[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"arrN2" ];
        // [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"arrN1" ];
        if([[NSUserDefaults standardUserDefaults] valueForKey:@"rdg_to_pad"] != nil)
        {
            NSString *uuid=[self getUniqueDeviceIdentifierAsString];
            
            strUrl=[NSString stringWithFormat:baseUrl@"/status/nationalRail/from/RDG/to/PAD/refresh/1/device_id/%@",uuid];
            
            
            // strUrl = [NSString stringWithFormat:baseUrl@"/status/nationalRail/from/RDG/to/PAD/refresh/1"];
            [self.segSwitchStation setSelectedSegmentIndex:0];
            
        }
        if([[NSUserDefaults standardUserDefaults] valueForKey:@"pad_to_rdg"] != nil)
        {
            NSString *uuid=[self getUniqueDeviceIdentifierAsString];
            
            strUrl=[NSString stringWithFormat:baseUrl@"status/nationalRail/from/PAD/to/RDG/refresh/1/device_id/%@",uuid];
            // strUrl = [NSString stringWithFormat:baseUrl@"status/nationalRail/from/PAD/to/RDG/refresh/1"];
            [self.segSwitchStation setSelectedSegmentIndex:1];
            
        }
        
        
        [AppDelegate appDelegate].IsRefresh = NO;
        
        
    }
    
    else
    {
        NSString *uuid=[self getUniqueDeviceIdentifierAsString];
        
        strUrl=[NSString stringWithFormat:baseUrl@"/status/nationalRail/from/RDG/to/PAD/device_id/%@",uuid];
        
        // strUrl = [NSString stringWithFormat:baseUrl@"/status/nationalRail/from/RDG/to/PAD"];
        [self.segSwitchStation setSelectedSegmentIndex:0];
        
    }
    
    [self webServiceCallingForRailway];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];

   //  [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(resetValue) userInfo:nil repeats:YES];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont boldSystemFontOfSize:11.0], UITextAttributeFont,
                                [UIColor whiteColor], UITextAttributeTextColor,
                                nil];
    
    
    NSDictionary *attributes1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont systemFontOfSize:11.0], UITextAttributeFont,
                                [UIColor whiteColor], UITextAttributeTextColor,
                                nil];
    [self.segSwitchStation setTitleTextAttributes:attributes1 forState:UIControlStateNormal];
    [self.segSwitchStation setTitleTextAttributes:attributes forState:UIControlStateSelected];

    arrayNatRail=[[NSMutableArray alloc]init];
    [arrayNatRail removeAllObjects];
    //[self.segSwitchStation setSelectedSegmentIndex:0];
    
    //arrN2
   
    
    
    
    //NSObject * object1=[[NSUserDefaults standardUserDefaults]objectForKey:@"arrN1"];
    //NSObject * object2=[[NSUserDefaults standardUserDefaults]objectForKey:@"arrN2"];
    
    
   /* if(object1 != nil)
    {
        arrayNatRail=[[NSUserDefaults standardUserDefaults]valueForKey:@"arrN1"];
        
        [_tblNatRail reloadData];
    }
    else if(object2 != nil)
    {
        arrayNatRail=[[NSUserDefaults standardUserDefaults]valueForKey:@"arrN2"];
        
        [_tblNatRail reloadData];
    }
    
    else
    {
         strUrl = [NSString stringWithFormat:@"http://183.182.87.171/svn/mycityapp/mycityapp/apis/DV/status/nationalRail/from/RDG/to/PAD"];
        [self webServiceCallingForRailway];
   // }*/
    

    
    
    
   
    
    rc=[[UIRefreshControl alloc]init];
    [rc setBackgroundColor:[UIColor clearColor]];
    _lblUpdate.text=@"";
    [rc addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [rc setTintColor:[UIColor whiteColor]];

    [_tblNatRail addSubview:rc];

    // Do any additional setup after loading the view.
}

-(void)resetValue
{
    
     [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"arrN2"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"arrN1"];

}
- (void)refresh:(id)sender
{
    Loadershow=@"No";
   
    
   [self webServiceCallingForRailway];
       //_lblUpdatedTime.text=[[NSDate date] description];
    // [_tblLondonTube reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webServiceCallingForRailway
{
    if([Loadershow isEqualToString:@"No"])
    {}
    else
    {
    [[AppDelegate appDelegate] showLoadingAlert:self.view];
     //   [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowMBProgressBar object:@"Loading..."];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer.timeoutInterval=30.0;
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"syscraft" password:@"sis*123"];
    //[httpclient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
   /*    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"rdg_to_padexpire"] != nil)
    {
        strUrl=@"http://183.182.87.171/svn/mycityapp/mycityapp/apis/DV/status/nationalRail/from/RDG/to/PAD/refresh=1";
        
    }
    else if ([[NSUserDefaults standardUserDefaults] valueForKey:@"pad_to_rdgexpire"] != nil)
    {
        strUrl=@"http://183.182.87.171/svn/mycityapp/mycityapp/apis/DV/status/nationalRail/from/PAD/to/RDG/refresh=1";
        
    }*/
    
[manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
   
   // NSLog(@"error data is %@",[responseObject valueForKey:@"data"]);
    
    NSMutableArray *array1=[[NSMutableArray alloc]init];
    [array1 removeAllObjects];
    array1 =responseObject;
    
    NSDictionary *dict = [array1 objectAtIndex:0];
    NSMutableArray *array2=[[NSMutableArray alloc]init];
    [array2 removeAllObjects];
    
    array2=[dict valueForKey:@"data"];
    if ([[dict valueForKey:@"error"] isEqualToString:@"No Content Found"]) {
        
        [self.view makeToast:NSLocalizedString(@"Device Id is Not Valid", nil) duration:3.0 position:CSToastPositionCenter];
        
        
    }
    

  else  if([[dict valueForKey:@"error"]isEqualToString:@""])
    {
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
        
        
        if(array2.count==0)
       {
        [self.view makeToast:NSLocalizedString(@"Data Not Found", nil) duration:3.0 position:CSToastPositionCenter];
       }
        else
        {
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"rdg_to_pad"] != nil)
        {
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"rdg_to_pad"];
        }
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"pad_to_rdg"] != nil)
        {

        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"pad_to_rdg"];
        }
        
        
        if(self.segSwitchStation.selectedSegmentIndex == 0)
        {
            ary1=[NSArray arrayWithObject:@"1"];
            arrayNatRail=[[NSMutableArray alloc]init];
            [arrayNatRail removeAllObjects];
            arrN1=[[NSMutableArray alloc]init];
            [arrN1 removeAllObjects];
            
            
            for(int i=0;i<[array2 count];i++)
            {
                if([[[array2 objectAtIndex:i]valueForKey:@"etd"]isEqualToString:@"Cancelled"])
                {
                    [arrayNatRail addObject:[array2 objectAtIndex:i]];
                     [arrN1 addObject:[array2 objectAtIndex:i]];
                    
                }
                else
                {
                    [arrayNatRail addObject:[array2 objectAtIndex:i]];
                     [arrN1 addObject:[array2 objectAtIndex:i]];
                    
                    
                }
                
            }
             [[NSUserDefaults standardUserDefaults]setObject:arrN1 forKey:@"arrN1"];
        
        }
        else
        {
             ary2=[NSArray arrayWithObject:@"2"];
            arrayNatRail=[[NSMutableArray alloc]init];
            [arrayNatRail removeAllObjects];
            arrN2=[[NSMutableArray alloc]init];
            [arrN2 removeAllObjects];
            NSMutableArray *array2=[[NSMutableArray alloc]init];
            [array2 removeAllObjects];
            
            array2=[dict valueForKey:@"data"];
            
            for(int i=0;i<[array2 count];i++)
            {
                if([[[array2 objectAtIndex:i]valueForKey:@"etd"]isEqualToString:@"Cancelled"])
                {
                    [arrayNatRail addObject:[array2 objectAtIndex:i]];
                    [arrN2 addObject:[array2 objectAtIndex:i]];

                    
                }
                else
                {
                    [arrayNatRail addObject:[array2 objectAtIndex:i]];
                    [arrN2 addObject:[array2 objectAtIndex:i]];
                    
                }
                
            }
            
            [[NSUserDefaults standardUserDefaults]setObject:arrN2 forKey:@"arrN2"];
        
        }
    
               NSLog(@"Nat Rail:%@",arrayNatRail);
  
        [_tblNatRail reloadData];
       NSArray *localTimee=[responseObject valueForKey:@"last_updated"];
        NSString *localTime=localTimee[0];
            BOOL local=[localTimee[0] integerValue];
            
            if(local==NO)
            {}
            else
            {
        NSArray *array = [localTime componentsSeparatedByString:@" "];
        NSString *totaltime=[array objectAtIndex:1];
        NSArray *array1 = [totaltime componentsSeparatedByString:@":"];
        _lblUpdate.text = [NSString stringWithFormat:@"Updated at %@:%@",[array1 objectAtIndex:0],[array1 objectAtIndex:1]];
        
            }

    
    }
        
   
   [rc endRefreshing];
    }
     //[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
    [[AppDelegate appDelegate] removeLoadingAlert:self.view];
    
} failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
     [rc endRefreshing];
    
   
   // UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Server Error Please Try Again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    //[alert show];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"rdg_to_pad"] != nil ||[[NSUserDefaults standardUserDefaults] valueForKey:@"rdg_to_pad"] != nil) {
        
        
        //[[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"arrN2" ];
        //[arrayNatRail addObject:]
        
        // [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"arrN1" ];
        if([[NSUserDefaults standardUserDefaults] valueForKey:@"rdg_to_pad"] != nil)
        {
             //arrayNatRail =[[NSUserDefaults standardUserDefaults] valueForKey:@"arrN1"];
            
           // [_tblNatRail reloadData];
            //[self.segSwitchStation setSelectedSegmentIndex:0];
            
        }
       else if([[NSUserDefaults standardUserDefaults] valueForKey:@"pad_to_rdg"] != nil)
        {
            // arrayNatRail =[[NSUserDefaults standardUserDefaults] valueForKey:@"arrN2"];
            //[_tblNatRail reloadData];
            //[self.segSwitchStation setSelectedSegmentIndex:1];
            
        }
        
    }
    else
    {
        //arrayNatRail =[[NSUserDefaults standardUserDefaults] valueForKey:@"arrN1"];
        
        //[_tblNatRail reloadData];
        //[self.segSwitchStation setSelectedSegmentIndex:0];
        
    }

    [self.view makeToast:NSLocalizedString(@"Server Error Please Try Again", nil) duration:3.0 position:CSToastPositionCenter];
     [[AppDelegate appDelegate] removeLoadingAlert:self.view];
     [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
    
    
    NSLog(@"%@",error.localizedDescription);

}];
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    return [ arrayNatRail count];
  
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(IS_IPHONE5|| IS_IPHONE4)
    {
        return 60.0;
    }
    else if(IS_IPHONE6plus)
    {
        return 85.0;
    }
    else
    {
        return 75.0;
    }
   
        


}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer  = [[UIView alloc] initWithFrame:CGRectZero];
    footer.backgroundColor = [UIColor clearColor];
    return footer;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"NationalCell";
    
    
    
    NationalCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NationalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
       
    }
       // cell.textLabel.text=@"Work In Progress";
    if([[[arrayNatRail objectAtIndex:indexPath.row]valueForKey:@"etd"]isEqualToString:@"Cancelled"])
    {
         cell.imgStatus.image=[UIImage imageNamed:@"imgDelay"];
         cell.lblDelayed.text=@"Cancelled";
    
    }
    else if([[[arrayNatRail objectAtIndex:indexPath.row]valueForKey:@"etd"]isEqualToString:@"Delayed"])
    {
        cell.imgStatus.image=[UIImage imageNamed:@"imgDelay"];
        //cell.lblDelayed.text=@"Cancelled";
         cell.lblDelayed.text=[NSString stringWithFormat:@"Delayed By Few Minutes"];
        
    }
    else if(![[[arrayNatRail objectAtIndex:indexPath.row]valueForKey:@"etd"]isEqualToString:@"On time"])
    {
       /* NSString *start = [[arrayNatRail objectAtIndex:indexPath.row]valueForKey:@"std"];
        NSString *end = [[arrayNatRail objectAtIndex:indexPath.row]valueForKey:@"etd"];
        
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        [f setDateFormat:@"hh:mm"];
        NSDate *startDate = [f dateFromString:start];
        NSDate *endDate = [f dateFromString:end];
            NSTimeInterval timeDifference = [endDate timeIntervalSinceDate:startDate];
        NSString *strMin=  [NSString stringWithFormat:@"%0.0f",(timeDifference/60)];*/
        NSString *strMin=[[arrayNatRail objectAtIndex:indexPath.row]valueForKey:@"delay"];
        
        if([strMin integerValue]<=1)
        {
         cell.lblDelayed.text=[NSString stringWithFormat:@"Delayed By %@ minute",strMin];
        }
        else
        {
             cell.lblDelayed.text=[NSString stringWithFormat:@"Delayed By %@ minutes",strMin];
        
        }
       
         cell.imgStatus.image=[UIImage imageNamed:@"imgDelay"];
    }
    else
    {
    cell.lblDelayed.text=[NSString stringWithFormat:@"%@",[[arrayNatRail objectAtIndex:indexPath.row]valueForKey:@"etd"]];
        cell.imgStatus.image=[UIImage imageNamed:@"imgOk"];
    
    }
    
    if([[arrayNatRail objectAtIndex:indexPath.row]valueForKey:@"platform"])
    {
   cell.lblFrom.text=[NSString stringWithFormat:@"Plat: %@",[[arrayNatRail objectAtIndex:indexPath.row]valueForKey:@"platform"]];
    }
    else
    {
    cell.lblFrom.text=[NSString stringWithFormat:@"Plat: "];
    
    }
    if([[arrayNatRail objectAtIndex:indexPath.row]valueForKey:@"std"])
    {
    cell.lblTime.text=[[arrayNatRail objectAtIndex:indexPath.row]valueForKey:@"std"];
    }
    if([[arrayNatRail objectAtIndex:indexPath.row]valueForKey:@"duration"])
    {
        
       NSArray *arrayDur= [[[arrayNatRail objectAtIndex:indexPath.row]valueForKey:@"duration"]componentsSeparatedByString:@":"];
        //[originalString characterAtIndex:index-1]
        NSString *strHrs=[NSString stringWithFormat:@"%c",[arrayDur[0] characterAtIndex:1]];
        
        cell.lblDuration.text=[NSString stringWithFormat:@"Duration %@h %@m",strHrs,arrayDur[1]];
   
    }
    else
    {
         cell.lblDuration.text=@"Duration: NA";
    
    }
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (IBAction)funcBack:(id)sender
{
       [self.navigationController popViewControllerAnimated:YES];


}

- (IBAction)funcSegmentChange:(id)sender {
    
    Loadershow=@"";
    
    if([AppDelegate appDelegate].isCheckConnection){
        
        _tblNatRail.hidden=YES;
        //Internet connection not available. Please try again.
        
        //        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Internate error" message:@"Internet connection not available. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alertView show];
        
        // if (self.segSwitchStation.selectedSegmentIndex == 0) {
        
      //  NSString *uuid=[self getUniqueDeviceIdentifierAsString];
        
      //  strUrl=[NSString stringWithFormat:baseUrl@"/status/nationalRail/from/RDG/to/PAD/device_id/%@",uuid];
        
        if(self.segSwitchStation.selectedSegmentIndex == 0)
        {
            if([[NSUserDefaults standardUserDefaults] valueForKey:@"arrN1"]!=nil)
            {
                arrayNatRail =[[NSUserDefaults standardUserDefaults] valueForKey:@"arrN1"];
                [_tblNatRail reloadData];
            }
            
            
            //[self.segSwitchStation setSelectedSegmentIndex:0];
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            [tracker set:kGAIScreenName value:@"Reading to Padington Screen"];
            [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
            
        }
        else if(self.segSwitchStation.selectedSegmentIndex == 1)
        {
            if([[NSUserDefaults standardUserDefaults] valueForKey:@"arrN2"]!= nil)
            {
                arrayNatRail =[[NSUserDefaults standardUserDefaults] valueForKey:@"arrN2"];
                [_tblNatRail reloadData];
            }
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            [tracker set:kGAIScreenName value:@"Padington To Reading Screen"];
            [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
            
        }
        
        [self.view makeToast:NSLocalizedString(@"Internet Connection Not Available Please Try Again", nil) duration:3.0 position:CSToastPositionCenter];
     //   [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
        
    }
    else
    {
         _tblNatRail.hidden=NO;
        if (self.segSwitchStation.selectedSegmentIndex == 0) {
       
        NSString *uuid=[self getUniqueDeviceIdentifierAsString];
        
        strUrl=[NSString stringWithFormat:baseUrl@"/status/nationalRail/from/RDG/to/PAD/device_id/%@",uuid];
        //NSObject * object2=[[NSUserDefaults standardUserDefaults]objectForKey:@"arrN1"];
        
        
      /*  if(object2 != nil)
        {
            arrayNatRail=[[NSUserDefaults standardUserDefaults]valueForKey:@"arrN1"];
            
            [_tblNatRail reloadData];
        }
        
        else
        {
            [self webServiceCallingForRailway];
        }*/
        
        [self webServiceCallingForRailway];

        
        }
        if (self.segSwitchStation.selectedSegmentIndex == 1) {
            
            NSString *uuid=[self getUniqueDeviceIdentifierAsString];
            
            strUrl=[NSString stringWithFormat:baseUrl@"/status/nationalRail/from/PAD/to/RDG/device_id/%@",uuid];
            //NSObject * object2=[[NSUserDefaults standardUserDefaults]objectForKey:@"arrN1"];
            
            
            /*  if(object2 != nil)
             {
             arrayNatRail=[[NSUs                                                                                                                                                                                                                                          erDefaults standardUserDefaults]valueForKey:@"arrN1"];
             
             [_tblNatRail reloadData];
             }
             
             else
             {
             [self webServiceCallingForRailway];
             }*/
            
            [self webServiceCallingForRailway];
            
            
        }

    }
}
- (IBAction)funcSettingCall:(id)sender {
    SettingViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
   // [self.navigationController pushViewController:obj animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController: obj animated:YES];
        
    });
    
}
@end
