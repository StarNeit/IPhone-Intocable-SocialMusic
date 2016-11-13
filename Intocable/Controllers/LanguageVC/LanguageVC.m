//
//  LanguageVC.m
//  Intocable
//
//  Created by Neeraj on 10/6/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import "LanguageVC.h"
#import "CommonHelper.h"
@interface LanguageVC ()

@end

@implementation LanguageVC

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
    self.navigationController.navigationBarHidden = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doLanguage:(id)sender {
    UIButton *btn =(UIButton *) sender;
    if (btn.tag ==0) {
        [USER_DEFAULT setValue:@"0" forKey:@"IS_LANGUAGE"];
        [USER_DEFAULT synchronize];
    }else
    {
        [USER_DEFAULT setValue:@"1" forKey:@"IS_LANGUAGE"];
        [USER_DEFAULT synchronize];
    }
    [[CommonHelper appDelegate] initTabbar];
}
@end
