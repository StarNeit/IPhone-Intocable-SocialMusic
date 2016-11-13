//
//  MusicVC.m
//  Intocable
//
//  Created by Neeraj on 10/6/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import "MusicVC.h"
#import "MusicCell.h"
#import "CommonHelper.h"
#import "MusicObj.h"
#import "XMLDictionary.h"
#import "SVProgressHUD.h"
#import <AVFoundation/AVFoundation.h>
@interface MusicVC ()<MusicCellDelegate>
{
    
    NSTimer *timer;
}

@end

@implementation MusicVC

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
   
    [CommonHelper appDelegate].musicVC = self;
    self.subMusic.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    [super viewDidLoad];
     self._arrMusics =[[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillAppear:(BOOL)animated{
    if ([self isLandScape]) {
        [self setFrameRotated];
    }
    else{
        [self setFrameNormal];
    }
    
   
}
-(void) loadDataMusic
{
    if (![CommonHelper appDelegate].isMusic) {
        [CommonHelper showBusyView];
        if (![CommonHelper connectedInternet]) {
            [CommonHelper showAlert:ERROR_NETWORK];
            [SVProgressHUD dismiss];
            return;
        }
        self.indicator.hidden = YES;
        [CommonHelper appDelegate].isLoadFirstMusic = YES;
         timer =[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(callWS) userInfo:nil repeats:YES];
       // [self callWS];
    }
    else
    {
        NSLog(@"Co rui");
    }
    
    
    
}

-(void) callWS
{
    [timer invalidate];
    timer = nil;
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    self.indicator.hidden = NO;
    
    int language =[[USER_DEFAULT valueForKey:@"IS_LANGUAGE"] intValue];
    NSURL *URL;
    if (language==1) {
        URL = [[NSURL alloc] initWithString:LINK_MUSIC_ENGLISH];
    }
    else
    {
        URL = [[NSURL alloc] initWithString:LINK_MUSIC_SPANISH];
    }
    
    NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
    if (xmlString.length ==0) {
        NSLog(@"NILL");
        [SVProgressHUD dismiss];
        return;
    }
    self.lblMusic.text = [xmlDoc objectForKey:@"_Name"];
    
    NSString *linkBackGroud =[xmlDoc objectForKey:@"_Background"];
    NSDictionary *arr = [xmlDoc objectForKey:@"Sections"];
    NSLog(@"Arr %@",xmlDoc);
    NSDictionary *section = [arr objectForKey:@"Section"];
    NSDictionary *song = [section objectForKey:@"Songs"];
    NSArray *songs = [song objectForKey:@"Song"];
    if (songs.count >0) {
        
        for (NSDictionary *dic in songs) {
            MusicObj *obj = [[MusicObj alloc] init];
            obj.artist = [dic objectForKey:@"Artist"];
            obj.title = [dic objectForKey:@"Title"];
            obj.linkBuy = [dic objectForKey:@"_Buy"];
            obj.canBuy = [[dic objectForKey:@"_CanBuy"]boolValue ];
            obj.canPlay = [[dic objectForKey:@"_CanPlay"] boolValue];
            obj.idMusic = [dic objectForKey:@"_ID"];
            obj.linkMusic = [dic objectForKey:@"_Play"];
            
            
            [self._arrMusics addObject:obj];
            [self.tblMusic reloadData];
        }
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:linkBackGroud]];
            if ( data == nil )
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                // WARNING: is the cell still using the same data by this point??
                self.imgMusic.image = [UIImage imageWithData: data];
                [self.indicator stopAnimating];
                self.indicator.hidden = YES;
            });
            
        });
        [CommonHelper appDelegate].isMusic = YES;
        [SVProgressHUD dismiss];
        
    }
    else
    {
        [SVProgressHUD dismiss];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation==UIInterfaceOrientationLandscapeRight) {
        [self setFrameRotated];
    }
    else{
        [self setFrameNormal];
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
        [self.imgMusic setFrame:CGRectMake(0,0,768,325)];
        [self.tblMusic setFrame:CGRectMake(0,326,768,547)];
    }
    else
    {
        [self.imgMusic setFrame:CGRectMake(0,0,320,175)];
        if (IPHONE_5) {
            [self.tblMusic setFrame:CGRectMake(0, 175, 320, 242)];
        }
        else
        {
            [self.tblMusic setFrame:CGRectMake(0, 175, 320, 154)];
        }
        self.imgLoadHome.image =[UIImage imageNamed:@"bg_home_568.png"];
        
    }
     [self.tblMusic reloadData];
}

