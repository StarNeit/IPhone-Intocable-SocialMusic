//
//  MediaVC.h
//  Intocable
//
//  Created by Neeraj on 10/6/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridView.h"
@interface MediaVC : UIViewController
{
    NSMutableArray *_selections;
}

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (weak, nonatomic) IBOutlet UIImageView *linePhotoOn;
@property (weak, nonatomic) IBOutlet UIImageView *lineVideoOn;
@property (weak, nonatomic) IBOutlet UIView *subTab;
@property (weak, nonatomic) IBOutlet UIGridView *tblPhotos;
- (IBAction)doPhotos:(id)sender;
- (IBAction)doVideos:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnPhoto;
@property (weak, nonatomic) IBOutlet UIButton *btnVideo;
@property (weak, nonatomic) IBOutlet UIButton *btnPhotos;
- (IBAction)doHome:(id)sender;

@end
