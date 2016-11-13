//
//  AboutVC.m
//  Intocable
//
//  Created by Neeraj on 10/10/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import "AboutVC.h"
#import "XMLDictionary.h"
#import "CommonHelper.h"
@interface AboutVC ()
{
    NSTimer *timer;
}
@end

@implementation AboutVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
-(void) settitlePage
{
    int language =[[USER_DEFAULT valueForKey:@"IS_LANGUAGE"] intValue];
    if (language==0) {
        self.lblTitle.text = ABOUT_APP_SPAINSH;
    }
    else
    {
        self.lblTitle.text = ABOUT_APP_ENGLISH;
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
        [self.subAbout setFrame:CGRectMake(0,115,320, 186)];
        
    }
}

-(void) setFrameRotated
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
    }
    else
    {
        if (IPHONE_5) {
            [self.subAbout setFrame:CGRectMake(124,0,320, 186)];
        }
        else
        {
            [self.subAbout setFrame:CGRectMake(70,0,320, 186)];
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

- (void)viewDidLoad
{
    [CommonHelper showBusyView];
    timer =[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(callWS) userInfo:nil repeats:YES];
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
        URL = [[NSURL alloc] initWithString:LINK_ABOUT_ENGLISH];
    }
    else
    {
        URL = [[NSURL alloc] initWithString:LINK_ABOUT_SPANISH];
    }
    
    NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
    NSLog(@"XML Doc %@",xmlDoc);
    NSDictionary *arr = [xmlDoc objectForKey:@"Sections"];
    
    NSDictionary *section = [arr objectForKey:@"Section"];
    NSDictionary *about = [section objectForKey:@"About"];
    NSString *text = [about objectForKey:@"__text"];
    //self.lblTitle.text = [xmlDoc objectForKey:@"_Name"];
    self.tvText.text = text;
    [CommonHelper hideBusyView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
