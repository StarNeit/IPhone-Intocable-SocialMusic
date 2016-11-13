//
//  NotificationVC.h
//  Intocable
//
//  Created by Neeraj on 10/10/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationVC : UIViewController
- (IBAction)doBack:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *btnSwitch;
- (IBAction)doSwitch:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblNotification;

@end
