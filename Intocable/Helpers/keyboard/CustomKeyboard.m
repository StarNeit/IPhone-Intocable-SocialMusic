//
//  CustomKeyboard.m
//
//  Created by Kalyan Vishnubhatla on 10/9/12.
//
//

#import "CustomKeyboard.h"
#import <UIKit/UIKit.h>
@implementation CustomKeyboard
@synthesize delegate, currentSelectedTextboxIndex;

- (id)init {
    self = [super init];
    if (self){
        
    }
    return self;
}

- (UIToolbar *)getToolbarWithPrevNextDone:(BOOL)prevEnabled :(BOOL)nextEnabled
{    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
//    [toolbar setBarStyle:UIBarStyleBlackOpaque];
    [toolbar setBackgroundImage:[UIImage imageNamed:@"bg_top.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];

    [toolbar sizeToFit];
    
    NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
    UIBarButtonItem *cancelBotton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(userClickedCancel:)];
    [itemsArray addObject:cancelBotton];
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [itemsArray addObject:flexButton];
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(userClickedDone:)];
    [itemsArray addObject:doneButton];

    [cancelBotton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:@"Roboto-Light" size:17.0], NSFontAttributeName,
                                        [UIColor whiteColor], NSForegroundColorAttributeName,
                                        nil]
                              forState:UIControlStateNormal];
    
    [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:@"Roboto-Light" size:17.0], NSFontAttributeName,
                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                          nil]
                                forState:UIControlStateNormal];
    
    toolbar.items = itemsArray;
        
    return toolbar;
}

- (UIToolbar *)getToolbarWithDone
{
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    //[toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar setBackgroundImage:[UIImage imageNamed:@"bg_top.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [toolbar sizeToFit];
    
    NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [itemsArray addObject:flexButton];
    
    
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(userClickedDone:)];
    [itemsArray addObject:doneButton];
    
    toolbar.items = itemsArray;
    
    return toolbar;
}


/* Previous / Next segmented control changed value */
- (void)segmentedControlHandler:(id)sender
{
    if (delegate){
        switch ([(UISegmentedControl *)sender selectedSegmentIndex]) {
            case 0:
                [delegate previousClicked:currentSelectedTextboxIndex];
                break;
            case 1:
                [delegate nextClicked:currentSelectedTextboxIndex];
                break;
            default:
                break;
        }
    }
}

-(void) userClickedCancel:(id)sender
{
    if (delegate){
        [delegate cancelClicked:currentSelectedTextboxIndex];
    }
}
- (void)userClickedDone:(id)sender {
    if (delegate){
        [delegate doneClicked:currentSelectedTextboxIndex];
    }
}

@end
