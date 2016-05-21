//
//  LondonTubeCell.m
//  MyCity
//
//  Created by Admin on 21/11/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import "LondonTubeCell.h"

#import "UIView+Borders.h"
@implementation LondonTubeCell

- (void)awakeFromNib {
    // Initialization code
    
_viewBorder.layer.borderWidth=0.6;
    
    _viewBorder.layer.borderColor=[UIColor colorWithRed:27/255.0 green:90/255.0 blue:123/255.0 alpha:1.0].CGColor;
    
   
    
   
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
