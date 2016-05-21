//
//  OffersDetailViewController.m
//  MyCity
//
//  Created by Admin on 30/12/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import "OffersDetailViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import <UIImageView+AFNetworking.h>
#import "offersDetailCell.h"
#import "OpeningHoursCell.h"
#import "SSKeychain.h"
#import "UIView+Toast.h"

@interface OffersDetailViewController ()

@end

@implementation OffersDetailViewController
- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}
- (UIStatusBarStyle) preferredStatusBarStyle

{
    return UIStatusBarStyleLightContent;
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //appDelegate.tabBarControllerMain = self.tabBarController;
}
-(void)viewWillAppear:(BOOL)animated
{
    //38,96,143
    [super viewWillAppear:animated];
    if ([AppDelegate appDelegate].isCheckConnection == YES) {
         [self.view makeToast:NSLocalizedString(@"Internet Connection Not Available Please Try Again", nil) duration:3.0 position:CSToastPositionCenter];
        _scrollViewDetail.hidden=YES;
    }
    else
    {
        //_scrollViewDetail.hidden=YES;
     [self OfferDetailWebService];
    }
    
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [[AppDelegate appDelegate] CheckLocEnabled];
     [[AppDelegate appDelegate] CheckNotEnabled];
  self.lblimgDiscount.transform = CGAffineTransformMakeRotation(-M_PI/4);
    _viewProductImage.layer.masksToBounds=YES;
    _lblimgDiscount.hidden=YES;

    //[self OfferDetailWebService];

    // Do any additional setup after loading the view.
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
-(void)OfferDetailWebService
{
    //[[NSUserDefaults standardUserDefaults]setObject:offerid forKey:@"offerid"];
   NSString *offerid= [[NSUserDefaults standardUserDefaults]valueForKey:@"offerid"];
    [[AppDelegate appDelegate] showLoadingAlert:self.view];
    //[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowMBProgressBar object:@"Loading..."];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"syscraft" password:@"sis*123"];
    //[httpclient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:30.0];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSString *uuid=[self getUniqueDeviceIdentifierAsString];
    NSString *urlpath=[NSString stringWithFormat:baseUrl@"/offers/offer_detail/offer_id/%@/device_id/%@",offerid,uuid];
    
    [manager GET:urlpath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if ([[responseObject valueForKey:@"error"] isEqualToString:@"No Content Found"]) {
             
             [self.view makeToast:NSLocalizedString(@"Device Id is Not Valid", nil) duration:3.0 position:CSToastPositionCenter];
             
             
         }
         
        if([[responseObject valueForKey:@"error"]isEqualToString:@""])
         {
             
             //discount_type
             _scrollViewDetail.hidden=NO;
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
             //[[self.tabBarController.tabBar.items objectAtIndex:0] setBadgeValue:badgeC];
             arraycustom1=[[NSMutableArray alloc]init];
            // [arraycustom3 removeAllObjects];
            // arraycustom3=[[NSMutableArray alloc]init];
             [arraycustom1 removeAllObjects];
            // arraycustom2=[[NSMutableArray alloc]init];
            // [arraycustom2 removeAllObjects];
             arrayOpeningHours=[[NSMutableArray alloc]init];
             [arrayOpeningHours removeAllObjects];

             arrayDetail =[[responseObject valueForKey:@"data"]objectAtIndex:0];
            
             if(arrayDetail.count==0)
             {
                 [self.view makeToast:NSLocalizedString(@"No Data Found", nil) duration:3.0 position:CSToastPositionCenter];
                 
             }
             else
             {

             NSLog(@"%@",arrayDetail);
             //offer_long_desc_title
             _lblProductHeading.text=[arrayDetail valueForKey:@"offer_long_desc_title"];
             if([arrayDetail valueForKey:@"discount_type"])
             {
                 _lblimgDiscount.hidden=NO;
                 _lblimgDiscount.text=[NSString stringWithFormat:@"%@ Off",[arrayDetail valueForKey:@"discount"]];
             
             }
             //_lblProductDescription.text=[arrayDetail valueForKey:@"offer_long_desc"];
             
             NSURL *imgpath=[[NSURL alloc]initWithString:[arrayDetail valueForKey:@"offer_image"]];
             [_imgProduct setImageWithURL:imgpath placeholderImage:[UIImage imageNamed:@""]];
             _lblProductName.text=[arrayDetail valueForKey:@"offer_name"];
             title=[[NSMutableArray alloc]init];
             [title removeAllObjects];
            if(![[arrayDetail valueForKey:@"customedescription_title_1"]isEqualToString:@""])
             {
                 
                 NSArray *array = [[NSArray alloc] initWithObjects:[arrayDetail valueForKey:@"customedescription1"], nil];
                 
                 NSDictionary *dict = @{@"Title":[arrayDetail valueForKey:@"customedescription_title_1"],@"Values":array};
                 
                 [arraycustom1 addObject:dict];
             }
             
             
             
             
             if(![[arrayDetail valueForKey:@"customedescription_title_2"]isEqualToString:@""])
             {
                  //[title addObject:@"customedescription2"];
                 //[arraycustom2 addObject:[arrayDetail valueForKey:@"customedescription2"]];
                 NSArray *array = [[NSArray alloc] initWithObjects:[arrayDetail valueForKey:@"customedescription2"], nil];
                 
                 NSDictionary *dict = @{@"Title":[arrayDetail valueForKey:@"customedescription_title_2"],@"Values":array};
                 
                 [arraycustom1 addObject:dict];
             }


             if(![[arrayDetail valueForKey:@"customedescription_title_3"]isEqualToString:@""])
             {
                 NSArray *array = [[NSArray alloc] initWithObjects:[arrayDetail valueForKey:@"customedescription3"], nil];
                 
                 NSDictionary *dict = @{@"Title":[arrayDetail valueForKey:@"customedescription_title_3"],@"Values":array};
                 
                 [arraycustom1 addObject:dict];

             }
             
              //
             
             if(![[arrayDetail valueForKey:@"offer_end_date"]isEqualToString:@""])
             {
                 // [title addObject:@"brandwebsiteurl"];
                 
                 // [arraycustom2 addObject:[arrayDetail valueForKey:@"brandwebsiteurl"]];
                 NSArray *array = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@,%@",[arrayDetail valueForKey:@"offer_start_date"],[arrayDetail valueForKey:@"offer_end_date"]], nil];
                 
                 NSDictionary *dict = @{@"Title":@"Start Date,End Date",@"Values":array};
                 
                 [arraycustom1 addObject:dict];
                 
             }
             
             
             if(![[arrayDetail valueForKey:@"brandwebsiteurl"]isEqualToString:@""])
             {
                // [title addObject:@"brandwebsiteurl"];
                 
                // [arraycustom2 addObject:[arrayDetail valueForKey:@"brandwebsiteurl"]];
                 NSArray *array = [[NSArray alloc] initWithObjects:[arrayDetail valueForKey:@"brandwebsiteurl"], nil];
                 
                 NSDictionary *dict = @{@"Title":@"Website",@"Values":array};
                 
                 [arraycustom1 addObject:dict];

             }

             if(![[arrayDetail valueForKey:@"brandandroidappurl"]isEqualToString:@""])
             {
                 NSArray *array = [[NSArray alloc] initWithObjects:[arrayDetail valueForKey:@"brandandroidappurl"], nil];
                 
                 NSDictionary *dict = @{@"Title":@"Google Play",@"Values":array};
                 
                 [arraycustom1 addObject:dict];
                 
             }
             if(![[arrayDetail valueForKey:@"brandiosappurl"]isEqualToString:@""])
             {
                 NSArray *array = [[NSArray alloc] initWithObjects:[arrayDetail valueForKey:@"brandiosappurl"], nil];
                 
                 NSDictionary *dict = @{@"Title":@"App Store",@"Values":array};
                 
                 [arraycustom1 addObject:dict];
             }
             
           
             
            
             [arrayOpeningHours addObject:[arrayDetail valueForKey:@"openinghours"]];
             
             
             
             NSString *str1 = [[arrayDetail  valueForKey:@"offer_long_desc"]stringByReplacingOccurrencesOfString:@"\n" withString:@""];
             
             NSString *str = [str1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
             NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
             [style setLineBreakMode:NSLineBreakByWordWrapping];
             
             CGRect rect = [str boundingRectWithSize:CGSizeMake(self.view.frame.size.width-20 , FLT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor blackColor],  NSParagraphStyleAttributeName : style,NSFontAttributeName: [UIFont systemFontOfSize:13.0f]} context:nil];
             CGSize expectedLabelSize = rect.size;
                          
             
             self.viewProductImage.frame = CGRectMake(self.viewProductImage.frame.origin.x, self.viewProductImage.frame.origin.y, self.view.frame.size.width,self.viewProductImage.frame.size.height);
             self.viewProductImage.translatesAutoresizingMaskIntoConstraints = YES;
             
             self.imgProduct.frame = CGRectMake(self.imgProduct.frame.origin.x, self.imgProduct.frame.origin.y, self.view.frame.size.width-8,self.imgProduct.frame.size.height);
             self.imgProduct.translatesAutoresizingMaskIntoConstraints = YES;
             
             self.lblProductName.frame = CGRectMake(self.view.frame.origin.x+40,self.lblProductName.frame.origin.y,self.lblProductName.frame.size.width ,self.lblProductName.frame.size.height );
             
            
             self.lblProductName.translatesAutoresizingMaskIntoConstraints = YES;
             
             
             self.ViewDate.translatesAutoresizingMaskIntoConstraints = YES;
             self.lblProductDescription.frame = CGRectMake(self.lblProductDescription.frame.origin.x,self.lblProductDescription.frame.origin.y, self.view.frame.size.width-20, expectedLabelSize.height);
        
             self.lblProductDescription.text = str;
             self.lblProductDescription.numberOfLines = 0;
             self.lblProductDescription.translatesAutoresizingMaskIntoConstraints = YES;

             
             CGFloat tableHeight = 0.0f;
             
             [_tblCustom reloadData];

             tableHeight = self.tblCustom.contentSize.height;
             
             [_tblOpeningHrs reloadData];
             CGFloat tableHeightt = 0.0f;
             [self.view bringSubviewToFront:self.tblCustom];
             
             tableHeightt=self.tblOpeningHrs.contentSize.height;

             self.tblCustom.frame = CGRectMake(self.tblCustom.frame.origin.x,self.lblProductDescription.frame.origin.y+self.lblProductDescription.frame.size.height+8, self.view.frame.size.width, tableHeight);
             
             //self.viewOuter.frame = CGRectMake(self.viewOuter.frame.origin.x, self.viewOuter.frame.origin.y, self.view.frame.size.width, 1000);
             
             self.tblCustom.translatesAutoresizingMaskIntoConstraints = YES;

           

             

             self.tblOpeningHrs.frame = CGRectMake(self.tblOpeningHrs.frame.origin.x, self.tblCustom.frame.origin.y+self.tblCustom.frame.size.height, self.view.frame.size.width, tableHeightt);
             
             self.tblOpeningHrs.translatesAutoresizingMaskIntoConstraints = YES;
             
                        int newPrice = [[arrayDetail valueForKey:@"new_price"] intValue];
             
             int discountPrice = [[arrayDetail valueForKey:@"old_price"] intValue];
             int discount = discountPrice-newPrice;
             
             _lblTotalViews.text=[NSString stringWithFormat:@"(Total Views:%@)",[arrayDetail valueForKey:@"total_views"] ];

             
             self.lblPrice1.text = [NSString stringWithFormat:@"£%d",discountPrice];
             self.lblPrice2.text = [NSString stringWithFormat:@"£%d",discount];

             self.lblPrice3.text = [NSString stringWithFormat:@"£%d",newPrice];
             self.lblTitle.text = [arrayDetail valueForKey:@"offer_name"];
                 id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                 [tracker set:kGAIScreenName value:[arrayDetail valueForKey:@"offer_name"]];
                 [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
             [self.lblTitle sizeToFit];
             
             
             
          
             
             
             
             NSLog(@"tableHeight%f",tableHeight);
             
             //Date View
             
             self.ViewDate.frame = CGRectMake(self.ViewDate.frame.origin.x, self.tblOpeningHrs.frame.origin.y+self.tblOpeningHrs.frame.size.height, self.view.frame.size.width,self.ViewDate.frame.size.height);
             self.ViewDate.translatesAutoresizingMaskIntoConstraints = YES;
             
             self.viewDate1.frame = CGRectMake(self.viewDate1.frame.origin.x, 0, self.view.frame.size.width,self.viewDate1.frame.size.height);
             self.viewDate1.translatesAutoresizingMaskIntoConstraints = YES;
             
             self.lblStartDate.frame = CGRectMake(self.lblStartDate.frame.origin.x, self.lblStartDate.frame.origin.y,self.view.frame.size.width-100,self.lblStartDate.frame.size.height);
             
             
             self.lblEndDate.frame = CGRectMake(self.view.frame.size.width-80,self.lblEndDate.frame.origin.y,self.view.frame.size.width-200,self.lblEndDate.frame.size.height);
             
             
             self.lblEndDate1.frame = CGRectMake(self.view.frame.size.width-80,self.lblEndDate1.frame.origin.y,self.lblEndDate1.frame.size.width,self.lblEndDate1.frame.size.height);
            self.lblStartDate.text = [arrayDetail valueForKey:@"offer_start_date"];
             self.lblEndDate.text = [arrayDetail valueForKey:@"offer_end_date"];
             self.lblStartDate.numberOfLines = 0;
             self.lblEndDate.numberOfLines = 0;
              self.lblEndDate1.numberOfLines = 0;
             self.lblStartDate.translatesAutoresizingMaskIntoConstraints = YES;
             self.lblEndDate.translatesAutoresizingMaskIntoConstraints = YES;
             self.lblEndDate1.translatesAutoresizingMaskIntoConstraints = YES;

             
             
             //ENds Here
             
             
             
           //iOS  Url View
             
             self.viewiOSUrl.frame = CGRectMake(self.viewiOSUrl.frame.origin.x, self.viewWebsite.frame.origin.y+self.viewWebsite.frame.size.height+10, self.view.frame.size.width,self.viewiOSUrl.frame.size.height);
             self.viewiOSUrl.translatesAutoresizingMaskIntoConstraints = YES;
             
             self.viewiOSUrl1.frame = CGRectMake(self.viewiOSUrl1.frame.origin.x, 0, self.view.frame.size.width,self.viewiOSUrl1.frame.size.height);
             self.viewiOSUrl1.translatesAutoresizingMaskIntoConstraints = YES;
             
             self.lbliOSUrl.frame = CGRectMake(self.lbliOSUrl.frame.origin.x, self.lbliOSUrl.frame.origin.y,self.view.frame.size.width,self.lbliOSUrl.frame.size.height);
             
             self.lbliOSUrl.text=[arrayDetail valueForKey:@"brandiosappurl"];
             self.lbliOSUrl.numberOfLines = 0;
             
             self.lbliOSUrl.translatesAutoresizingMaskIntoConstraints = YES;

             // ENds Here
             
             
             //Android Url View
             
             self.viewAndroidUrl.frame = CGRectMake(self.viewAndroidUrl.frame.origin.x, self.viewiOSUrl.frame.origin.y+self.viewiOSUrl.frame.size.height+10, self.view.frame.size.width,self.viewAndroidUrl.frame.size.height);
             self.viewAndroidUrl.translatesAutoresizingMaskIntoConstraints = YES;
             
             self.viewAndroidUrl2.frame = CGRectMake(self.viewAndroidUrl2.frame.origin.x, 0, self.view.frame.size.width,self.viewAndroidUrl2.frame.size.height);
             self.viewAndroidUrl2.translatesAutoresizingMaskIntoConstraints = YES;
             
             self.lblAndroidUrl.frame = CGRectMake(self.lblAndroidUrl.frame.origin.x, self.lblAndroidUrl.frame.origin.y,self.view.frame.size.width,self.lblAndroidUrl.frame.size.height);
             
             self.lblAndroidUrl.text=[arrayDetail valueForKey:@"brandandroidappurl"];
             self.lblAndroidUrl.numberOfLines = 0;
             
             self.lblAndroidUrl.translatesAutoresizingMaskIntoConstraints = YES;
             
             // ENds Here

            
             
             //Address View
             
             NSString *strAddress1 = [[arrayDetail  valueForKey:@"address"]stringByReplacingOccurrencesOfString:@"\n" withString:@""];
             
             NSString *strAddress=  [strAddress1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
             
             CGSize maximumLabelSizee = CGSizeMake(235, FLT_MAX);
             
             CGSize expectedLabelSizee = [strAddress sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:maximumLabelSizee lineBreakMode:self.lblAddress.lineBreakMode];
             
             //adjust the label the the new height.
             CGRect newFramee = self.lblAddress.frame;
             newFramee.size.height = expectedLabelSizee.height;
             self.viewAddress.frame = CGRectMake(self.viewAddress.frame.origin.x, self.tblOpeningHrs.frame.origin.y+self.tblOpeningHrs.frame.size.height+5, self.view.frame.size.width,self.viewAddress.frame.size.height+expectedLabelSizee.height-25+2+_lblContact.frame.size.height+2);
             self.viewAddress.translatesAutoresizingMaskIntoConstraints = YES;
             
             self.viewAddress1.frame = CGRectMake(self.viewAddress1.frame.origin.x, 0, self.view.frame.size.width,self.viewAddress1.frame.size.height);
             self.viewAddress1.translatesAutoresizingMaskIntoConstraints = YES;
             
             self.lblAddress.frame = CGRectMake(self.lblAddress.frame.origin.x,self.viewAddress1.frame.origin.y+self.viewAddress1.frame.size.height+6,self.view.frame.size.width-100,expectedLabelSizee.height);
             
             
             self.lblContact.frame = CGRectMake(self.lblAddress.frame.origin.x,self.lblAddress.frame.origin.y+self.lblAddress.frame.size.height,self.lblContact.frame.size.width,self.lblContact.frame.size.height);

             
             
             self.lblAddress.text =[NSString stringWithFormat:@"%@",strAddress];
             self.lblContact.text =[NSString stringWithFormat:@"Contact:%@",[arrayDetail valueForKey:@"phonenumber"]];
             self.lblContact.numberOfLines = 0;
             self.lblAddress.numberOfLines = 0;
             self.lblContact.translatesAutoresizingMaskIntoConstraints = YES;
            self.lblAddress.translatesAutoresizingMaskIntoConstraints = YES;
             
             //Ends Here
             
             
             //Terms And Conditions View
             
             NSString *strtnC1 = [[arrayDetail  valueForKey:@"offer_tnc"]stringByReplacingOccurrencesOfString:@"\n" withString:@""];
             
              NSString *strtnC = [strtnC1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
             
             CGSize maximumLabel = CGSizeMake(self.view.frame.size.width-30, FLT_MAX);
             
             CGSize expectedLabel = [strtnC sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:maximumLabel lineBreakMode:self.lblAddress.lineBreakMode];
              self.viewWebsite.frame = CGRectMake(self.viewWebsite.frame.origin.x, _viewAddress.frame.origin.y+_viewAddress.frame.size.height, self.view.frame.size.width ,expectedLabel.height+10);

             self.viewWebsite.translatesAutoresizingMaskIntoConstraints = YES;
             
             self.viewWebsite1.frame = CGRectMake(self.viewWebsite1.frame.origin.x, 0, self.view.frame.size.width ,self.viewWebsite1.frame.size.height);
             self.viewWebsite1.translatesAutoresizingMaskIntoConstraints = YES;
             
             self.lblUrl.frame = CGRectMake(self.lblUrl.frame.origin.x, self.viewWebsite1.frame.origin.y+self.viewWebsite1.frame.size.height+8,self.view.frame.size.width-30,expectedLabel.height);
             //self.lblUrl.text=[arrayDetail valueForKey:@"brandwebsiteurl"];
                         //adjust the label the the new height.
             //CGRect newwFramee = self.lblUrl.frame;
            // newwFramee.size.height = expectedLabel.height;
            // self.lblUrl.frame=newwFramee;
             self.lblUrl.numberOfLines = 0;
             self.lblUrl.text=strtnC;
             self.lblUrl.translatesAutoresizingMaskIntoConstraints = YES;
             
             
             
             //ENds Here
             self.scrollViewDetail.delegate = self;
             self.scrollViewDetail.scrollEnabled = YES;

             [self.scrollViewDetail setContentSize:CGSizeMake(self.scrollViewDetail.frame.size.width, _lblProductDescription.frame.size.height+_tblCustom.frame.size.height+_tblOpeningHrs.frame.size.height+_viewAddress.frame.size.height+_viewWebsite.frame.size.height+400)];
             NSLog(@"Scrool frame is %@",NSStringFromCGRect(_scrollViewDetail.frame));
             
              self.viewOuter.frame = CGRectMake(self.viewOuter.frame.origin.x, self.viewOuter.frame.origin.y, self.view.frame.size.width, self.scrollViewDetail.frame.size.height+100);
             
             self.viewInner.frame = CGRectMake(self.viewInner.frame.origin.x, self.viewInner.frame.origin.y, self.view.frame.size.width, self.scrollViewDetail.contentSize.height+50);
             
             self.viewFull.frame = CGRectMake(self.viewFull.frame.origin.x, self.viewFull.frame.origin.y, self.view.frame.size.width, self.scrollViewDetail.contentSize.height+150);
              self.viewFull.translatesAutoresizingMaskIntoConstraints = YES;
             self.viewInner.translatesAutoresizingMaskIntoConstraints = YES;
             self.viewOuter.translatesAutoresizingMaskIntoConstraints = YES;
             
         }
        
         NSLog(@"Reading Response: %@", arrayDetail);
         }
         [[AppDelegate appDelegate] removeLoadingAlert:self.view];
      //   [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         [self.view makeToast:NSLocalizedString(@"Server Error Please Try Again", nil) duration:3.0 position:CSToastPositionCenter];
      //   [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
         [[AppDelegate appDelegate] removeLoadingAlert:self.view];
         
         
     }];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if(tableView==_tblCustom)
    {
    return  [arraycustom1 count];
    }
    else
    {
        return [arrayOpeningHours count];
    }
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    if(tableView==_tblCustom)
    {
        NSDictionary *dict = [arraycustom1 objectAtIndex:section];
        NSArray *array = [dict valueForKey:@"Values"];
        
        return  array.count;
    }
    else
    {
      
        return  [arrayOpeningHours count];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(tableView==_tblCustom)
    {
        NSArray *array=[[arraycustom1 objectAtIndex:indexPath.section] valueForKey:@"Values"];
        NSString *strAddress2 = [array[0]stringByReplacingOccurrencesOfString:@"%" withString:@""];
        NSString *strAddress1 = [strAddress2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *strAddress=  [strAddress1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        
      //  BOOL isValid = [self validateUrl:strAddress];
        
      //  if (isValid == YES) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strAddress]];
            
       // }
        
        
        
       NSLog(@"table 1 called");
        
    }
    
    else
        
    {
        NSLog(@"table 2 called");
    
    }
    
    
    
    
}

- (BOOL) validateUrl: (NSString *) candidate {
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(tableView==_tblCustom)
    {
        return 30;
    
    }
    else
    {
        return 30;
    
    }
    
   // return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_tblCustom)
    {
    
    static NSString *simpleTableIdentifier = @"customdesCell";
    
    offersDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[offersDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    //cell.textLabel.text = [self.data1 objectAtIndex:indexPath.row];
    UIFont *myFont = [UIFont systemFontOfSize:13.0f];
    cell.textLabel.font  = myFont;
   
        if([[[arraycustom1 objectAtIndex:indexPath.section]valueForKey:@"Title"]isEqualToString:@"Start Date,End Date"])
        {
            cell.lblDescriptionCell2.hidden=NO;
            
         NSArray *arrayVal=[[arraycustom1 objectAtIndex:indexPath.section]valueForKey:@"Values"];
            NSArray *strsplitDate=[arrayVal[0] componentsSeparatedByString:@","];
        
            // FOr Start Date
            NSString *strAddress2 = [strsplitDate[0]stringByReplacingOccurrencesOfString:@"%" withString:@""];
            NSString *strAddress1 = [strAddress2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSString *strAddress=  [strAddress1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [style setLineBreakMode:NSLineBreakByWordWrapping];
            
            CGRect rect = [strAddress boundingRectWithSize:CGSizeMake(self.view.frame.size.width-20 , FLT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor blackColor],  NSParagraphStyleAttributeName : style,NSFontAttributeName: [UIFont systemFontOfSize:13.0f]} context:nil];
            CGSize expectedLabelSizee = rect.size;        //adjust the label the the new height.
            CGRect newFramee = cell.textLabel.frame;
            newFramee.size.height = expectedLabelSizee.height;
            cell.lblDescriptioncell.frame = CGRectMake(cell.lblDescriptioncell.frame.origin.x, cell.lblDescriptioncell.frame.origin.y+8,self.view.frame.size.width-20,expectedLabelSizee.height);
            cell.lblDescriptioncell.text = strAddress;
            cell.lblDescriptioncell.numberOfLines=0;
            cell.lblDescriptioncell.translatesAutoresizingMaskIntoConstraints=YES;
            //
            
            //For End Date
            
            NSString *strAddress3 = [strsplitDate[1]stringByReplacingOccurrencesOfString:@"%" withString:@""];
            NSString *strAddress4 = [strAddress3 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSString *sstrAddress=  [strAddress4 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            NSMutableParagraphStyle *stylee = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [style setLineBreakMode:NSLineBreakByWordWrapping];
            
            CGRect rectt = [sstrAddress boundingRectWithSize:CGSizeMake(self.view.frame.size.width-20 , FLT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor blackColor],  NSParagraphStyleAttributeName : stylee,NSFontAttributeName: [UIFont systemFontOfSize:13.0f]} context:nil];
            CGSize expectedLabelSizeee = rectt.size;        //adjust the label the the new height.
            CGRect newFrameee = cell.textLabel.frame;
            newFrameee.size.height = expectedLabelSizeee.height;
            cell.lblDescriptionCell2.frame = CGRectMake(self.view.frame.size.width-80, cell.lblDescriptionCell2.frame.origin.y+8,self.view.frame.size.width-20,expectedLabelSizeee.height);
            cell.lblDescriptionCell2.text = sstrAddress;
            cell.lblDescriptionCell2.numberOfLines=0;
            cell.lblDescriptionCell2.translatesAutoresizingMaskIntoConstraints=YES;
            
            cell.selectionStyle=NO;

        }
        else
        {
            cell.lblDescriptionCell2.hidden=YES;
                    NSArray *arrayVal=[[arraycustom1 objectAtIndex:indexPath.section]valueForKey:@"Values"];
        
        
         NSString *strAddress2 = [arrayVal[0]stringByReplacingOccurrencesOfString:@"%" withString:@""];
        NSString *strAddress1 = [strAddress2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *strAddress=  [strAddress1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        
        CGRect rect = [strAddress boundingRectWithSize:CGSizeMake(self.view.frame.size.width-20 , FLT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor blackColor],  NSParagraphStyleAttributeName : style,NSFontAttributeName: [UIFont systemFontOfSize:13.0f]} context:nil];
        CGSize expectedLabelSizee = rect.size;        //adjust the label the the new height.
        CGRect newFramee = cell.textLabel.frame;
        newFramee.size.height = expectedLabelSizee.height;
         cell.lblDescriptioncell.frame = CGRectMake(cell.lblDescriptioncell.frame.origin.x, cell.lblDescriptioncell.frame.origin.y+6,self.view.frame.size.width-20,expectedLabelSizee.height);
        cell.lblDescriptioncell.text = strAddress;
        cell.lblDescriptioncell.numberOfLines=0;
        cell.lblDescriptioncell.translatesAutoresizingMaskIntoConstraints=YES;
        
        cell.selectionStyle=NO;
        }
        //NSLog(@"Detail frame is %@",NSStringFromCGRect(cell.textLabel.frame));
    
    return cell;
    }
    else
    {
        static NSString *simpleTableIdentifierr = @"SimpleTableItemm";
        
        OpeningHoursCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifierr];
        
        if (cell == nil) {
            cell = [[OpeningHoursCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifierr];
        }
        
        //cell.textLabel.text = [self.data1 objectAtIndex:indexPath.row];
        UIFont *myFont = [UIFont systemFontOfSize:12.0f];
        cell.textLabel.font  = myFont;
        if (indexPath.section ==0)
        {
            
            
            
            
            NSString *strAddress1 = [[arrayOpeningHours objectAtIndex:indexPath.row]stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSString *strAddress=  [strAddress1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [style setLineBreakMode:NSLineBreakByWordWrapping];
            
            CGRect rect = [strAddress boundingRectWithSize:CGSizeMake(self.view.frame.size.width-20 , FLT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor blackColor],  NSParagraphStyleAttributeName : style,NSFontAttributeName: [UIFont systemFontOfSize:13.0f]} context:nil];
            CGSize expectedLabelSizee = rect.size;        //adjust the label the the new height.
            CGRect newFramee = cell.lblOpeningHrsCell.frame;
            newFramee.size.height = expectedLabelSizee.height;
            cell.lblOpeningHrsCell.frame = CGRectMake(cell.lblOpeningHrsCell.frame.origin.x, cell.lblOpeningHrsCell.frame.origin.y+8,self.view.frame.size.width-20,expectedLabelSizee.height);
            cell.lblOpeningHrsCell.text = strAddress;
            cell.lblOpeningHrsCell.numberOfLines=0;
            cell.lblOpeningHrsCell.translatesAutoresizingMaskIntoConstraints=YES;
            
                   }
        
      cell.selectionStyle=NO;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_tblCustom)
        
    {
        NSArray *arrayVal=[[arraycustom1 valueForKey:@"Values"]objectAtIndex:indexPath.section];
        
        
        NSString *strAddress = [arrayVal[0]stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        
        
        CGRect rect = [strAddress boundingRectWithSize:CGSizeMake(self.view.frame.size.width-20 , FLT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor blackColor],  NSParagraphStyleAttributeName : style,NSFontAttributeName: [UIFont systemFontOfSize:12.0f]} context:nil];
        CGSize expectedLabelSizee = rect.size;
        return expectedLabelSizee.height+17.0;
        }
    else
    {
        
        
        
        NSString *strAddress = [[arrayOpeningHours objectAtIndex:indexPath.section]stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        
        
        CGRect rect = [strAddress boundingRectWithSize:CGSizeMake(self.view.frame.size.width-20 , FLT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor blackColor],  NSParagraphStyleAttributeName : style,NSFontAttributeName: [UIFont systemFontOfSize:12.0f]} context:nil];
        CGSize expectedLabelSizee = rect.size;
        return expectedLabelSizee.height+17.0;
        
    }
    
    
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    [headerView setBackgroundColor:[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0]];
        if(tableView==_tblCustom)
    {
        if([[[arraycustom1 objectAtIndex:section]valueForKey:@"Title"]isEqualToString:@"Start Date,End Date"])
        {
            
            UILabel *myLabel = [[UILabel alloc] init];
            myLabel.frame = CGRectMake(14, 4, 150, 20);
            myLabel.font = [UIFont boldSystemFontOfSize:12];
            //int count = section+1;
            myLabel.text = @"Start Date";
            myLabel.textColor=[UIColor colorWithRed:38/255.0 green:96/255.0 blue:143/255.0 alpha:1.0];
            
            UILabel *myLabel1 = [[UILabel alloc] init];
            myLabel1.frame = CGRectMake(self.view.frame.size.width-80, 4, 150, 20);
            myLabel1.font = [UIFont boldSystemFontOfSize:12];
            myLabel1.text = @"End Date";
            myLabel1.textColor=[UIColor colorWithRed:38/255.0 green:96/255.0 blue:143/255.0 alpha:1.0];
            
            
            [headerView addSubview:myLabel];
            [headerView addSubview:myLabel1];

            
            return headerView;
        
        
        }
        else
        {
        
                UILabel *myLabel = [[UILabel alloc] init];
                myLabel.frame = CGRectMake(14, 4, 320, 20);
                myLabel.font = [UIFont boldSystemFontOfSize:12];
                //int count = section+1;
                myLabel.text = [[arraycustom1 valueForKey:@"Title"]objectAtIndex:section];
                myLabel.textColor=[UIColor colorWithRed:38/255.0 green:96/255.0 blue:143/255.0 alpha:1.0];
                [headerView addSubview:myLabel];
                
                return headerView;
        }

    }
        
    else
    {
        UILabel *myLabel = [[UILabel alloc] init];
        myLabel.frame = CGRectMake(14, 4, 320, 20);
        myLabel.font = [UIFont boldSystemFontOfSize:12];
        myLabel.text = @"Opening Hours";
        myLabel.textColor=[UIColor colorWithRed:38/255.0 green:96/255.0 blue:143/255.0 alpha:1.0];
        [headerView addSubview:myLabel];
        
        return headerView;

    
    }
   
    
}


- (IBAction)funcBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
