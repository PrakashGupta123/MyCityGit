//
//  LondonTubeDetailViewController.m
//  MyCity
//
//  Created by Admin on 09/12/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import "LondonTubeDetailViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "SSKeychain.h"
#import "UIView+Toast.h"
#import "SettingViewController.h"
@interface LondonTubeDetailViewController ()

@end

@implementation LondonTubeDetailViewController
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   // AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   // appDelegate.tabBarControllerMain = self.tabBarController;
}
- (UIStatusBarStyle) preferredStatusBarStyle

{
    return UIStatusBarStyleLightContent;
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
     [[AppDelegate appDelegate] CheckNotEnabled];
     [[AppDelegate appDelegate] CheckLocEnabled];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"London Tube Detail Screen"];
    [self.navigationController setNavigationBarHidden:YES];
    
    _viewStatusDescription.layer.cornerRadius=8.0;
    _viewStatusDescription.layer.masksToBounds=YES;
    
    // Do any additional setup stationName loading the view.stationImage
    
    stnName=[[NSUserDefaults standardUserDefaults] valueForKey:@"stationName"];
    _lblHeading.text=stnName;
    
    strImageStatus=   [[NSUserDefaults standardUserDefaults]valueForKey:@"stationImage"];
    if ([strImageStatus isEqualToString:@"Good Service"]) {
        [_imsStatusImage setImage:[UIImage imageNamed:@"imgOk2" ]];
       
        
    }
      if ([strImageStatus isEqualToString:@"Part Suspended"])
          {
              [_imsStatusImage setImage:[UIImage imageNamed:@"imgWarning2" ]];
     
          }
    
    else if ([strImageStatus isEqualToString:@"Part Closure"]) {
       
        [_imsStatusImage setImage:[UIImage imageNamed:@"imgWarning2" ]];
            }
    
    else if ([strImageStatus isEqualToString:@"Minor Delays"]) {
        
        [_imsStatusImage setImage:[UIImage imageNamed:@"imgWarning1" ]];
        
        
    }
    else if ([strImageStatus isEqualToString:@"Service Closed"]) {
        
        [_imsStatusImage setImage:[UIImage imageNamed:@"imgSClosed" ]];
        
        
    }
    else if ([strImageStatus isEqualToString:@"Severe Delays"]) {
        
        [_imsStatusImage setImage:[UIImage imageNamed:@"imgWarning2" ]];
        

        
    }
    else if ([strImageStatus isEqualToString:@"Suspended"]) {
        
        [_imsStatusImage setImage:[UIImage imageNamed:@"imgWarning2" ]];
        
    }
    else if ([strImageStatus isEqualToString:@"Special Service"]) {
        
        [_imsStatusImage setImage:[UIImage imageNamed:@"imgWarning1" ]];
        
    }
    else if ([strImageStatus isEqualToString:@"Planned Closure"]) {
        
        [_imsStatusImage setImage:[UIImage imageNamed:@"imgWarning1" ]];
        
        
    }
    else if ([strImageStatus isEqualToString:@"Reduced Service"]) {
        
        [_imsStatusImage setImage:[UIImage imageNamed:@"imgWarning1" ]];
        
    }//Exist OnlyBus Service
    else if ([strImageStatus isEqualToString:@"Bus Service"]) {
        
        [_imsStatusImage setImage:[UIImage imageNamed:@"imgWarning1" ]];
        
        
    }
    else if ([strImageStatus isEqualToString:@"Closed"]) {
        
        [_imsStatusImage setImage:[UIImage imageNamed:@"imgWarning1" ]];
        
    }
    else if ([strImageStatus isEqualToString:@"Part Closed"]) {
        
        [_imsStatusImage setImage:[UIImage imageNamed:@"imgWarning1" ]];
        
        
    }
    else if ([strImageStatus isEqualToString:@"Exist Only"]) {
        
        [_imsStatusImage setImage:[UIImage imageNamed:@"imgWarning1" ]];
        
        
    }
    else if ([strImageStatus isEqualToString:@"No Step Free Access"]) {
        
        [_imsStatusImage setImage:[UIImage imageNamed:@"imgWarning1" ]];
        
    }
    else if ([strImageStatus isEqualToString:@"Change of frequency"]) {
        
        [_imsStatusImage setImage:[UIImage imageNamed:@"imgWarning1" ]];
        
        
    }
    else if ([strImageStatus isEqualToString:@"Diverted"]) {
        
        [_imsStatusImage setImage:[UIImage imageNamed:@"imgWarning1" ]];
        
        
    }
    else if ([strImageStatus isEqualToString:@"Not Running"]) {
        
        [_imsStatusImage setImage:[UIImage imageNamed:@"imgWarning1" ]];
        
    }
    else if ([strImageStatus isEqualToString:@"Issues Reported"]) {
        
        [_imsStatusImage setImage:[UIImage imageNamed:@"imgWarning1" ]];
        
        
    }
    else if ([strImageStatus isEqualToString:@"No Issues"]) {
        
        [_imsStatusImage setImage:[UIImage imageNamed:@"imgWarning1" ]];
        
        
    }
    else if ([strImageStatus isEqualToString:@"Information"]) {
        
        [_imsStatusImage setImage:[UIImage imageNamed:@"imgWarning1" ]];
        
        
    }



    _lblStatus.text=strImageStatus;
    
    NSString *str = [[[NSUserDefaults standardUserDefaults] valueForKey:@"reason"]stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
   
    CGRect rect = [str boundingRectWithSize:CGSizeMake(self.view.frame.size.width-90 , FLT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor blackColor],  NSParagraphStyleAttributeName : style,NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
    CGSize requiredSize = rect.size;
 
     _lblStatusDescription.frame = CGRectMake(_lblStatusDescription.frame.origin.x, _lblStatusDescription.frame.origin.y, self.view.frame.size.width-90, requiredSize.height);
    _lblStatusDescription.numberOfLines = 0;
    _lblStatusDescription.lineBreakMode = NSLineBreakByWordWrapping;
    _lblStatusDescription.text= str;
    _lblStatusDescription.translatesAutoresizingMaskIntoConstraints = YES;
   // requiredSize.height=requiredSize.height+70;
    _viewStatusDescription.frame = CGRectMake(_viewStatusDescription.frame.origin.x, _viewCurrentStatus.frame.origin.y+_viewCurrentStatus.frame.size.height+15, self.view.frame.size.width-20, _lblStatusDescription.frame.size.height+60);
 _viewStatusDescription.translatesAutoresizingMaskIntoConstraints = YES;
   
    UIView *viewCOLOR=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 7, _viewStatusDescription.frame.size.height)];
    if ([stnName isEqualToString:@"Bakerloo"]) {
        viewCOLOR.backgroundColor =[UIColor colorWithRed:123/255.0 green:70/255.0 blue:32/255.0 alpha:1.0];
        /* UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(cell.viewBorder.frame.origin.x, cell.viewBorder.frame.origin.y, cell.viewBorder.frame.size.width,2.0f)];
         lbl.layer.borderColor=[UIColor colorWithRed:27/255.0 green:90/255.0 blue:123/255.0 alpha:1.0].CGColor;
         lbl.layer.borderWidth=0.6;
         [cell addSubview:lbl];*/
        //  cell.viewHide.hidden=NO;
        // cell.layer.borderWidth=0.6;
        // cell.viewHide.backgroundColor=[UIColor colorWithRed:27/255.0 green:90/255.0 blue:123/255.0 alpha:1.0];
        
        
        
        
        
    }
    
    if ([stnName isEqualToString:@"Central"]) {
        viewCOLOR.backgroundColor = [UIColor colorWithRed:197/255.0 green:32/255.0 blue:27/255.0 alpha:1.0];
        
    }
    
    
    if ([stnName isEqualToString:@"Circle"]) {
        viewCOLOR.backgroundColor = [UIColor colorWithRed:229/255.0 green:185/255.0 blue:0/255.0 alpha:1.0];
    }
    
    
    if ([stnName isEqualToString:@"District"]) {
        viewCOLOR.backgroundColor = [UIColor colorWithRed:0/255.0 green:102/255.0 blue:36/255.0 alpha:1.0];
        
    }
    
    
    if ([stnName isEqualToString:@"Hammersmith & City"]) {
        viewCOLOR.backgroundColor = [UIColor colorWithRed:193/255.0 green:137/255.0 blue:157/255.0 alpha:1.0];
        
        
    }
    
    
    if ([stnName isEqualToString:@"Jubilee"]) {
        viewCOLOR.backgroundColor = [UIColor colorWithRed:95/255.0 green:102/255.0 blue:107/255.0 alpha:1.0];
        
    }
    
    
    if ([stnName isEqualToString:@"Metropolitan"]) {
        viewCOLOR.backgroundColor = [UIColor colorWithRed:105/255.0 green:14/255.0 blue:77/255.0 alpha:1.0];
        
    }
    
    
    if ([stnName isEqualToString:@"Northern"]) {
        viewCOLOR.backgroundColor = [UIColor blackColor];
        
        
    }
    
    
    if ([stnName isEqualToString:@"Piccadilly"]) {
        viewCOLOR.backgroundColor = [UIColor colorWithRed:0/255.0 green:18/255.0 blue:127/255.0 alpha:1.0];
        
        
    }
    
    
    if ([stnName isEqualToString:@"Victoria"]) {
        viewCOLOR.backgroundColor = [UIColor colorWithRed:0/255.0 green:143/255.0 blue:203/255.0 alpha:1.0];
        
        
    }
    
    
    if ([stnName isEqualToString:@"Waterloo & City"]) {
        viewCOLOR.backgroundColor = [UIColor colorWithRed:106/255.0 green:189/255.0 blue:169/255.0 alpha:1.0];
        /* UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(cell.viewBorder.frame.origin.x, cell.viewBorder.frame.origin.y+cell.viewBorder.frame.size.height-2,self.view.frame.size.width-30,2.0f)];
         lbl.layer.borderColor=[UIColor colorWithRed:27/255.0 green:90/255.0 blue:123/255.0 alpha:1.0].CGColor;
         lbl.layer.borderWidth=0.6;
         [cell addSubview:lbl];*/
        // cell.viewhide2.hidden=NO;
        // cell.viewhide2.layer.backgroundColor=[UIColor colorWithRed:27/255.0 green:90/255.0 blue:123/255.0 alpha:0.3].CGColor;
        //        cell.viewhide2.hidden=NO;
        //        cell.layer.bo   rderWidth=0.6;
        //        cell.viewhide2.layer.borderColor=[UIColor colorWithRed:27/255.0 green:90/255.0 blue:123/255.0 alpha:1.0].CGColor;
        
    }
      // [_viewStatusDescription addSubview:viewCOLOR];
    if(IS_IPHONE5)
    {
         //requiredSize.height=requiredSize.height+70;
        //_lblStatusDescription.frame = CGRectMake(_lblStatusDescription.frame.origin.x, _lblStatusDescription.frame.origin.y, _viewStatusDescription.frame.size.width-65, requiredSize.height);
       
       
    
    }
    if(IS_IPHONE6)
    {
        
        
  // _lblStatusDescription.frame = CGRectMake(_lblStatusDescription.frame.origin.x, _lblStatusDescription.frame.origin.y, _viewStatusDescription.frame.size.width-20, requiredSize.height+40);
   // requiredSize.height=requiredSize.height+70;
   
   // _viewStatusDescription.frame = CGRectMake(_viewStatusDescription.frame.origin.x, _viewStatusDescription.frame.origin.y+20, _viewStatusDescription.frame.size.width+55, requiredSize.height);
    }
    if(IS_IPHONE6plus)
    {
        
       // _lblStatusDescription.frame = CGRectMake(_lblStatusDescription.frame.origin.x, _lblStatusDescription.frame.origin.y, _viewStatusDescription.frame.size.width, requiredSize.height+40);
       // requiredSize.height=requiredSize.height+70;
        
       // _viewStatusDescription.frame = CGRectMake(_viewStatusDescription.frame.origin.x, _viewStatusDescription.frame.origin.y+20, _viewStatusDescription.frame.size.width+95, requiredSize.height);
    }
    
    [self UpdateBatchCount];

}

