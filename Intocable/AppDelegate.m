//
//  AppDelegate.m
//  Intocable
//
//  Created by Neeraj on 10/6/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import "AppDelegate.h"
#import "LanguageVC.h"
#import "PlayerEventLogger.h"
#import <MediaPlayer/MediaPlayer.h>
#import <Foundation/Foundation.h>
#import <XCDYouTubeKit/XCDYouTubeKit.h>
#import <CFNetwork/CFNetwork.h>
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "JSON.h"
@implementation AppDelegate
@synthesize window,tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        // use registerUserNotificationSettings
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        // use registerForRemoteNotifications
         [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
#else
    // use registerForRemoteNotifications
     [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
#endif
   
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"IS_LANGUAGE"]) {
        [self initTabbar];
    }
    else
    {
        [self initLanguage];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayerViewControllerDidReceiveVideo:) name:XCDYouTubeVideoPlayerViewControllerDidReceiveVideoNotification object:nil];
	
	[[PlayerEventLogger sharedLogger] setEnabled:YES];
    [window makeKeyAndVisible];
       if (![[NSUserDefaults standardUserDefaults] valueForKey:@"FIRST_UPDATE"]) {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"IS_UPDATE"]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IS_UPDATE"];
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"FIRST_UPDATE"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
   
    return YES;
}
-(void) initTabbar
{
    self.nav =[[UINavigationController alloc] initWithRootViewController:tabBarController];
    self.nav.navigationBarHidden = YES;
    self.window.rootViewController = self.nav;
     [self.window makeKeyAndVisible];
}
-(void) initLanguage
{
    LanguageVC *languageVC;
    if (IS_IPAD) {
        languageVC =[[LanguageVC alloc] initWithNibName:@"LanguageVC_iPad" bundle:nil];
    }
    else
    {
        languageVC =[[LanguageVC alloc] initWithNibName:@"LanguageVC" bundle:nil];
    }
     self.nav =[[UINavigationController alloc] initWithRootViewController:languageVC];
    self.nav.navigationBarHidden = YES;
    self.window.rootViewController =self.nav;
}

-(void) tabWasSelected:(NSInteger)index
{
    
}
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"content---%@", token);
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"REGISTER_PUSH"]) {
        [self callWSResgister:token];
    }
    
    self.strToken = token;
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    
}

-(void) callWSResgister:(NSString *) uiid
{
    NSDictionary *parameters = @{@"key":@"5583ba04d14de2e2a04c2ff7dcd7f504",@"apns":[self deviceId],@"udid":uiid,@"notification":@"1" };
    NSLog(@"Parame %@",parameters);
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    NSURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"http://grupointocable.com/_ws/api/register.php" parameters:parameters];
    AFHTTPRequestOperation *operation1 = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Reponse %@",operation.responseString);
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"REGISTER_PUSH"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IS_PUSH"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
        NSLog(@"AFHTTPRequestOperation Failure: %@", error);
        
    }];
    [operation1 start];

}
-(NSString *)deviceId {
    [[NSUserDefaults standardUserDefaults] setValue:[[UIDevice currentDevice] identifierForVendor].UUIDString forKey:@"UUID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return [[UIDevice currentDevice] identifierForVendor].UUIDString;
}
- (NSString *)generateUUID
{
	// Create universally unique identifier (object)
	CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    
	// Get the string representation of CFUUID object.
	// NSString *uuidStr = [(NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidObject) autorelease];
	CFStringRef uuidString = CFUUIDCreateString( kCFAllocatorDefault, uuidObject );
	NSString *uuidStr = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    
	
    
	CFRelease(uuidObject);
	CFRelease(uuidString);
    [[NSUserDefaults standardUserDefaults] setValue:uuidStr forKey:@"UUID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return uuidStr;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - GoHome

-(void) goHome
{
    self.tabBarController.selectedIndex =0;
    self.musicVC.imgLoadHome.hidden = NO;
    self.musicVC.subMusic.hidden = YES;
    [self.tabBarController.customTabBarView.scrollTabbar setContentOffset:CGPointMake(0,0) animated:YES];
    self.tabBarController.customTabBarView.pageControl.currentPage = 0;
    self.alertTabbar.btnMusic.selected = NO;
    self.alertTabbar.btnMedia.selected = NO;
    self.alertTabbar.btnNew.selected = NO;
    self.alertTabbar.btnEvent.selected = NO;
    self.alertTabbar.btnListenNow.selected = NO;
    self.alertTabbar.btnMerchare.selected = NO;
    self.alertTabbar.btnBio.selected = NO;
    self.alertTabbar.btnWatchNow.selected = NO;
    self.alertTabbar.btnReferences.selected = NO;
    self.alertTabbar.btnMore.selected = NO;
}
#pragma mark - Notifications

- (void) videoPlayerViewControllerDidReceiveVideo:(NSNotification *)notification
{
	XCDYouTubeVideo *video = notification.userInfo[XCDYouTubeVideoUserInfoKey];
	NSString *title = video.title;
	if (title)
		[MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = @{ MPMediaItemPropertyTitle: title };
	
	[NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:video.mediumThumbnailURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
		if (data)
		{
			UIImage *image = [UIImage imageWithData:data];
			MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
			if (title && artwork)
				[MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = @{ MPMediaItemPropertyTitle: title, MPMediaItemPropertyArtwork: artwork };
		}
	}];
}


@end
