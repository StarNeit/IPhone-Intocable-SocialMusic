//
//  DetailMerchandiseVC.m
//  Intocable
//
//  Created by Neeraj on 10/10/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import "DetailMerchandiseVC.h"
#import "CommonHelper.h"
#import "XMLDictionary.h"
@interface DetailMerchandiseVC ()
{
    NSTimer *timer;
    NSString *strLinkBuy;
}
@end

@implementation DetailMerchandiseVC

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
    [CommonHelper showBusyView];
    timer =[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(callWS) userInfo:nil repeats:YES];
    self.lbltitleProduct.text = self.productObj.title;
    int language =[[USER_DEFAULT valueForKey:@"IS_LANGUAGE"] intValue];
    
    if (language==1) {
        [self.labelBuy setTitle:BUY_ENGLISH forState:UIControlStateNormal];
    }
    else
    {
        [self.labelBuy setTitle:BUY_SPANISH forState:UIControlStateNormal];
    }
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
        URL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.grupointocable.com/_ws/intocable/english/xml/productdetail/%@.xml",self.productObj.productID]];
    }
    else
    {
        URL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.grupointocable.com/_ws/intocable/spanish/xml/productdetail/%@.xml",self.productObj.productID]];
    }
    
    NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
    NSLog(@"XML DOC %@",xmlDoc);
    NSDictionary *arr = [xmlDoc objectForKey:@"Sections"];
    NSDictionary *section = [arr objectForKey:@"Section"];
    NSDictionary *product =[section objectForKey:@"Product"];
    self.lblPrice.text = [product objectForKey:@"ProductPrice"];
    self.lblProduct.text = self.productObj.title;
    [self loadBackgroud:self.imgThumbnail imageUrl:[product objectForKey:@"_LargeImageURL"]];
    strLinkBuy =[product objectForKey:@"_Buy"];
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
-(void) viewWillAppear:(BOOL)animated{
    if ([self isLandScape]) {
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
        [self.subThumbnail setFrame:CGRectMake(18,11,738, 800)];
        [self.subPrice setFrame:CGRectMake(18,811,738, 61)];
        [self.imgThumbnail setFrame:CGRectMake(10,14,708, 765)];
        [self.btnBuy setFrame:CGRectMake(605,0,115,40)];
    }
    else
    {
        if (!IPHONE_5) {
            [self.scrollPage setContentSize:CGSizeMake(320,520)];
        }
        else
        {
            [self.scrollPage setContentSize:CGSizeMake(320,430)];
        }
        [self.subThumbnail setFrame:CGRectMake(10,11,300, 353)];
        [self.subPrice setFrame:CGRectMake(10,364,300, 53)];
         [self.imgThumbnail setFrame:CGRectMake(10,14,280, 319)];
    }
}

-(void) setFrameRotated
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        [self.subThumbnail setFrame:CGRectMake(0,11,500, 500)];
        [self.subPrice setFrame:CGRectMake(524,11,500, 61)];
        [self.imgThumbnail setFrame:CGRectMake(10,14,468, 468)];
        [self.btnBuy setFrame:CGRectMake(370,0,115,40)];
    }
    else
    {
        if (IPHONE_5) {
            [self.scrollPage setContentSize:CGSizeMake(568,430)];
            [self.subThumbnail setFrame:CGRectMake(0,10,258, 170)];
            [self.imgThumbnail setFrame:CGRectMake(10,10, 238, 170)];
            [self.subPrice setFrame:CGRectMake(268,10,300, 53)];
            
        }
        else
        {
            [self.scrollPage setContentSize:CGSizeMake(480,430)];
            [self.subThumbnail setFrame:CGRectMake(0,10,130, 170)];
            [self.subPrice setFrame:CGRectMake(140,10,300, 53)];
            [self.imgThumbnail setFrame:CGRectMake(10,10, 100, 130)];
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

- (IBAction)doBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)doBuy:(id)sender {
    [[UIApplication sharedApplication]
     openURL:[NSURL URLWithString:strLinkBuy]];
}
@end
