//
//  ViewController.m
//  MyCity
//
//  Created by Admin on 05/11/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "ListCell.h"
#import "SettingViewController.h"
#import "DAMapAnnotationView.h"
#import "SSKeychain.h"
#import "UIView+Toast.h"
#import "OffersViewController.h"


@interface ViewController ()<UIGestureRecognizerDelegate,UISearchBarDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>
{
    NSString *strLong;
    NSString *strLat;
    
    NSMutableArray *ArrayPinData,*places_;
    BOOL isMapSerach;
    BOOL isSearching;
    BOOL IsCalled;
    BOOL isLabelShow,isLocation;
    BOOL currentLoc,showingAnnotations_;
    NSMutableArray *ArraySearchData;
    
    
    GMSMarker *mkr;
    
    
    
}

@end

@implementation ViewController
@synthesize roundview,delegate = delegate_;
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //appDelegate.tabBarControllerMain = self.tabBarController;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [[AppDelegate appDelegate] CheckNotEnabled];
    [[AppDelegate appDelegate] CheckLocEnabled];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName value:@"Parking Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
     [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(webserviceCarParkkk) userInfo:nil repeats:NO];
    
    
    
    
    CGRect val;nav=0;
    val=self.SearchBox.frame;
    NSLog(@"width of searchbox is %@",NSStringFromCGRect(val));
    isSearching = NO;
    isLabelShow=NO;
    isMapSerach=NO;
    showingAnnotations_ = NO;
    
    
    [self.GMap clear];
    NSObject * object1=[[NSUserDefaults standardUserDefaults]objectForKey:@"ArrayPinData"];
    
    if([AppDelegate appDelegate].isCheckConnection){
        
        //Internet connection not available. Please try again.
        
        //        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Internate error" message:@"Internet connection not available. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alertView show];
        
         ArrayPinData=[[NSMutableArray alloc]init];
        [ArrayPinData removeAllObjects];
        self.arrayTable=[[NSMutableArray alloc]init];
        [ self.arrayTable removeAllObjects];
        arrayData=[[NSMutableArray alloc]init];
        arrayStore=[[NSMutableArray alloc]init];
        [arrayData removeAllObjects];
        [arrayStore removeAllObjects];
        [self.GMap clear];
        
        if([[NSUserDefaults standardUserDefaults] valueForKey:@"ArrayPinData2"] != nil)
        {
            
            arrayStore=[[NSUserDefaults standardUserDefaults] valueForKey:@"ArrayPinData2"];
            arrayData=[[NSUserDefaults standardUserDefaults] valueForKey:@"ArrayPinData2"];
            self.arrayTable=[[NSUserDefaults standardUserDefaults] valueForKey:@"ArrayPinData2"];
            
            ArrayPinData = [[NSMutableArray alloc] init];
            [ArrayPinData removeAllObjects];
            for (int i = 0; i<arrayData.count; i++) {
                
                
                NSDictionary *dict = @{@"Lat":[[[arrayData objectAtIndex:i] valueForKey:@"Coordinates"] valueForKey:@"Latitude"],@"Long":[[[arrayData objectAtIndex:i] valueForKey:@"Coordinates"] valueForKey:@"Longitude"],@"Name":[[arrayData objectAtIndex:i] valueForKey:@"Name"],@"Price":[[arrayData objectAtIndex:i] valueForKey:@"Price"]};
                
                [ArrayPinData addObject:dict];
                
                
            }
            NSDictionary *dict = @{@"Lat":@"51.4594086",@"Long":@"-0.9731692",@"Name":@"",@"Price":@""};
            [ArrayPinData addObject:dict];
            
            [self setDataOnMapView:ArrayPinData];
            

            [_tblParking reloadData];
            
        }
        
        
        [self.view makeToast:NSLocalizedString(@"Internet Connection Not Available Please Try Again", nil) duration:3.0 position:CSToastPositionCenter];
     //   [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
         [[AppDelegate appDelegate] removeLoadingAlert:self.view];
        
    }
    
    else
    {
        
    
    if(object1 != nil)
    {
        ArrayPinData=[[NSUserDefaults standardUserDefaults]valueForKey:@"ArrayPinData"];
        if([ArrayPinData count]>0)
        {
            [self setDataOnMapView:ArrayPinData];
        }
        
    }
    
    else
    {
        [self webserviceCarParkk];
    }
    
    
    }
    
    
    
    IsCalled = NO;
    currentLoc=NO;
    isLabelShow = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showMainMenu:)
                                                 name:@"LocationEnabled" object:nil];
    //[self doMyLayoutStuff:self];
    
    /* if([CLLocationManager locationServicesEnabled] &&
     [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
     {
     
     if([[[UIDevice currentDevice] systemVersion] floatValue] <= 7.0)
     {
     locationManager = [[CLLocationManager alloc] init];
     [locationManager setDelegate:self];
     [locationManager setDistanceFilter:kCLHeadingFilterNone];
     //change the desired accuracy to kCLLocationAccuracyBest
     [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
     //SOLUTION: set setPausesLocationUpdatesAutomatically to NO
     [locationManager setPausesLocationUpdatesAutomatically:NO];
     [locationManager startUpdatingLocation];
     }
     else
     {
     
     locationManager = [[CLLocationManager alloc] init];
     locationManager.delegate = self;
     locationManager.desiredAccuracy = kCLLocationAccuracyBest;
     [locationManager requestWhenInUseAuthorization];
     
     [locationManager startUpdatingLocation];
     
     if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
     {
     [locationManager requestWhenInUseAuthorization];
     }
     
     }
     
     _viewLocation.hidden=YES;
     
     
     }
     
     else
     {
     _viewLocation.hidden=NO;
     _viewLocation.backgroundColor=[UIColor redColor];
     }
     */
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    // [timer invalidate];
    // [self.navigationController popViewControllerAnimated:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // [self webserviceCarParkk];
    
    //timer=  [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(webserviceCarParkkk) userInfo:nil repeats:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showMainMenu:)
                                                 name:@"LocationEnabled" object:nil];
    [self setNeedsStatusBarAppearanceUpdate];
    isSearching = NO;
    isLocation = YES;
    roundview.layer.cornerRadius=5;
    roundview.layer.masksToBounds=YES;
    self.ViewList.hidden = YES;
    self.ViewMap.hidden = NO;
    //    self.GMap.myLocationEnabled = YES;
    //    self.GMap.settings.myLocationButton = YES;
    //    self.GMap.settings.compassButton = NO;
    
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
    //                                   initWithTarget:self
    //                                   action:@selector(dismissKeyboard)];
    //
    //    [self.view addGestureRecognizer:tap];
    
    //   [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
    self.SearchBox.barTintColor = [UIColor colorWithRed:53.0/255.0 green:94.0/255.0 blue:120.0/255.0 alpha:1.0];
    
    //    [self.SearchBox setImage:[[UIImage imageNamed: @"search.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    //self.SearchBox.barTintColor = [UIColor yellowColor];
    
    for (UIView *subView in _SearchBox.subviews)
        
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
    
    self.SearchBox.searchTextPositionAdjustment = UIOffsetMake(25, 0);
    
    
    
    for (UIView *subView in _SearchBox.subviews)
    {
        for(id field in subView.subviews)
        {
            if ([field isKindOfClass:[UITextField class]])
            {
                UITextField *textField = (UITextField *)field;
                [textField setBackgroundColor:[UIColor colorWithRed:53.0/255.0 green:94.0/255.0 blue:120.0/255.0 alpha:1.0]];
                
                // [self.SearchBox setText:@"     Place holder"];
                
                //[self.SearchBox setPlaceholder:@"Postcode,Place...."];
                [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor grayColor]];
            }
        }
    }
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setLeftViewMode:UITextFieldViewModeNever];
    
    [UITextField appearanceWhenContainedIn:[UISearchBar class], nil].leftView = nil;
    
    // Give some left padding between the edge of the search bar and the text the user enters
    self.SearchBox.searchTextPositionAdjustment = UIOffsetMake(20, 0);
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont boldSystemFontOfSize:15], UITextAttributeFont,
                                [UIColor whiteColor], UITextAttributeTextColor,
                                nil];
    [self.segmentCtrl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.segmentCtrl setTitleTextAttributes:attributes forState:UIControlStateSelected];
    
    //    NSDictionary *attributes1 = [NSDictionary dictionaryWithObjectsAndKeys:
    //                                [UIFont boldSystemFontOfSize:12], UITextAttributeFont,
    //                                [UIColor whiteColor], UITextAttributeTextColor,
    //                                nil];
    //
    //
    //    [self.segmentCtrl2 setTitleTextAttributes:attributes1 forState:UIControlStateSelected];
    
    [self.segmentCtrl2 setTintColor:[UIColor clearColor]];
    _segmentCtrl2.selectedSegmentIndex=1;
    _lblParking.backgroundColor=[UIColor colorWithRed:7.0/255.0 green:42.0/255.0 blue:65.0/255.0 alpha:1.0];
    
    
    isMapSerach= NO;
    
    
    
    
    //    GMSMarker *mkr1= [[GMSMarker alloc]init];
    //
    //    [mkr1 setPosition:CLLocationCoordinate2DMake([strLat floatValue],[strLong floatValue] )];
    //
    //
    //
    //    GMSCameraPosition *camera1 = [GMSCameraPosition cameraWithLatitude:[strLat floatValue] longitude:[strLong floatValue]  zoom:14];
    //      mkr1.icon = [UIImage imageNamed:@"pin"];
    //    [mkr1 setTitle:@"Title"];
    //    [mkr1 setSnippet:@"Snipp"];
    //
    //    self.GMap.camera = camera1;
    //
    //
    //    [mkr1 setMap:self.GMap];
    
    
    self.GMap.delegate = self;
    self.GMap.myLocationEnabled =YES;
    self.GMap.mapType = kGMSTypeNormal;
    self.GMap.settings.compassButton =YES;
    self.GMap.settings.myLocationButton = YES;
    
    self.GMap.myLocationEnabled = YES;
    
    
    
    self.segmentCtrl.selectedSegmentIndex = 1;
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)webserviceCarParkkk
{
    //zoomer=@"1";
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"ArrayPinData"];
    
}

