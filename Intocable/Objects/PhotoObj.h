//
//  PhotoObj.h
//  Intocable
//
//  Created by Neeraj on 10/22/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoObj : NSObject
@property(nonatomic,retain) NSString *photoID;
@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSString *linkImg;
@property(nonatomic,retain) UIImage *imgThumbnail;
@end
