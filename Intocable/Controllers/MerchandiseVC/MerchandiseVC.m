//
//  MerchandiseVC.m
//  Intocable
//
//  Created by Neeraj on 10/6/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import "MerchandiseVC.h"
#import "Cell.h"
#import "DetailMerchandiseVC.h"
#import "CommonHelper.h"
#import "XMLDictionary.h"
#import "ProductObj.h"
@interface MerchandiseVC ()
{
    NSTimer *timer;
    NSMutableArray *_arrProducts;
}
@end

@implementation MerchandiseVC

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
    if ([self isLandScape]) {
        [self setFrameRotated];
    }
    else{
        [self setFrameNormal];
    }
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
        URL = [[NSURL alloc] initWithString:LINK_MERCHARSE_ENGLISH];
    }
    else
    {
        URL = [[NSURL alloc] initWithString:LINK_MERCHARSE_SPANISH];
    }
    
    NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
    NSLog(@"XML DOC %@",xmlDoc);
    NSDictionary *category = [xmlDoc objectForKey:@"Category"];
    NSDictionary *products = [category objectForKey:@"Product"];
    for (NSDictionary *dic in products) {
        ProductObj *obj = [[ProductObj alloc] init];
        obj.productID = [dic objectForKey:@"_ID"];
        obj.title = [dic objectForKey:@"_Title"];
        obj.strThumbnail = [dic objectForKey:@"_SmallImageURL"];
        [_arrProducts addObject:obj];
    }
    
    [self loadBackgroud:self.imgMerchandise imageUrl:[xmlDoc objectForKey:@"_Background"]];
    self.lblTitle.text = [xmlDoc objectForKey:@"_Name"];
    [CommonHelper appDelegate].isProduct = YES;
    [self.tblMerchares reloadData];
    [CommonHelper hideBusyView];
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
    if (![CommonHelper appDelegate].isProduct) {
        _arrProducts =[[NSMutableArray alloc] init];
        [CommonHelper showBusyView];
        timer =[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(callWS) userInfo:nil repeats:YES];
        [self.tblMerchares reloadData];
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
        [self.tblMerchares setFrame:CGRectMake(0,401,768,472)];
    }
    else
    {
        [self.imgMerchandise setFrame:CGRectMake(0,0,320,175)];
        if (IPHONE_5) {
            [self.tblMerchares setFrame:CGRectMake(0, 191, 320, 232)];
        }
        else
        {
            [self.tblMerchares setFrame:CGRectMake(0, 191, 320, 144)];
        }
        
    }
}

-(void) setFrameRotated
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        [self.tblMerchares setFrame:CGRectMake(128,401,768,250)];
    }
    else
    {
        //[self.tblPhotos setFrame:CGRectMake(34, 40, 500, 130)];
        [self.imgMerchandise setFrame:CGRectMake(0,0,150,140)];
        if (IPHONE_5) {
            [self.tblMerchares setFrame:CGRectMake(160, 0, 320, 170)];
        }
        else
        {
            [self.tblMerchares setFrame:CGRectMake(160, 0, 320, 170)];
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
- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
    if (IS_IPAD) {
        return 192;
    }
	return 105;
}

- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex
{
    if (IS_IPAD) {
        return 192;
    }
	return 105;
}

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
    if (IS_IPAD) {
        return 4;
    }
    return 3;
    
	
}


- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
    
	return _arrProducts.count;
}

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
	Cell *cell = (Cell *)[grid dequeueReusableCell];
	
	if (cell == nil) {
		cell = [[Cell alloc] init];
	}
    int position;
    if (IS_IPAD) {
        position =(rowIndex *4)+columnIndex;
    }
    else
    {
        position =(rowIndex *3)+columnIndex;
    }
    cell.btnPlay.hidden = YES;
    ProductObj *obj = [_arrProducts objectAtIndex:position];
    if (obj.imgThumbnail) {
        cell.thumbnail.image = obj.imgThumbnail;
    }
    else
    {
        [self getImageForImageView:cell.thumbnail imageUrl:obj.strThumbnail andNew:obj];
    }
    cell.backgroundColor =[UIColor clearColor];
	return cell;
}

- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex
{
    int position;
    if (IS_IPAD) {
        position =(rowIndex *4)+colIndex;
    }
    else
    {
        position =(rowIndex *3)+colIndex;
    }
    if (IS_IPAD) {
        DetailMerchandiseVC *detailVC =[[DetailMerchandiseVC alloc] initWithNibName:@"DetailMerchandiseVC_iPad" bundle:nil];
        detailVC.productObj = [_arrProducts objectAtIndex:position];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else
    {
        DetailMerchandiseVC *detailVC =[[DetailMerchandiseVC alloc] initWithNibName:@"DetailMerchandiseVC" bundle:nil];
         detailVC.productObj = [_arrProducts objectAtIndex:position];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
    
}
- (IBAction)doHome:(id)sender {
    [[CommonHelper appDelegate] goHome];
}

- (void) getImageForImageView:(UIImageView *)imageView imageUrl:(NSString *)url andNew:(ProductObj *) obj
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
                obj.imgThumbnail = image;
                [indicator stopAnimating];
                indicator.hidden = YES;
                [self.tblMerchares reloadData];
            }
            
            
        });
    });
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
