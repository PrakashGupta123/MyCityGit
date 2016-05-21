//
//  LocationHelper.m
//  MyCity
//
//  Created by Admin on 02/01/16.
//  Copyright © 2016 Syscraft. All rights reserved.
//

#import "LocationHelper.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"




@implementation LocationHelper
@synthesize strLocation,dictData;



-(void)getAddressFromLatLon:(NSString *)pdblLatitude withLongitude:(NSString *)pdblLongitude
{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //[httpclient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:30.0];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    
 
    
    [manager GET:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&sensor=true",pdblLatitude, pdblLongitude] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"%@",responseObject);
        NSDictionary *dict = responseObject;
        
        strLocation = [[[dict valueForKey:@"results"] objectAtIndex:0] valueForKey:@"formatted_address"];
        [[NSUserDefaults standardUserDefaults] setValue:strLocation forKey:@"Address"];
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"%@",error.localizedDescription);
        
    }];

    
}


-(void)getReturnString:(NSString *)strOrigin andStrDestination:(NSString *)strDist
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //[httpclient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:30.0];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSString  *ulrString;
    
    ulrString =[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&mode=driving",strOrigin, strDist];
    ulrString = [ulrString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    
    [manager GET:ulrString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"%@",responseObject);
        dictData =responseObject;
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"%@",error.localizedDescription);

    }];
    

    

    
    
}


@end
