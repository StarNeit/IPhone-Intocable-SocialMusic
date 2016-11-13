//
//  AboutVC.h
//  Intocable
//
//  Created by Neeraj on 10/10/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutVC : UIViewController
- (IBAction)doBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *subAbout;
@property (weak, nonatomic) IBOutlet UITextView *tvText;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end
