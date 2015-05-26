//
//  LastestNewsManager.h
//  LocationWidget
//
//  Created by German Pereyra on 5/26/15.
//  Copyright (c) 2015 German Pereyra. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kLastestNewsManagerLastUpdateTime @"lastUpdate"
#define kLastestNewsManagerLastestNewsArray @"lastestNews"

@interface LastestNewsManager : NSObject
- (void)loadLastestNewsWithSuccessCompletition:(void (^)(NSDictionary * result))onSuccess onFailCompletition:(void (^)(NSError * error))onFail;
@end
