//
//  ALTabBarView.m
//  ALCommon
//
//  Created by Andrew Little on 10-08-17.
//  Copyright (c) 2010 Little Apps - www.myroles.ca. All rights reserved.
//

#import "ALTabBarView.h"
#import "CommonHelper.h"
#import "MusicObj.h"
@implementation ALTabBarView

@synthesize delegate;
@synthesize selectedButton;

- (void)dealloc {
    
    [selectedButton release];
    delegate = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

//Let the delegate know that a tab has been touched
-(IBAction) touchButton:(id)sender {

    if( delegate != nil && [delegate respondsToSelector:@selector(tabWasSelected:)]) {
        
        
        
        selectedButton = [((UIButton *)sender) retain];
        switch (selectedButton.tag) {
            case 0:
            {
              
                [CommonHelper appDelegate].musicVC.imgLoadHome.hidden = YES;
                [CommonHelper appDelegate].musicVC.subMusic.hidden = NO;
                [[CommonHelper appDelegate].musicVC loadDataMusic];
                [[CommonHelper appDelegate].musicVC.player pause];
                [CommonHelper appDelegate].musicVC.player = nil;
                for (int i=0;i<[CommonHelper appDelegate].musicVC._arrMusics.count;i++) {
                    MusicObj *obj = [[CommonHelper appDelegate].musicVC._arrMusics objectAtIndex:i];
                    obj.isPlay = NO;
                    
                }
                [[CommonHelper appDelegate].musicVC.tblMusic reloadData];
                [[CommonHelper appDelegate].listenVC.player pause];
                [CommonHelper appDelegate].listenVC.player =nil;
                [[CommonHelper appDelegate].listenVC.btnPlay setImage:[UIImage imageNamed:@"ic_btn_pause.png"] forState:UIControlStateNormal];
                self.btnMusic.selected = YES;
                self.btnMedia.selected = NO;
                self.btnNew.selected = NO;
                self.btnEvent.selected = NO;
                self.btnListenNow.selected = NO;
                self.btnMerchare.selected = NO;
                self.btnBio.selected = NO;
                self.btnWatchNow.selected = NO;
                self.btnReferences.selected = NO;
                self.btnMore.selected = NO;
            }
                break;
            case 1:
            {
                [[CommonHelper appDelegate].musicVC.player pause];
                [CommonHelper appDelegate].musicVC.player = nil;
                for (int i=0;i<[CommonHelper appDelegate].musicVC._arrMusics.count;i++) {
                    MusicObj *obj = [[CommonHelper appDelegate].musicVC._arrMusics objectAtIndex:i];
                    obj.isPlay = NO;
                    
                }
                [[CommonHelper appDelegate].musicVC.tblMusic reloadData];
                [[CommonHelper appDelegate].listenVC.player pause];
                [CommonHelper appDelegate].listenVC.player =nil;
                [[CommonHelper appDelegate].listenVC.btnPlay setImage:[UIImage imageNamed:@"ic_btn_pause.png"] forState:UIControlStateNormal];
                self.btnMusic.selected = NO;
                self.btnMedia.selected = YES;
                self.btnNew.selected = NO;
                self.btnEvent.selected = NO;
                self.btnListenNow.selected = NO;
                self.btnMerchare.selected = NO;
                self.btnBio.selected = NO;
                self.btnWatchNow.selected = NO;
                self.btnReferences.selected = NO;
                self.btnMore.selected = NO;
            }
                break;
            case 2:
            {
                [[CommonHelper appDelegate].musicVC.player pause];
                [CommonHelper appDelegate].musicVC.player = nil;
                for (int i=0;i<[CommonHelper appDelegate].musicVC._arrMusics.count;i++) {
                    MusicObj *obj = [[CommonHelper appDelegate].musicVC._arrMusics objectAtIndex:i];
                    obj.isPlay = NO;
                    
                }
                [[CommonHelper appDelegate].musicVC.tblMusic reloadData];
                [[CommonHelper appDelegate].listenVC.player pause];
                [CommonHelper appDelegate].listenVC.player =nil;
                [[CommonHelper appDelegate].listenVC.btnPlay setImage:[UIImage imageNamed:@"ic_btn_pause.png"] forState:UIControlStateNormal];
                self.btnMusic.selected = NO;
                self.btnMedia.selected = NO;
                self.btnNew.selected = YES;
                self.btnEvent.selected = NO;
                self.btnListenNow.selected = NO;
                self.btnMerchare.selected = NO;
                self.btnBio.selected = NO;
                self.btnWatchNow.selected = NO;
                self.btnReferences.selected = NO;
                self.btnMore.selected = NO;
            }
                break;
            case 3:
            {
                [[CommonHelper appDelegate].musicVC.player pause];
                [CommonHelper appDelegate].musicVC.player = nil;
                for (int i=0;i<[CommonHelper appDelegate].musicVC._arrMusics.count;i++) {
                    MusicObj *obj = [[CommonHelper appDelegate].musicVC._arrMusics objectAtIndex:i];
                    obj.isPlay = NO;
                    
                }
                [[CommonHelper appDelegate].musicVC.tblMusic reloadData];
                [[CommonHelper appDelegate].listenVC.player pause];
                [CommonHelper appDelegate].listenVC.player =nil;
                [[CommonHelper appDelegate].listenVC.btnPlay setImage:[UIImage imageNamed:@"ic_btn_pause.png"] forState:UIControlStateNormal];
                self.btnMusic.selected = NO;
                self.btnMedia.selected = NO;
                self.btnNew.selected = NO;
                self.btnEvent.selected = YES;
                self.btnListenNow.selected = NO;
                self.btnMerchare.selected = NO;
                self.btnBio.selected = NO;
                self.btnWatchNow.selected = NO;
                self.btnReferences.selected = NO;
                self.btnMore.selected = NO;
            }
                break;
            case 4:
            {
                [[CommonHelper appDelegate].musicVC.player pause];
                [CommonHelper appDelegate].musicVC.player = nil;
                for (int i=0;i<[CommonHelper appDelegate].musicVC._arrMusics.count;i++) {
                    MusicObj *obj = [[CommonHelper appDelegate].musicVC._arrMusics objectAtIndex:i];
                    obj.isPlay = NO;
                    
                }
                [[CommonHelper appDelegate].musicVC.tblMusic reloadData];
                
                self.btnMusic.selected = NO;
                self.btnMedia.selected = NO;
                self.btnNew.selected = NO;
                self.btnEvent.selected = NO;
                self.btnListenNow.selected = YES;
                self.btnMerchare.selected = NO;
                self.btnBio.selected = NO;
                self.btnWatchNow.selected = NO;
                self.btnReferences.selected = NO;
                self.btnMore.selected = NO;
            }
                break;
            case 5:
            {
                [[CommonHelper appDelegate].musicVC.player pause];
                [CommonHelper appDelegate].musicVC.player = nil;
                for (int i=0;i<[CommonHelper appDelegate].musicVC._arrMusics.count;i++) {
                    MusicObj *obj = [[CommonHelper appDelegate].musicVC._arrMusics objectAtIndex:i];
                    obj.isPlay = NO;
                    
                }
                [[CommonHelper appDelegate].musicVC.tblMusic reloadData];
                [[CommonHelper appDelegate].listenVC.player pause];
                [CommonHelper appDelegate].listenVC.player =nil;
                [[CommonHelper appDelegate].listenVC.btnPlay setImage:[UIImage imageNamed:@"ic_btn_pause.png"] forState:UIControlStateNormal];
                self.btnMusic.selected = NO;
                self.btnMedia.selected = NO;
                self.btnNew.selected = NO;
                self.btnEvent.selected = NO;
                self.btnListenNow.selected = NO;
                self.btnMerchare.selected = YES;
                self.btnBio.selected = NO;
                self.btnWatchNow.selected = NO;
                self.btnReferences.selected = NO;
                self.btnMore.selected = NO;
            }
                break;
            case 6:
            {
                [[CommonHelper appDelegate].musicVC.player pause];
                [CommonHelper appDelegate].musicVC.player = nil;
                for (int i=0;i<[CommonHelper appDelegate].musicVC._arrMusics.count;i++) {
                    MusicObj *obj = [[CommonHelper appDelegate].musicVC._arrMusics objectAtIndex:i];
                    obj.isPlay = NO;
                    
                }
                [[CommonHelper appDelegate].musicVC.tblMusic reloadData];
                [[CommonHelper appDelegate].listenVC.player pause];
                [CommonHelper appDelegate].listenVC.player =nil;
                [[CommonHelper appDelegate].listenVC.btnPlay setImage:[UIImage imageNamed:@"ic_btn_pause.png"] forState:UIControlStateNormal];
                self.btnMusic.selected = NO;
                self.btnMedia.selected = NO;
                self.btnNew.selected = NO;
                self.btnEvent.selected = NO;
                self.btnListenNow.selected = NO;
                self.btnMerchare.selected = NO;
                self.btnBio.selected = YES;
                self.btnWatchNow.selected = NO;
                self.btnReferences.selected = NO;
                self.btnMore.selected = NO;
            }
                break;
            case 7:
            {
                [[CommonHelper appDelegate].musicVC.player pause];
                [CommonHelper appDelegate].musicVC.player = nil;
                for (int i=0;i<[CommonHelper appDelegate].musicVC._arrMusics.count;i++) {
                    MusicObj *obj = [[CommonHelper appDelegate].musicVC._arrMusics objectAtIndex:i];
                    obj.isPlay = NO;
                    
                }
                [[CommonHelper appDelegate].musicVC.tblMusic reloadData];
                [[CommonHelper appDelegate].listenVC.player pause];
                [CommonHelper appDelegate].listenVC.player =nil;
                [[CommonHelper appDelegate].listenVC.btnPlay setImage:[UIImage imageNamed:@"ic_btn_pause.png"] forState:UIControlStateNormal];
                self.btnMusic.selected = NO;
                self.btnMedia.selected = NO;
                self.btnNew.selected = NO;
                self.btnEvent.selected = NO;
                self.btnListenNow.selected = NO;
                self.btnMerchare.selected = NO;
                self.btnBio.selected = NO;
                self.btnWatchNow.selected = YES;
                self.btnReferences.selected = NO;
                self.btnMore.selected = NO;
            }
                break;
            case 8:
            {
                [[CommonHelper appDelegate].musicVC.player pause];
                [CommonHelper appDelegate].musicVC.player = nil;
                for (int i=0;i<[CommonHelper appDelegate].musicVC._arrMusics.count;i++) {
                    MusicObj *obj = [[CommonHelper appDelegate].musicVC._arrMusics objectAtIndex:i];
                    obj.isPlay = NO;
                    
                }
                [[CommonHelper appDelegate].musicVC.tblMusic reloadData];
                [[CommonHelper appDelegate].listenVC.player pause];
                [CommonHelper appDelegate].listenVC.player =nil;
                [[CommonHelper appDelegate].listenVC.btnPlay setImage:[UIImage imageNamed:@"ic_btn_pause.png"] forState:UIControlStateNormal];
                self.btnMusic.selected = NO;
                self.btnMedia.selected = NO;
                self.btnNew.selected = NO;
                self.btnEvent.selected = NO;
                self.btnListenNow.selected = NO;
                self.btnMerchare.selected = NO;
                self.btnBio.selected = NO;
                self.btnWatchNow.selected = NO;
                self.btnReferences.selected = YES;
                self.btnMore.selected = NO;
            }
                break;
            case 9:
            {
                /*self.btnMusic.selected = NO;
                self.btnMedia.selected = NO;
                self.btnNew.selected = NO;
                self.btnEvent.selected = NO;
                self.btnListenNow.selected = NO;
                self.btnMerchare.selected = NO;
                self.btnBio.selected = NO;
                self.btnWatchNow.selected = NO;
                self.btnReferences.selected = NO;
                self.btnMore.selected = YES;*/
                [[CommonHelper appDelegate].musicVC.player pause];
                [CommonHelper appDelegate].musicVC.player = nil;
                for (int i=0;i<[CommonHelper appDelegate].musicVC._arrMusics.count;i++) {
                    MusicObj *obj = [[CommonHelper appDelegate].musicVC._arrMusics objectAtIndex:i];
                    obj.isPlay = NO;
                    
                }
                [[CommonHelper appDelegate].musicVC.tblMusic reloadData];
                [[CommonHelper appDelegate].listenVC.player pause];
                [CommonHelper appDelegate].listenVC.player =nil;
                
                [[CommonHelper appDelegate].listenVC.btnPlay setImage:[UIImage imageNamed:@"ic_btn_pause.png"] forState:UIControlStateNormal];
                [[CommonHelper appDelegate] goHome];
            }
                break;
            default:
                break;
        }
        if (selectedButton.tag==9) {
            [delegate tabWasSelected:0];
        }
        else{
            [delegate tabWasSelected:selectedButton.tag];
        }
        
    }
}

-(void) readLanguage
{
    int language =[[USER_DEFAULT valueForKey:@"IS_LANGUAGE"] intValue];
    NSLog(@"----->%d",language);
    switch (language) {
        case 1:
        {
            self.lblMusic.text = TXT_MUSIC_ENGLISH;
            self.lblMedia.text = TXT_MEDIA_ENGLISH;
            self.lblNews.text = TXT_NEWS_ENGLISH;
            self.lblEvents.text = TXT_EVENT_ENGLISH;
            self.lblListenNow.text = TXT_LISTENNOW_ENGLISH;
            self.lblMecharse.text = TXT_MERCHANDISE_ENGLISH;
            self.lblBio.text = TXT_BIO_ENGLISH;
            self.lblWatchNow.text = TXT_WATCHNOW_ENGLISH;
            self.lblPreferences.text = TXT_PREFEREECES_ENGLISH;
            self.lblMore.text = TXT_MORE_ENGLISH;
            
        }
            break;
        case 0:
        {
            self.lblMusic.text = TXT_MUSIC_ESPANOL;
            self.lblMedia.text = TXT_MEDIA_ESPANOL;
            self.lblNews.text = TXT_NEWS_ESPANOL;
            self.lblEvents.text = TXT_EVENT_ESPANOL;
            self.lblListenNow.text = TXT_LISTENNOW_ESPANOL;
            self.lblMecharse.text = TXT_MERCHANDISE_ESPANOL;
            self.lblBio.text = TXT_BIO_ESPANOL;
            self.lblWatchNow.text = TXT_WATCHNOW_ESPANOL;
            self.lblPreferences.text = TXT_PREFEREECES_ESPANOL;
            self.lblMore.text = TXT_MORE_ESPANOL;
        }
            break;
        default:
            break;
    }
}
-(void) initTabbar
{
    [self.scrollTabbar setContentSize:CGSizeMake(self.scrollTabbar.frame.size.width*3,self.scrollTabbar.frame.size.height)];
    [self.tab1 setFrame:CGRectMake(0,0, 320, 85)];
    [self.tab2 setFrame:CGRectMake(320,0, 320, 85)];
    [self.tab3 setFrame:CGRectMake(640,0, 320, 85)];
    [self.scrollTabbar addSubview:self.tab1];
    [self.scrollTabbar addSubview:self.tab2];
    [self.scrollTabbar addSubview:self.tab3];
    
    [self readLanguage];
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int  modeScroll =  (int)(self.scrollTabbar.contentOffset.x / self.scrollTabbar.frame.size.width);
    
    self.pageControl.currentPage = modeScroll;
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
