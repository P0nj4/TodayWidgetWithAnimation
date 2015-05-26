//
//  LastestNewsManager.m
//  LocationWidget
//
//  Created by German Pereyra on 5/26/15.
//  Copyright (c) 2015 German Pereyra. All rights reserved.
//

#define kGroupId @"group.com.germanpereyra.test"
#define kHoursToUpdate 1.
#define kPreventCache NO

#import "LastestNewsManager.h"
#import "WidgetLastNews.h"

@interface LastestNewsManager ()
@property (nonatomic, strong) NSMutableDictionary *dicLastestNews;
@end

@implementation LastestNewsManager

- (void)loadLastestNewsWithSuccessCompletition:(void (^)(NSDictionary * result))onSuccess onFailCompletition:(void (^)(NSError * error))onFail {
    if (!self.dicLastestNews) {
        NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:kGroupId];
        containerURL = [containerURL URLByAppendingPathComponent:[NSString stringWithFormat:@"lastestNews.plist"]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[containerURL path]]) {
            self.dicLastestNews = [NSMutableDictionary dictionaryWithContentsOfURL:containerURL];
        }
        if (!kPreventCache && self.dicLastestNews && self.dicLastestNews[kLastestNewsManagerLastUpdateTime] && [self.dicLastestNews[kLastestNewsManagerLastUpdateTime] isKindOfClass:[NSDate class]]) {
            NSDate *lastUpdate = self.dicLastestNews[kLastestNewsManagerLastUpdateTime];
            NSTimeInterval diff = [[NSDate date] timeIntervalSinceDate:lastUpdate];
            float hours = (diff / 60) / 60;
            if (hours < kHoursToUpdate) {
                onSuccess(self.dicLastestNews);
                return;
            }
        }
        
        self.dicLastestNews = [[NSMutableDictionary alloc] init];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://primerahora.api.gfrmservices.com/v3/news/main/?api_key=xsrx2bwzzcu7hjc42qxsxh8z&count=5"]];
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            NSError *error = connectionError;
            NSDictionary *json;
            if (error) {
                onFail(error);
            } else {
                json = [NSJSONSerialization JSONObjectWithData:data
                                                       options:NSJSONReadingMutableContainers
                                                         error:&error];
                if (error || !json) {
                    onFail(error);
                } else {
                    for (NSDictionary *sectionItem in json) {
                        if (sectionItem[@"section"] && sectionItem[@"section"] != [NSNull null] && [sectionItem[@"section"] isEqualToString:@"ultimahora"]) {
                            if (sectionItem[@"items"] && sectionItem[@"items"] != [NSNull null] && [sectionItem[@"items"] isKindOfClass:[NSArray class]]) {
                                NSMutableArray *resultAux = [[NSMutableArray alloc] init];
                                for (NSDictionary *newsItem in sectionItem[@"items"]) {
                                    WidgetLastNews *aux = [[WidgetLastNews alloc] init];
                                    aux.identifier = [newsItem objectForKey:@"id"];
                                    aux.title = [newsItem objectForKey:@"title"];
                                    
                                    if ([newsItem objectForKey:@"images"] && [newsItem objectForKey:@"images"] != [NSNull null]) {
                                        NSDictionary *imagesData = [newsItem objectForKey:@"images"];
                                        if ([imagesData objectForKey:@"mobile"] && [imagesData objectForKey:@"mobile"] != [NSNull null]) {
                                            NSDictionary *mobileData = [imagesData objectForKey:@"mobile"];
                                            if ([mobileData objectForKey:@"thumb"] && [mobileData objectForKey:@"thumb"] != [NSNull null]) {
                                                NSString *path = [mobileData objectForKey:@"thumb"];
                                                NSURL *url = [NSURL URLWithString:path];
                                                aux.imageData = [NSData dataWithContentsOfURL:url];
                                            }
                                        }
                                    }
                                    [resultAux addObject:[aux convertToDictionary]];
                                }
                                [self.dicLastestNews setObject:resultAux forKey:kLastestNewsManagerLastestNewsArray];
                            }
                            
                        }
                    }
                    if (self.dicLastestNews) {
                        if ([[NSFileManager defaultManager] fileExistsAtPath:[containerURL path]]) {
                            [[NSFileManager defaultManager] removeItemAtURL:containerURL error:nil];
                        }
                        [self.dicLastestNews setObject:[NSDate date] forKey:kLastestNewsManagerLastUpdateTime];
                        [self.dicLastestNews writeToURL:containerURL atomically:YES];
                    }
                    onSuccess(self.dicLastestNews);
                }
            }
        }];
    }
}


@end
