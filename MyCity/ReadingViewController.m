//
//  ReadingViewController.m
//  MyCity
//
//  Created by Admin on 25/11/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import "ReadingViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "ReadingTableViewCell.h"
#import "TaxiViewController.h"
#import "ViewController.h"
#import "SettingViewController.h"
#import "HomeViewController.h"
#import "SSKeychain.h"
#import "UIView+Toast.h"



@interface ReadingViewController ()

@end

@implementation ReadingViewController


- (void)viewDidLoad {
    [super viewDidLoad];

   
    _tblReading.layer.cornerRadius=5.0;
    _tblReading.layer.masksToBounds=YES;
    self.tblReading.tableFooterView = [UIView new];
    self.segmentCtrl2.selectedSegmentIndex = 4;

  
        
    
    // Do any additional setup after loading the view.
}
- (UIStatusBarStyle) preferredStatusBarStyle

{
    return UIStatusBarStyleLightContent;
}
-(void)refreshingg
{
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"arrrayReading"];
    
    
    
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   // AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   // appDelegate.tabBarControllerMain = self.tabBarController;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [[AppDelegate appDelegate] CheckNotEnabled];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Reading Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(refreshingg) userInfo:nil repeats:NO];
    NSObject * object2=[[NSUserDefaults standardUserDefaults]objectForKey:@"arrrayReading"];
    if([AppDelegate appDelegate].isCheckConnection){
        
        //Internet connection not available. Please try again.
        
        //        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Internate error" message:@"Internet connection not available. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alertView show];
        
        if([[NSUserDefaults standardUserDefaults] valueForKey:@"arrrayReading2"] != nil)
        {
            arrrayReading =[[NSUserDefaults standardUserDefaults] valueForKey:@"arrrayReading2"];
            
            [_tblReading reloadData];
            
        }
        
        
        [self.view makeToast:NSLocalizedString(@"Internet Connection Not Available Please Try Again", nil) duration:3.0 position:CSToastPositionCenter];
     //   [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
        
    }
    else
    {
        [self ReadingCallingWebService];
    
    if(object2 != nil)
    {
        //arrrayReading=[[NSUserDefaults standardUserDefaults]valueForKey:@"arrrayReading"];
        
       // [_tblReading reloadData];
    }
    
    else
    {
        
    }
    
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




-(void)ReadingCallingWebService
{
    [[AppDelegate appDelegate] showLoadingAlert:self.view];
    // [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowMBProgressBar object:@"Loading..."];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"syscraft" password:@"sis*123"];
    //[httpclient setDefaultHeader:@"Accept" value:@"application/json"];
     [manager.requestSerializer setTimeoutInterval:30.0];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
     NSString *uuid=[self getUniqueDeviceIdentifierAsString];
    NSString *path=[NSString stringWithFormat:baseUrl@"/menus/index/name/Reading/device_id/%@",uuid];
    
   
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
        
         if([[responseObject valueForKey:@"error"]isEqualToString:@""])
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

            // [[self.tabBarController.tabBar.items objectAtIndex:0] setBadgeValue:badgeC];
             [[NSUserDefaults standardUserDefaults]setObject:[[[responseObject valueForKey:@"data"]objectAtIndex:0]valueForKey:@"sp_image_path"] forKey:@"imgpath"];

             arrrayReading=[[NSMutableArray alloc]init];
             [arrrayReading removeAllObjects];
             
                  arrrayReading =[[[responseObject valueForKey:@"data"]objectAtIndex:0]valueForKey:@"sub_menu"];
             [[NSUserDefaults standardUserDefaults]setObject:arrrayReading forKey:@"arrrayReading"];
             [[NSUserDefaults standardUserDefaults]setObject:arrrayReading forKey:@"arrrayReading2"];
             [_tblReading reloadData];
             
             
         }
         else
         {
             
         }
         NSLog(@"Reading Response: %@", arrrayReading);
         
         [[AppDelegate appDelegate] removeLoadingAlert:self.view];
      //   [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         if([[NSUserDefaults standardUserDefaults]valueForKey:@"arrrayReading2"]!=nil)
         {
            // arrrayReading=[[NSUserDefaults standardUserDefaults]valueForKey:@"arrrayReading2"];
            // [_tblReading reloadData];
         
         }
         
         [self.view makeToast:NSLocalizedString(@"Server Error Please Try Again", nil) duration:3.0 position:CSToastPositionCenter];
         [[AppDelegate appDelegate] removeLoadingAlert:self.view];
      //   [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
         
         
     }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    return [ arrrayReading count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"ReadingTableViewCell";
    ReadingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[ReadingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
       
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.lblHeading.text=[[arrrayReading objectAtIndex:indexPath.row] valueForKey:@"menu_name"];
    
                        ;
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaxiViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"TaxiViewController"];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array removeAllObjects];
    array = [[arrrayReading objectAtIndex:indexPath.row] valueForKey:@"service_providers"];
    obj.arrayService = array;
    obj.strTitle =[[arrrayReading objectAtIndex:indexPath.row] valueForKey:@"menu_name"];
    
   // [self.navigationController pushViewController:obj animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController: obj animated:YES];
        
    });

    

    
}

- (IBAction)ActionbackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (IBAction)FuncCallSetting:(id)sender
{
    
    SettingViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    //[self.navigationController pushViewController:obj animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController: obj animated:YES];
        
    });

    
    
}



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

@end
