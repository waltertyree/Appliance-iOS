//
//  PostCell.h
//  Appliance
//
//  Created by Felipe on 8/18/12.
//  Copyright (c) 2012 Felipe Laso Marsetti. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PostCellIdentifier  @"PostCell"

@interface PostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end
