//
//  DetailViewController.m
//  MyCity
//
//  Created by Pushpendra on 05/11/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import "IQActionSheetPickerView.h"
#import "IQActionSheetViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager.h"
#import <QuartzCore/QuartzCore.h>
#import "DetailCell.h"
#import "UIImageView+AFNetworking.h"
#import "RestHoursCell.h"
#import "SettingViewController.h"


@interface DetailViewController ()<UIGestureRecognizerDelegate>

@end

@implementation DetailViewController
@synthesize Detailsearch,roundview,priceview,distanceview,capacityview,viewaddress,viewdistance2,viewprice2;


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
       //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //appDelegate.tabBarControllerMain = self.tabBarController;
}
- (void)viewDidLoad

{
    [super viewDidLoad];
    [[AppDelegate appDelegate] CheckNotEnabled];
     [[AppDelegate appDelegate] CheckLocEnabled];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Parking Detail Screen"];

   arrayRestPrice=[[NSMutableArray alloc]init];
    [arrayRestPrice removeAllObjects];
//           UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
//         [self.view addGestureRecognizer:gestureRecognizer];
//     gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];

//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
//                                       initWithTarget:self
//                                       action:@selector(dismissKeyboard)];
//    
//        [self.view addGestureRecognizer:tap];
   // hidden=1;
   // _tblParkingPrice.hidden=YES;Carpark ImageAvailable Spaces" = 1091
    NSLog(@"%@",self.dictData);
    
    if(IS_IPHONE6)
    {
        viewprice2.frame=CGRectMake(viewprice2.frame.origin.x, viewprice2.frame.origin.y+55, viewprice2.frame.size.width+55, 23);
        viewprice2.translatesAutoresizingMaskIntoConstraints=YES;
        
//        _lblOpeningHours.frame=CGRectMake(_lblOpeningHours.frame.origin.x, _lblOpeningHours.frame.origin.y+20, _lblOpeningHours.frame.size.width+55, _lblOpeningHours.frame.size.height);
//        _lblOpeningHours.translatesAutoresizingMaskIntoConstraints=YES;
    }
    NSDictionary *dictValue=[self.dictData valueForKey:@"Extra Pricing"];
    _lblOpeningHrs2.text=[[self.dictData valueForKey:@"OpeningTimes"]valueForKey:@"0"];
    _lblAvailableSpaces.text=[NSString stringWithFormat:@"Available Spaces:%@",[self.dictData valueForKey:@"Available Spaces"]];
    id value=[dictValue valueForKey:@"value"];
    
    if ([value isKindOfClass:[NSString class]]) {
        _lblOpeningHours.text=@"NA";
        _lblOpenHeading.text=[NSString stringWithFormat:@"Rest of the Hours:%@",@"NA"];
        _viewRest1.hidden=YES;
        _viewRest2.hidden=YES;
        
    }
    else
    {
        NSString * str;
     
        NSArray *arry=[dictValue valueForKey:@"data"];
        
        for(int i=0; i< [arry count];i++)
        {
            
            [arrayRestPrice addObject:[NSString stringWithFormat:@"%@,%@",[[arry objectAtIndex:i]valueForKey:@"key"],[[arry objectAtIndex:i]valueForKey:@"value"]]];
        
           
        }
        
       
        
        NSMutableString *strData=[[NSMutableString alloc]init];
        for (int i=0; i<[arry count]; i++) {
          
            if(i==[arry count]-1)
            {
                str=[NSString stringWithFormat:@"%@  £%@",[[arry objectAtIndex:i]valueForKey:@"key"],[[arry objectAtIndex:i]valueForKey:@"value"]];
            
            }
            else
            {
                str=[NSString stringWithFormat:@"%@  £%@ / ",[[arry objectAtIndex:i]valueForKey:@"key"],[[arry objectAtIndex:i]valueForKey:@"value"]];
                
            }
            [strData appendString:str];
            
        }
        _lblOpeningHours.text=strData;
       
    }
     NSLog(@"Rest Price array2 is %@",arrayRestPrice);
    
    _lblPayment.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"Payment"];
    NSString *imgpath=[[NSUserDefaults standardUserDefaults] valueForKey:@"CarparkImage"];
    NSURL *imgUrl=[[NSURL alloc]initWithString:imgpath];
     [_imgParkingView  setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@""]];
    
    
    roundview.layer.cornerRadius=5;
    roundview.layer.masksToBounds=YES;
    _viewAll.layer.cornerRadius=5;
    _viewAll.layer.masksToBounds=YES;
    
   
    arrayPrice=[[NSMutableArray alloc]init];
    [arrayPrice removeAllObjects];
    arrayPricename=[[NSMutableArray alloc]init];
    [arrayPricename removeAllObjects];
    arrayPriveval=[[NSMutableArray alloc]init];
    [arrayPriveval removeAllObjects];
   
    arrayPrice=[[[NSUserDefaults standardUserDefaults]valueForKey:@"arrayPrice"]mutableCopy];
    
    if([arrayPrice count]==0)
    {
        //_lblParkingPrice.hidden=YES;
        viewprice2.hidden=YES;
    }
    else
    {
    for(int i=0;i<[arrayPrice count];i++)
    {
        NSMutableArray *arraySplit=[[NSMutableArray alloc]init];
        [arraySplit removeAllObjects];
        
        arraySplit=[[[arrayPrice objectAtIndex:i]componentsSeparatedByString:@":"]mutableCopy];
        [arrayPricename insertObject:arraySplit[0] atIndex:i];
        [arrayPriveval insertObject:arraySplit[1] atIndex:i];
    
    
    }
    }
    
    
    CGFloat tableHeight = 0.0f;
