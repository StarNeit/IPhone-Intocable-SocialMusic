//
//  NotificationVC.m
//  Intocable
//
//  Created by Neeraj on 10/10/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import "NotificationVC.h"
#import <CFNetwork/CFNetwork.h>
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "JSON.h"
#import "CommonHelper.h"
#import "SVProgressHUD.h"

@interface NotificationVC ()

@end

@implementation NotificationVC

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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated
{
    [self settitlePage];
    [super viewWillAppear:YES];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IS_PUSH"]) {
        [self.btnSwitch setOn:YES];
    }
    else
    {
        [self.btnSwitch setOn:NO];
    }
    
}
-(void) settitlePage
{
    int language =[[USER_DEFAULT valueForKey:@"IS_LANGUAGE"] intValue];
    if (language==0) {
        self.lblTitle.text = TXT_NOTIFICATION_ESPANOL;
        self.lblNotification.text  =TXT_NOTIFICATION_ESPANOL;
    }
    else
    {
        self.lblTitle.text = TXT_NOTIFICATION_ENGLISH;
        self.lblNotification.text = TXT_NOTIFICATION_ENGLISH;
    }
    
}
- (IBAction)doBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)doSwitch:(id)sender {
    if([sender isOn]){
        NSLog(@"Switch is ON");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IS_PUSH"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //[self callWSResgister:YES];
    } else{
        NSLog(@"Switch is OFF");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IS_PUSH"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //[self callWSResgister:NO];
    }
}

-(void) callWSResgister:(Boolean) noti
{
    [CommonHelper showBusyView];
    NSDictionary *parameters = @{@"key":@"5583ba04d14de2e2a04c2ff7dcd7f504",@"apns":[[NSUserDefaults standardUserDefaults] valueForKey:@"UUID"],@"udid":[CommonHelper appDelegate].strToken,@"notification":[NSString stringWithFormat:@"%d",noti] };
    NSLog(@"Parame %@",parameters);
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    NSURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"http://grupointocable.com/_ws/api/register.php" parameters:parameters];
    AFHTTPRequestOperation *operation1 = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Reponse %@",operation.responseString);
        [CommonHelper hideBusyView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"AFHTTPRequestOperation Failure: %@", error);
        [CommonHelper hideBusyView];
        
    }];
    [operation1 start];
    
}
@end