- (void)showMainMenu:(NSNotification *)note
{
   
//    UIViewController *currentVC = self.navigationController.visibleViewController;
//    if ([NSStringFromClass([currentVC class]) isEqualToString:@"LondonTubeViewController"])
//    {
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:@"Your current view controller:" message:NSStringFromClass([currentVC class]) delegate:nil
//                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    }
    
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] <= 7.0)
        {
            locationManager = [[CLLocationManager alloc] init];
            [locationManager setDelegate:self];
            [locationManager setDistanceFilter:kCLHeadingFilterNone];
            //change the desired accuracy to kCLLocationAccuracyBest
            [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            //SOLUTION: set setPausesLocationUpdatesAutomatically to NO
            [locationManager setPausesLocationUpdatesAutomatically:NO];
            [locationManager startUpdatingLocation];
        }
        else
        {
            
            locationManager = [[CLLocationManager alloc] init];
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            [locationManager requestWhenInUseAuthorization];
            
            [locationManager startUpdatingLocation];
            
            if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            {
                [locationManager requestWhenInUseAuthorization];
            }
            
        }
        
        _viewLocation.hidden=YES;
//        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//        [tracker set:kGAIScreenName value:@"Location Enabled"];
//        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

        
    }
    
    

    else
    {
        _viewLocation.hidden=NO;
        _viewLocation.backgroundColor=[UIColor redColor];
       // id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//        [tracker set:kGAIScreenName value:@"Location Disabled"];
//        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    }
    
}
- (UIStatusBarStyle) preferredStatusBarStyle

{
    return UIStatusBarStyleLightContent;
}
- (void) dismissKeyboard
{
    // add self
    [self.SearchBox resignFirstResponder];
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    _SearchBox.showsCancelButton = NO;
    
    
    // isSearching = NO;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    if(self.ViewList.hidden==NO)
    {
        if([arrayStore count]>0)
        {
            self.arrayTable=arrayStore;
            [_tblParking reloadData];
        }
    }
    else
    {
        isLabelShow=NO;
        isMapSerach=NO;
        showingAnnotations_ = NO;
        [self.GMap clear];
        if([ArrayPinData count]>0)
        {
            [self setDataOnMapView:ArrayPinData];
        }
        
        
        
    }
    
    
    isSearching = NO;
    
    
    
    [_SearchBox resignFirstResponder];
    
    
}



-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _SearchBox.showsCancelButton = YES;
    
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    isLabelShow=YES;
    [_SearchBox resignFirstResponder];
    //self.ViewList.hidden = NO;
    // self.ViewMap.hidden = YES;
    if(self.ViewList.hidden==YES)
    {
        if (isSearching == NO) {
            isMapSerach= YES;
            [self searchBarClickedOnMapSearch:searchBar.text];
            
        }
    }
    else
    {
        [self isTableSearchingEnable:searchBar.text];
    }
    IsCalled = YES;
    searchBar.text = @"";
    
}


-(void)isTableSearchingEnable:(NSString *)str
{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array removeAllObjects];
    
    for (int i = 0; i<self.arrayTable.count; i++) {
        
        [array addObject:[[self.arrayTable objectAtIndex:i] valueForKey:@"Name"]];
        
        
    }
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",str]; // if you need case sensitive search avoid '[c]' in the predicate
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    [results removeAllObjects];
    results = [[array filteredArrayUsingPredicate:predicate] mutableCopy];
    
    NSMutableArray *ArrayResults = [[NSMutableArray alloc] init];
    [ArrayResults removeAllObjects];
    
    if (results.count != 0) {
        
        
        for (int i = 0; i<results.count; i++) {
            
            for (int j = 0; j<self.arrayTable.count; j++) {
                
                if ([[results objectAtIndex:i] isEqualToString:[[self.arrayTable objectAtIndex:j] valueForKey:@"Name"]]) {
                    
                    [ArrayResults addObject:[self.arrayTable objectAtIndex:j]];
                    
                }
            }
            
            
        }
        
    }
    
    
    NSLog(@"ArrayResults --->%@",ArrayResults);
    if (ArrayResults.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"No results found." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        isLabelShow=NO;
        alert.tag = 121;
        
        [alert show];
        
        
    }
    else
    {
        self.arrayTable = [[NSMutableArray alloc] init];
        [self.arrayTable removeAllObjects];
        self.arrayTable = ArrayResults;
        [self.tblParking reloadData];
        
    }
    
    
    
    
    
}


