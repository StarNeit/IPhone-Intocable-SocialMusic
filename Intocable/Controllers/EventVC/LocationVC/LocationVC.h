//
//  LocationVC.h
//  Intocable
//
//  Created by Neeraj on 10/13/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationVC : UIViewController
- (IBAction)doBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UILabel *lblTitlePage;
@property(nonatomic,retain) NSString *strLink;
@property(nonatomic,retain) NSString *title;
@end
