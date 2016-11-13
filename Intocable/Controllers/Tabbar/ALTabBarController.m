//
//  ALTabBarController.m
//  ALCommon
//
//  Created by Andrew Little on 10-08-17.
//  Copyright (c) 2010 Little Apps - www.myroles.ca. All rights reserved.
//

#import "ALTabBarController.h"
#import "CommonHelper.h"

@implementation ALTabBarController

@synthesize customTabBarView;

- (void)dealloc {
    
    [customTabBarView release];
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self hideExistingTabBar];
    [CommonHelper appDelegate].tabBarController = self;
    
    NSArray *nibObjects;
    if (IS_IPAD) {
        nibObjects  = [[NSBundle mainBundle] loadNibNamed:@"TabBarView_iPad" owner:self options:nil];
    }
    else
    {
        nibObjects  = [[NSBundle mainBundle] loadNibNamed:@"TabBarView" owner:self options:nil];
    }
    self.customTabBarView = [nibObjects objectAtIndex:0];
    self.customTabBarView.delegate = self;
    [self setFrameTab];
    [self.customTabBarView initTabbar];
    [CommonHelper appDelegate].alertTabbar =self.customTabBarView;
    [self.view addSubview:self.customTabBarView];
}

//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    [self setFrameTab];
//}

-(void) chooseLanguage
{
    int language =[[USER_DEFAULT valueForKey:@"IS_LANGUAGE"] intValue];
    NSLog(@"----->%d",language);
    switch (language) {
        case 1:
        {
            self.customTabBarView .lblMusic.text = TXT_MUSIC_ENGLISH;
            self.customTabBarView .lblMedia.text = TXT_MEDIA_ENGLISH;
            self.customTabBarView .lblNews.text = TXT_NEWS_ENGLISH;
            self.customTabBarView .lblEvents.text = TXT_EVENT_ENGLISH;
            self.customTabBarView .lblListenNow.text = TXT_LISTENNOW_ENGLISH;
            self.customTabBarView .lblMecharse.text = TXT_MERCHANDISE_ENGLISH;
            self.customTabBarView .lblBio.text = TXT_BIO_ENGLISH;
            self.customTabBarView .lblWatchNow.text = TXT_WATCHNOW_ENGLISH;
            self.customTabBarView .lblPreferences.text = TXT_PREFEREECES_ENGLISH;
            self.customTabBarView .lblMore.text = TXT_MORE_ENGLISH;
            
        }
            break;
        case 0:
        {
            self.customTabBarView .lblMusic.text = TXT_MUSIC_ESPANOL;
            self.customTabBarView .lblMedia.text = TXT_MEDIA_ESPANOL;
            self.customTabBarView .lblNews.text = TXT_NEWS_ESPANOL;
            self.customTabBarView .lblEvents.text = TXT_EVENT_ESPANOL;
            self.customTabBarView .lblListenNow.text = TXT_LISTENNOW_ESPANOL;
            self.customTabBarView .lblMecharse.text = TXT_MERCHANDISE_ESPANOL;
            self.customTabBarView .lblBio.text = TXT_BIO_ESPANOL;
            self.customTabBarView .lblWatchNow.text = TXT_WATCHNOW_ESPANOL;
            self.customTabBarView .lblPreferences.text = TXT_PREFEREECES_ESPANOL;
            self.customTabBarView .lblMore.text = TXT_MORE_ESPANOL;
        }
            break;
        default:
            break;
    }
}

-(void) setFrameTab
{
    if (IS_IPAD) {
        [self.customTabBarView setFrame:CGRectMake(0,self.view.frame.size.height-self.customTabBarView.frame.size.height,self.view.frame.size.width,self.customTabBarView.frame.size.height)];
    }
    else
    {
        NSLog(@"%f---%f---%f",self.view.frame.size.height-self.customTabBarView.frame.size.height,self.customTabBarView.frame.size.width,self.customTabBarView.frame.size.height);
        
        [self.customTabBarView setFrame:CGRectMake(0,self.view.frame.size.height-self.customTabBarView.frame.size.height,self.view.frame.size.width,self.customTabBarView.frame.size.height)];
    }

}
- (void)hideExistingTabBar
{
	for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
			view.hidden = YES;
			break;
		}
	}
}

#pragma mark ALTabBarDelegate

-(void)tabWasSelected:(NSInteger)index {
 
    self.selectedIndex = index;
}


@end
