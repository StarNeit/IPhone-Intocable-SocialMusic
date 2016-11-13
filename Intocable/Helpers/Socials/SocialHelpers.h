//
//  TwitterHelpers.h
//  PersonalApp
//
//  Created by Victor NGO on 7/22/14.
//  Copyright (c) 2014 Victor NGO. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ShareTwitterAccount : NSObject

@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *avatarUrl;


@end

@interface ShareFacebookAccount : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *name;


@end
typedef void (^SocialHelpersBlock) (BOOL success,NSInteger intValue, id objectValue);

@interface SocialHelpers : NSObject
{
    SocialHelpersBlock _handler;
}

+ (SocialHelpers *) sharedManager;

@property (nonatomic,strong) ShareTwitterAccount *shareTwitterAccount;
@property (nonatomic,strong) ShareFacebookAccount *shareFacebookAccount;


- (void) getTwitterProfile:(NSString *)username completionHander:(SocialHelpersBlock)handler;

- (void) getFacebookProfile:(NSString *)username completionHandler:(SocialHelpersBlock)handler;

- (void)fetchTimelineForUser:(NSString *)username completionHandler:(SocialHelpersBlock)handler;

- (void)fetchTimelineFacebookForUser:(NSString *)username completionHandler:(SocialHelpersBlock)handler;

- (void)postMessage:(NSString *)msg;

- (void)postComment:(NSString *)postId message:(NSString *)msg;


@end




