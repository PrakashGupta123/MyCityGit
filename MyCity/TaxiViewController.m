






//
//  TaxiViewController.m
//  MyCity
//
//  Created by Admin on 24/11/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import "TaxiViewController.h"
#import "TaxiTableViewCell.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "HomeViewController.h"
#import "SettingViewController.h"
#import "ReadingViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SSKeychain.h"
#import "UIImageView+WebCache.h"
#import "UIView+Toast.h"
@interface TaxiViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation TaxiViewController

- (BOOL)hidesBottomBarWhenPushed {
    return [self funcReturn];
}

-(BOOL)funcReturn
{
    if (self.arrayService.count == 0) {
        return NO;
    }
    else
    {
        return YES;
    }

}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

   //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //appDelegate.tabBarControllerMain = self.tabBarController;
}
- (UIStatusBarStyle) preferredStatusBarStyle

{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [[AppDelegate appDelegate] CheckNotEnabled];
     [[AppDelegate appDelegate] CheckLocEnabled];
    [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(refreshhing) userInfo:nil repeats:NO];
   
    
    if([AppDelegate appDelegate].isCheckConnection){
        
        //Internet connection not available. Please try again.
        
        //        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Internate error" message:@"Internet connection not available. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alertView show];
        
//        if([[NSUserDefaults standardUserDefaults] valueForKey:@"arrayTaxi2"] != nil)
//        {
//            arrayTaxi =[[NSUserDefaults standardUserDefaults] valueForKey:@"arrayTaxi2"];
//            imgpath= [[NSUserDefaults standardUserDefaults]valueForKey :@"imgpath"];
//            [_tbltaxi reloadData];
//            
//        }
        if (self.arrayService.count == 0) {
            self.lblTitle.text = @"Taxi";
            
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            [tracker set:kGAIScreenName value:@"Taxi Screen"];
            [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
            if(IS_IPHONE4 || IS_IPHONE5)
            {
                self.tbltaxi.frame = CGRectMake(self.tbltaxi.frame.origin.x,self.tbltaxi.frame.origin.y, self.view.frame.size.width-19.0, self.view.frame.size.height-115.0);
            }
            else if(IS_IPHONE6)
            {
                self.tbltaxi.frame = CGRectMake(self.tbltaxi.frame.origin.x,self.tbltaxi.frame.origin.y, self.view.frame.size.width-19, self.view.frame.size.height-125.0);
                
            }
            else if (IS_IPHONE6plus)
            {
                self.tbltaxi.frame = CGRectMake(self.tbltaxi.frame.origin.x,self.tbltaxi.frame.origin.y, self.view.frame.size.width-19, self.view.frame.size.height-132.0);
                
            }
            _tbltaxi.translatesAutoresizingMaskIntoConstraints=YES;
            _btnbackk.userInteractionEnabled=NO;
            _imgbackk.hidden=YES;
            NSObject * object1=[[NSUserDefaults standardUserDefaults]objectForKey:@"arrayTaxi2"];
            
            
            if(object1 != nil)
            {
               // arrayTaxi=[[NSUserDefaults standardUserDefaults]valueForKey:@"arrayTaxi2"];
                //imgpath= [[NSUserDefaults standardUserDefaults]valueForKey :@"imgpath"];
                //[_tbltaxi reloadData];
            }
            
            else
            {
                [self TaxiCalling];
            }
            
            
            
            
        }
        
        else
        {
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            [tracker set:kGAIScreenName value:@"Reading Screen"];
            [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
            _btnbackk.userInteractionEnabled=YES;
            _imgbackk.hidden=NO;
            
            if ([self.strTitle isEqualToString:@"Movers & Packers"]) {
                
                self.lblTitle.text = self.strTitle;
                //self.lblTitle.font = [UIFont boldSystemFontOfSize:24.0];
            }
            else
            {
                self.lblTitle.text = self.strTitle;
            }
            arrayTaxi=[[NSMutableArray alloc]init];
            [arrayTaxi removeAllObjects];
            arrayTaxi = self.arrayService;
            
            
            
        }
        
        [self.view makeToast:NSLocalizedString(@"Internet Connection Not Available Please Try Again", nil) duration:3.0 position:CSToastPositionCenter];
     //   [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
         [[AppDelegate appDelegate] removeLoadingAlert:self.view];
        
    }
    else
    {
        
        
    if (self.arrayService.count == 0) {
        self.lblTitle.text = @"Taxi";
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Taxi Screen"];
        
        if(IS_IPHONE4 || IS_IPHONE5)
        {
            self.tbltaxi.frame = CGRectMake(self.tbltaxi.frame.origin.x,self.tbltaxi.frame.origin.y, self.view.frame.size.width-19.0, self.view.frame.size.height-115.0);
        }
        else if(IS_IPHONE6)
        {
            self.tbltaxi.frame = CGRectMake(self.tbltaxi.frame.origin.x,self.tbltaxi.frame.origin.y, self.view.frame.size.width-19, self.view.frame.size.height-125.0);
            
        }
        else if (IS_IPHONE6plus)
        {
            self.tbltaxi.frame = CGRectMake(self.tbltaxi.frame.origin.x,self.tbltaxi.frame.origin.y, self.view.frame.size.width-19, self.view.frame.size.height-132.0);
        
        }
        _tbltaxi.translatesAutoresizingMaskIntoConstraints=YES;
        _btnbackk.userInteractionEnabled=NO;
        _imgbackk.hidden=YES;
        /* NSObject * object1=[[NSUserDefaults standardUserDefaults]objectForKey:@"arrayTaxi2"];
        
        
       if(object1 != nil)
        {
            arrayTaxi=[[NSUserDefaults standardUserDefaults]valueForKey:@"arrayTaxi2"];
            imgpath= [[NSUserDefaults standardUserDefaults]valueForKey :@"imgpath"];
            [_tbltaxi reloadData];
        }
        
        
        else
        {*/
            [self TaxiCalling];
        //}
        
        
        
        
    }
    
    else
    {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Reading Page"];
        _btnbackk.userInteractionEnabled=YES;
        _imgbackk.hidden=NO;
        
        if ([self.strTitle isEqualToString:@"Movers & Packers"]) {
            
            self.lblTitle.text = self.strTitle;
            //self.lblTitle.font = [UIFont boldSystemFontOfSize:24.0];
        }
        else
        {
            self.lblTitle.text = self.strTitle;
        }
        arrayTaxi=[[NSMutableArray alloc]init];
        [arrayTaxi removeAllObjects];
        arrayTaxi = self.arrayService;
        
        
        
    }
        
    }

}

-(void)viewWillDisappear:(BOOL)animated
{
    if (self.arrayService.count != 0){
        
        //[self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    _viewCall.hidden=YES;
   
    arrayTaxi=[[NSMutableArray alloc]init];
    [arrayTaxi removeAllObjects];
    _viewCall.layer.borderColor =[UIColor colorWithRed:51/255.0 green:95/255.0 blue:129/255.0 alpha:1.0].CGColor;
    _viewCall.layer.borderWidth = 1.0f;
    _viewCall.layer.cornerRadius=5.0;
    _viewCall.layer.masksToBounds=YES;
    
    
    
    // Do any additional setup after loading the view.
}

-(void)refreshhing
{
       [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"arrayTaxi"];
    
    


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    return [ arrayTaxi count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"TaxiTableViewCell";
    
    
    
    TaxiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[TaxiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
   
    cell.lblHeadingTaxi.text=[[arrayTaxi objectAtIndex:indexPath.row]valueForKey:@"sp_name"];
    // cell.lblEmail.text=[[arrayTaxi objectAtIndex:indexPath.row]valueForKey:@"sp_email"];
    //[[[responseObject valueForKey:@"data"]objectAtIndex:0]valueForKey:@"service_providers"]sp_details
      cell.lblPhoneNo.text=[NSString stringWithFormat:@"Call: %@",[[arrayTaxi objectAtIndex:indexPath.row]valueForKey:@"sp_phone"]];
    NSURL *imgUrl =[[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]valueForKey :@"imgpath"],[[arrayTaxi objectAtIndex:indexPath.row]valueForKey:@"sp_image"]]];
    
    [cell.imgTaxi sd_setImageWithURL:imgUrl placeholderImage:nil];
    //[imageView hnk_setImageFromURL:url];
    
    cell.lblDescription.text=[[arrayTaxi objectAtIndex:indexPath.row]valueForKey:@"sp_details"];
    
    cell.lblUrl.text=[[arrayTaxi objectAtIndex:indexPath.row]valueForKey:@"sp_website"];
    cell.btnOpenLink.tag=indexPath.row;
    cell.btnCallNo.tag=indexPath.row;
    cell.btnCall2.tag=indexPath.row;
    [cell.btnOpenLink addTarget:self action:@selector(funcOpenUrl:) forControlEvents:UIControlEventTouchUpInside];
[cell.btnCallNo addTarget:self action:@selector(funcCallUrl:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnCall2 addTarget:self action:@selector(funcCallUrl:) forControlEvents:UIControlEventTouchUpInside];
    /*if(!([[[arrayTaxi objectAtIndex:indexPath.row ]valueForKey:@"sp_website"]isEqualToString:@""])&&!([[[arrayTaxi objectAtIndex:indexPath.row ]valueForKey:@"sp_email"]isEqualToString:@""])&&!([[[arrayTaxi objectAtIndex:indexPath.row ]valueForKey:@"sp_phone"]isEqualToString:@""]))
    {
        
        
        cell.lblEmail.hidden=NO;
        cell.lblUrl.hidden=NO;
        cell.lblPhoneNo.hidden=NO;
    }

   else if([[[arrayTaxi objectAtIndex:indexPath.row ]valueForKey:@"sp_website"]isEqualToString:@""]&&[[[arrayTaxi objectAtIndex:indexPath.row ]valueForKey:@"sp_email"]isEqualToString:@""])
    {
        cell.lblEmail.hidden=YES;
        cell.lblUrl.hidden=YES;
        
        
    }
    else if(!([[[arrayTaxi objectAtIndex:indexPath.row ]valueForKey:@"sp_website"]isEqualToString:@""])&&[[[arrayTaxi objectAtIndex:indexPath.row ]valueForKey:@"sp_email"]isEqualToString:@""])
    {
        cell.lblEmail.text=[[arrayTaxi objectAtIndex:indexPath.row ]valueForKey:@"sp_website"];
        cell.lblEmail.hidden=NO;
        cell.lblUrl.hidden=YES;
       
        
    }
    else if([[[arrayTaxi objectAtIndex:indexPath.row ]valueForKey:@"sp_website"]isEqualToString:@""])
    {
        cell.lblUrl.hidden=YES;
        
        
    }*/

     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)funcCallUrl:(UIButton *) sender

{
    NSLog(@"Tag of butn is %ld",(long)[sender tag]);
    UIButton *btn=sender;
    if(self.arrayService.count==0)
    {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                              action:@"Taxi Called"  // Event action (required)
                                                               label:[[arrayTaxi objectAtIndex:btn.tag]valueForKey:@"sp_name"]         // Event label
                                                               value:nil] build]];
    }
    
    else
    {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                              action:[NSString stringWithFormat:@"%@ Called",self.strTitle]  // Event action (required)
                                                               label:[[arrayTaxi objectAtIndex:btn.tag]valueForKey:@"sp_name"]         // Event label
                                                               value:nil] build]];    // Event value
    }

    //[[arrayTaxi objectAtIndex:btn.tag] valueForKey:@"sp_website"];
    if([[[arrayTaxi objectAtIndex:btn.tag] valueForKey:@"sp_phone"]isEqualToString:@""])
    {
        
    }
    else
    {
       // NSURL *url = [NSURL URLWithString:[[arrayTaxi objectAtIndex:btn.tag] valueForKey:@"sp_phone"]];
        NSString *strNo = [[arrayTaxi objectAtIndex:btn.tag]valueForKey:@"sp_phone"];
        
        
        NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",strNo]];
        
        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
            [[UIApplication sharedApplication] openURL:phoneUrl];
        }
        else
        {
            NSLog(@"Alert");
            
        }
        

    }
}

