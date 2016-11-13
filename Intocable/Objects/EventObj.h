//
//  EventObj.h
//  Intocable
//
//  Created by Neeraj on 10/22/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventObj : NSObject

@property(nonatomic,retain) NSString *eventID;
@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSString *time;
@property(nonatomic,retain) NSString *city;
@property(nonatomic,retain) NSString *state;
@property(nonatomic,retain) NSString *zip;
@property(nonatomic,retain) NSString *text;
@property(nonatomic,retain) NSString *day;
@end
