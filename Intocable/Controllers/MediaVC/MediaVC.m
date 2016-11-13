//
//  MediaVC.m
//  Intocable
//
//  Created by Neeraj on 10/6/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import "MediaVC.h"
#import "Cell.h"
#import "CommonHelper.h"
#import "XMLDictionary.h"
#import "PhotoObj.h"
#import "VideoObj.h"
#import "SVProgressHUD.h"
#import <Foundation/Foundation.h>
#import <XCDYouTubeKit/XCDYouTubeKit.h>
#import "FGalleryViewController.h"
#import "MWPhotoBrowser.h"
#import "MWCommon.h"
@interface MediaVC ()<UIViewControllerTransitioningDelegate,MWPhotoBrowserDelegate>
{
    BOOL isPhotoAndVideo;
    NSTimer *timer;
    NSMutableArray *_arrPhotos;
    NSMutableArray *_arrVideos;
    BOOL isLoadVideo;
    FGalleryViewController *networkGallery;
}
@end

@implementation MediaVC

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
    int language =[[USER_DEFAULT valueForKey:@"IS_LANGUAGE"] intValue];
   
    if (language==1) {
        [self.btnPhotos setTitle:PHOTO_ENGLISH forState:UIControlStateNormal];
    }
    else
    {
        [self.btnPhotos setTitle:PHOTO_SPANISH forState:UIControlStateNormal];
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void) callWSLoadPhoto
{
    [timer invalidate];
    timer = nil;
    
    if (![CommonHelper connectedInternet]) {
        [CommonHelper showAlert:ERROR_NETWORK];
        [SVProgressHUD dismiss];
        return;
    }
    
    int language =[[USER_DEFAULT valueForKey:@"IS_LANGUAGE"] intValue];
    NSURL *URL;
    if (language==1) {
        URL = [[NSURL alloc] initWithString:LINK_MEDIA_PHOTO_ENGLISH];
    }
    else
    {
        URL = [[NSURL alloc] initWithString:LINK_MEDIA_PHOTO_SPANISH];
    }
    
    NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
    //NSLog(@"xmldoc %@",xmlDoc);
    NSDictionary *arr = [xmlDoc objectForKey:@"Sections"];
    
    NSArray *section = [arr objectForKey:@"Section"];
    NSDictionary *dics = section[1];
    NSDictionary *categories =[dics objectForKey:@"Categories"];
    NSDictionary *category =[categories objectForKey:@"Category"];
    NSDictionary *photo_tmps =[category objectForKey:@"Photos"];
    NSArray *photo = [photo_tmps objectForKey:@"Photo"];
    NSLog(@"xmldoc %@",photo);
    for (NSDictionary *dic in photo) {
        PhotoObj *photoObj = [[PhotoObj alloc] init];
        photoObj.photoID = [dic objectForKey:@"_ID"];
        photoObj.title = [dic objectForKey:@"_Title"];
        photoObj.linkImg = [dic objectForKey:@"_URL"];
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:photoObj.linkImg]];
            if ( data == nil )
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                // WARNING: is the cell still using the same data by this point??
                photoObj.imgThumbnail = [UIImage imageWithData:data];
                [self.tblPhotos reloadData];
            });
        });
        [_arrPhotos addObject:photoObj];
    }
    [CommonHelper appDelegate].isMedia = YES;
    [self.tblPhotos reloadData];
    [SVProgressHUD dismiss];
}

