//
//  MusicVC.h
//  Intocable
//
//  Created by Neeraj on 10/6/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface MusicVC : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imgMusic;
@property (strong, nonatomic) IBOutlet UITableView *tblMusic;
@property (strong, nonatomic) IBOutlet UIImageView *imgLoadHome;
@property (strong, nonatomic) IBOutlet UIView *subMusic;
@property (strong, nonatomic) IBOutlet UIView *viewMusic;
@property (weak, nonatomic) IBOutlet UILabel *lblMusic;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) AVPlayer *player;
@property(nonatomic,retain) NSMutableArray *_arrMusics;
@property(nonatomic,retain) NSTimer *timerPlay;
- (IBAction)doHome:(id)sender;
-(void) loadDataMusic;
@end
