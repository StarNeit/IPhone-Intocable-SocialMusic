//
//  NewCell.m
//  Intocable
//
//  Created by Neeraj on 10/8/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import "NewCell.h"

@implementation NewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) initCell
{
    self.imgThumbnail.layer.cornerRadius = 5;
    self.imgThumbnail.layer.masksToBounds = YES;

}
@end
