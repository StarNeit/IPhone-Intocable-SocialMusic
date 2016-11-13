//
//  ProductObj.h
//  Intocable
//
//  Created by Neeraj on 10/23/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductObj : NSObject
@property(nonatomic,retain) NSString *productID;
@property(nonatomic,retain) NSString *strThumbnail;
@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) UIImage *imgThumbnail;
@end