-(void)UpdateBatchCount
{
     [[AppDelegate appDelegate] showLoadingAlert:self.view];
    //[[NSNotificationCenter defaultCenter]postNotificationName:kNotificationShowMBProgressBar object:@"Loading..."];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager.requestSerializer setTimeoutInterval:30.0];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"syscraft" password:@"sis*123"];
    //[httpclient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
     NSString *uuid=[self getUniqueDeviceIdentifierAsString];
    NSDictionary *params;
    params =  @{@"device_id":uuid,@"severity":strImageStatus,@"title":stnName};
   
    NSString *path=[NSString stringWithFormat:baseUrl@"/status/londontube_badge_count"];
    
    manager.requestSerializer.timeoutInterval=30.0;
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *badgeC= [responseObject valueForKey:@"badge"];
         [[NSUserDefaults standardUserDefaults]setValue:badgeC forKey:@"BadgeValue"];
                  NSLog(@"LOndon Batch COunt Response: %@", responseObject);
         //[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
         [[AppDelegate appDelegate] removeLoadingAlert:self.view];
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
          [[AppDelegate appDelegate] removeLoadingAlert:self.view];
        // [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
        
         [self.view makeToast:NSLocalizedString(@"Server Error Please Try Again", nil) duration:3.0 position:CSToastPositionCenter];
         
         
     }];
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
-(IBAction)funSettingCall:(id)sender
{
    SettingViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [self.navigationController pushViewController:vc animated:YES];


}

- (IBAction)funcBack:(id)sender {
    

    [self.navigationController popViewControllerAnimated:YES];
    

    
}
@end