-(void)searchBarClickedOnMapSearch:(NSString *)str
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array removeAllObjects];
    
    for (int i = 0; i<ArrayPinData.count; i++) {
        
        [array addObject:[[ArrayPinData objectAtIndex:i] valueForKey:@"Name"]];
        
        
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",str]; // if you need case sensitive search avoid '[c]' in the predicate
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    [results removeAllObjects];
    results = [[array filteredArrayUsingPredicate:predicate] mutableCopy];
    
    ArraySearchData = [[NSMutableArray alloc] init];
    [ArraySearchData removeAllObjects];
    
    
    if (results.count != 0) {
        
        
        for (int i = 0; i<results.count; i++) {
            
            for (int j = 0; j<ArrayPinData.count; j++) {
                
                if ([[results objectAtIndex:i] isEqualToString:[[ArrayPinData objectAtIndex:j] valueForKey:@"Name"]]) {
                    
                    [ArraySearchData addObject:[ArrayPinData objectAtIndex:j]];
                    
                }
            }
            
            
        }
        
    }
    
    
    
    
    
    NSLog(@"ArrayResults --->%@",ArraySearchData);
    
    if (ArraySearchData.count != 0 ) {
        NSDictionary *dict = @{@"Lat":@"51.4594086",@"Long":@"-0.9731692",@"Name":@"",@"Price":@""};
        [ArraySearchData addObject:dict];
        [self removePlacesFromMap];
        
        [self setDataOnMapView:ArraySearchData];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"No results found." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        isLabelShow=NO;
        alert.tag = 121;
        
        [alert show];
        
    }
    
    
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                    withVelocity:(CGPoint)velocity
             targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    /*self.SearchBox.translatesAutoresizingMaskIntoConstraints = YES;
     CGRect val;
     val=self.SearchBox.frame;
     NSLog(@"width of searchbox is %@",NSStringFromCGRect(val));
     if(IS_IPHONE6plus)
     {
     if(_SearchBox.frame.size.width==414)
     {}
     else
     {
     
     if (velocity.y > 0){
     
     
     //        CATransition *animation = [CATransition animation];
     //        animation.type = kCATransitionFade;
     //        animation.duration = 0.4;
     //        [_SearchBox.layer addAnimation:animation forKey:nil];
     //        [_imgSearch2.layer addAnimation:animation forKey:nil];
     //
     [UIView transitionWithView:_SearchBox duration:2.0 options:UIViewAnimationOptionTransitionNone animations:^(void) {
     
     
     CGRect newRect = _SearchBox.frame;
     
     
     newRect.size.width *= 50;
     
     _SearchBox.frame = newRect;
     
     
     
     } completion:^(BOOL finished) {
     
     
     
     }];
     _imgSearch2.hidden=NO;
     //_SearchBox.hidden=NO;
     NSLog(@"up");
     }
     }
     if(_SearchBox.frame.size.width<=30)
     {}
     else
     {
     
     if (velocity.y < 0){
     //        CATransition *animation = [CATransition animation];
     //        animation.type = kCATransitionFade;
     //        animation.duration = 0.4;
     //        [_SearchBox.layer addAnimation:animation forKey:nil];
     //        [_imgSearch2.layer addAnimation:animation forKey:nil];
     
     [UIView transitionWithView:_SearchBox duration:2.0 options:UIViewAnimationOptionTransitionNone animations:^(void) {
     
     
     CGRect newRect = _SearchBox.frame;
     
     
     newRect.size.width /= 50;
     
     _SearchBox.frame = newRect;
     } completion:^(BOOL finished) {
     
     
     
     }];
     
     NSLog(@"down");
     
     }
     }
     
     }
     else if(IS_IPHONE6)
     {
     if(_SearchBox.frame.size.width==375)
     {}
     else
     {
     
     if (velocity.y > 0){
     
     
     //        CATransition *animation = [CATransition animation];
     //        animation.type = kCATransitionFade;
     //        animation.duration = 0.4;
     //        [_SearchBox.layer addAnimation:animation forKey:nil];
     //        [_imgSearch2.layer addAnimation:animation forKey:nil];
     //
     [UIView transitionWithView:_SearchBox duration:2.0 options:UIViewAnimationOptionTransitionNone animations:^(void) {
     
     
     CGRect newRect = _SearchBox.frame;
     
     
     newRect.size.width *= 50;
     
     _SearchBox.frame = newRect;
     
     
     
     
     
     } completion:^(BOOL finished) {
     
     
     
     }];
     _imgSearch2.hidden=NO;
     //_SearchBox.hidden=NO;
     NSLog(@"up");
     }
     }
     if(_SearchBox.frame.size.width<=30)
     {}
     else
     {
     
     if (velocity.y < 0){
     //        CATransition *animation = [CATransition animation];
     //        animation.type = kCATransitionFade;
     //        animation.duration = 0.4;
     //        [_SearchBox.layer addAnimation:animation forKey:nil];
     //        [_imgSearch2.layer addAnimation:animation forKey:nil];
     
     [UIView transitionWithView:_SearchBox duration:2.0 options:UIViewAnimationOptionTransitionNone animations:^(void) {
     
     
     CGRect newRect = _SearchBox.frame;
     
     
     newRect.size.width /= 50;
     
     _SearchBox.frame = newRect;
     } completion:^(BOOL finished) {
     
     
     
     }];
     
     NSLog(@"down");
     
     }
     }
     
     }
     else
     {
     
     if(_SearchBox.frame.size.width==320)
     {}
     else
     {
     
     if (velocity.y > 0){
     
     
     //        CATransition *animation = [CATransition animation];
     //        animation.type = kCATransitionFade;
     //        animation.duration = 0.4;
     //        [_SearchBox.layer addAnimation:animation forKey:nil];
     //        [_imgSearch2.layer addAnimation:animation forKey:nil];
     //
     [UIView transitionWithView:_SearchBox duration:2.0 options:UIViewAnimationOptionTransitionNone animations:^(void) {
     
     
     CGRect newRect = _SearchBox.frame;
     
     
     newRect.size.width *= 50;
     
     _SearchBox.frame = newRect;
     
     
     
     
     
     } completion:^(BOOL finished) {
     
     
     
     }];
     _imgSearch2.hidden=NO;
     //_SearchBox.hidden=NO;
     NSLog(@"up");
     }
     }
     if(_SearchBox.frame.size.width<=30)
     {}
     else
     {
     
     if (velocity.y < 0){
     //        CATransition *animation = [CATransition animation];
     //        animation.type = kCATransitionFade;
     //        animation.duration = 0.4;
     //        [_SearchBox.layer addAnimation:animation forKey:nil];
     //        [_imgSearch2.layer addAnimation:animation forKey:nil];
     
     [UIView transitionWithView:_SearchBox duration:2.0 options:UIViewAnimationOptionTransitionNone animations:^(void) {
     
     
     CGRect newRect = _SearchBox.frame;
     
     
     newRect.size.width /= 50;
     
     _SearchBox.frame = newRect;
     } completion:^(BOOL finished) {
     
     
     
     }];
     
     NSLog(@"down");
     
     }
     }
     }*/
}

- (IBAction)ActionSegmentControl:(UISegmentedControl *)sender {
    
    
    for (int i=0; i<[sender.subviews count]; i++)
    {
        if ([[sender.subviews objectAtIndex:i]isSelected] )
        {
            UIColor *tintcolor=[UIColor colorWithRed:12.0/255.0 green:41.0/255.0 blue:64.0/255.0 alpha:1.0];
            [[sender.subviews objectAtIndex:i] setTintColor:tintcolor];
        }
        else
        {
            
            
            
            [[sender.subviews objectAtIndex:i] setTintColor:nil];
        }
    }
    
    
    int index = (int)sender.selectedSegmentIndex;
    if (index == 0) {
        [self.view endEditing:YES];
        
        //isSearching = YES;
        if (IsCalled == YES) {
            isSearching = NO;
            
            self.arrayTable=arrayStore;
            
            [_tblParking reloadData];
            IsCalled = NO;
        }
        else
        {
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"ArrayPinData2"] != nil) {
                self.arrayTable=[[NSUserDefaults standardUserDefaults] valueForKey:@"ArrayPinData2"];
                
                [_tblParking reloadData];

            }
            else
            {
                [_tblParking reloadData];

            }
                   }
        self.ViewList.hidden = NO;
        self.ViewMap.hidden = YES;
    }
    else
    {
        [self.GMap clear];
        [self.view endEditing:YES];
        isSearching = NO;
        isLabelShow=NO;
        isMapSerach=NO;
        showingAnnotations_ = NO;
        [self.GMap clear];
        
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"ArrayPinData2"] != nil) {
            arrayData =[[NSUserDefaults standardUserDefaults] valueForKey:@"ArrayPinData2"];
        }
        ArrayPinData = [[NSMutableArray alloc] init];
        [ArrayPinData removeAllObjects];
        for (int i = 0; i<arrayData.count; i++) {
            
            
            NSDictionary *dict = @{@"Lat":[[[arrayData objectAtIndex:i] valueForKey:@"Coordinates"] valueForKey:@"Latitude"],@"Long":[[[arrayData objectAtIndex:i] valueForKey:@"Coordinates"] valueForKey:@"Longitude"],@"Name":[[arrayData objectAtIndex:i] valueForKey:@"Name"],@"Price":[[arrayData objectAtIndex:i] valueForKey:@"Price"]};
            
            [ArrayPinData addObject:dict];
            
            
        }
        NSDictionary *dict = @{@"Lat":@"51.4594086",@"Long":@"-0.9731692",@"Name":@"",@"Price":@""};
        [ArrayPinData addObject:dict];
        
        [self setDataOnMapView:ArrayPinData];
        
        
        self.ViewList.hidden = YES;
        self.ViewMap.hidden = NO;
        
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






#pragma Mark:- MAPVIEW