-(void) setFrameRotated
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        [self.imgMusic setFrame:CGRectMake(0,0,500,325)];
        [self.tblMusic setFrame:CGRectMake(504,0,500,647)];
    }
    else
    {
        [self.imgMusic setFrame:CGRectMake(0,0,200,150)];
        
        [self.tblMusic setFrame:CGRectMake(210, 0, 270, 169)];
        self.imgLoadHome.image =[UIImage imageNamed:@"bg_home_landscape.png"];
        
    }
    [self.tblMusic reloadData];
}

-(BOOL) isLandScape{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if ((orientation == UIInterfaceOrientationLandscapeLeft)||(orientation == UIInterfaceOrientationLandscapeRight))
    {
        return YES;
    }
    return NO;
}
#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self._arrMusics.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicCell *currentCell=(MusicCell *)[self.tblMusic dequeueReusableCellWithIdentifier:@"MusicCell"];
    if (currentCell == nil)
    {
        
        if (IS_IPAD) {
            currentCell = [[[NSBundle mainBundle] loadNibNamed:@"MusicCell_iPad" owner:self options:nil] objectAtIndex:0];
        }
        else
        {
            if ([self isLandScape]) {
                currentCell = [[[NSBundle mainBundle] loadNibNamed:@"MusicCellLanScand" owner:self options:nil] objectAtIndex:0];
            }
            else
            {
                currentCell = [[[NSBundle mainBundle] loadNibNamed:@"MusicCell" owner:self options:nil] objectAtIndex:0];
            }
            
        }
        
        
        
    }
    currentCell.indexPath = indexPath.row;
    currentCell.delegate = self;
    MusicObj *obj = [self._arrMusics objectAtIndex:indexPath.row];
    currentCell.lblTitle.text = obj.title;
    if (obj.isPlay) {
        [currentCell.btnPlay setImage:[UIImage imageNamed:@"ic_btn_play.png"] forState:UIControlStateNormal];
    }else
    {
        [currentCell.btnPlay setImage:[UIImage imageNamed:@"ic_btn_pause.png"] forState:UIControlStateNormal];
    }
    [currentCell initBuy];
    currentCell.backgroundColor =[UIColor clearColor];
    return currentCell;
}

#pragma MusicCellDelegate
-(void) actionClickPlayMusic:(int)index
{
    
    MusicObj *obj = [self._arrMusics objectAtIndex:index];
    if (!obj.avPlayer) {
        UInt32 doChangeDefaultRoute = 1;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,                      sizeof (doChangeDefaultRoute), &doChangeDefaultRoute);
        
        obj.avPlayer = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:obj.linkMusic]];
    }
   
    for (int i=0;i<self._arrMusics.count;i++) {
         MusicObj *obj = [self._arrMusics objectAtIndex:i];
        if (i==index) {
            if (obj.isPlay) {
                obj.isPlay = NO;
                [self.player pause];
            }
            else
            {
                //if (self.player != nil)
                    //[self.player removeObserver:self forKeyPath:@"status"];
                self.player = obj.avPlayer;
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(playerItemDidReachEnd:)
                                                             name:AVPlayerItemDidPlayToEndTimeNotification
                                                           object:[self.player currentItem]];
                
                //[self.player addObserver:self forKeyPath:@"status" options:0 context:nil];
                [self.player play];

                obj.isPlay = YES;
            }
            
       }
        else
        {
             obj.isPlay = NO;
            obj.avPlayer = nil;
        }
    }
   
    [self.tblMusic reloadData];
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

- (void) playerItemDidReachEnd:(NSNotification*)notification
{
    self.player = nil;
    
}
-(void) actionbuyMusic:(int)index
{
    MusicObj *obj = [self._arrMusics objectAtIndex:index];
    [[UIApplication sharedApplication]
     openURL:[NSURL URLWithString:obj.linkBuy]];
}
- (IBAction)doHome:(id)sender {
    [[CommonHelper appDelegate] goHome];
}
@end
