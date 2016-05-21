//
//  HomeTableViewCell.m
//  MyCity
//
//  Created by Pushpendra on 18/11/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "AppDelegate.h"
#import "NotificationCell.h"
#import "NotificationSummaryViewController.h"
#import "AppDelegate.h"




@implementation HomeTableViewCell

- (void)awakeFromNib {
    // Initialization code
//    UIBezierPath *maskPath;
//    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.viewContentView.bounds
//                                     byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)
//                                           cornerRadii:CGSizeMake(7.0, 7.0)];
//    
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.viewContentView.bounds;
//    maskLayer.path = maskPath.CGPath;
//    self.contentView.layer.mask = maskLayer;
   
    //self.tblNoti.estimatedRowHeight = 100;
    //self.tblNoti.rowHeight = UITableViewAutomaticDimension;
    
    
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    /*
    if(IS_IPHONE6plus)
    {
        CGRect rect=self.contentView.frame;
        rect.size.width=394;
        
        self.contentView.frame=rect;
    }else if(IS_IPHONE6)
    {
        CGRect rect=self.contentView.frame;
        rect.size.width=355;
        
        self.contentView.frame=rect;
    }else
        
    {
        CGRect rect=self.contentView.frame;
        rect.size.width=300;
        self.contentView.frame=rect;
        
    }
     */
    
    self.tblNoti.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, self.contentView.frame.size.height);
    self.tblNoti.translatesAutoresizingMaskIntoConstraints = YES;
    
    self.tblNoti.dataSource = self;
    self.tblNoti.delegate = self;
    self.lblNoti.hidden = YES;
    self.tblNoti.scrollEnabled = NO;
    
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)cornerRadii:CGSizeMake(7.0, 7.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.contentView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
  
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutIfNeeded

{
    [super layoutIfNeeded];
}

- (void)setupCellWithData:(NSMutableArray *)data
{
    self.arrayTable = [[NSMutableArray alloc] init];
    [self.arrayTable removeAllObjects];
    for (int i = 0; i<data.count; i++) {
        
        if ([[data objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
            
            [self.arrayTable addObject:[data objectAtIndex:i]];
           
            
        }
    }
    if (self.arrayTable.count == 0) {
        self.tblNoti.hidden=YES;
        self.lblNoti.text=@"No Notifications Found";
        self.lblNoti.hidden = NO;
        
    }
    else
    {
       // self.lblNoti.text=@"No Notifications Found";
         self.tblNoti.hidden=NO;
        self.lblNoti.hidden = YES;
        
    }
    [self.tblNoti reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
       NSLog(@"data is %@",[_arrayTable objectAtIndex:indexPath.row]);
    NSDictionary *dict = @{@"index":[NSString stringWithFormat:@"%ld",(long)indexPath.row],@"Values":[_arrayTable objectAtIndex:indexPath.row]};
    

   [[NSNotificationCenter defaultCenter] postNotificationName:@"navigateHome" object:dict];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    return [ self.arrayTable count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"NotificationCell";

    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NotificationCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
   // cell.txtView.text = [[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"message"];
    NSString *strAddress1 = [[[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"Values"]valueForKey:@"message"]stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *strAddress=  [strAddress1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    cell.txtView.text=strAddress;
    
   
    
    if([[[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"Values"] valueForKey:@"type"]isEqualToString:@"londontube"])
    {
    cell.lblTitle.text = @"London Tube";
    }
    
    else if([[[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"Values"] valueForKey:@"type"]isEqualToString:@"nationalrail"])
    {
        cell.lblTitle.text =[[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"Values"] valueForKey:@"title"];
    }
    else if([[[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"Values"] valueForKey:@"type"]isEqualToString:@"rdg_to_pad"])
    {
        //cell.lblTitle.text = [[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"Values"] valueForKey:@"title"];
        cell.lblTitle.text=@"National Rail";
    }
    else if([[[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"Values"] valueForKey:@"type"]isEqualToString:@"pad_to_rdg"])
    {
        //cell.lblTitle.text = [[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"Values"] valueForKey:@"title"];
         cell.lblTitle.text=@"National Rail";
    }
    else if([[[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"Values"] valueForKey:@"type"]isEqualToString:@"general"])
    {
        cell.lblTitle.text = @"General";
    }
    
    else
    {
        cell.lblTitle.text =[[[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"Values"] valueForKey:@"type"];
        
    
    }
    cell.lblDate.text = [[self.arrayTable objectAtIndex:indexPath.row] valueForKey:@"Date"];
    //[cell.txtView sizeToFit];
    
    cell.selectionStyle=NO;

    return cell;
    
}




@end
