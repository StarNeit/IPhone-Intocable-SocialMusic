//
//  Common.h


#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface CommonHelper : NSObject
+ (AppDelegate *)appDelegate;
+ (void)showAlert:(NSString *)message;
+ (void)showBusyView;
+ (void)hideBusyView;
+ (BOOL) connectedInternet;
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize andImage:(UIImage *) img;
@end
