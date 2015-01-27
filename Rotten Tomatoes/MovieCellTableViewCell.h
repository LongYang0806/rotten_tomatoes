//
//  MovieCellTableViewCell.h
//  Rotten Tomatoes
//
//  Created by Long Yang on 1/23/15.
//  Copyright (c) 2015 Grace Wu/Long Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleCell;
@property (weak, nonatomic) IBOutlet UILabel *bodyCell;
@property (weak, nonatomic) IBOutlet UIImageView *imageCell;

@end