-(void) callWSLoadVideo
{
    NSLog(@"Vao day");
    [timer invalidate];
    timer = nil;
   
    if (![CommonHelper connectedInternet]) {
        [CommonHelper showAlert:ERROR_NETWORK];
        [SVProgressHUD dismiss];
        return;
    }
    
    int language =[[USER_DEFAULT valueForKey:@"IS_LANGUAGE"] intValue];
    NSURL *URL;
    if (language==1) {
        URL = [[NSURL alloc] initWithString:LINK_MEDIA_VIDEO_ENGLISH];
    }
    else
    {
        URL = [[NSURL alloc] initWithString:LINK_MEDIA_VIDEO_SPANISH];
    }
    
    NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
    //NSLog(@"XML DOC %@",xmlDoc);
    NSDictionary *arr = [xmlDoc objectForKey:@"Sections"];
    
    NSArray *section = [arr objectForKey:@"Section"];
    NSDictionary *dics = section[1];
    NSDictionary *categories =[dics objectForKey:@"Categories"];
    NSDictionary *category =[categories objectForKey:@"Category"];
    NSDictionary *photos =[category objectForKey:@"Videos"];
    NSArray *videos = [photos objectForKey:@"Video"];
    NSLog(@"xmldoc %@",videos);
    for (NSDictionary *dic in videos) {
        NSLog(@"DIC %@",dic);
        VideoObj *obj = [[VideoObj alloc] init];
        obj.videoID = [dic objectForKey:@"_ID"];
        obj.bgVideo = [dic objectForKey:@"_BackgroundURL"];
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:obj.bgVideo]];
            if ( data == nil )
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                // WARNING: is the cell still using the same data by this point??
                obj.imgBg = [UIImage imageWithData:data];
                [self.tblPhotos reloadData];
            });
        });

        obj.nameVideo = [dic objectForKey:@"_Name"];
        obj.playUrl = [dic objectForKey:@"_PlayURL"];
        if ([obj.playUrl rangeOfString:@"="].location != NSNotFound) {
            NSArray* arrs = [obj.playUrl componentsSeparatedByString: @"="];
            if (arrs.count>0) {
                NSString *str = arrs[1];
                str = [str stringByReplacingOccurrencesOfString:@"&list"
                                                     withString:@""];
                NSLog(@"-------->%@",str);
                obj.videoIDEmble = str;
                
            }
        }
        
        else
        {
             NSArray* arrs = [obj.playUrl componentsSeparatedByString: @"/"];
            NSString *str = [arrs lastObject];
            str = [str stringByReplacingOccurrencesOfString:@"&list"
                                                 withString:@""];
            NSLog(@"-------->%@",str);
            obj.videoIDEmble = str;
        }
        [_arrVideos addObject:obj];
    }
    [self.tblPhotos reloadData];
     isLoadVideo = true;
    [SVProgressHUD dismiss];
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
    self.navigationController.navigationBarHidden = YES;
    if ([self isLandScape]) {
        [self setFrameRotated];
    }
    else{
        [self setFrameNormal];
    }
    if (![CommonHelper appDelegate].isMedia) {
        _arrPhotos =[[NSMutableArray alloc] init];
        _arrVideos =[[NSMutableArray alloc] init];
        self.navigationController.navigationBarHidden = YES;
        [CommonHelper showBusyView];
        timer =[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(callWSLoadPhoto) userInfo:nil repeats:YES];
        if (IS_IPAD) {
            int language =[[USER_DEFAULT valueForKey:@"IS_LANGUAGE"] intValue];
           
            if (language==1) {
                [self.btnPhoto setTitle:PHOTO_ENGLISH forState:UIControlStateNormal];

            }
            else
            {
                [self.btnPhoto setTitle:PHOTO_SPANISH forState:UIControlStateNormal];

            }
                      [self.btnPhoto setBackgroundImage:[UIImage imageNamed:@"ic_btn_photos_on.png"] forState:UIControlStateNormal];
            [self.btnVideo setImage:[UIImage imageNamed:@"ic_btn_video.png"] forState:UIControlStateNormal];
        }
        else
        {
            self.linePhotoOn.image =[UIImage imageNamed:@"line_button_on.png"];
            self.lineVideoOn.image =[UIImage imageNamed:@"line2.png"];
        }
        isPhotoAndVideo = NO;
        [self.tblPhotos reloadData];
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
        
        if (IPHONE_5) {
            [self.tblPhotos setFrame:CGRectMake(0, 41, 320, 377)];
        }
        else
        {
            [self.tblPhotos setFrame:CGRectMake(0, 41, 320, 289)];
        }
        
    }
    [self.tblPhotos reloadData];
}

-(void) setFrameRotated
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
    }
    else
    {
        if (IPHONE_5) {
             [self.tblPhotos setFrame:CGRectMake(124, 40, 320, 130)];
        }
        else
        {
             [self.tblPhotos setFrame:CGRectMake(80, 40, 320, 130)];
        }
       
        
    }
    [self.tblPhotos reloadData];
}

