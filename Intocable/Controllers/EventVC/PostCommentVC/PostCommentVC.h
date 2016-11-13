//
//  PostCommentVC.h
//  Intocable
//
//  Created by Neeraj on 10/13/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventObj.h"
@interface PostCommentVC : UIViewController
- (IBAction)doBack:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *tvComment;
- (IBAction)touchScroll:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
- (IBAction)doPostComment:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnPostAcomment;
@property (weak, nonatomic) IBOutlet UITextField *txfName;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollPage;
@property(nonatomic,retain) EventObj *eventObj;
@end