-(void)funcOpenUrl:(UIButton *) sender

{
    NSLog(@"Tag of butn is %ld",(long)[sender tag]);
    UIButton *btn=sender;
   
    
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                              action:[NSString stringWithFormat:@"%@ Called",self.strTitle]  // Event action (required)
                                                               label:[[arrayTaxi objectAtIndex:btn.tag]valueForKey:@"sp_website"]         // Event label
                                                               value:nil] build]];    // Event value
    

    //[[arrayTaxi objectAtIndex:btn.tag] valueForKey:@"sp_website"];
    if([[[arrayTaxi objectAtIndex:btn.tag] valueForKey:@"sp_website"]isEqualToString:@""])
    {
    
    }
    else
    {
    NSURL *url = [NSURL URLWithString:[[arrayTaxi objectAtIndex:btn.tag] valueForKey:@"sp_website"]];
    [[UIApplication sharedApplication] openURL:url];
    }
}

/*- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!([[[arrayTaxi objectAtIndex:indexPath.row ]valueForKey:@"sp_website"]isEqualToString:@""])&&!([[[arrayTaxi objectAtIndex:indexPath.row ]valueForKey:@"sp_email"]isEqualToString:@""])&&!([[[arrayTaxi objectAtIndex:indexPath.row ]valueForKey:@"sp_phone"]isEqualToString:@""]))
    {
        
        return 90;
    }
    
   else if([[[arrayTaxi objectAtIndex:indexPath.row ]valueForKey:@"sp_website"]isEqualToString:@""]&&[[[arrayTaxi objectAtIndex:indexPath.row ]valueForKey:@"sp_email"]isEqualToString:@""])
    {
       
        
        return 50;
    }
    else if(!([[[arrayTaxi objectAtIndex:indexPath.row ]valueForKey:@"sp_website"]isEqualToString:@""])&&[[[arrayTaxi objectAtIndex:indexPath.row ]valueForKey:@"sp_email"]isEqualToString:@""])
    {
        
        return 80;
        
    }
   else if([[[arrayTaxi objectAtIndex:indexPath.row ]valueForKey:@"sp_website"]isEqualToString:@""])
    {
        

      return 80;
    }
    
    return 0;
}*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
  /*  NSString *strNo = [[arrayTaxi objectAtIndex:indexPath.row]valueForKey:@"sp_phone"];
    
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",strNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
    else
    {
        NSLog(@"Alert");
        
    }*/

  /*  
    CGRect cellRect = [tableView rectForRowAtIndexPath:indexPath];
    NSLog(@"%f%f",cellRect.origin.x,cellRect.origin.y);
    
    
   
    UIView *vwTemp=[self.view viewWithTag:987654];
    [vwTemp removeFromSuperview];
    vwTemp=nil;
    
    UIView *vwPopUp=[[UIView alloc]init];
    vwPopUp.tag=987654;
    if(IS_IPHONE6)
    {
        [vwPopUp setFrame:CGRectMake(104, cellRect.origin.y+150, 152, 61)];
    
    }
    else
    {
    [vwPopUp setFrame:CGRectMake(84, cellRect.origin.y+150, 152, 61)];
    }
    [vwPopUp setBackgroundColor:[UIColor whiteColor]];
    
    vwPopUp.layer.borderColor =[UIColor colorWithRed:37/255.0 green:96/255.0 blue:143/255.0 alpha:1.0].CGColor;
    vwPopUp.layer.borderWidth = 1.0f;
    vwPopUp.layer.cornerRadius=5.0;
    vwPopUp.layer.masksToBounds=YES;
    
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(0,2, 152,20)];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setTextColor:[UIColor blackColor]];
    lbl.text=[[arrayTaxi objectAtIndex:indexPath.row]valueForKey:@"sp_phone"];
    [vwPopUp addSubview:lbl];
    
    UIView *viewLine1 = [[UIView alloc] init];
    viewLine1.frame = CGRectMake(0, 26, 152, 1);
    [viewLine1 setBackgroundColor:[UIColor lightGrayColor]];
    [vwPopUp addSubview:viewLine1];
    
    UIView *viewLine2 = [[UIView alloc] init];
    viewLine2.frame = CGRectMake(80, 28, 1, 33);
    [viewLine2 setBackgroundColor:[UIColor lightGrayColor]];
    [vwPopUp addSubview:viewLine2];
    //37,96,143
    UIButton *btnCancel = [[UIButton alloc] init];
    btnCancel.frame = CGRectMake(5, 33, 63, 23);
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [ btnCancel setTitleColor:[UIColor colorWithRed:37/255.0 green:96/255.0 blue:143/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    
    [btnCancel addTarget:self action:@selector(btnCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [vwPopUp addSubview:btnCancel];
    
    
    UIButton *btnCall = [[UIButton alloc] init];
    btnCall.frame = CGRectMake(88, 32, 54, 25);
    btnCall.tag = indexPath.row;
    [btnCall setTitle:@"Call" forState:UIControlStateNormal];
    [btnCall addTarget:self action:@selector(btnCallAction:) forControlEvents:UIControlEventTouchUpInside];
    [ btnCall setTitleColor:[UIColor colorWithRed:37/255.0 green:96/255.0 blue:143/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [vwPopUp addSubview:btnCall];
    
    
    [self.view addSubview:vwPopUp];*/
    
    
    
    
}
-(IBAction)FuncCallSetting:(id)sender
{
    SettingViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    
    [self.navigationController pushViewController:obj animated:YES];
   

}