-(void)webserviceCarParkk
{
    [[AppDelegate appDelegate] showLoadingAlert:self.view];
    //[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowMBProgressBar object:@"Loading..."];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer.timeoutInterval=60.0;
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"syscraft" password:@"sis*123"];
    //[httpclient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSString *uuid=[self getUniqueDeviceIdentifierAsString];
    NSString  *path=[NSString stringWithFormat:baseUrl@"/carpark/index/device_id/%@",uuid];
    
    
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         
         
         if (![[responseObject valueForKey:@"error"] isEqualToString:@""]) {
             
             [self.view makeToast:NSLocalizedString(@"Device Id is Not Valid", nil) duration:3.0 position:CSToastPositionCenter];         }
         else
         {
             isLabelShow=NO;
             isMapSerach=NO;
             showingAnnotations_ = NO;
             [self.GMap clear];
             
             self.arrayTable = [[NSMutableArray alloc] init];
             [ self.arrayTable removeAllObjects];
             self.arrayTable = [responseObject valueForKey:@"data"];
             if(self.arrayTable.count==0)
             {
                 [self.view makeToast:NSLocalizedString(@"No Data Found", nil) duration:3.0 position:CSToastPositionCenter];  
             
             }
             else
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
                 }             //[[self.tabBarController.tabBar.items objectAtIndex:0] setBadgeValue:badgeC];
             
             [self.tblParking reloadData];
             
             arrayStore=[[NSMutableArray alloc]init];
             [arrayStore removeAllObjects];
             arrayStore = [responseObject valueForKey:@"data"];
             arrayData = [[NSMutableArray alloc] init];
             [arrayData removeAllObjects];
             arrayData = [responseObject valueForKey:@"data"];
             ArrayPinData = [[NSMutableArray alloc] init];
             [ArrayPinData removeAllObjects];
             for (int i = 0; i<arrayData.count; i++) {
                 
                 
                 NSDictionary *dict = @{@"Lat":[[[arrayData objectAtIndex:i] valueForKey:@"Coordinates"] valueForKey:@"Latitude"],@"Long":[[[arrayData objectAtIndex:i] valueForKey:@"Coordinates"] valueForKey:@"Longitude"],@"Name":[[arrayData objectAtIndex:i] valueForKey:@"Name"],@"Price":[[arrayData objectAtIndex:i] valueForKey:@"Price"]};
                 
                 [ArrayPinData addObject:dict];
                 
                 
                 
             }
             NSDictionary *dict = @{@"Lat":@"51.4594086",@"Long":@"-0.9731692",@"Name":@"",@"Price":@""};
             [ArrayPinData addObject:dict];
             
             if([zoomer isEqualToString:@"1"])
             {
                 [self setDataOnMapView2:ArrayPinData];
             }
             else
             {
                 [self setDataOnMapView:ArrayPinData];
             }
             [[NSUserDefaults standardUserDefaults]setObject:ArrayPinData forKey:@"ArrayPinData"];
             
             [[NSUserDefaults standardUserDefaults]setObject:arrayData forKey:@"ArrayPinData2"];
             
                 
             }
          //   [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
             [[AppDelegate appDelegate] removeLoadingAlert:self.view];
             
             
         }
         
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
      //   [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];

          [[AppDelegate appDelegate] removeLoadingAlert:self.view];
         if([[NSUserDefaults standardUserDefaults] valueForKey:@"ArrayPinData"] != nil)
         {
             ArrayPinData =[[NSUserDefaults standardUserDefaults] valueForKey:@"ArrayPinData"];
             
             [_tblParking reloadData];
             
         }
         
         
     }];
}



-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    //[timer invalidate];
    
}

#pragma Mark:- Set Data On MapView
/*
 -(void)setDataOnMapView:(NSMutableArray *)array
 
 {
 
 if (isMapSerach == YES) {
 isMapSerach = NO;
 
 [self.GMap clear];
 
 
 }
 
 mkr= [[GMSMarker alloc]init];
 
 [mkr setPosition:CLLocationCoordinate2DMake(51.4594086,-0.9731692 )];
 
 GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:51.4594086 longitude:-0.9731692  zoom:14];
 self.GMap.camera = camera;
 
 
 
 mkr.icon = [UIImage imageNamed:@"pin"];
 [mkr setTitle:@"Title"];
 [mkr setSnippet:@"Snipp"];
 [mkr setMap:self.GMap];
 
 
 UIImageView *pinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,25,40,65)];
 pinImageView.image= [UIImage imageNamed:@"mappin"];
 for (int j = 0; j<array.count; j++) {
 
 mkr= [[GMSMarker alloc]init];
 //[mkr setValue:[ArrayPinData objectAtIndex:j] forKey:@"Hello"];
 [mkr setPosition:CLLocationCoordinate2DMake([[[array objectAtIndex:j] valueForKey:@"Lat"] floatValue], [[[array objectAtIndex:j] valueForKey:@"Long"] floatValue])];
 
 GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[[array objectAtIndex:0] valueForKey:@"Lat"] floatValue]longitude:[[[array
 objectAtIndex:0] valueForKey:@"Long"] floatValue]zoom:14];
 self.GMap.camera = camera;
 NSString *str=[[array objectAtIndex:j] valueForKey:@"Name"];
 // UILabel *lbl;
 
 
 
 UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,100,130)];
 
 //UILabel *label = [UILabel new];
 NSRange range = [[[array objectAtIndex:j] valueForKey:@"Price"] rangeOfString:@"."];
 
 if (range.length > 0){
 NSLog(@"Double value");
 label = [[UILabel alloc] initWithFrame:CGRectMake(11 ,38,30,5)];
 }
 else {
 NSLog(@"Integer value");
 label = [[UILabel alloc] initWithFrame:CGRectMake(14 ,38,30,5)];
 }
 lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(5 ,27,30,5)];
 
 lbl2.textAlignment = NSTextAlignmentCenter;
 lbl2.numberOfLines=0;
 lbl2.text =@"1st Hour";
 [lbl2 setFont:[UIFont systemFontOfSize:7]];
 [lbl2 sizeToFit];
 
 
 
 
 label.textAlignment = NSTextAlignmentCenter;
 label.numberOfLines=0;
 label.text = [NSString stringWithFormat:@"£%@",[[array objectAtIndex:j] valueForKey:@"Price"]];
 [label setFont:[UIFont systemFontOfSize:8]];
 [label sizeToFit];
 
 
 if (isLabelShow == YES) {
 
 
 klabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 100, 40)];
 //[klabel setFont: [UIFont fontWithName:@"Roboto-Light" size:9]];
 // [klabel setText: @"Tower"];
 // here I apply the add triangle function to the uilabel.layer
 //lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0 ,0,150,20)];
 
 klabel.textAlignment = NSTextAlignmentCenter;
 klabel.numberOfLines=1;
 klabel.text =[[array objectAtIndex:j] valueForKey:@"Name"];
 [klabel setBackgroundColor:[UIColor whiteColor]];
 [klabel setFont:[UIFont systemFontOfSize:16]];
 [klabel sizeToFit];
 //[klabel addSubview:lblTitle];
 
 [self addTriangleTipToLayer:klabel];
 //set the label to fit text content before rendered as a image
 [klabel sizeToFit];
 
 //convert the uilabel to image content
 //  UIGraphicsBeginImageContextWithOptions:(CGRectMake(0, 0, klabel.frame.size.width,klabel.frame.size.height), NO, [[UIScreen mainScreen] scale]);
 UIGraphicsBeginImageContextWithOptions(klabel.bounds.size, NO, [[UIScreen mainScreen] scale]);
 [klabel.layer renderInContext:UIGraphicsGetCurrentContext()];
 [view addSubview:klabel];
 [klabel.layer renderInContext:UIGraphicsGetCurrentContext()];
 UIImage * kicon = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 
 
 
 
 }
 else
 {
 
 [lblTitle removeFromSuperview];
 
 
 }
 
 
 [view addSubview:pinImageView];
 [view addSubview:label];
 //[view addSubview:lbl2];
 
 //i.e. customize view to get what you need
 
 
 UIImage *markerIcon = [self imageFromView:view];
 mkr.icon = markerIcon;
 // mkr.icon = [UIImage imageNamed:@"mappin"];
 [mkr setTitle:[[array objectAtIndex:j] valueForKey:@"Name"]];
 NSLog(@"Map icon title %@",mkr.title);
 // [mkr setSnippet:@"Snipp"];
 [mkr setMap:self.GMap];
 [mkr setUserData:str];
 //[self.GMap setSelectedMarker:mkr];
 currentZoom = self.GMap.camera.zoom;
 
 
 }
 }
 */

