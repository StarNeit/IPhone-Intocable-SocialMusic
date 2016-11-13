//
//  DetailMerchandiseVC.h
//  Intocable
//
//  Created by Neeraj on 10/10/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductObj.h"
@interface DetailMerchandiseVC : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollPage;
@property (weak, nonatomic) IBOutlet UIView *subThumbnail;
@property (weak, nonatomic) IBOutlet UIImageView *imgThumbnail;
@property (weak, nonatomic) IBOutlet UIView *subPrice;
@property(nonatomic,retain) ProductObj *productObj;
- (IBAction)doBack:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbltitleProduct;
@property (weak, nonatomic) IBOutlet UILabel *lblProduct;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnBuy;
@property (weak, nonatomic) IBOutlet UIButton *labelBuy;
- (IBAction)doBuy:(id)sender;

@end
