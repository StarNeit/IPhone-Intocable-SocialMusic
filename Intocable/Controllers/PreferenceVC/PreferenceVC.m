//
//  PreferenceVC.m
//  Intocable
//
//  Created by Neeraj on 10/6/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import "PreferenceVC.h"
#import "ChooseLanguageVC.h"
#import "NotificationVC.h"
#import "UpdateVC.h"
#import "AboutVC.h"
#import "CommonHelper.h"
@interface PreferenceVC ()

@end

@implementation PreferenceVC

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
    self.navigationController.navigationBarHidden = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
-(void) viewWillAppear:(BOOL)animated{
    if ([self isLandScape]) {
        [self setFrameRotated];
    }
    else{
        [self setFrameNormal];
    }
     int language =[[USER_DEFAULT valueForKey:@"IS_LANGUAGE"] intValue];
    if (language ==0) {
        self.lblRefre.text = TXT_PREFEREECES_ESPANOL;
        [self.btnLabguage setTitle:TXT_LANGUAGE_ESPANOL forState:UIControlStateNormal];
        [self.btnAbout setTitle:TXT_ABOUT_APPLICATION_ESPANOL forState:UIControlStateNormal];
        [self.btnUpdate setTitle:TXT_UPDATE_ESPANOL forState:UIControlStateNormal];
        [self.btnNotification setTitle:TXT_NOTIFICATION_ESPANOL forState:UIControlStateNormal];
    }
    else
    {
        self.lblRefre.text = TXT_PREFEREECES_ENGLISH;
        [self.btnLabguage setTitle:TXT_LANGUAGE_ENGLISH forState:UIControlStateNormal];
        [self.btnAbout setTitle:TXT_ABOUT_APPLICATION_ENGLISH forState:UIControlStateNormal];
        [self.btnUpdate setTitle:TXT_UPDATE_ENGLISH forState:UIControlStateNormal];
        [self.btnNotification setTitle:TXT_NOTIFICATION_ENGLISH forState:UIControlStateNormal];
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
        [self.subTab1 setFrame:CGRectMake(0,0,320,90)];
        [self.subTab2 setFrame:CGRectMake(0,90,320,90)];
        
    }
}

-(void) setFrameRotated
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
    }
    else
    {
        if (IPHONE_5) {
            [self.subTab1 setFrame:CGRectMake(0,0,280,90)];
            [self.subTab2 setFrame:CGRectMake(290,0,280,90)];
        }
        else
        {
            [self.subTab1 setFrame:CGRectMake(0,0,230,90)];
            [self.subTab2 setFrame:CGRectMake(250,0,230,90)];
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

- (IBAction)doHome:(id)sender {
    [[CommonHelper appDelegate] goHome];
}

- (IBAction)doLanguage:(id)sender {
    ChooseLanguageVC *languageVC;
    if (IS_IPAD) {
        languageVC =[[ChooseLanguageVC alloc] initWithNibName:@"ChooseLanguageVC_iPad" bundle:nil];
    }
    else
    {
        languageVC =[[ChooseLanguageVC alloc] initWithNibName:@"ChooseLanguageVC" bundle:nil];
    }
    [self.navigationController pushViewController:languageVC animated:YES];
}

- (IBAction)doNotifications:(id)sender {
    NotificationVC *languageVC;
    if (IS_IPAD) {
        languageVC =[[NotificationVC alloc] initWithNibName:@"NotificationVC_iPad" bundle:nil];
    }
    else
    {
        languageVC =[[NotificationVC alloc] initWithNibName:@"NotificationVC" bundle:nil];
    }
    [self.navigationController pushViewController:languageVC animated:YES];
}

- (IBAction)doUpdates:(id)sender {
    UpdateVC *languageVC;
    if (IS_IPAD) {
        languageVC =[[UpdateVC alloc] initWithNibName:@"UpdateVC_iPad" bundle:nil];
    }
    else
    {
        languageVC =[[UpdateVC alloc] initWithNibName:@"UpdateVC" bundle:nil];
    }
    [self.navigationController pushViewController:languageVC animated:YES];
    
}

- (IBAction)doAbout:(id)sender {
    AboutVC *languageVC;
    if (IS_IPAD) {
        languageVC =[[AboutVC alloc] initWithNibName:@"AboutVC_iPad" bundle:nil];
    }
    else
    {
        languageVC =[[AboutVC alloc] initWithNibName:@"AboutVC" bundle:nil];
    }
    [self.navigationController pushViewController:languageVC animated:YES];
}
@end
