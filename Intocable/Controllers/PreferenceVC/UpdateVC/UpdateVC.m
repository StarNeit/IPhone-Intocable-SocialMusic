//
//  UpdateVC.m
//  Intocable
//
//  Created by Neeraj on 10/10/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import "UpdateVC.h"

@interface UpdateVC ()

@end

@implementation UpdateVC

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
    [super viewWillAppear:YES];
    [self settitlePage];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IS_UPDATE"]) {
        [self.btnSwitch setOn:YES];
    }
    else
    {
        [self.btnSwitch setOn:NO];
    }
}
- (IBAction)doBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) settitlePage
{
    int language =[[USER_DEFAULT valueForKey:@"IS_LANGUAGE"] intValue];
    if (language==0) {
        self.lblTitle.text = TXT_UPDATE_ESPANOL;
        self.lblAutoUpdate.text = AUTO_UPDATE_SPAINSH;
    }
    else
    {
        self.lblTitle.text = TXT_UPDATE_ENGLISH;
        self.lblAutoUpdate.text = AUTO_UPDATE_ENGLISH;
    }
    
}
- (IBAction)doSwitch:(id)sender {
    if([sender isOn]){
        NSLog(@"Switch is ON");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IS_UPDATE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else{
        NSLog(@"Switch is OFF");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IS_UPDATE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
@end
