//
//  ALTabBarView.h
//  ALCommon
//
//  Created by Andrew Little on 10-08-17.
//  Copyright (c) 2010 Little Apps - www.myroles.ca. All rights reserved.
//
//  Simple custom TabBar view that is defined in the TabBarView nib and used to 
//  replace the standard iOS TabBar view.  By customizing TabBarView.xib, you can
//  create a tab bar that is unique to your application, but still has the tab
//  switching functionality you've come to expect out of UITabBarController.

#import <UIKit/UIKit.h>

//Delegate methods for responding to TabBar events
@protocol ALTabBarDelegate <NSObject>

//Handle tab bar touch events, sending the index of the selected tab
-(void)tabWasSelected:(NSInteger)index;

@end

@interface ALTabBarView : UIView <UIScrollViewDelegate>{

    NSObject<ALTabBarDelegate> *delegate;

    UIButton *selectedButton;
}
-(void) initTabbar;
@property (nonatomic, assign) NSObject<ALTabBarDelegate> *delegate;
@property (nonatomic, retain) UIButton *selectedButton;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollTabbar;
@property (retain, nonatomic) IBOutlet UIView *tab1;
@property (retain, nonatomic) IBOutlet UIView *tab2;
@property (retain, nonatomic) IBOutlet UIView *tab3;
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;
@property (retain, nonatomic) IBOutlet UILabel *lblMusic;
@property (retain, nonatomic) IBOutlet UILabel *lblMedia;
@property (retain, nonatomic) IBOutlet UILabel *lblNews;
@property (retain, nonatomic) IBOutlet UILabel *lblEvents;
@property (retain, nonatomic) IBOutlet UILabel *lblListenNow;
@property (retain, nonatomic) IBOutlet UILabel *lblMecharse;
@property (retain, nonatomic) IBOutlet UILabel *lblBio;
@property (retain, nonatomic) IBOutlet UILabel *lblWatchNow;
@property (retain, nonatomic) IBOutlet UILabel *lblMore;
@property (retain, nonatomic) IBOutlet UILabel *lblPreferences;
@property (retain, nonatomic) IBOutlet UIButton *btnMusic;
@property (retain, nonatomic) IBOutlet UIButton *btnMedia;
@property (retain, nonatomic) IBOutlet UIButton *btnNew;
@property (retain, nonatomic) IBOutlet UIButton *btnEvent;
@property (retain, nonatomic) IBOutlet UIButton *btnListenNow;
@property (retain, nonatomic) IBOutlet UIButton *btnMerchare;
@property (retain, nonatomic) IBOutlet UIButton *btnBio;
@property (retain, nonatomic) IBOutlet UIButton *btnWatchNow;
 
@property (retain, nonatomic) IBOutlet UIButton *btnReferences;
@property (retain, nonatomic) IBOutlet UIButton *btnMore;
-(void) readLanguage;
-(IBAction) touchButton:(id)sender;

@end
