//
//  Common.m


#import "CommonHelper.h"
#import "Reachability.h"
#import "SVProgressHUD.h"
@implementation CommonHelper 
+ (AppDelegate *)appDelegate
{
    UIApplication *app = [UIApplication sharedApplication];
    return (AppDelegate *)app.delegate;
}

+ (void)showAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
}
+ (void)showBusyView
{
    [SVProgressHUD showImage:[UIImage imageNamed:@"icon_load.png"] status:TXT_PLEASE_WAIT];
   // [SVProgressHUD showProgress:-1 status:TXT_PLEASE_WAIT maskType:SVProgressHUDMaskTypeGradient];
}

+ (void)hideBusyView
{
    [SVProgressHUD dismiss];
}

+ (BOOL) connectedInternet{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize andImage:(UIImage *) img
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

@end
