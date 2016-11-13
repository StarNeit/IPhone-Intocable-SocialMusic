//
//  ListenVC.m
//  Intocable
//
//  Created by Neeraj on 10/6/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import "ListenVC.h"
#import "CommonHelper.h"
#import "XMLDictionary.h"
#import <MediaPlayer/MediaPlayer.h>
@interface ListenVC ()
{
    NSTimer *timer;
    BOOL isListen;
    float valueVolum;
}
@end

@implementation ListenVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [CommonHelper appDelegate].listenVC = self;
    self.navigationController.navigationBarHidden = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void) callWS
{
    [timer invalidate];
    timer = nil;
    
    if (![CommonHelper connectedInternet]) {
        [CommonHelper showAlert:ERROR_NETWORK];
        [CommonHelper hideBusyView];
        return;
    }
    
    int language =[[USER_DEFAULT valueForKey:@"IS_LANGUAGE"] intValue];
    NSURL *URL;
    if (language==1) {
        URL = [[NSURL alloc] initWithString:LINK_LISTEN_NOW_ENGLISH];
    }
    else
    {
        URL = [[NSURL alloc] initWithString:LINK_LISTEN_NOW_SPANISH];
    }
    
    NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
    NSLog(@"XML Doc %@",xmlDoc);
    self.lblbTitlePage.text = [xmlDoc objectForKey:@"_Name"];
    NSDictionary *arr = [xmlDoc objectForKey:@"Sections"];
    
    NSDictionary *section = [arr objectForKey:@"Section"];
    NSDictionary *station = [section objectForKey:@"Station"];
    self.lblTitleListen.text = [station objectForKey:@"_Title"];
    [self getImageForImageView:self.imgThumbnail imageUrl:[station objectForKey:@"_Background"]];
    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,                      sizeof (doChangeDefaultRoute), &doChangeDefaultRoute);
    
    self.player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:[station objectForKey:@"_StationURL"]]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.player currentItem]];
    
    
    //[self.player addObserver:self forKeyPath:@"status" options:0 context:nil];
    
    [CommonHelper appDelegate].isListenNow = YES;
    [CommonHelper hideBusyView];
}
- (void) playerItemDidReachEnd:(NSNotification*)notification
{
    self.player = nil;
    [self.btnPlay setImage:[UIImage imageNamed:@"ic_btn_pause.png"] forState:UIControlStateNormal];
    isListen = NO;
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation==UIInterfaceOrientationLandscapeRight) {
        [self setFrameRotated];
    }
    else{
        [self setFrameNormal];
    }
}
-(void) viewWillAppear:(BOOL)animated{
    if ([self isLandScape]) {
        [self setFrameRotated];
    }
    else{
        [self setFrameNormal];
    }
    MPMusicPlayerController *iPod = [MPMusicPlayerController iPodMusicPlayer];
    valueVolum = iPod.volume;
    self.btnSlider.value = valueVolum;
    if (![CommonHelper appDelegate].isListenNow) {
        [CommonHelper showBusyView];
        timer =[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(callWS) userInfo:nil repeats:YES];
    }
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration
{
    if (orientation==UIInterfaceOrientationLandscapeLeft || orientation==UIInterfaceOrientationLandscapeRight) {
        [self setFrameRotated];
    }
    else{
        [self setFrameNormal];
    }
}
-(void) setFrameNormal{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
    }
    else
    {
        if (!IPHONE_5) {
            //[self.scrollPage setContentSize:CGSizeMake(320,520)];
            [self.subSound setFrame:CGRectMake(0,290,320, 40)];
        }
        else
        {
            [self.scrollPage setContentSize:CGSizeMake(320,430)];
            [self.subSound setFrame:CGRectMake(0,383,320, 40)];
        }
        [self.topWatch setFrame:CGRectMake(0,0,320, 50)];
        [self.bgTop setFrame:CGRectMake(0,0,320, 50)];
        [self.imgThumbnail setFrame:CGRectMake(0,50,320, 373)];
        //[self.subSound setFrame:CGRectMake(0,383,320, 40)];
        [self.bgSound setFrame:CGRectMake(0,0,320, 40)];
        [self.btnSmallSound setFrame:CGRectMake(14,9,11, 22)];
        [self.btnBigSound setFrame:CGRectMake(286,9,26, 22)];
        [self.btnSlider setFrame:CGRectMake(31,6,252, 31)];
    }
}

