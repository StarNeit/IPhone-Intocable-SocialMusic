//
//  AppDelegate.h
//  Intocable
//
//  Created by Neeraj on 10/6/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALTabBarController.h"
#import "MusicVC.h"
#import "EventDetailVC.h"
#import "ListenVC.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,ALTabBarDelegate>
{
    UIWindow *window;
    
    ALTabBarController *tabBarController;
}


@property (nonatomic, retain) IBOutlet ALTabBarController *tabBarController;
@property(nonatomic,retain) ALTabBarView *alertTabbar;
@property(nonatomic,retain) UINavigationController *nav;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property(nonatomic,retain) UINavigationController *navEventDetail;
@property(nonatomic,retain) MusicVC *musicVC;
@property(nonatomic,retain) ListenVC *listenVC;
@property(nonatomic,assign) BOOL isLoadFirstMusic;

@property(nonatomic,assign) BOOL isMusic;
@property(nonatomic,assign) BOOL isMedia;
@property(nonatomic,assign) BOOL isNews;
@property(nonatomic,assign) BOOL isEvents;
@property(nonatomic,assign) BOOL isListenNow;
@property(nonatomic,assign) BOOL isProduct;
@property(nonatomic,assign) BOOL isBio;
@property(nonatomic,assign) BOOL isWatchNow;
@property(nonatomic,retain) NSString *strToken;
-(void) initLanguage;
-(void) initTabbar;
-(void) goHome;


@end
