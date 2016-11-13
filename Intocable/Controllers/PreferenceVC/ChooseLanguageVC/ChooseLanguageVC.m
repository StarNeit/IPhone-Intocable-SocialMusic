//
//  ChooseLanguageVC.m
//  Intocable
//
//  Created by Neeraj on 10/9/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import "ChooseLanguageVC.h"
#import "CommonHelper.h"
@interface ChooseLanguageVC ()
{
    int intLaguage;
}
@end

@implementation ChooseLanguageVC

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
    
    [self initLanguage];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    [self settitlePage];
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
        [self.subTab1 setFrame:CGRectMake(0,0,320,60)];
        [self.subTab2 setFrame:CGRectMake(0,60,320,60)];
        
    }
}

-(void) setFrameRotated
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
    }
    else
    {
        if (IPHONE_5) {
            [self.subTab1 setFrame:CGRectMake(0,0,280,60)];
            [self.subTab2 setFrame:CGRectMake(290,0,280,60)];
        }
        else
        {
            [self.subTab1 setFrame:CGRectMake(0,0,230,60)];
            [self.subTab2 setFrame:CGRectMake(250,0,230,60)];
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
-(void) settitlePage
{
    int language =[[USER_DEFAULT valueForKey:@"IS_LANGUAGE"] intValue];
    if (language==0) {
        self.lblTitle.text = TXT_LANGUAGE_ESPANOL;
    }
    else
    {
        self.lblTitle.text = TXT_LANGUAGE_ENGLISH;
    }
    
}
-(void) initLanguage
{
     int language =[[USER_DEFAULT valueForKey:@"IS_LANGUAGE"] intValue];
    switch (language) {
        case 0:
        {
            [self.btnSpanish setImage:[UIImage imageNamed:@"check_on.png"] forState:UIControlStateNormal];
            [self.btnEnglish setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
           
        }
            break;
        case 1:
        {
            [self.btnEnglish setImage:[UIImage imageNamed:@"check_on.png"] forState:UIControlStateNormal];
            [self.btnSpanish setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
            
        }
            break;
        default:
            break;
    }
    intLaguage  =[[USER_DEFAULT valueForKey:@"IS_LANGUAGE"] intValue];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)doEnglish:(id)sender {
    
    
    [self.btnEnglish setImage:[UIImage imageNamed:@"check_on.png"] forState:UIControlStateNormal];
    [self.btnSpanish setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    
    if (intLaguage==1) {
        
    }
    else
    {
        [CommonHelper appDelegate].isMusic =NO;
        [CommonHelper appDelegate].isMedia =NO;
        [CommonHelper appDelegate].isNews =NO;
        [CommonHelper appDelegate].isEvents =NO;
        [CommonHelper appDelegate].isListenNow =NO;
        [CommonHelper appDelegate].isProduct =NO;
        [CommonHelper appDelegate].isBio =NO;
        [CommonHelper appDelegate].isWatchNow =NO;
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKeyPath:@"IS_LANGUAGE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[CommonHelper appDelegate].tabBarController chooseLanguage];

    }
    [self settitlePage];
}

- (IBAction)doSpanish:(id)sender {
    [self.btnSpanish setImage:[UIImage imageNamed:@"check_on.png"] forState:UIControlStateNormal];
    [self.btnEnglish setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKeyPath:@"IS_LANGUAGE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
     [[CommonHelper appDelegate].tabBarController chooseLanguage];
    if (intLaguage==1) {
        [CommonHelper appDelegate].isMusic =NO;
        [CommonHelper appDelegate].isMedia =NO;
        [CommonHelper appDelegate].isNews =NO;
        [CommonHelper appDelegate].isEvents =NO;
        [CommonHelper appDelegate].isListenNow =NO;
        [CommonHelper appDelegate].isProduct =NO;
        [CommonHelper appDelegate].isBio =NO;
        [CommonHelper appDelegate].isWatchNow =NO;
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKeyPath:@"IS_LANGUAGE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[CommonHelper appDelegate].tabBarController chooseLanguage];
    }
    else
    {
        
    }
    [self settitlePage];
}
@end