-(void)setDataOnMapView2:(NSMutableArray *)array
{
    if (!places_)
        places_ = [NSMutableArray new];
    
    [places_ removeAllObjects];
    
    for (int i = 0; i < array.count; i++) {
        mkr = [GMSMarker new];
        mkr.title = [[array objectAtIndex:i] valueForKey:@"Name"];
        
        //self.GMap.camera = camera;
        NSString *str= mkr.title;
        mkr.position = CLLocationCoordinate2DMake([[[array objectAtIndex:i] valueForKey:@"Lat"] floatValue], [[[array objectAtIndex:i] valueForKey:@"Long"] floatValue]);
        mkr.map = self.GMap;
        [mkr setUserData:str];
        [places_ addObject:mkr];
    }
    
    
    if (isMapSerach == YES) {
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[[ArraySearchData objectAtIndex:0] valueForKey:@"Lat"] floatValue]longitude:[[[ArraySearchData
                                                                                                                                                          objectAtIndex:0] valueForKey:@"Long"] floatValue]zoom:zoomLevel];
        self.GMap.camera = camera;
        
        
        
    }
    else
    {
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[[ArrayPinData objectAtIndex:0] valueForKey:@"Lat"] floatValue]longitude:[[[ArrayPinData
                                                                                                                                                       objectAtIndex:0] valueForKey:@"Long"] floatValue]zoom:zoomLevel];
        self.GMap.camera = camera;
        
        
        
    }
    
    [self loadPlacesOnMap];
    
}

-(void)setDataOnMapView:(NSMutableArray *)array
{
    if (!places_)
        places_ = [NSMutableArray new];
    
    [places_ removeAllObjects];
    
    for (int i = 0; i < array.count; i++) {
        mkr = [GMSMarker new];
        mkr.title = [[array objectAtIndex:i] valueForKey:@"Name"];
        
        //self.GMap.camera = camera;
        NSString *str= mkr.title;
        mkr.position = CLLocationCoordinate2DMake([[[array objectAtIndex:i] valueForKey:@"Lat"] floatValue], [[[array objectAtIndex:i] valueForKey:@"Long"] floatValue]);
        mkr.map = self.GMap;
        [mkr setUserData:str];
        [places_ addObject:mkr];
    }
    
    
    if (isMapSerach == YES) {
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[[ArraySearchData objectAtIndex:0] valueForKey:@"Lat"] floatValue]longitude:[[[ArraySearchData
                                                                                                                                                          objectAtIndex:0] valueForKey:@"Long"] floatValue]zoom:14.00];
        self.GMap.camera = camera;
        
        
        
    }
    else
    {
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[[ArrayPinData objectAtIndex:0] valueForKey:@"Lat"] floatValue]longitude:[[[ArrayPinData
                                                                                                                                                       objectAtIndex:0] valueForKey:@"Long"] floatValue]zoom:14.00];
        self.GMap.camera = camera;
        
        
        
    }
    
    [self loadPlacesOnMap];
    
}


- (void)removePlacesFromMap {
    self.GMap.selectedMarker = nil;
    
    for (GMSMarker *place in places_) {
        place.map = nil;
        place.panoramaView = nil;
    }
    
    
    
    
}



- (void)loadPlacesOnMap {
    /*
     for (GMSMarker *place in places_) {
     
     if (showingAnnotations_)
     {
     //place.icon = [DAMapAnnotationView annotationImageWithMarker:place andPinIcon:[UIImage imageNamed:@"mappin.png"]];
     place.icon = [DAMapAnnotationView annotationImageWithMarker:place andPinIcon:[UIImage imageNamed:@"mappin.png"] andStrValue:<#(NSString *)#>]
     NSLog(@"IF");
     place.map = self.GMap;
     
     }
     else
     {
     place.icon = [UIImage imageNamed:@"mappin.png"];
     NSLog(@"ELSE");
     place.map = self.GMap;
     }
     
     
     }
     
     */
    
    for (int i = 0; i<=places_.count; i++) {
        if(i==places_.count)
        {
            mkr.icon=[UIImage imageNamed:@"imgPin"];
            
        }
        else
        {
            mkr = [places_ objectAtIndex:i];
            if (showingAnnotations_) {
                if (isMapSerach == YES) {
                    mkr.icon = [DAMapAnnotationView annotationImageWithMarker:mkr andPinIcon:[UIImage imageNamed:@"imgLoc"] andStrValue:[[ArraySearchData objectAtIndex:i] valueForKey:@"Price"]];
                }
                else
                {
                    mkr.icon = [DAMapAnnotationView annotationImageWithMarker:mkr andPinIcon:[UIImage imageNamed:@"imgLoc"] andStrValue:[[ArrayPinData objectAtIndex:i] valueForKey:@"Price"]];
                }
                
                /*  GMSMarker *mkrr= [[GMSMarker alloc]init];
                 
                 [mkrr setPosition:CLLocationCoordinate2DMake(51.4594086,-0.9731692 )];
                 
                 GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:51.4594086 longitude:-0.9731692  zoom:14];
                 self.GMap.camera = camera;
                 
                 
                 
                 mkrr.icon = [UIImage imageNamed:@"pin"];
                 [mkrr setTitle:@"Title"];
                 [mkrr setSnippet:@"Snipp"];
                 [mkrr setMap:self.GMap];*/
                
                
            }
            else
            {
                
                
                if (isMapSerach == YES)
                {
                    /*  GMSMarker *mkrr= [[GMSMarker alloc]init];
                     
                     [mkrr setPosition:CLLocationCoordinate2DMake(51.4594086,-0.9731692 )];
                     
                     GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:51.4594086 longitude:-0.9731692  zoom:14];
                     self.GMap.camera = camera;
                     
                     
                     
                     mkrr.icon = [UIImage imageNamed:@"pin"];
                     [mkrr setTitle:@"Title"];
                     [mkrr setSnippet:@"Snipp"];
                     [mkrr setMap:self.GMap];*/
                    
                    mkr.icon = [DAMapAnnotationView annotationImageWithMarker:mkr andPinIcon:[UIImage imageNamed:@"imgLoc"] andStrValue:[[ArrayPinData objectAtIndex:i] valueForKey:@"Price"]];
                    
                    /* UIImageView *pinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,25,40,65)];
                     pinImageView.image= [UIImage imageNamed:@"mappin.png"];
                     
                     UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,100,130)];
                     
                     
                     NSRange range = [[[ArraySearchData objectAtIndex:i] valueForKey:@"Price"] rangeOfString:@"."];
                     
                     if (range.length > 0){
                     NSLog(@"Double value");
                     label = [[UILabel alloc] initWithFrame:CGRectMake(11 ,38,30,5)];
                     }
                     else {
                     NSLog(@"Integer value");
                     label = [[UILabel alloc] initWithFrame:CGRectMake(14 ,38,30,5)];
                     }
                     
                     
                     label.textAlignment = NSTextAlignmentCenter;
                     label.numberOfLines=0;
                     label.text = [NSString stringWithFormat:@"£%@",[[ArraySearchData objectAtIndex:i] valueForKey:@"Price"]];
                     [label setFont:[UIFont systemFontOfSize:8]];
                     [label sizeToFit];
                     
                     [view addSubview:pinImageView];
                     [view addSubview:label];
                     
                     
                     UIImage *markerIcon = [self imageFromView:view];
                     mkr.icon = markerIcon;*/
                    
                }
                else
                {
                    /*  GMSMarker *mkrr= [[GMSMarker alloc]init];
                     
                     [mkrr setPosition:CLLocationCoordinate2DMake(51.4594086,-0.9731692 )];
                     
                     GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:51.4594086 longitude:-0.9731692  zoom:14];
                     self.GMap.camera = camera;
                     
                     
                     
                     mkrr.icon = [UIImage imageNamed:@"pin"];
                     [mkrr setTitle:@"Title"];
                     [mkrr setSnippet:@"Snipp"];
                     [mkrr setMap:self.GMap];*/
                    
                    UIImageView *pinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,25,40,65)];
                    pinImageView.image= [UIImage imageNamed:@"imgLoc"];
                    
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,100,130)];
                    
                    
                    NSRange range = [[[ArrayPinData objectAtIndex:i] valueForKey:@"Price"] rangeOfString:@"."];
                    
                    if (range.length > 0){
                        NSLog(@"Double value");
                        label = [[UILabel alloc] initWithFrame:CGRectMake(11 ,38,30,5)];
                    }
                    else {
                        NSLog(@"Integer value");
                        label = [[UILabel alloc] initWithFrame:CGRectMake(14 ,38,30,5)];
                    }
                    
                    
                    label.textAlignment = NSTextAlignmentCenter;
                    label.numberOfLines=0;
                    label.text = [NSString stringWithFormat:@"£%@",[[ArrayPinData objectAtIndex:i] valueForKey:@"Price"]];
                    [label setFont:[UIFont systemFontOfSize:8]];
                    [label sizeToFit];
                    
                    [view addSubview:pinImageView];
                    [view addSubview:label];
                    
                    
                    UIImage *markerIcon = [self imageFromView:view];
                    mkr.icon = markerIcon;
                }
                
                
                
            }
            
            
            
        }
    }
}




