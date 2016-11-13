//
//  LocationVC.m
//  Intocable
//
//  Created by Neeraj on 10/13/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import "LocationVC.h"

@interface LocationVC ()

@end

@implementation LocationVC

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
    self.lblTitlePage.text = self.title;
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.strLink]]];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
