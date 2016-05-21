//
//  LocationHelper.h
//  MyCity
//
//  Created by Admin on 02/01/16.
//  Copyright © 2016 Syscraft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationHelper : NSObject
@property (strong,nonatomic)NSString *strLocation;
@property (strong,nonatomic)NSDictionary *dictData;


-(void)getAddressFromLatLon:(NSString *)pdblLatitude withLongitude:(NSString *)pdblLongitude;

-(void)getReturnString:(NSString *)strOrigin andStrDestination:(NSString *)strDist;

@end
