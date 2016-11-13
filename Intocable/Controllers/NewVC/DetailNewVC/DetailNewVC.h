//
//  DetailNewVC.h
//  Intocable
//
//  Created by Neeraj on 10/23/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewObj.h"
@interface DetailNewVC : UIViewController
- (IBAction)doBack:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIWebView *webNews;
@property(nonatomic,retain) NewObj *objNew;
@property(nonatomic,assign) int indexTab;
@end
