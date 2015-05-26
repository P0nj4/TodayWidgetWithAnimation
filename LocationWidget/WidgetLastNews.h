//
//  WidgetLastNews.h
//  LocationWidget
//
//  Created by German Pereyra on 5/26/15.
//  Copyright (c) 2015 German Pereyra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WidgetLastNews : NSObject
@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSData *imageData;
- (NSDictionary *)convertToDictionary;
- (instancetype)initWithDictionay:(NSDictionary *)dictionary;

@end
