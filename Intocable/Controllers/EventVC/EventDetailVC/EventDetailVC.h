//
//  EventDetailVC.h
//  Intocable
//
//  Created by Neeraj on 10/9/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventObj.h"
@interface EventDetailVC : UIViewController
@property (weak, nonatomic) IBOutlet UIView *viewDetail;
@property (weak, nonatomic) IBOutlet UIView *viewDetail1;
@property (weak, nonatomic) IBOutlet UIView *viewDetail2;
@property (weak, nonatomic) IBOutlet UIView *subTab;
@property (weak, nonatomic) IBOutlet UIImageView *imgTab;
@property (weak, nonatomic) IBOutlet UIButton *btnFly;
@property (weak, nonatomic) IBOutlet UIButton *btnInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (strong, nonatomic) IBOutlet UIView *subInfo;
@property (strong, nonatomic) IBOutlet UIView *subComment;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollPage;
@property (strong, nonatomic) IBOutlet UIView *subFlyer;
@property (weak, nonatomic) IBOutlet UIButton *btnViewMap;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckIn;
@property (weak, nonatomic) IBOutlet UIButton *btnPostaComment;
@property (weak, nonatomic) IBOutlet UITableView *tblComment;
@property (weak, nonatomic) IBOutlet UIButton *btnPurchase;
@property(nonatomic,retain) EventObj *eventObj;
- (IBAction)doBack:(id)sender;
- (IBAction)doFlyer:(id)sender;
- (IBAction)doInfo:(id)sender;
- (IBAction)doComment:(id)sender;
- (IBAction)doPostComment:(id)sender;
- (IBAction)doViewMap:(id)sender;
- (IBAction)doPurchase:(id)sender;
- (IBAction)doCheckIn:(id)sender;
- (IBAction)showImage:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnImage;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAdress;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblTitlePage;
@property (weak, nonatomic) IBOutlet UIImageView *imgEvent;



@end