//    for (int i = 0; i < [arrayPrice count]; i ++) {
//    
//        tableHeight += [self tableView:self.tblParkingPrice heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
//        
//    }
    tableHeight=[arrayPrice count]*30+30;
    
  //  [_tblParkingPrice reloadData];
    
    
    
    
    if(IS_IPHONE5)
    {
        self.viewTable.frame = CGRectMake(self.viewTable.frame.origin.x,self.viewTable.frame.origin.y, self.viewTable.frame.size.width, tableHeight);
        self.viewTable.translatesAutoresizingMaskIntoConstraints = YES;
        
        self.tblParkingPrice.frame = CGRectMake(self.tblParkingPrice.frame.origin.x, self.tblParkingPrice.frame.origin.y, self.viewTable.frame.size.width, tableHeight);
        self.tblParkingPrice.translatesAutoresizingMaskIntoConstraints = YES;
        self.viewContainer.frame = CGRectMake(self.viewContainer.frame.origin.x, self.viewTable.frame.origin.y+self.viewTable.frame.size.height+1, self.viewContainer.frame.size.width, self.viewContainer.frame.size.height);
        self.viewContainer.translatesAutoresizingMaskIntoConstraints = YES;
        
        if([arrayPrice count]==0 &&[arrayRestPrice count]==0)
        {
            self.viewContainer.frame = CGRectMake(_viewContainer.frame.origin.x,viewprice2.frame.origin.y+0, self.viewContainer.frame.size.width, self.viewRestContainer.frame.size.height);
            self.viewRestContainer.frame=CGRectMake(self.viewRestContainer.frame.origin.x,0+10, self.viewContainer.frame.size.width, self.viewRestContainer.frame.size.height);
            
            self.viewRestContainer.translatesAutoresizingMaskIntoConstraints = YES;
            
            
        }
        else if([arrayRestPrice count]==0 )
        {
            self.viewRestContainer.frame=CGRectMake(self.viewRestContainer.frame.origin.x,0, self.viewContainer.frame.size.width, self.viewRestContainer.frame.size.height);
            self.viewRestContainer.translatesAutoresizingMaskIntoConstraints = YES;
            //[_tblParkingPrice reloadData];
        }
        else
        {
            //            self.viewContainer.frame = CGRectMake(_viewContainer.frame.origin.x,_viewContainer.frame.origin.y+10, self.viewContainer.frame.size.width, self.viewRestContainer.frame.size.height);
            CGFloat tableHeightt = 0.0f;
            for (int i = 0; i < [arrayRestPrice count]; i ++) {
                
                tableHeightt += [self tableView:self.tblRestHours heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                
            }
            self.viewRest1.frame = CGRectMake(_viewRest1.frame.origin.x, _viewRest1.frame.origin.y, self.viewContainer.frame.size.width, _viewRest1.frame.size.height);
            self.viewRest1.translatesAutoresizingMaskIntoConstraints = YES;
            
            self.viewRest2.frame = CGRectMake(_viewRest2.frame.origin.x, _viewRest2.frame.origin.y, self.viewContainer.frame.size.width, tableHeightt);
            self.viewRest2.translatesAutoresizingMaskIntoConstraints = YES;
            self.tblRestHours.frame = CGRectMake(self.tblRestHours.frame.origin.x, self.tblRestHours.frame.origin.y, self.viewContainer.frame.size.width, tableHeightt);
            self.tblRestHours.translatesAutoresizingMaskIntoConstraints = YES;
            
            self.viewRestContainer.frame = CGRectMake(_viewRestContainer.frame.origin.x,_viewRest2.frame.origin.y+_viewRest2.frame.size.height+10, self.viewContainer.frame.size.width, self.viewRestContainer.frame.size.height);
            
            self.viewRestContainer.translatesAutoresizingMaskIntoConstraints = YES;
            
            //[_tblParkingPrice reloadData];
        }
    }
     if (IS_IPHONE6)
    {
        self.viewTable.frame = CGRectMake(self.viewTable.frame.origin.x,self.viewOpeningHrs2.frame.origin.y+20, self.viewTable.frame.size.width+30, tableHeight);
        self.viewTable.translatesAutoresizingMaskIntoConstraints = YES;
        
        self.tblParkingPrice.frame = CGRectMake(self.tblParkingPrice.frame.origin.x, self.tblParkingPrice.frame.origin.y, self.viewTable.frame.size.width+25, tableHeight);
        self.tblParkingPrice.translatesAutoresizingMaskIntoConstraints = YES;
        self.viewContainer.frame = CGRectMake(self.viewContainer.frame.origin.x, self.viewTable.frame.origin.y+self.viewTable.frame.size.height+1, self.viewContainer.frame.size.width+30, self.viewContainer.frame.size.height);
        self.viewContainer.translatesAutoresizingMaskIntoConstraints = YES;
        
        if([arrayPrice count]==0 &&[arrayRestPrice count]==0)
        {
            self.viewContainer.frame = CGRectMake(_viewContainer.frame.origin.x,viewprice2.frame.origin.y+0, self.viewContainer.frame.size.width, self.viewRestContainer.frame.size.height);
            self.viewRestContainer.frame=CGRectMake(self.viewRestContainer.frame.origin.x,0+10, self.viewContainer.frame.size.width+30, self.viewRestContainer.frame.size.height);
            
            self.viewRestContainer.translatesAutoresizingMaskIntoConstraints = YES;
            
            
        }
        else if([arrayRestPrice count]==0 )
        {
            self.viewRestContainer.frame=CGRectMake(self.viewRestContainer.frame.origin.x,0, self.viewContainer.frame.size.width+30, self.viewRestContainer.frame.size.height);
            self.viewRestContainer.translatesAutoresizingMaskIntoConstraints = YES;
            //[_tblParkingPrice reloadData];
        }
        else
        {
            //            self.viewContainer.frame = CGRectMake(_viewContainer.frame.origin.x,_viewContainer.frame.origin.y+10, self.viewContainer.frame.size.width, self.viewRestContainer.frame.size.height);
            CGFloat tableHeightt = 0.0f;
            for (int i = 0; i < [arrayRestPrice count]; i ++) {
                
                tableHeightt += [self tableView:self.tblRestHours heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                
            }
            self.viewRest1.frame = CGRectMake(_viewRest1.frame.origin.x, _viewRest1.frame.origin.y, self.viewContainer.frame.size.width+30, _viewRest1.frame.size.height);
            self.viewRest1.translatesAutoresizingMaskIntoConstraints = YES;
            
            self.viewRest2.frame = CGRectMake(_viewRest2.frame.origin.x, _viewRest2.frame.origin.y, self.viewContainer.frame.size.width+50, tableHeightt);
            self.viewRest2.translatesAutoresizingMaskIntoConstraints = YES;
            self.tblRestHours.frame = CGRectMake(self.tblRestHours.frame.origin.x, self.tblRestHours.frame.origin.y, self.viewContainer.frame.size.width+25, tableHeightt);
            self.tblRestHours.translatesAutoresizingMaskIntoConstraints = YES;
            
            self.viewRestContainer.frame = CGRectMake(_viewRestContainer.frame.origin.x,_viewRest2.frame.origin.y+_viewRest2.frame.size.height+10, self.viewContainer.frame.size.width+30, self.viewRestContainer.frame.size.height);
            
            self.viewRestContainer.translatesAutoresizingMaskIntoConstraints = YES;
            
            //[_tblParkingPrice reloadData];
        }
    }
    else if (IS_IPHONE6plus)
    {
        self.viewTable.frame = CGRectMake(self.viewTable.frame.origin.x,self.viewOpeningHrs2.frame.origin.y+30, self.viewTable.frame.size.width+50, tableHeight);
        self.viewTable.translatesAutoresizingMaskIntoConstraints = YES;
        
        self.tblParkingPrice.frame = CGRectMake(self.tblParkingPrice.frame.origin.x, self.tblParkingPrice.frame.origin.y, self.viewTable.frame.size.width+45, tableHeight);
        self.tblParkingPrice.translatesAutoresizingMaskIntoConstraints = YES;
        self.viewContainer.frame = CGRectMake(self.viewContainer.frame.origin.x, self.viewTable.frame.origin.y+self.viewTable.frame.size.height+1, self.viewContainer.frame.size.width+50, self.viewContainer.frame.size.height);
        self.viewContainer.translatesAutoresizingMaskIntoConstraints = YES;

        if([arrayPrice count]==0 &&[arrayRestPrice count]==0)
        {
            self.viewContainer.frame = CGRectMake(_viewContainer.frame.origin.x,viewprice2.frame.origin.y+60, self.viewContainer.frame.size.width, self.viewRestContainer.frame.size.height);
            self.viewRestContainer.frame=CGRectMake(self.viewRestContainer.frame.origin.x,0+10, self.viewContainer.frame.size.width+50, self.viewRestContainer.frame.size.height);
            
            self.viewRestContainer.translatesAutoresizingMaskIntoConstraints = YES;
            
            
        }
        else if([arrayRestPrice count]==0 )
        {
            self.viewRestContainer.frame=CGRectMake(self.viewRestContainer.frame.origin.x,0, self.viewContainer.frame.size.width+50, self.viewRestContainer.frame.size.height);
             self.viewRestContainer.translatesAutoresizingMaskIntoConstraints = YES;
            //[_tblParkingPrice reloadData];
        }
        else
        {
//            self.viewContainer.frame = CGRectMake(_viewContainer.frame.origin.x,_viewContainer.frame.origin.y+10, self.viewContainer.frame.size.width, self.viewRestContainer.frame.size.height);
            CGFloat tableHeightt = 0.0f;
            for (int i = 0; i < [arrayRestPrice count]; i ++) {
                
                tableHeightt += [self tableView:self.tblRestHours heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                
            }
            self.viewRest1.frame = CGRectMake(_viewRest1.frame.origin.x, _viewRest1.frame.origin.y, self.viewContainer.frame.size.width+50, _viewRest1.frame.size.height);
            self.viewRest1.translatesAutoresizingMaskIntoConstraints = YES;

            self.viewRest2.frame = CGRectMake(_viewRest2.frame.origin.x, _viewRest2.frame.origin.y, self.viewContainer.frame.size.width+80, tableHeightt);
            self.viewRest2.translatesAutoresizingMaskIntoConstraints = YES;
            self.tblRestHours.frame = CGRectMake(self.tblRestHours.frame.origin.x, self.tblRestHours.frame.origin.y, self.viewContainer.frame.size.width+45, tableHeightt);
            self.tblRestHours.translatesAutoresizingMaskIntoConstraints = YES;
            
            self.viewRestContainer.frame = CGRectMake(_viewRestContainer.frame.origin.x,_viewRest2.frame.origin.y+_viewRest2.frame.size.height+10, self.viewContainer.frame.size.width+50, self.viewRestContainer.frame.size.height);
            
            self.viewRestContainer.translatesAutoresizingMaskIntoConstraints = YES;
            
            //[_tblParkingPrice reloadData];
        }
          }



    NSLog(@"%f",self.viewContainer.frame.size.height);
    CGFloat heightRoundView=_imgParkingView.frame.size.height+_viewParkingHeader.frame.size.height+_viewAll.frame.size.height+_viewOpeninghrs.frame.size.height+_viewOpeningHrs2.frame.size.height+viewprice2.frame.size.height+_viewTable.frame.size.height+_viewContainer.frame.size.height;
    
    
    //[_scrollDetail setContentSize:CGSizeMake(_scrollDetail.frame.size.width,heightRoundView+400)];
  
    roundview.frame=CGRectMake(roundview.frame.origin.x, roundview.frame.origin.y, roundview.frame.size.width, heightRoundView);
   // roundview.translatesAutoresizingMaskIntoConstraints=YES;
    _lblCapacity.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"Capacity"];
    _lblParkingName.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"ParkingName"];
    _lblDistance.text=[NSString stringWithFormat:@"%@ Miles",[[NSUserDefaults standardUserDefaults]valueForKey:@"DistanceFromStation"]];
    _lblPrice.text=[NSString stringWithFormat:@"£%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Price"]];
    _lblDisabledSpaces.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"DisabledCapacity"]];
    _lblAddress.text=[NSString stringWithFormat:@"%@\nContact:%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Postcode"],[self.dictData valueForKey:@"Phone"]];
    
    
    
    self.Detailsearch.barTintColor = [UIColor colorWithRed:53.0/255.0 green:94.0/255.0 blue:120.0/255.0 alpha:1.0];
    
    
    
    for (UIView *subView in Detailsearch.subviews)
        
    {
        for(id field in subView.subviews)
        {
            if ([field isKindOfClass:[UITextField class]])
                
            {
                UITextField *textField = (UITextField *)field;
                
                [textField setBackgroundColor:[UIColor colorWithRed:53.0/255.0 green:94.0/255.0 blue:120.0/255.0 alpha:1.0]];
                
                
                
                [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor grayColor]];
                
            }
        }
    }
    
    
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setLeftViewMode:UITextFieldViewModeNever];
    
    [UITextField appearanceWhenContainedIn:[UISearchBar class], nil].leftView = nil;
    
    self.Detailsearch.searchTextPositionAdjustment = UIOffsetMake(25, 0);
    
    
    
    for (UIView *subView in Detailsearch.subviews)
        
    {
        for(id field in subView.subviews)
        {
            if ([field isKindOfClass:[UITextField class]])
            {
                UITextField *textField = (UITextField *)field;
                [textField setBackgroundColor:[UIColor colorWithRed:53.0/255.0 green:94.0/255.0 blue:120.0/255.0 alpha:1.0]];
                
                
                [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor grayColor]];
                
            }
        }
    }
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setLeftViewMode:UITextFieldViewModeNever];
    
    [UITextField appearanceWhenContainedIn:[UISearchBar class], nil].leftView = nil;
    
    
    self.Detailsearch.searchTextPositionAdjustment = UIOffsetMake(20, 0);
    
    
    
    