-(void) setFrameRotated
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
    }
    else
    {
        if (IPHONE_5) {
            [self.topWatch setFrame:CGRectMake(0,0,250, 50)];
            [self.bgTop setFrame:CGRectMake(0,0,250, 50)];
            [self.imgThumbnail setFrame:CGRectMake(300,0,280, 170)];
            [self.subSound setFrame:CGRectMake(0,60,250, 40)];
            [self.bgSound setFrame:CGRectMake(0,0,250, 40)];
            [self.btnSmallSound setFrame:CGRectMake(10,9,11, 22)];
            [self.btnBigSound setFrame:CGRectMake(220,9,26, 22)];
            [self.btnSlider setFrame:CGRectMake(30,9,180, 22)];
            [self.scrollPage setContentSize:CGSizeMake(568,430)];
        }
        else
        {
            [self.topWatch setFrame:CGRectMake(0,0,250, 50)];
            [self.bgTop setFrame:CGRectMake(0,0,250, 50)];
            [self.imgThumbnail setFrame:CGRectMake(270,0,200, 170)];
            [self.subSound setFrame:CGRectMake(0,60,250, 40)];
            [self.bgSound setFrame:CGRectMake(0,0,250, 40)];
            [self.btnSmallSound setFrame:CGRectMake(10,9,11, 22)];
            [self.btnBigSound setFrame:CGRectMake(220,9,26, 22)];
            [self.btnSlider setFrame:CGRectMake(30,9,180, 22)];
            [self.scrollPage setContentSize:CGSizeMake(480,430)];
        }
        
        
        
    }
}

-(BOOL) isLandScape{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if ((orientation == UIInterfaceOrientationLandscapeLeft)||(orientation == UIInterfaceOrientationLandscapeRight))
    {
        return YES;
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doPlay:(id)sender {
    if (!isListen) {
        if (self.player) {
            [self.btnPlay setImage:[UIImage imageNamed:@"ic_btn_play.png"] forState:UIControlStateNormal];
            isListen = YES;
            [self.player play];
        }
        else
        {
            NSLog(@"ERROR");
        }
       
        
    }else
    {
        [self.btnPlay setImage:[UIImage imageNamed:@"ic_btn_pause.png"] forState:UIControlStateNormal];
        isListen = NO;
        [self.player pause];
    }

}
/*- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.player && [keyPath isEqualToString:@"status"]) {
        if (self.player.status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayer Failed");
            
        } else if (self.player.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            
        } else if (self.player.status == AVPlayerItemStatusUnknown) {
            NSLog(@"AVPlayer Unknown");
            
        }
    }
}*/


- (IBAction)doBigVolum:(id)sender {
    if (valueVolum >=1) {
        
    }
    else
    {
        valueVolum +=0.1;
    }
    
    self.btnSlider.value = valueVolum;
    [self.player setVolume:valueVolum];
}

- (IBAction)doSmallVolum:(id)sender {
    if (valueVolum <=0) {
        
    }
    else
    {
        valueVolum -=0.1;
    }
    
    self.btnSlider.value = valueVolum;
    [self.player setVolume:valueVolum];
}

- (IBAction)changeVolum:(id)sender {
    NSLog(@"Value %f",self.btnSlider.value);
    [self.player setVolume:self.btnSlider.value];
}

-(void) doHome:(id)sender
{
    [[CommonHelper appDelegate] goHome];
}
- (void) getImageForImageView:(UIImageView *)imageView imageUrl:(NSString *)url {
    dispatch_queue_t queue = dispatch_queue_create([url UTF8String], 0);
    __weak UIImageView *wImageView = imageView;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator startAnimating];
    indicator.hidesWhenStopped = YES;
    indicator.center = imageView.center;
    
    [imageView addSubview:indicator];
    dispatch_async(queue, ^{
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (wImageView) {
                wImageView.image = image;
                
                [indicator stopAnimating];
                indicator.hidden = YES;
            }
            
            
        });
    });
}


@end
