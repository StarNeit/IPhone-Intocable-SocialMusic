//
//  PostCommentVC.m
//  Intocable
//
//  Created by Neeraj on 10/13/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import "PostCommentVC.h"
#import "CustomKeyboard.h"
#import "CommonHelper.h"
#import <CFNetwork/CFNetwork.h>
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "JSON.h"
@interface PostCommentVC ()<UITextViewDelegate,CustomKeyboardDelegate,UITextFieldDelegate>
{
     CustomKeyboard *customkeyboard;
    BOOL indexTab;
}
@end

@implementation PostCommentVC

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
        self.lblTitle.text = POST_A_COMMENT_ENGLISH;
        [self.btnPostAcomment setTitle:POST_A_COMMENT_ENGLISH forState:UIControlStateNormal];
    }
    else
    {
        
        self.lblTitle.text =POST_A_COMMENT_SPAINSH;
        [self.btnPostAcomment setTitle:POST_A_COMMENT_SPAINSH forState:UIControlStateNormal];
    }
    customkeyboard = [[CustomKeyboard alloc] init];
    customkeyboard.delegate = self;
    self.tvComment.inputAccessoryView = [customkeyboard getToolbarWithPrevNextDone:YES :NO];
    self.txfName.inputAccessoryView = [customkeyboard getToolbarWithPrevNextDone:YES :NO];
    if (IPHONE_4) {
         [self.scrollPage setContentSize:CGSizeMake(self.scrollPage.frame.size.width, self.scrollPage.frame.size.height)];
    }
    else
    {
         [self.scrollPage setContentSize:CGSizeMake(self.scrollPage.frame.size.width, self.scrollPage.frame.size.height+50)];
    }
   
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) textViewDidBeginEditing:(UITextView *)textView
{
    indexTab = 2;
    if (!IS_IPAD) {
        [self.scrollPage setContentOffset:CGPointMake(0,100) animated:YES];
    }
}
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    indexTab =1;
}
- (IBAction)doBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.tvComment resignFirstResponder];
    [self.tvComment resignFirstResponder];
    [self.txfName resignFirstResponder];
    [self.scrollPage setContentOffset:CGPointMake(0,0) animated:YES];
}


- (IBAction)touchScroll:(id)sender {
    [self.tvComment resignFirstResponder];
    [self.txfName resignFirstResponder];
     [self.scrollPage setContentOffset:CGPointMake(0,0) animated:YES];
}


-(void) cancelClicked:(NSUInteger)selectedId
{
    if (indexTab==1) {
        [self.txfName resignFirstResponder];
    }
    else
    {
        [self.tvComment resignFirstResponder];
    }
    
}

-(void) doneClicked:(NSUInteger)selectedId
{
    if (indexTab==1) {
         [self.tvComment becomeFirstResponder];
    }
    else
    {
         [self.tvComment resignFirstResponder];
        [self.scrollPage setContentOffset:CGPointMake(0,0) animated:YES];
        
    }
   
}
- (IBAction)doPostComment:(id)sender {
    if (self.txfName.text.length ==0) {
        [CommonHelper showAlert:@"Name is required"];
        [self.txfName becomeFirstResponder];
    }
    else if (self.tvComment.text.length ==0) {
        [CommonHelper showAlert:@"Comment is required"];
        [self.tvComment becomeFirstResponder];
    }
    else
        
    {
        [CommonHelper showBusyView];
        NSDictionary *parameters = @{@"key":@"5583ba04d14de2e2a04c2ff7dcd7f504",@"name":self.txfName.text,@"comment":self.tvComment.text,@"thread":self.eventObj.eventID };
        NSLog(@"Parame %@",parameters);
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        NSURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"http://grupointocable.com/_ws/intocable/english/comments/index.php" parameters:parameters];
        AFHTTPRequestOperation *operation1 = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // Success
            
            //NSDictionary *dic = [operation.responseString JSONValue];
            NSLog(@"Reponse %@",operation.responseString);
            [CommonHelper hideBusyView];
            [self.navigationController popViewControllerAnimated:YES];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            //[CommonHelper showAlert:error.description];
            NSLog(@"AFHTTPRequestOperation Failure: %@", error);
            [CommonHelper hideBusyView];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [operation1 start];
    
    }
}
@end
