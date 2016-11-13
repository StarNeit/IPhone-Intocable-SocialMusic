//
//  PreferenceVC.h
//  Intocable
//
//  Created by Neeraj on 10/6/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreferenceVC : UIViewController
@property (weak, nonatomic) IBOutlet UIView *subTab1;
@property (weak, nonatomic) IBOutlet UIView *subTab2;
- (IBAction)doHome:(id)sender;
- (IBAction)doLanguage:(id)sender;
- (IBAction)doNotifications:(id)sender;
- (IBAction)doUpdates:(id)sender;
- (IBAction)doAbout:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblRefre;
@property (strong, nonatomic) IBOutlet UIButton *btnLabguage;
@property (strong, nonatomic) IBOutlet UIButton *btnNotification;
@property (strong, nonatomic) IBOutlet UIButton *btnUpdate;
@property (strong, nonatomic) IBOutlet UIButton *btnAbout;

@end
