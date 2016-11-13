//
//  DetailNewVC.m
//  Intocable
//
//  Created by Neeraj on 10/23/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import "DetailNewVC.h"

@interface DetailNewVC ()

@end

@implementation DetailNewVC

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
    //self.webNews.scalesPageToFit = YES;
    self.lblTitle.text = self.objNew.title;
    NSString *strContent =@"";
    if (self.indexTab ==0) {
        if (IS_IPAD) {
             strContent = [NSString stringWithFormat:@"<img src ='%@' alt =''> \n",self.objNew.linkThumbnail];
        }
        else
        {
             strContent = [NSString stringWithFormat:@"<img src ='%@' alt ='' width ='300px' > \n",self.objNew.linkThumbnail];
        }
       
    }
    NSString *content =[self.objNew.body stringByReplacingOccurrencesOfString:@"(null)"
                                                      withString:@""];
    NSLog(@"COntent %@",content);
    [self.webNews loadHTMLString:[NSString stringWithFormat:@"%@%@",strContent,content] baseURL:nil];
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
