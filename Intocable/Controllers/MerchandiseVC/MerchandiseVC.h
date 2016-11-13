//
//  MerchandiseVC.h
//  Intocable
//
//  Created by Neeraj on 10/6/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridView.h"
@interface MerchandiseVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgMerchandise;
@property (weak, nonatomic) IBOutlet UIGridView *tblMerchares;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
- (IBAction)doHome:(id)sender;

@end
