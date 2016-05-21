//
//  SettingViewController.m
//  MyCity
//
//  Created by Admin on 23/11/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import "SettingViewController.h"
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import "UIView+Toast.h"
#import "AFHTTPRequestOperationManager.h"



@interface SettingViewController ()<MFMailComposeViewControllerDelegate>
{
    NSString *strMailId;
    
}
@end

@implementation SettingViewController
- (UIStatusBarStyle) preferredStatusBarStyle

{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    Val=@"1";
    

   
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    _lblAppVersion.text = [NSString stringWithFormat:@"%@(%@)",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[infoDictionary objectForKey:@"CFBundleVersion"]];

    _viewSetting.layer.cornerRadius=5.0;
    _viewSetting.layer.masksToBounds=YES;
    _webViewHTML.layer.cornerRadius=5.0;
    _webViewHTML.layer.masksToBounds=YES;
   // [self WebserviceGetMailId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Webservice for Get Contact Email Id:-
-(void)WebserviceGetMailId
{
    //[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowMBProgressBar object:@"Loading..."];
    [[AppDelegate appDelegate] showLoadingAlert:self.view];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager.requestSerializer setTimeoutInterval:30.0];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"syscraft" password:@"sis*123"];
    //[httpclient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    http://183.182.87.171/svn/mycityapp/mycityapp/apis/DV/users/email_to
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSString *path=[NSString stringWithFormat:baseUrl@"/users/email_to"];
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
         [[AppDelegate appDelegate] removeLoadingAlert:self.view];
     //   [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
        NSArray *array = responseObject;
        NSDictionary *dict = [array objectAtIndex:0];
        if([[dict valueForKey:@"error"]isEqualToString:@""]){
           
            strMailId= [dict valueForKey:@"data"];
            if ([MFMailComposeViewController canSendMail]) {
                NSString *emailTitle = @"Hello Femo Mail";
                NSString *messageBody = @"Hey, check this out! Mycity app.";
                NSArray *toRecipents = [NSArray arrayWithObject:strMailId];
                
                MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
                mc.mailComposeDelegate = self;
                [mc setSubject:emailTitle];
                [mc setMessageBody:messageBody isHTML:NO];
                [mc setToRecipients:toRecipents];
                [self presentViewController:mc animated:YES completion:nil];
            }


             }
        else
        {
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
     //   [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
         [[AppDelegate appDelegate] removeLoadingAlert:self.view];

        
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

- (IBAction)funcBack:(id)sender {
    if([Val isEqualToString:@"0"])
    {
        
        _webViewHTML.hidden=YES;
        _lblTitle.text=@"Settings";
        Val=@"1";
        
    }
    else
    {
    [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)funcLocation:(id)sender {
}

- (IBAction)funcNotification:(id)sender {
    NSString *iOSversion = [[UIDevice currentDevice] systemVersion];
    NSString *prefix = [[iOSversion componentsSeparatedByString:@"."] firstObject];
    float versionVal = [prefix floatValue];
    
    
    if (versionVal >= 8)
    {
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone)
        {
            
            NSLog(@" Push Notification ON");
        }
        else
        {
            
            NSString *msg = @"Please press setting  to  enable Push Notification";
            UIAlertView *alert_push = [[UIAlertView alloc] initWithTitle:@"Push Notification Service Disable" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Setting", nil];
            alert_push.tag = 2;
            [alert_push show];
            
            NSLog(@" Push Notification OFF");
            
        }
        
    }
    else
    {
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (types != UIRemoteNotificationTypeNone)
            
        {
            NSLog(@" Push Notification ON");
            
        }
        else
        {
            NSString *msg = @"Please press setting  to  enable Push Notification";
            UIAlertView *alert_push = [[UIAlertView alloc] initWithTitle:@"Push Notification Service Disable" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Setting", nil];
            alert_push.tag = 2;
            [alert_push show];
            
            NSLog(@" Push Notification OFF");
        }
        
    }
}

- (IBAction)funcNotificationSound:(id)sender {
}

- (IBAction)funcOpenMail:(id)sender {
     //[_imgSet setImage:[UIImage imageNamed:@"imgSetting1" ]];
    /*if([Val isEqualToString:@"0"])
    {
        
     _webViewHTML.hidden=YES;
        _lblTitle.text=@"Settings";
        Val=@"1";

    }
    else
    {*/
    if([AppDelegate appDelegate].isCheckConnection){
        
               [self.view makeToast:NSLocalizedString(@"Internet Connection Not Available Please Try Again", nil) duration:3.0 position:CSToastPositionCenter];
     //   [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMBProgressBar object:Nil];
        
    }
    else
    {
        if(strMailId.length>0)
        {
            if ([MFMailComposeViewController canSendMail]) {
                NSString *emailTitle = @"Hello Femo Mail";
                NSString *messageBody = @"Hey, check this out! Mycity app.";
                NSArray *toRecipents = [NSArray arrayWithObject:strMailId];
                
                MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
                mc.mailComposeDelegate = self;
                [mc setSubject:emailTitle];
                [mc setMessageBody:messageBody isHTML:NO];
                [mc setToRecipients:toRecipents];
                [self presentViewController:mc animated:YES completion:nil];
            }

        
        }
        else
        {
        [self WebserviceGetMailId];
        }
       
    
    }
}



- (IBAction)funcOpenWebView:(id)sender {
    
    Val=@"0";NSString *urlAddress;
    _webViewHTML.hidden=NO;
    NSURL *url = [NSURL URLWithString:@""];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_webViewHTML loadRequest:requestObj];
    //[_imgSet setImage:[UIImage imageNamed:@"imgWv" ]];
    if([sender tag]==0)
    {
    _lblTitle.text=@"Privacy Policy";
        urlAddress = @"http://183.182.87.171/svn/mycityapp/mycityapp/apis/DV/Webviews/show_privacy_policy";
    
    }
    else if ([sender tag]==1)
        
    {
    
    _lblTitle.text=@"Acknowledgement";
        urlAddress = @"http://183.182.87.171/svn/mycityapp/mycityapp/apis/DV/Webviews/show_acknowledgement";
       
    }
    else if ([sender tag]==2)
        
    {
        
        _lblTitle.text=@"T & C's";
        urlAddress = @"http://183.182.87.171/svn/mycityapp/mycityapp/apis/DV/Webviews/show_tnc";

    }
    
    url = [NSURL URLWithString:urlAddress];
   requestObj = [NSURLRequest requestWithURL:url];
    [_webViewHTML loadRequest:requestObj];
}

#pragma mark Delegate Method of MFMailcomposer
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
