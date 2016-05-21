//
//  HomeTableViewCell.h
//  MyCity
//
//  Created by Pushpendra on 18/11/15.
//  Copyright © 2015 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *viewContentView;

@property (strong, nonatomic) IBOutlet UIView *viewCell;
@property (strong, nonatomic) IBOutlet UIImageView *imgCell;
@property (strong, nonatomic) IBOutlet UILabel *lblCell;
@property (strong, nonatomic) IBOutlet UIImageView *imgCell2;
@property (strong, nonatomic) IBOutlet UITableView *tblNoti;
@property (strong, nonatomic) IBOutlet UILabel *lblNoti;
//lblDate
@property (strong, nonatomic) IBOutlet UILabel *lblDate;

@property (strong,nonatomic)NSMutableArray *arrayTable;
- (void)setupCellWithData:(NSMutableArray *)data ;

@end
