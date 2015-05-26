//
//  WidgetLastNews.m
//  LocationWidget
//
//  Created by German Pereyra on 5/26/15.
//  Copyright (c) 2015 German Pereyra. All rights reserved.
//

#import "WidgetLastNews.h"

@implementation WidgetLastNews
- (NSDictionary *)convertToDictionary {
    return @{@"title":self.title, @"identifier":self.identifier, @"imageData":self.imageData};
}

- (instancetype)initWithDictionay:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.title = [dictionary objectForKey:@"title"];
        self.identifier = [dictionary objectForKey:@"identifier"];
        self.imageData = [dictionary objectForKey:@"imageData"];
    }
    return self;
}

@end
