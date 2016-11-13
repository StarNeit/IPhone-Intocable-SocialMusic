//
//  NewVC.h
//  Intocable
//
//  Created by Neeraj on 10/6/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewVC : UIViewController
- (IBAction)doNews:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgTab;
@property (weak, nonatomic) IBOutlet UIButton *btnNews;
- (IBAction)doFacebook:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnTweet;
@property (weak, nonatomic) IBOutlet UITableView *tblNews;
- (IBAction)doTweet:(id)sender;
- (IBAction)doHome:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end
