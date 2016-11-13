//
//  WatchNowVC.m
//  Intocable
//
//  Created by Neeraj on 10/6/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import "WatchNowVC.h"
#import "CommonHelper.h"
#import "SVProgressHUD.h"
#import "XMLDictionary.h"
@interface WatchNowVC ()<UIWebViewDelegate>

@end

@implementation WatchNowVC

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
    if (!IS_IPAD) {
        if (!IPHONE_5) {
            self.webView.frame =CGRectMake(self.webView.frame.origin.x, self.webView.frame.origin.y,self.webView.frame.size.width, self.webView.frame.size.height-88);
        }
    }
    // Do any additional setup after loading the view from its nib.
}

-(void) loadWS
{
    [CommonHelper showBusyView];
    if (![CommonHelper connectedInternet]) {
        [CommonHelper showAlert:ERROR_NETWORK];
        [CommonHelper hideBusyView];
        return;
    }
    
    static NSString *feedURLString = @"http://grupointocable.com/_ws/intocable/any/xml/livestream/";
    NSURLRequest *earthquakeURLRequest =
    [NSURLRequest requestWithURL:[NSURL URLWithString:feedURLString]];
    [NSURLConnection sendAsynchronousRequest:earthquakeURLRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               NSLog(@"MY %@",response);
                               NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:myString];
                               NSDictionary *dic =[xmlDoc objectForKey:@"Sections"];
                               NSDictionary *section =[dic  objectForKey:@"Section"];
                               NSDictionary *station = [section objectForKey:@"Station"];
                               if ([[station objectForKey:@"_StationEnabled"] boolValue]) {
                                   NSLog(@"URL %@",[station objectForKey:@"_StationURL"]);
                                   [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[station objectForKey:@"_StationURL"]]]];
                               }
                               else
                               {
                                   [CommonHelper showAlert:@"There are no streaming events today, keep checking back for more."];
                                   NSLog(@"URL %@",[station objectForKey:@"_StationURL"]);
                               }
                               [CommonHelper hideBusyView];
                               if (error != nil) {
                               }
                               else {
                                   
                               }
                           }];
    

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
    
    if (language==1) {
        self.lblTitle.text =@"Watch Now";
    }
    else
    {
        self.lblTitle.text =@"Ver Ahora";
    }
    
    [self loadWS];
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
            [self.scrollPage setContentSize:CGSizeMake(320,520)];
            [self.subSound setFrame:CGRectMake(0,340,320, 40)];
        }
        else
        {
            [self.subSound setFrame:CGRectMake(0,383,320, 40)];
            [self.scrollPage setContentSize:CGSizeMake(320,430)];
        }
        [self.topWatch setFrame:CGRectMake(0,0,320, 50)];
        [self.bgTop setFrame:CGRectMake(0,0,320, 50)];
        [self.imgThumbnail setFrame:CGRectMake(0,50,320, 373)];
        
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

- (IBAction)doHome:(id)sender {
    [[CommonHelper appDelegate] goHome];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [CommonHelper hideBusyView];
}
@end