- (void)addTriangleTipToLayer: (UIView *) view{
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


-(void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition*)position {
    
    CGFloat  zoom= self.GMap.camera.zoom;
    
    zoomLevel = [[NSString stringWithFormat:@"%0.2f",zoom] floatValue];
    
    
    if (zoomLevel< 14.00) {
        showingAnnotations_ = NO;
        
        
        [self loadPlacesOnMap];
        
        NSLog(@"HIDE");
        
    }
    if (zoomLevel > 15.00) {
        showingAnnotations_ = YES;
        
        [self loadPlacesOnMap];
        
        NSLog(@"SHOW");
        
    }
    
    
}




-(bool) isNumeric:(NSString*) checkText{
    return [[NSScanner scannerWithString:checkText] scanFloat:NULL];
}

- (UIImage *)imageFromView:(UIView *) view
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(view.frame.size);
    }
    [view.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    NSLog(@"DETAIL---->%@",marker);
    // NSLog(@"%@",marker.userData);
    
    for (int i = 0; i<arrayData.count; i++) {
        
        NSString *str=[[arrayData objectAtIndex:i] valueForKey:@"Name"];
        if ([str isEqualToString:marker.userData])
        {
            NSDictionary *dic=[arrayData objectAtIndex:i];
            // marker.title=[dic valueForKey:@"Name"];
            NSMutableArray *arrayPrice=[[NSMutableArray alloc]init];
            [arrayPrice removeAllObjects];
            for(int i=0;i<13;i++)
            {
                if(i==0)
                {
                    if([[dic valueForKey:@"0.5 hr Price"]isEqualToString:@"0"])
                    {}
                    else
                    {
                        //[arrayPrice insertObject:[NSString stringWithFormat:@"0.5 hr Price:£%@",[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"0.5 hr Price"]] atIndex:i];
                        [arrayPrice addObject:[NSString stringWithFormat:@"0.5 hr :£%@",[dic valueForKey:@"0.5 hr Price"]]];
                    }
                    //[NSString stringWithFormat:@"£%@",[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"0.5 hr Price"]]
                    
                }
                if(i==1)
                {
                    if([[dic valueForKey:@"1 hr Price"]isEqualToString:@"0"])
                    {}
                    else
                    {
                        [arrayPrice addObject:[NSString stringWithFormat:@"1 hr :£%@",[dic valueForKey:@"1 hr Price"]]];
                    }
                    
                }
                if(i==2)
                {
                    if([[dic valueForKey:@"2 hr Price"]isEqualToString:@"0"])
                    {}
                    else
                    {
                        [arrayPrice addObject:[NSString stringWithFormat:@"2 hrs :£%@",[dic valueForKey:@"2 hr Price"]]];
                    }
                    
                }
                if(i==3)
                {
                    if([[dic valueForKey:@"3 hr Price"]isEqualToString:@"0"])
                    {}
                    else
                    {
                        [arrayPrice addObject:[NSString stringWithFormat:@"3 hrs :£%@",[dic valueForKey:@"3 hr Price"]]];
                    }
                    
                }
                if(i==4)
                {
                    if([[dic valueForKey:@"4 hr Price"]isEqualToString:@"0"])
                    {}
                    else
                    {
                        [arrayPrice addObject:[NSString stringWithFormat:@"4 hrs :£%@",[dic valueForKey:@"4 hr Price"]]];
                    }
                    
                }
                if(i==5)
                {
                    if([[dic valueForKey:@"5 hr Price"]isEqualToString:@"0"])
                    {}
                    else
                    {
                        [arrayPrice addObject:[NSString stringWithFormat:@"5 hrs :£%@",[dic valueForKey:@"5 hr Price"]]];
                    }
                    
                }
                if(i==6)
                {
                    if([[dic valueForKey:@"6 hr Price"]isEqualToString:@"0"])
                    {}
                    else
                    {
                        [arrayPrice addObject:[NSString stringWithFormat:@"6 hrs :£%@",[dic valueForKey:@"6 hr Price"]]];
                    }
                    
                }
                if(i==7)
                {
                    if([[dic valueForKey:@"7 hr Price"]isEqualToString:@"0"])
                    {}
                    else
                    {
                        [arrayPrice addObject:[NSString stringWithFormat:@"7 hrs :£%@",[dic valueForKey:@"7 hr Price"]]];
                    }
                    
                }
                if(i==8)
                {
                    if([[dic valueForKey:@"8 hr Price"]isEqualToString:@"0"])
                    {}
                    else
                    {
                        [arrayPrice addObject:[NSString stringWithFormat:@"8 hrs :£%@",[dic valueForKey:@"8 hr Price"]]];
                    }
                    
                }
                if(i==9)
                {
                    if([[dic valueForKey:@"9 hr Price"]isEqualToString:@"0"])
                    {}
                    else
                    {
                        [arrayPrice addObject:[NSString stringWithFormat:@"9 hrs :£%@",[dic valueForKey:@"9 hr Price"]]];
                    }
                    
                }
                if(i==10)
                {
                    if([[dic valueForKey:@"12 hr Price"]isEqualToString:@"0"])
                    {}
                    else
                    {
                        [arrayPrice addObject:[NSString stringWithFormat:@"12 hrs :£%@",[dic valueForKey:@"12 hr Price"]]];
                    }
                    
                }
                if(i==11)
                {
                    if([[dic valueForKey:@"24 hr Price"]isEqualToString:@"0"])
                    {}
                    else
                    {
                        [arrayPrice addObject:[NSString stringWithFormat:@"24 hrs :£%@",[dic valueForKey:@"24 hr Price"]]];
                        
                    }
                    
                }
                if(i==12)
                {
                    if([[dic valueForKey:@"1 wk Price"]isEqualToString:@"0"])
                    {}
                    else
                    {
                        [arrayPrice addObject:[NSString stringWithFormat:@"1 Week :£%@",[dic valueForKey:@"1 wk Price"]]];
                    }
                    
                }
                
            }
            [[NSUserDefaults standardUserDefaults]setObject:arrayPrice forKey:@"arrayPrice"];
            [[NSUserDefaults standardUserDefaults]setObject: [dic valueForKey:@"Name"] forKey:@"ParkingName"];
            
            
            [[NSUserDefaults standardUserDefaults]setObject:[dic valueForKey:@"Carpark Image"] forKey:@"CarparkImage"];
            NSString *payment=[dic valueForKey:@"Payments"];
            
            payment = [payment stringByReplacingOccurrencesOfString:@"/"
                                                         withString:@","];
            
            [[NSUserDefaults standardUserDefaults]setObject:payment forKey:@"Payment"];
            
            [[NSUserDefaults standardUserDefaults]setObject:arrayPrice forKey:@"arrayPrice"];
            [[NSUserDefaults standardUserDefaults]setObject: [dic valueForKey:@"Distance From Station"] forKey:@"DistanceFromStation"];
            
            if([[dic valueForKey:@"Available Spaces"]isEqualToString:@"0"])
            {
                
                [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"NA/%@",[dic valueForKey:@"Capacity"]] forKey:@"Capacity"];
                
            }
            else
            {
                [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@/%@",[dic valueForKey:@"Available Spaces"],[dic valueForKey:@"Capacity"]] forKey:@"Capacity"];
                
            }
            
            
            
            [[NSUserDefaults standardUserDefaults]setObject:[dic valueForKey:@"Price"] forKey:@"Price"];
            [[NSUserDefaults standardUserDefaults]setObject:[dic valueForKey:@"Postcode"] forKey:@"Postcode"];
            [[NSUserDefaults standardUserDefaults]setObject:[dic valueForKey:@"DisabledCapacity"] forKey:@"DisabledCapacity"];
            // obj.dictData = [self.arrayTable objectAtIndex:indexPath.row];
            DetailViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
            obj.dictData = [dic mutableCopy];
            //[self.navigationController pushViewController:obj animated:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController: obj animated:YES];
                
            });

            
        }
    }
    
    
    
    return YES;
}