-(void)btnCancelAction:(UIButton *)sender
{
    UIView *vwTemp=[self.view viewWithTag:987654];
    [vwTemp removeFromSuperview];
    vwTemp=nil;
    
}



-(void)btnCallAction:(UIButton *)sender
{
    
    int tag = (int)sender.tag;
    if(self.arrayService.count==0)
    {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                              action:@"Taxi Called"  // Event action (required)
                                                               label:[[arrayTaxi objectAtIndex:tag]valueForKey:@"sp_name"]         // Event label
                                                               value:nil] build]];
    }
    
    else
    {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                          action:@"Taxi Called"  // Event action (required)
                                                           label:[[arrayTaxi objectAtIndex:tag]valueForKey:@"sp_name"]         // Event label
                                                           value:nil] build]];    // Event value
    }
    
    NSString *strNo = [[arrayTaxi objectAtIndex:tag]valueForKey:@"sp_phone"];
    
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",strNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
    else
    {
        NSLog(@"Alert");
        
    }
}




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIView *vwTemp=[self.view viewWithTag:987654];
    [vwTemp removeFromSuperview];
    vwTemp=nil;
}



-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                    withVelocity:(CGPoint)velocity
             targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    /*if (velocity.y > 0){
        
        UIView *vwTemp=[self.view viewWithTag:987654];
        [vwTemp removeFromSuperview];
        vwTemp=nil;
        NSLog(@"up");
    }
    if (velocity.y < 0){
        
        UIView *vwTemp=[self.view viewWithTag:987654];
        [vwTemp removeFromSuperview];
        vwTemp=nil;
        
    }*/
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==12)
    {
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

-(void)TaxiCalling
{
    [[AppDelegate appDelegate] showLoadingAlert:self.view];
     //[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowMBProgressBar object:@"Loading..."];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager.requestSerializer setTimeoutInterval:30.0];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"syscraft" password:@"sis*123"];
    //[httpclient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSString *uuid=[self getUniqueDeviceIdentifierAsString];
    NSString *path=[NSString stringWithFormat:baseUrl@"/menus/index/name/Taxi/device_id/%@",uuid];
    
     //manager.requestSerializer.timeoutInterval=30.0;
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         if([[responseObject valueForKey:@"error"]isEqualToString:@""])
         {
             arrayTaxi=[[NSMutableArray alloc]init];
             [arrayTaxi removeAllObjects];
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

             if ([[[[responseObject valueForKey:@"data"]objectAtIndex:0]valueForKey:@"service_providers"] isKindOfClass:[NSArray class]]) {
                 
                   arrayTaxi =[[[responseObject valueForKey:@"data"]objectAtIndex:0]valueForKey:@"service_providers"];
                 [[NSUserDefaults standardUserDefaults]setObject:arrayTaxi forKey:@"arrayTaxi"];
                 [[NSUserDefaults standardUserDefaults]setObject:arrayTaxi forKey:@"arrayTaxi2"];
                 
                     imgpath=  [[[responseObject valueForKey:@"data"]objectAtIndex:0]valueForKey:@"sp_image_path"];
                 [[NSUserDefaults standardUserDefaults]setObject:imgpath forKey:@"imgpath"];

                 
             }
             else
             {
                // NSDictionary *dict = responseObject;
                
             }
             
             
             
             //arrayTaxi=[arrayTaxi1 objectAtIndex:0];
       
             [_tbltaxi reloadData];
             
             
         }
         else
         {
            [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"BadgeValue"];
                 [UIApplication sharedApplication].applicationIconBadgeNumber=[[[NSUserDefaults standardUserDefaults] valueForKey:@"BadgeValue"]integerValue];
                 
             
         
         }
         NSLog(@"Taxi Response: %@", responseObject);
      //   [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
         [[AppDelegate appDelegate] removeLoadingAlert:self.view];
         
         
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
        
         //[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
         //UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"Title" message:@" It is taking longer than expected time, Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
         if([[NSUserDefaults standardUserDefaults]valueForKey:@"arrayTaxi"]!=nil)
         {
            // arrayTaxi=[[NSUserDefaults standardUserDefaults]valueForKey:@"arrayTaxi"];
             //[_tbltaxi reloadData];
         }
          [[[UIApplication sharedApplication] keyWindow] makeToast:NSLocalizedString(@"Server Error Please Try Again", nil) duration:3.0 position:CSToastPositionBottom];
          //[self.view makeToast:NSLocalizedString(@"Server Error Please Try Again", nil) duration:3.0 position:CSToastPositionCenter];
      //   [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
          [[AppDelegate appDelegate] removeLoadingAlert:self.view];
         //av.tag=12;
        // [av show];
         
         
     }];
}
- (IBAction)funcCancelCall:(id)sender {
    _viewCall.hidden=YES;
}
- (IBAction)funcBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
        
        HomeViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
       // [self.navigationController pushViewController:obj animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController: obj animated:YES];
            
        });

        return;
        
        
        
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

- (IBAction)funcCall:(id)sender {
}
@end
