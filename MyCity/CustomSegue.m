//
//  CustomSegue.m
//  MyCity
//
//  Created by Admin on 19/03/16.
//  Copyright © 2016 Syscraft. All rights reserved.
//

#import "CustomSegue.h"
#import "QuartzCore/QuartzCore.h"

@implementation CustomSegue
-(void)perform {
    
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    
    CATransition* transition = [CATransition animation];
    transition.duration = .30;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionPush; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromRight; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    
    
    
    [sourceViewController.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [sourceViewController.navigationController pushViewController:destinationController animated:NO];
    //[UIView commitAnimations];
    
    
}

@end