#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    
    
    // NSString *markerCategory=[marker.userData objectAtIndex:0];
    // NSString *markerName=[marker.userData objectAtIndex:1];
    //UIImage *markerImage=[marker.userData objectAtIndex:2];
    //CLPlacemark *markerPlacemark=[marker.userData objectAtIndex:3];
    
    NSLog(@"DETAIL---->%@",marker);
    // NSLog(@"%@",marker.userData);
    
    for (int i = 0; i<arrayData.count; i++) {
        
        NSString *str=[[arrayData objectAtIndex:i] valueForKey:@"Name"];
        if ([str isEqualToString:marker.userData])
        {
            NSDictionary *dic=[arrayData objectAtIndex:i];
            // marker.title=[dic valueForKey:@"Name"];
            NSMutableArray *arrayPrice=[[NSMutableArray alloc]init];
            [arrayPrice removeAllObjects];
            for(int i=0;i<13;i++)
            {
                if(i==0)
                {
                    if([[dic valueForKey:@"0.5 hr Price"]isEqualToString:@"0"])
                    {}
                    else
                    {
                        //[arrayPrice insertObject:[NSString stringWithFormat:@"0.5 hr Price:£%@",[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"0.5 hr Price"]] atIndex:i];
                        [arrayPrice addObject:[NSString stringWithFormat:@"0.5 hr :£%@",[dic valueForKey:@"0.5 hr Price"]]];
                    }
                    //[NSString stringWithFormat:@"£%@",[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"0.5 hr Price"]]
                    
                }
                if(i==1)
                {
                    if([[dic valueForKey:@"1 hr Price"]isEqualToString:@"0"])
                    {}
                    else
                    {
                        [arrayPrice addObject:[NSString stringWithFormat:@"1 hr :£%@",[dic valueForKey:@"1 hr Price"]]];
                    }
                    
                }
                if(i==2)
                {
                    if([[dic valueForKey:@"2 hr Price"]isEqualToString:@"0"])
                    {}
                    else
                    {
                        [arrayPrice addObject:[NSString stringWithFormat:@"2 hrs :£%@",[dic valueForKey:@"2 hr Price"]]];
                    }
                    
                }
                if(i==3)
                {
                    if([[dic valueForKey:@"3 hr Price"]isEqualToString:@"0"])
                    {}
                    else
                    {
                        [arrayPrice addObject:[NSString stringWithFormat:@"3 hrs :£%@",[dic valueForKey:@"3 hr Price"]]];
                    }
                    
                }
                if(i==4)
                {
                    if([[dic valueForKey:@"4 hr Price"]isEqualToString:@"0"])
                    {}
                    else
                    {
                        [arrayPrice addObject:[NSString stringWithFormat:@"4 hrs :£%@",[dic valueForKey:@"4 hr Price"]]];
                    }
                    
                }
                if(i==5)
                {
                    if([[dic valueForKey:@"5 hr Price"]isEqualToString:@"0"])
                    {}
                    else
                    {
                        [arrayPrice addObject:[NSString stringWithFormat:@"5 hrs :£%@",[dic valueForKey:@"5 hr Price"]]];
                    }
                    
                }
                if(i==6)
                {
                    if([[dic valueForKey:@"6 hr Price"]isEqualToString:@"0"])
                    {}
                    else
                    {
                        [arrayPrice addObject:[NSString stringWithFormat:@"6 hrs :£%@",[dic valueForKey:@"6 hr Price"]]];
                    }
                    
                }
                if(i==7)
                {
                    if([[dic valueForKey:@"7 hr Price"]isEqualToString:@"0"])
                    {}
                    else
                    {
                        [arrayPrice addObject:[NSString stringWithFormat:@"7 hrs :£%@",[dic valueForKey:@"7 hr Price"]]];
                    }
                    
                }
                if(i==8)
                {
                    if([[dic valueForKey:@"8 hr Price"]isEqualToString:@"0"])
                    {}
                    else
                    {
                        [arrayPrice addObject:[NSString stringWithFormat:@"8 hrs :£%@",[dic valueForKey:@"8 hr Price"]]];
                    }
                    
                }
                if(i==9)
                {
                    if([[dic valueForKey:@"9 hr Price"]isEqualToString:@"0"])
                    {}
                    else
                    {
                        [arrayPrice addObject:[NSString stringWithFormat:@"9 hrs :£%@",[dic valueForKey:@"9 hr Price"]]];
                    }
                    
                }
                if(i==10)
                {
                    if([[dic valueForKey:@"12 hr Price"]isEqualToString:@"0"])
                    {}
                    else
                    {
                        [arrayPrice addObject:[NSString stringWithFormat:@"12 hrs :£%@",[dic valueForKey:@"12 hr Price"]]];
                    }
                    
                }
                if(i==11)
                {
                    if([[dic valueForKey:@"24 hr Price"]isEqualToString:@"0"])
                    {}
                    else
                    {
                        [arrayPrice addObject:[NSString stringWithFormat:@"24 hrs :£%@",[dic valueForKey:@"24 hr Price"]]];
                        
                    }
                    
                }
                if(i==12)
                {
                    if([[dic valueForKey:@"1 wk Price"]isEqualToString:@"0"])
                    {}
                    else
                    {
                        [arrayPrice addObject:[NSString stringWithFormat:@"1 Week :£%@",[dic valueForKey:@"1 wk Price"]]];
                    }
                    
                }
                
            }
            [[NSUserDefaults standardUserDefaults]setObject:arrayPrice forKey:@"arrayPrice"];
            [[NSUserDefaults standardUserDefaults]setObject: [dic valueForKey:@"Name"] forKey:@"ParkingName"];
            
            
            [[NSUserDefaults standardUserDefaults]setObject:[dic valueForKey:@"Carpark Image"] forKey:@"CarparkImage"];
            NSString *payment=[dic valueForKey:@"Payments"];
            
            payment = [payment stringByReplacingOccurrencesOfString:@"/"
                                                         withString:@","];
            
            [[NSUserDefaults standardUserDefaults]setObject:payment forKey:@"Payment"];
            
            [[NSUserDefaults standardUserDefaults]setObject:arrayPrice forKey:@"arrayPrice"];
            [[NSUserDefaults standardUserDefaults]setObject: [dic valueForKey:@"Distance From Station"] forKey:@"DistanceFromStation"];
            [[NSUserDefaults standardUserDefaults]setObject: [dic valueForKey:@"Capacity"] forKey:@"Capacity"];
            [[NSUserDefaults standardUserDefaults]setObject:[dic valueForKey:@"Price"] forKey:@"Price"];
            [[NSUserDefaults standardUserDefaults]setObject:[dic valueForKey:@"Postcode"] forKey:@"Postcode"];
            [[NSUserDefaults standardUserDefaults]setObject:[dic valueForKey:@"DisabledCapacity"] forKey:@"DisabledCapacity"];
            // obj.dictData = [self.arrayTable objectAtIndex:indexPath.row];
            DetailViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
            obj.dictData = [dic mutableCopy];
            //[self.navigationController pushViewController:obj animated:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController: obj animated:YES];
                
            });

            return;
        }
    }
    
}

