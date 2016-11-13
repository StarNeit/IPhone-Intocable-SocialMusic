//
//  BioGraphyVC.m
//  Intocable
//
//  Created by Neeraj on 10/6/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import "BioGraphyVC.h"
#import "CommonHelper.h"
#import "XMLDictionary.h"
@interface BioGraphyVC ()<UIWebViewDelegate>
{
    NSTimer *timer;
}
@end

@implementation BioGraphyVC

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
    //self.webBio.scrollView.scrollEnabled = NO;
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
        URL = [[NSURL alloc] initWithString:LINK_BIO_ENGLISH];
    }
    else
    {
        URL = [[NSURL alloc] initWithString:[NSString stringWithFormat:LINK_BIO_SPANISH]];
    }
    
    NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
    NSLog(@"XML DOC %@",xmlDoc);
    NSDictionary *arr = [xmlDoc objectForKey:@"Sections"];
    NSDictionary *section = [arr objectForKey:@"Section"];
    self.lblTitleBio.text = [xmlDoc objectForKey:@"_Name"];
    [self.webBio loadHTMLString:[section objectForKey:@"Bio"] baseURL:nil];
    NSDictionary *url = [section objectForKey:@"Image"];

    [self loadBackgroud:self.imgBio imageUrl:[url objectForKey:@"_URL"]];
    [CommonHelper appDelegate].isBio = YES;
    [CommonHelper hideBusyView];
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation==UIInterfaceOrientationLandscapeRight) {
        [self setFrameRotated];
    }
    else{
        [self setFrameNormal];
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([self isLandScape]) {
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
    if (![CommonHelper appDelegate].isBio) {
        [CommonHelper showBusyView];
        self.webBio.backgroundColor =[UIColor clearColor];
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
//        [self.imgBio setFrame:CGRectMake(0,0,320,160)];
//        if (IPHONE_5) {
//             [self.webBio setFrame:CGRectMake(0, 165, 320, 253)];
//        }
//        else
//        {
//             [self.webBio setFrame:CGRectMake(0, 165, 320, 200)];
//        }
        [self.webBio setFrame:CGRectMake(self.webBio.frame.origin.x,self.webBio.frame.origin.y, 320, [[self.webBio stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue]+50)];
         self.scrollPage.contentSize = CGSizeMake(self.scrollPage.frame.size.width,[[self.webBio stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue]+160);
    }
}

-(void) setFrameRotated
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
    }
    else
    {
//        if (IPHONE_5) {
//            [self.imgBio setFrame:CGRectMake(0,10,320,160)];
//            [self.webBio setFrame:CGRectMake(330,0,238, 170)];
//        }
//        else
//        {
//            [self.imgBio setFrame:CGRectMake(0,10,240,160)];
//            [self.webBio setFrame:CGRectMake(250,0,230, 170)];
//        }
        if (IPHONE_5) {
            [self.webBio setFrame:CGRectMake(self.webBio.frame.origin.x,self.webBio.frame.origin.y, 568, [[self.webBio stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue]+50)];
            self.scrollPage.contentSize = CGSizeMake(self.scrollPage.frame.size.width,[[self.webBio stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue]+160);
        }
        else
        {
            [self.webBio setFrame:CGRectMake(self.webBio.frame.origin.x,self.webBio.frame.origin.y, 480, [[self.webBio stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue]+50)];
            self.scrollPage.contentSize = CGSizeMake(self.scrollPage.frame.size.width,[[self.webBio stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue]+250);
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

- (void) loadBackgroud:(UIImageView *)imageView imageUrl:(NSString *)url
{
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
