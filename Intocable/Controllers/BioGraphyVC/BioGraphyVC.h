//
//  BioGraphyVC.h
//  Intocable
//
//  Created by Neeraj on 10/6/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BioGraphyVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgBio;
@property (weak, nonatomic) IBOutlet UIWebView *webBio;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleBio;
@property (weak, nonatomic) IBOutlet UITextView *tvBio;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollPage;
- (IBAction)doHome:(id)sender;

@end
