//
//  WatchNowVC.h
//  Intocable
//
//  Created by Neeraj on 10/6/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WatchNowVC : UIViewController
@property (weak, nonatomic) IBOutlet UIView *topWatch;
@property (weak, nonatomic) IBOutlet UIImageView *imgThumbnail;
@property (weak, nonatomic) IBOutlet UIView *subSound;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollPage;
@property (weak, nonatomic) IBOutlet UISlider *btnSlider;
@property (weak, nonatomic) IBOutlet UIImageView *bgTop;
@property (weak, nonatomic) IBOutlet UIButton *btnSmallSound;
@property (weak, nonatomic) IBOutlet UIButton *btnBigSound;
@property (weak, nonatomic) IBOutlet UIImageView *bgSound;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)doHome:(id)sender;

@end