-(BOOL) isLandScape{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if ((orientation == UIInterfaceOrientationLandscapeLeft)||(orientation == UIInterfaceOrientationLandscapeRight))
    {
        return YES;
    }
    
    return NO;
}
- (IBAction)doPhotos:(id)sender {
    if (IS_IPAD) {
        [self.btnPhoto setTintColor:[UIColor whiteColor]];
        self.btnPhoto.titleLabel.textColor =[UIColor whiteColor];
        [self.btnPhoto setBackgroundImage:[UIImage imageNamed:@"ic_btn_photos_on.png"] forState:UIControlStateNormal];
         [self.btnVideo setImage:[UIImage imageNamed:@"ic_btn_video.png"] forState:UIControlStateNormal];
    }
    else
    {
        self.linePhotoOn.image =[UIImage imageNamed:@"line_button_on.png"];
        self.lineVideoOn.image =[UIImage imageNamed:@"line2.png"];
    }
    isPhotoAndVideo = NO;
    [self.tblPhotos reloadData];
    
}

- (IBAction)doVideos:(id)sender {
    if (IS_IPAD) {
        
        [self.btnPhoto setTintColor:[UIColor whiteColor]];
        self.btnPhoto.titleLabel.textColor =[UIColor whiteColor];
        [self.btnPhoto setBackgroundImage:[UIImage imageNamed:@"ic_btn_photos.png"] forState:UIControlStateNormal];
        [self.btnPhoto setTintColor:[UIColor darkGrayColor]];
        [self.btnVideo setImage:[UIImage imageNamed:@"ic_btn_video_on.png"] forState:UIControlStateNormal];
    }
    else
    {
        self.lineVideoOn.image =[UIImage imageNamed:@"line_button_on.png"];
        self.linePhotoOn.image =[UIImage imageNamed:@"line2.png"];
    }
    isPhotoAndVideo = YES;
    [self.tblPhotos reloadData];
    if (!isLoadVideo) {
        [CommonHelper showBusyView];
        timer =[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(callWSLoadVideo) userInfo:nil repeats:YES];
    }
    
    
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
        return 195;
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
	if (!isPhotoAndVideo) {
        return _arrPhotos.count;
    }
    return _arrVideos.count;
}

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
	Cell *cell = (Cell *)[grid dequeueReusableCell];
	
	if (cell == nil) {
        cell = [[Cell alloc] init];
    
		
	}
    if (!isPhotoAndVideo) {
        cell.btnPlay.hidden = YES;
        PhotoObj *obj;
        int position ;
        if (IS_IPAD) {
            obj  = [_arrPhotos objectAtIndex:(rowIndex *4)+columnIndex];
            position =(rowIndex *4)+columnIndex;
        }
        else
        {
            obj = [_arrPhotos objectAtIndex:(rowIndex *3)+columnIndex];
            position =(rowIndex *3)+columnIndex;
        }
        if (obj.imgThumbnail) {
            cell.thumbnail.image = [self imageByScalingAndCroppingForSize:CGSizeMake(192, 195) andImage:obj.imgThumbnail ];
            
        }
        else
        {
            cell.thumbnail.image = nil;
            //[self getImageForImageViewPhoto:cell.thumbnail imageUrl:obj.linkImg andPhotoObj:obj];
        }
      
        

        
    }
    else
    {
        cell.btnPlay.hidden = NO;
       
        VideoObj *videoObj;
        if (IS_IPAD) {
             cell.indexPath = (rowIndex *4)+columnIndex;
            videoObj  = [_arrVideos objectAtIndex:(rowIndex *4)+columnIndex];
        }
        else
        {
             cell.indexPath = (rowIndex *3)+columnIndex;
            videoObj = [_arrVideos objectAtIndex:(rowIndex *3)+columnIndex];
        }
        if (videoObj.imgBg) {
            cell.thumbnail.image = [self imageByScalingAndCroppingForSize:CGSizeMake(192, 195) andImage:videoObj.imgBg ];;
        }
        else
        {
            cell.thumbnail.image = nil;
            //[self getImageForImageViewVideo:cell.thumbnail imageUrl:videoObj.bgVideo andVideo:videoObj];
        }
    }
    cell.backgroundColor =[UIColor clearColor];
	return cell;
}


- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize andImage:(UIImage *) img
{
    UIImage *sourceImage = img;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex
{
    
    if (isPhotoAndVideo) {
        VideoObj *obj;
        if (IS_IPAD) {
            obj = [_arrVideos objectAtIndex:(rowIndex *4)+colIndex];
        }
        else
        {
           obj = [_arrVideos objectAtIndex:(rowIndex *3)+colIndex];
        }
        NSLog(@"%@------->video emble %@",obj.playUrl,obj.videoIDEmble);
        XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:obj.videoIDEmble];
        
        [self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
    }
    else
    {
       
        int postion;
        if (IS_IPAD) {
            postion = (rowIndex *4)+colIndex;
        }
        else
        {
            postion = (rowIndex *3)+colIndex;
        }
        
        /*NSLog(@"-------->%d",postion);
        networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
        networkGallery.currentIndex = postion;
        networkGallery.startingIndex = postion;
        [self.navigationController pushViewController:networkGallery animated:YES];*/
        // Photos
        
        NSMutableArray *photos = [[NSMutableArray alloc] init];
        NSMutableArray *thumbs = [[NSMutableArray alloc] init];
        
        BOOL displayActionButton = YES;
        BOOL displaySelectionButtons = NO;
        BOOL displayNavArrows = NO;
        BOOL enableGrid = YES;
        BOOL startOnGrid = NO;
        for (int i =0;i<_arrPhotos.count;i++) {
            PhotoObj *obj = [_arrPhotos objectAtIndex:i];
            NSLog(@"IMG -->%@",obj.linkImg);
            [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:obj.linkImg]]];
            [thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:obj.linkImg]]];
        }
        self.photos = [NSMutableArray array];
        self.photos = photos;
        self.thumbs = thumbs;
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = displayActionButton;
        browser.displayNavArrows = displayNavArrows;
        browser.displaySelectionButtons = displaySelectionButtons;
        browser.alwaysShowControls = displaySelectionButtons;
        browser.zoomPhotosToFill = NO;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        browser.wantsFullScreenLayout = NO;
#endif
        browser.enableGrid = enableGrid;
        browser.startOnGrid = startOnGrid;
        browser.enableSwipeToDismiss = NO;
        [browser setCurrentPhotoIndex:postion];
        if (displaySelectionButtons) {
            _selections = [NSMutableArray new];
            for (int i = 0; i < photos.count; i++) {
                [_selections addObject:[NSNumber numberWithBool:NO]];
            }
        }
        // Reset selections
        
        [self.navigationController pushViewController:browser animated:YES];
        
         
    }
    
}



- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    NSLog(@"Index ---->%d",index);
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photos objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return [captionView autorelease];
//}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"ACTION!");
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    return [[_selections objectAtIndex:index] boolValue];
}

//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
//    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}


//

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
 
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    return nil;
}
- (IBAction)doHome:(id)sender {
    [[CommonHelper appDelegate] goHome];
}

- (void) getImageForImageViewPhoto:(UIImageView *)imageView imageUrl:(NSString *)url andPhotoObj:(PhotoObj *) obj
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
                [self.tblPhotos reloadData];
            }
            
            
        });
    });
}
- (void) getImageForImageViewVideo:(UIImageView *)imageView imageUrl:(NSString *)url andVideo:(VideoObj *) obj
{
    NSLog(@"IMG %@",url);
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
                obj.imgBg = image;
                [indicator stopAnimating];
                indicator.hidden = YES;
                [self.tblPhotos reloadData];
            }
            
            
        });
    });
}

/*#pragma mark - FGalleryViewControllerDelegate Methods


- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
   
	return _arrPhotos.count;
}


- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
	 return FGalleryPhotoSourceTypeNetwork;
}


- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
    
	return nil;
}


- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    PhotoObj *obj = [_arrPhotos objectAtIndex:index];
    return obj.linkImg;
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    PhotoObj *obj = [_arrPhotos objectAtIndex:index];
    return obj.linkImg;
}

- (void)handleTrashButtonTouch:(id)sender {
    // here we could remove images from our local array storage and tell the gallery to remove that image
    // ex:
    //[localGallery removeImageAtIndex:[localGallery currentIndex]];
}


- (void)handleEditCaptionButtonTouch:(id)sender {
    // here we could implement some code to change the caption for a stored image
}


*/


@end
