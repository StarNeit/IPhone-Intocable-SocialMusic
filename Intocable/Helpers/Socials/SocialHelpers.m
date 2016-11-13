//
//  TwitterHelpers.m
//  PersonalApp
//
//  Created by Victor NGO on 7/22/14.
//  Copyright (c) 2014 Victor NGO. All rights reserved.
//

#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "SocialHelpers.h"
#import "CommonHelper.h"
@interface SocialHelpers()
{
    ACAccount *_facebookAccount, *_twitterAccount;
    BOOL _isBusy;
}

@property (nonatomic) ACAccountStore *accountStore;



@end
@implementation SocialHelpers

+ (SocialHelpers *) sharedManager
{
    static SocialHelpers *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    return self;
}

- (BOOL)userHasAccessToFacebook
{
    NSLog(@"userHasAccessToFacebook");
    return [SLComposeViewController
            isAvailableForServiceType:SLServiceTypeFacebook];
}

- (BOOL)userHasAccessToTwitter
{
    NSLog(@"userHasAccessToTwitter");
    return [SLComposeViewController
            isAvailableForServiceType:SLServiceTypeTwitter];
}


- (void) getTwitterProfile:(NSString *)username completionHander:(SocialHelpersBlock)handler
{
    _handler = handler;
    //  Step 0: Check that the user has local Twitter accounts
    if ([self userHasAccessToTwitter]) {
        
        //  Step 1:  Obtain access to the user's Twitter accounts
        ACAccountType *twitterAccountType =
        [self.accountStore accountTypeWithAccountTypeIdentifier:
         ACAccountTypeIdentifierTwitter];
        
        [self.accountStore
         requestAccessToAccountsWithType:twitterAccountType
         options:NULL
         completion:^(BOOL granted, NSError *error) {
             if (granted) {
                 //  Step 2:  Create a request
                 
                 NSArray *twitterAccounts =
                 [self.accountStore accountsWithAccountType:twitterAccountType];
             
                 NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"];
                 NSDictionary *params = @{@"screen_name" : username,
                                          };
                 SLRequest *request =
                 [SLRequest requestForServiceType:SLServiceTypeTwitter
                                    requestMethod:SLRequestMethodGET
                                              URL:url
                                       parameters:params];
                 
                 //  Attach an account to the request
                 [request setAccount:[twitterAccounts lastObject]];
                 
                 //  Step 3:  Execute the request
                 [request performRequestWithHandler:
                  ^(NSData *responseData,
                    NSHTTPURLResponse *urlResponse,
                    NSError *error) {
                      
                      if (responseData) {
                          if (urlResponse.statusCode >= 200 &&
                              urlResponse.statusCode < 300) {
                              
                              NSError *jsonError;
                              NSDictionary *timelineData =
                              [NSJSONSerialization
                               JSONObjectWithData:responseData
                               options:NSJSONReadingAllowFragments error:&jsonError];
                              if (timelineData) {
                                      NSLog(@"Profile Response: %@\n", timelineData);
                                  if (_handler) {
                                      _handler(YES,0,timelineData);
                                  }
                              }
                              else {
                                  // Our JSON deserialization went awry
                                  NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                                  _handler(NO,0,nil);
                                  
                              }
                          }
                          else {
                              // The server did not respond ... were we rate-limited?
                              NSLog(@"The response status code is %d",
                                    urlResponse.statusCode);
                              _handler(NO,0,nil);
                              
                          }
                      }
                  }];
             }
             else {
                 // Access was not granted, or an error occurred
                 NSLog(@"%@", [error localizedDescription]);
                 _handler(NO,0,nil);
                 
             }
         }];
    }else{
        [CommonHelper hideBusyView];
        [[[UIAlertView alloc] initWithTitle:@"Please login your twitter account in Settings" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        
        _handler(NO,0,nil);
        
    }
}

- (void) getFacebookProfile:(NSString *)username completionHandler:(SocialHelpersBlock)handler
{
    _handler = handler;
    //  Step 0: Check that the user has local Twitter accounts
    if ([self userHasAccessToFacebook]) {
        
        //  Step 1:  Obtain access to the user's Twitter accounts
        ACAccountType *facebookAccountType =
        [self.accountStore accountTypeWithAccountTypeIdentifier:
         ACAccountTypeIdentifierFacebook];
        
        NSDictionary *options = @{
                                  ACFacebookAppIdKey: @"561946873861898",
                                  ACFacebookPermissionsKey: @[@"email",@"read_stream"],
                                  ACFacebookAudienceKey: ACFacebookAudienceEveryone
                                  };
        
        
        [self.accountStore
         requestAccessToAccountsWithType:facebookAccountType
         options:options
         completion:^(BOOL granted, NSError *error) {
             if (granted) {
                 //  Step 2:  Create a request
                 NSArray *facebookAccounts =
                 [self.accountStore accountsWithAccountType:facebookAccountType];
                 
                 NSDictionary *params =
                 @{@"access_token":[[facebookAccounts lastObject] credential].oauthToken,@"fields":@"id,name,picture"};
                 
                 NSURL *url = [NSURL
                               URLWithString:@"https://graph.facebook.com/v2.0/10972486708/"];
                 
                 SLRequest *request =
                 [SLRequest requestForServiceType:SLServiceTypeFacebook
                                    requestMethod:SLRequestMethodGET
                                              URL:url
                                       parameters:params];
                 
                 //  Attach an account to the request
                 
                 if (_facebookAccount == nil) {
                     _facebookAccount = [facebookAccounts lastObject];
                 }
                 [request setAccount:_facebookAccount];
                 
                 //  Step 3:  Execute the request                 
                 
                 [request performRequestWithHandler:
                  ^(NSData *responseData,
                    NSHTTPURLResponse *urlResponse,
                    NSError *error) {
                      
                      if (responseData) {
                          if (urlResponse.statusCode >= 200 &&
                              urlResponse.statusCode < 300) {
                              
                              NSError *jsonError;
                              NSDictionary *timelineData =
                              [NSJSONSerialization
                               JSONObjectWithData:responseData
                               options:NSJSONReadingAllowFragments error:&jsonError];
                              if (timelineData) {
                                  NSLog(@"Profile Response: %@\n", timelineData);
                                  if (_handler) {
                                      _handler(YES,0,timelineData);
                                  }
                              }
                              else {
                                  // Our JSON deserialization went awry
                                  NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                                  _handler(NO,0,nil);
                                  
                              }
                          }
                          else {
                              // The server did not respond ... were we rate-limited?
                              NSLog(@"The response status code is %d",
                                    urlResponse.statusCode);
                              _handler(NO,0,nil);
                              
                          }
                      }
                  }];
             }
             else {
                 // Access was not granted, or an error occurred
                 NSLog(@"%@", [error localizedDescription]);
                 _handler(NO,0,nil);
                 
             }
         }];
    }else{
        [CommonHelper hideBusyView];
        [[[UIAlertView alloc] initWithTitle:@"Please login your facebook account in Settings" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];

        _handler(NO,0,nil);
        
    }

}

- (void)fetchTimelineForUser:(NSString *)username completionHandler:(SocialHelpersBlock)handler
{
    _handler = handler;
    //  Step 0: Check that the user has local Twitter accounts
    if ([self userHasAccessToTwitter]) {
        
        //  Step 1:  Obtain access to the user's Twitter accounts
        ACAccountType *twitterAccountType =
        [self.accountStore accountTypeWithAccountTypeIdentifier:
         ACAccountTypeIdentifierTwitter];
        
        [self.accountStore
         requestAccessToAccountsWithType:twitterAccountType
         options:NULL
         completion:^(BOOL granted, NSError *error) {
             if (granted) {
                 //  Step 2:  Create a request
                 
                 NSArray *twitterAccounts =
                 [self.accountStore accountsWithAccountType:twitterAccountType];
                 NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                               @"/1.1/statuses/user_timeline.json"];
                 NSDictionary *params = @{@"screen_name" : username,
                                          @"include_rts" : @"0",
                                          @"trim_user" : @"1",
                                          @"count" : @"30"};
                 SLRequest *request =
                 [SLRequest requestForServiceType:SLServiceTypeTwitter
                                    requestMethod:SLRequestMethodGET
                                              URL:url
                                       parameters:params];
                 
                 //  Attach an account to the request
                 [request setAccount:[twitterAccounts lastObject]];
                 
                 //  Step 3:  Execute the request
                 [request performRequestWithHandler:
                  ^(NSData *responseData,
                    NSHTTPURLResponse *urlResponse,
                    NSError *error) {
                      
                      if (responseData) {
                          if (urlResponse.statusCode >= 200 &&
                              urlResponse.statusCode < 300) {
                              
                              NSError *jsonError;
                              NSDictionary *timelineData =
                              [NSJSONSerialization
                               JSONObjectWithData:responseData
                               options:NSJSONReadingAllowFragments error:&jsonError];
                              if (timelineData) {
                                  NSLog(@"Timeline Response: %@\n", timelineData);
                                  if (_handler) {
                                      _handler(YES,0,timelineData);
                                  }
                              }
                              else {
                                  // Our JSON deserialization went awry
                                  NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                                  _handler(NO,0,nil);

                              }
                          }
                          else {
                              // The server did not respond ... were we rate-limited?
                              NSLog(@"The response status code is %d",
                                    urlResponse.statusCode);
                              _handler(NO,0,nil);

                          }
                      }
                  }];
             }
             else {
                 // Access was not granted, or an error occurred
                 NSLog(@"%@", [error localizedDescription]);
                 _handler(NO,0,nil);

             }
         }];
    }else{
        _handler(NO,0,nil);

    }
    
}

- (void)fetchTimelineFacebookForUser:(NSString *)username completionHandler:(SocialHelpersBlock)handler
{
    _handler = handler;
    //  Step 0: Check that the user has local Twitter accounts
    if ([self userHasAccessToFacebook]) {
       
        
        NSDictionary *params =
        @{@"access_token":[_facebookAccount credential].oauthToken};
        
        NSURL *url = [NSURL
                      URLWithString:@"https://graph.facebook.com/v2.0/10972486708/feed"];
        
        SLRequest *request =
        [SLRequest requestForServiceType:SLServiceTypeFacebook
                           requestMethod:SLRequestMethodGET
                                     URL:url
                              parameters:params];
       
        [request setAccount:_facebookAccount];
        
        //  Step 3:  Execute the request
        
        [request performRequestWithHandler:
         ^(NSData *responseData,
           NSHTTPURLResponse *urlResponse,
           NSError *error) {
             
             if (responseData) {
                 if (urlResponse.statusCode >= 200 &&
                     urlResponse.statusCode < 300) {
                     
                     NSError *jsonError;
                     NSDictionary *timelineData =
                     [NSJSONSerialization
                      JSONObjectWithData:responseData
                      options:NSJSONReadingAllowFragments error:&jsonError];
                     if (timelineData) {
                         NSLog(@"Timeline Response: %@\n", timelineData);
                         if (_handler) {
                             _handler(YES,0,timelineData);
                         }
                     }
                     else {
                         // Our JSON deserialization went awry
                         NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                         _handler(NO,0,nil);
                         
                     }
                 }
                 else {
                     // The server did not respond ... were we rate-limited?
                     NSLog(@"The response status code is %ld",
                           (long)urlResponse.statusCode);
                     _handler(NO,0,nil);
                     
                 }
             }
         }];
  
    
    }else{
        _handler(NO,0,nil);
        
    }

}

- (void)postComment:(NSString *)postId message:(NSString *)msg
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *accountTypeFacebook =
    [accountStore accountTypeWithAccountTypeIdentifier:
     ACAccountTypeIdentifierFacebook];
    
    NSDictionary *options = @{
                              ACFacebookAppIdKey: @"878046662208837",
                              ACFacebookPermissionsKey: @[
                                      @"publish_actions"],
                              ACFacebookAudienceKey: ACFacebookAudienceFriends
                              };
    
    [accountStore requestAccessToAccountsWithType:accountTypeFacebook
                                          options:options
                                       completion:^(BOOL granted, NSError *error) {
                                           
                                           if(granted) {
                                               
                                               NSArray *accounts = [accountStore
                                                                    accountsWithAccountType:accountTypeFacebook];
                                               _facebookAccount = [accounts lastObject];
                                               
                                               NSDictionary *parameters =
                                               @{@"access_token":_facebookAccount.credential.oauthToken,
                                                 @"message": msg};
                                               
                                               NSURL *feedURL = [NSURL
                                                                 URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/v2.0/%@/likes",postId]];
                                               
                                               SLRequest *feedRequest =
                                               [SLRequest
                                                requestForServiceType:SLServiceTypeFacebook
                                                requestMethod:SLRequestMethodPOST
                                                URL:feedURL
                                                parameters:parameters];
                                               
                                               [feedRequest
                                                performRequestWithHandler:^(NSData *responseData,
                                                                            NSHTTPURLResponse *urlResponse, NSError *error)
                                                {
                                                    NSLog(@"Request failed, %@",
                                                          [urlResponse description]);
                                                }];
                                           } else {
                                               NSLog(@"Access Denied");
                                               NSLog(@"[%@]",[error localizedDescription]);
                                           }
                                       }];
}

- (void)postMessage:(NSString *)msg
{
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *accountTypeFacebook =
    [accountStore accountTypeWithAccountTypeIdentifier:
     ACAccountTypeIdentifierFacebook];
    
    NSDictionary *options = @{
                              ACFacebookAppIdKey: @"878046662208837",
                              ACFacebookPermissionsKey: @[
                                                          @"publish_actions"],
                              ACFacebookAudienceKey: ACFacebookAudienceFriends
                              };
    
    [accountStore requestAccessToAccountsWithType:accountTypeFacebook
                                          options:options
                                       completion:^(BOOL granted, NSError *error) {
                                           
                                           if(granted) {
                                               
                                               NSArray *accounts = [accountStore
                                                                    accountsWithAccountType:accountTypeFacebook];
                                               _facebookAccount = [accounts lastObject];
                                               
                                               NSDictionary *parameters =
                                               @{@"access_token":_facebookAccount.credential.oauthToken,
                                                 @"message": msg};
                                               
                                               NSURL *feedURL = [NSURL
                                                                 URLWithString:@"https://graph.facebook.com/v2.0/me/feed"];
                                               
                                               SLRequest *feedRequest =
                                               [SLRequest
                                                requestForServiceType:SLServiceTypeFacebook
                                                requestMethod:SLRequestMethodPOST
                                                URL:feedURL
                                                parameters:parameters];
                                               
                                               [feedRequest 
                                                performRequestWithHandler:^(NSData *responseData,
                                                                            NSHTTPURLResponse *urlResponse, NSError *error)
                                                {
                                                    NSLog(@"Request failed, %@", 
                                                          [urlResponse description]);
                                                }];
                                           } else {
                                               NSLog(@"Access Denied");
                                               NSLog(@"[%@]",[error localizedDescription]);
                                           }
                                       }];
    
}
#pragma mark - Privates


@end

@implementation ShareTwitterAccount


@end

@implementation ShareFacebookAccount

@end
