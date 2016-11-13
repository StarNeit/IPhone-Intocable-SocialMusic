//
//  MusicCell.h
//  Intocable
//
//  Created by Neeraj on 10/8/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MusicCellDelegate;
@interface MusicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property(nonatomic,assign) int indexPath;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property(nonatomic,retain) id<MusicCellDelegate> delegate;
- (IBAction)doPlay:(id)sender;
- (IBAction)doBuy:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnBuy;
-(void) initBuy;

@end

@protocol MusicCellDelegate <NSObject>

-(void) actionClickPlayMusic:(int) index;
-(void) actionbuyMusic:(int) index;

@end