#pragma MARK TAbleView Methods


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    return [ self.arrayTable count];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE6)
    {
        return 88.0;
    }else if (IS_IPHONE6plus)
    {
        return 98.0;
    }else
    {
        return 80.0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ListCell";
    
    
    
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[ListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // cell.roundviewtable.layer.cornerRadius=5;
    // cell.roundviewtable.layer.masksToBounds=YES;
    //Available Spaces
    if([[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"Available Spaces"]isEqualToString:@"0"])
    {
        cell.lblcapacity.text = [NSString stringWithFormat:@"NA/%@",[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"Capacity"]];
        
    }
    else
    {
        cell.lblcapacity.text = [NSString stringWithFormat:@"%@/%@",[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"Available Spaces"],[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"Capacity"]];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    cell.lblParkName.text = [[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"Name"];
    
    cell.lblPrice.text = [NSString stringWithFormat:@"£%@",[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"Price"]];
    // cell.lblPrice.text = [NSString stringWithFormat:@"£%@",[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"Price"]];
    
    cell.lblDistance.text = [NSString stringWithFormat:@"%@ Miles",[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"Distance From Station"]];
    
    cell.viewCell.layer.cornerRadius = 7;
    cell.viewCell.layer.masksToBounds = YES;
    
    cell.selected=NO;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    NSMutableArray *arrayPrice=[[NSMutableArray alloc]init];
    [arrayPrice removeAllObjects];
    for(int i=0;i<13;i++)
    {
        if(i==0)
        {
            if([[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"0.5 hr Price"]isEqualToString:@"0"])
            {}
            else
            {
                //[arrayPrice insertObject:[NSString stringWithFormat:@"0.5 hr Price:£%@",[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"0.5 hr Price"]] atIndex:i];
                [arrayPrice addObject:[NSString stringWithFormat:@"0.5 hr :£%@",[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"0.5 hr Price"]]];
            }
            //[NSString stringWithFormat:@"£%@",[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"0.5 hr Price"]]
            
        }
        if(i==1)
        {
            if([[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"1 hr Price"]isEqualToString:@"0"])
            {}
            else
            {
                [arrayPrice addObject:[NSString stringWithFormat:@"1 hr :£%@",[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"1 hr Price"]]];
            }
            
        }
        if(i==2)
        {
            if([[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"2 hr Price"]isEqualToString:@"0"])
            {}
            else
            {
                [arrayPrice addObject:[NSString stringWithFormat:@"2 hrs :£%@",[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"2 hr Price"]]];
            }
            
        }
        if(i==3)
        {
            if([[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"3 hr Price"]isEqualToString:@"0"])
            {}
            else
            {
                [arrayPrice addObject:[NSString stringWithFormat:@"3 hrs :£%@",[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"3 hr Price"]]];
            }
            
        }
        if(i==4)
        {
            if([[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"4 hr Price"]isEqualToString:@"0"])
            {}
            else
            {
                [arrayPrice addObject:[NSString stringWithFormat:@"4 hrs :£%@",[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"4 hr Price"]]];
            }
            
        }
        if(i==5)
        {
            if([[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"5 hr Price"]isEqualToString:@"0"])
            {}
            else
            {
                [arrayPrice addObject:[NSString stringWithFormat:@"5 hrs :£%@",[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"5 hr Price"]]];
            }
            
        }
        if(i==6)
        {
            if([[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"6 hr Price"]isEqualToString:@"0"])
            {}
            else
            {
                [arrayPrice addObject:[NSString stringWithFormat:@"6 hrs :£%@",[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"6 hr Price"]]];
            }
            
        }
        if(i==7)
        {
            if([[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"7 hr Price"]isEqualToString:@"0"])
            {}
            else
            {
                [arrayPrice addObject:[NSString stringWithFormat:@"7 hrs :£%@",[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"7 hr Price"]]];
            }
            
        }
        if(i==8)
        {
            if([[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"8 hr Price"]isEqualToString:@"0"])
            {}
            else
            {
                [arrayPrice addObject:[NSString stringWithFormat:@"8 hrs :£%@",[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"8 hr Price"]]];
            }
            
        }
        if(i==9)
        {
            if([[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"9 hr Price"]isEqualToString:@"0"])
            {}
            else
            {
                [arrayPrice addObject:[NSString stringWithFormat:@"9 hrs :£%@",[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"9 hr Price"]]];
            }
            
        }
        if(i==10)
        {
            if([[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"12 hr Price"]isEqualToString:@"0"])
            {}
            else
            {
                [arrayPrice addObject:[NSString stringWithFormat:@"12 hrs :£%@",[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"12 hr Price"]]];
            }
            
        }
        if(i==11)
        {
            if([[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"24 hr Price"]isEqualToString:@"0"])
            {}
            else
            {
                [arrayPrice addObject:[NSString stringWithFormat:@"24 hrs :£%@",[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"24 hr Price"]]];
                
            }
            
        }
        if(i==12)
        {
            if([[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"1 wk Price"]isEqualToString:@"0"])
            {}
            else
            {
                [arrayPrice addObject:[NSString stringWithFormat:@"1 Week :£%@",[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"1 wk Price"]]];
            }
            
        }
        
    }
    
    
    NSLog(@"array price%@",arrayPrice);
    [[NSUserDefaults standardUserDefaults]setObject:arrayPrice forKey:@"arrayPrice"];
    [[NSUserDefaults standardUserDefaults]setObject:[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"Distance From Station"] forKey:@"DistanceFromStation"];
    [[NSUserDefaults standardUserDefaults]setObject:[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"Carpark Image"] forKey:@"CarparkImage"];
    if([[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"Available Spaces"]isEqualToString:@"0"])
    {
        
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"NA/%@",[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"Capacity"]] forKey:@"Capacity"];
        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@/%@",[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"Available Spaces"],[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"Capacity"]] forKey:@"Capacity"];
        
    }
    
    ;
    [[NSUserDefaults standardUserDefaults]setObject:[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"Price"] forKey:@"Price"];
    [[NSUserDefaults standardUserDefaults]setObject:[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"Postcode"] forKey:@"Postcode"];
    [[NSUserDefaults standardUserDefaults]setObject:[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"DisabledCapacity"] forKey:@"DisabledCapacity"];
    [[NSUserDefaults standardUserDefaults]setObject:[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"Name"] forKey:@"ParkingName"];
    NSString *payment=[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"Payments"];
    
    payment = [payment stringByReplacingOccurrencesOfString:@"/"
                                                 withString:@","];
    
    [[NSUserDefaults standardUserDefaults]setObject:payment forKey:@"Payment"];
    
    
    DetailViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    obj.dictData = [self.arrayTable objectAtIndex:indexPath.row];
    //[self.navigationController pushViewController:obj animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController: obj animated:YES];
        
    });

    
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //[errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    /*  NSLog(@"didUpdateToLocation: %@", newLocation);
     CLLocation *currentLocation = newLocation;
     
     if (currentLocation != nil) {
     if (isLocation == YES) {
     
     isLocation = NO;
     
     strLong= [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
     strLat = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
     
     
     mkr= [[GMSMarker alloc]init];
     
     [mkr setPosition:CLLocationCoordinate2DMake([strLat floatValue],[strLong floatValue] )];
     
     
     
     GMSCameraPosition *camera1 = [GMSCameraPosition cameraWithLatitude:[strLat floatValue] longitude:[strLong floatValue]  zoom:14];
     
     self.GMap.camera = camera1;
     
     [mkr setMap:self.GMap];
     
     NSLog(@"%@,%@",strLat,strLong);
     }
     
     
     }*/
}




- (IBAction)funcEnableLocation:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}
- (IBAction)funcCloseLocationView:(id)sender {
    _viewLocation.hidden=YES;
}
- (IBAction)funcCallSetting:(id)sender {
    SettingViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    //[self.navigationController pushViewController:obj animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController: obj animated:YES];
        
    });

    return;
}
-(void)startSampleProcess
{
    //  [self.delegate processCompleted];
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==12)
    {
        
        UITabBarController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBar"];
        [self presentViewController:tbc animated:YES completion:nil];
        
        
    }
    if (alertView.tag == 121) {
        if (buttonIndex == 0) {
            
            isSearching = NO;
            isLabelShow=NO;
            isMapSerach=NO;
            showingAnnotations_ = NO;
            [self.GMap clear];
            
            ArrayPinData = [[NSMutableArray alloc] init];
            [ArrayPinData removeAllObjects];
            for (int i = 0; i<arrayData.count; i++) {
                
                
                NSDictionary *dict = @{@"Lat":[[[arrayData objectAtIndex:i] valueForKey:@"Coordinates"] valueForKey:@"Latitude"],@"Long":[[[arrayData objectAtIndex:i] valueForKey:@"Coordinates"] valueForKey:@"Longitude"],@"Name":[[arrayData objectAtIndex:i] valueForKey:@"Name"],@"Price":[[arrayData objectAtIndex:i] valueForKey:@"Price"]};
                
                [ArrayPinData addObject:dict];
                
                
            }
            NSDictionary *dict = @{@"Lat":@"51.4594086",@"Long":@"-0.9731692",@"Name":@"",@"Price":@""};
            [ArrayPinData addObject:dict];
            
            [self setDataOnMapView:ArrayPinData];
            
        }
    }
}


@end