//    viewprice2.layer.borderColor = [UIColor colorWithRed:237/255.0 green:232/255.0 blue:232/255.0 alpha:1.0].CGColor;
//    
//    viewprice2.layer.borderWidth = 1.0f;
    
    
    viewaddress.layer.borderColor = [UIColor colorWithRed:237/255.0 green:232/255.0 blue:232/255.0 alpha:1.0].CGColor;
    
    viewaddress.layer.borderWidth = 1.0f;
    
    viewdistance2.layer.borderColor = [UIColor colorWithRed:237/255.0 green:232/255.0 blue:232/255.0 alpha:1.0].CGColor;
    
    viewdistance2.layer.borderWidth = 1.0f;
    
   // viewspace.layer.borderColor = [UIColor colorWithRed:237/255.0 green:232/255.0 blue:232/255.0 alpha:1.0].CGColor;
    
    //viewspace.layer.borderWidth = 1.0f;
    
    
    [self setNeedsStatusBarAppearanceUpdate];
}
- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}
-(void)dismissKeyboard
{
//    hidden=1;
//    _tblParkingPrice.hidden=YES;
//    [self.Detailsearch resignFirstResponder];
//

}

- (UIStatusBarStyle) preferredStatusBarStyle

{
    return UIStatusBarStyleLightContent;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    if(tableView==_tblParkingPrice)
    {
    
    return [ arrayPrice count];
    }
    else
    {
         return [ arrayRestPrice count];
    
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    [headerView setBackgroundColor:[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0]];
    if(tableView==_tblParkingPrice)
    {
        UILabel *myLabel = [[UILabel alloc] init];
        myLabel.frame = CGRectMake(3, 0, 320, 20);
        myLabel.font = [UIFont boldSystemFontOfSize:12];
        myLabel.text = @"Mon-Sun 6:00-18:00";
        
        [headerView addSubview:myLabel];
        
        return headerView;
    }
    else
    {
        [headerView removeFromSuperview];
        return headerView;
        
    }
}
//- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if(tableView==_tblParkingPrice)
//    {
    
//    return 0 ;
//    
//}
//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(tableView==_tblRestHours)
    {
        return 0.0;
    }
    else
    {
        return 20.0;
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView==_tblParkingPrice)
    {
        return 30.0;
    }
    else
    {
       
        
        return 30;
    
    }
    
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if(tableView==_tblParkingPrice)
//    {
//       return 10;
//    }
//    else
//    {
//        return 0;
//    }
//}




//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (IS_IPHONE6)
//    {
//        return 88.0;
//    }else if (IS_IPHONE6plus)
//    {
//        return 98.0;
//    }else
//    {
//        return 73.0;
//    }
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView==_tblParkingPrice)
    {
    static NSString *simpleTableIdentifier = @"DetailCell";
    
    
    
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[DetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
    }
   
    //cell.textLabel.text=[arrayPrice objectAtIndex:indexPath.row];
    cell.lblName.text=[arrayPricename objectAtIndex:indexPath.row];
    cell.lblPrice.text=[arrayPriveval objectAtIndex:indexPath.row];
    
    cell.selectionStyle=NO;
    
    return cell;
    }
    else
    {
        static NSString *simpleTableIdentifier = @"RestHoursCell";
     
        RestHoursCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if(cell==nil)
        {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Resthours" owner:self options:nil];
        cell = [nib objectAtIndex:0];

        
        }
        cell.selectionStyle=NO;
        //cell.textLabel.text=;
        NSArray *val1;
        NSString *Value=[arrayRestPrice objectAtIndex:indexPath.row];
        val1=[Value componentsSeparatedByString:@","];
        
        cell.lblRestHours.text=val1[0];
        if(IS_IPHONE5)
        {
            cell.lblRestHoursPrice.frame=CGRectMake(cell.lblRestHoursPrice.frame.origin.x-10,cell.lblRestHoursPrice.frame.origin.y, cell.lblRestHoursPrice.frame.size.width, cell.lblRestHoursPrice.frame.size.height);
            cell.lblRestHoursPrice.translatesAutoresizingMaskIntoConstraints=YES;
        }

        if(IS_IPHONE6)
        {
            cell.lblRestHoursPrice.frame=CGRectMake(cell.lblRestHoursPrice.frame.origin.x+48,cell.lblRestHoursPrice.frame.origin.y, cell.lblRestHoursPrice.frame.size.width, cell.lblRestHoursPrice.frame.size.height);
            cell.lblRestHoursPrice.translatesAutoresizingMaskIntoConstraints=YES;
        }
        if(IS_IPHONE6plus)
        {
            cell.lblRestHoursPrice.frame=CGRectMake( cell.lblRestHoursPrice.frame.origin.x+83, cell.lblRestHoursPrice.frame.origin.y, cell.lblRestHoursPrice.frame.size.width, cell.lblRestHoursPrice.frame.size.height);
            cell.lblRestHoursPrice.translatesAutoresizingMaskIntoConstraints=YES;
        }

        cell.lblRestHoursPrice.text=[NSString stringWithFormat:@"£%@",val1[1]];
        
        return cell;
    
    }
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
- (IBAction)productSizeActionBtn:(id)sender
{
    //    if (arrayPrice.count == 0)
    //    {
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Product size not available." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    //        [alert show];
    //    }
    //    else
    //    {
    //        [self PickerPopUpForCity:arrayPrice];
    //
    //    }
    if(hidden==0)
    {
        _tblParkingPrice.hidden=YES;
        hidden=1;
    }
    else
    {
        _tblParkingPrice.hidden=NO;
        hidden=0;
        
    }
    
}

-(void)PickerPopUpForCity:(NSMutableArray *)arrCit
{
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Select Price" delegate:self];
    
    picker.backgroundColor = [UIColor whiteColor];
    
    // [picker setActionSheetPickerStyle:IQActionSheetPickerStyleTextPicker];
    
    [picker setTag:1];
    
    [picker setTitlesForComponenets:[NSArray arrayWithObject:arrCit]];
    
    [picker show];
}


-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray *)titles
{
    if (pickerView.tag == 1)
    {
        NSString *str =[titles componentsJoinedByString:@" - "];
        [_btnSelectPrice setTitle:str forState:UIControlStateNormal];
        [_btnSelectPrice setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
    }
    
}

- (void)cancelSheetPicker

{
    // [_ageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.50];
    [UIView commitAnimations];
}

- (IBAction)funcSettingCall:(id)sender
{
    SettingViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [self.navigationController pushViewController:obj animated:YES];
}





- (IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)funcSelectPrice:(id)sender {
}
    @end
