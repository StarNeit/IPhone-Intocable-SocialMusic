//
//  MusicCell.m
//  Intocable
//
//  Created by Neeraj on 10/8/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import "MusicCell.h"

@implementation MusicCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)doPlay:(id)sender {
    [self.delegate actionClickPlayMusic:self.indexPath];
}

- (IBAction)doBuy:(id)sender {
    [self.delegate actionbuyMusic:self.indexPath];
}

-(void) initBuy
{
    int language =[[USER_DEFAULT valueForKey:@"IS_LANGUAGE"] intValue];
   
    if (language==1) {
        [self.btnBuy setTitle:BUY_ENGLISH forState:UIControlStateNormal];
    }
    else
    {
        [self.btnBuy setTitle:BUY_SPANISH forState:UIControlStateNormal];
    }

}
@end
