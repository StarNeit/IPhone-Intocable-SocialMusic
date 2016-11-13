//
//  NewCell.h
//  Intocable
//
//  Created by Neeraj on 10/8/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@property (weak, nonatomic) IBOutlet UITextView *tvBody;
-(void) initCell;
@end
