//
//  ChooseLanguageVC.h
//  Intocable
//
//  Created by Neeraj on 10/9/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseLanguageVC : UIViewController
- (IBAction)doBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *subTab1;
@property (weak, nonatomic) IBOutlet UIView *subTab2;
@property (weak, nonatomic) IBOutlet UIButton *btnEnglish;
@property (weak, nonatomic) IBOutlet UIButton *btnSpanish;
- (IBAction)doEnglish:(id)sender;
- (IBAction)doSpanish:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end
