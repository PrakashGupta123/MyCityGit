//
//  NotificationSummaryViewController.m
//  MyCity
//
//  Created by Admin on 22/12/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import "NotificationSummaryViewController.h"
//#import "NotiDetailViewController.h"
#import "AppDelegate.h"
@interface NotificationSummaryViewController ()

@end

@implementation NotificationSummaryViewController
- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}
- (UIStatusBarStyle) preferredStatusBarStyle

{
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     
    
    NSLog(@"Dictionary is %@",_dictDes);
    _lblNotHeading.text=[_dictDes valueForKey:@"type"];
    _lblDescription.text=[_dictDes valueForKey:@"message"];
    NSString *str = [[_dictDes valueForKey:@"message"]stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(296 , FLT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor blackColor],  NSParagraphStyleAttributeName : style,NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
    CGSize requiredSize = rect.size;
    if(IS_IPHONE5||IS_IPHONE4)
    {
        _lblDescription.frame = CGRectMake(_lblDescription.frame.origin.x, _lblDescription.frame.origin.y, _viewNotSummary.frame.size.width-30, requiredSize.height);
        
        requiredSize.height=requiredSize.height+40;
        _viewNotSummary.frame = CGRectMake(_viewNotSummary.frame.origin.x, _viewNotSummary.frame.origin.y, _viewNotSummary.frame.size.width, requiredSize.height);
        
    }
    if(IS_IPHONE6)
    {
        
        
        _lblDescription.frame = CGRectMake(_lblDescription.frame.origin.x, _lblDescription.frame.origin.y, _viewNotSummary.frame.size.width-20, requiredSize.height);
        requiredSize.height=requiredSize.height+40;
        
        _viewNotSummary.frame = CGRectMake(_viewNotSummary.frame.origin.x, _viewNotSummary.frame.origin.y, _viewNotSummary.frame.size.width+55, requiredSize.height);
    }
    if(IS_IPHONE6plus)
    {
        
        _lblDescription.frame = CGRectMake(_lblDescription.frame.origin.x, _lblDescription.frame.origin.y, _viewNotSummary.frame.size.width, requiredSize.height);
        requiredSize.height=requiredSize.height+40;
        
        _viewNotSummary.frame = CGRectMake(_viewNotSummary.frame.origin.x, _viewNotSummary.frame.origin.y, _viewNotSummary.frame.size.width+95, requiredSize.height);
    }
    _lblDescription.numberOfLines = 0;
    _lblDescription.lineBreakMode = NSLineBreakByWordWrapping;
    _lblDescription.text= str;
    _lblDescription.translatesAutoresizingMaskIntoConstraints = YES;
   _viewNotSummary.translatesAutoresizingMaskIntoConstraints = YES;
  
   
//_lblDescription.numberOfLines = 0;
//_lblDescription.lineBreakMode = NSLineBreakByWordWrapping;
//_lblDescription.text= str;
//_lblDescription.translatesAutoresizingMaskIntoConstraints = YES;

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

- (IBAction)funcNotAll:(id)sender {
//    NotiDetailViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"NotiDetailViewController"];
//    [self.navigationController pushViewController:obj animated:YES];
    
}

- (IBAction)funcBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
