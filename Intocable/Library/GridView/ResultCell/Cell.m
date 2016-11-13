//
//  Cell.m
//  naivegrid
//
//  Created by Apirom Na Nakorn on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Cell.h"
#import <QuartzCore/QuartzCore.h> 

@implementation Cell


@synthesize thumbnail;
@synthesize label;


- (id)init {
	
    if (self = [super init]) {
		
        self.frame = CGRectMake(0, 0, 105, 105);
		if (IS_IPAD) {
            [[NSBundle mainBundle] loadNibNamed:@"Cell_iPad" owner:self options:nil];
        }
        else
        {
            [[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil];
        }
		self.thumbnail.layer.cornerRadius = 5;
        self.thumbnail.layer.masksToBounds = YES;
		self.view.backgroundColor =[UIColor clearColor];
        [self addSubview:self.view];
		
		
	}
	
    return self;
	
}





@end
