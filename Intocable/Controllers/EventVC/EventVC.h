//
//  EventVC.h
//  Intocable
//
//  Created by Neeraj on 10/6/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventVC : UIViewController
- (IBAction)doHome:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tblEvents;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end
