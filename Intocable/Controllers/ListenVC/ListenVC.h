//
//  ListenVC.h
//  Intocable
//
//  Created by Neeraj on 10/6/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ListenVC : UIViewController
@property (weak, nonatomic) IBOutlet UIView *topWatch;
@property (weak, nonatomic) IBOutlet UIImageView *imgThumbnail;
@property (weak, nonatomic) IBOutlet UIView *subSound;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollPage;
@property (weak, nonatomic) IBOutlet UISlider *btnSlider;
@property (weak, nonatomic) IBOutlet UIImageView *bgTop;
@property (weak, nonatomic) IBOutlet UIButton *btnSmallSound;
@property (weak, nonatomic) IBOutlet UIButton *btnBigSound;
@property (weak, nonatomic) IBOutlet UIImageView *bgSound;
@property (weak, nonatomic) IBOutlet UILabel *lblbTitlePage;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (nonatomic, retain) AVPlayer *player;
- (IBAction)doPlay:(id)sender;
- (IBAction)doBigVolum:(id)sender;
- (IBAction)doSmallVolum:(id)sender;
- (IBAction)changeVolum:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleListen;
- (IBAction)doHome:(id)sender;
@end
