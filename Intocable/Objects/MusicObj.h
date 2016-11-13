//
//  MusicObj.h
//  Intocable
//
//  Created by Neeraj on 10/8/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface MusicObj : NSObject
@property(nonatomic,retain) NSString *artist;
@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSString *linkBuy;
@property(nonatomic,retain) NSString *timer;
@property(nonatomic,assign) BOOL canBuy;
@property(nonatomic,assign) BOOL canPlay;
@property(nonatomic,retain) NSString *idMusic;
@property(nonatomic,retain) NSString *linkMusic;
@property(nonatomic,assign) BOOL isPlay;
@property(nonatomic,retain) AVPlayer *avPlayer;
@end
