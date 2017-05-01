//
//  NetworkService.m
//  VK videos
//
//  Created by 1 on 02.05.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import "NetworkService.h"
#import <UIKit/UIKit.h>

@interface NetworkService()
@end

@implementation NetworkService

- (instancetype)init{
    self=[super init];
    if(self){
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}

- (void) performRequestWithHTTPS: (NSURL*) url andCompletionHandler:(void (^)(NSData *data))completionHandler {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        if (error) {
            NSLog(@"ERROR %@",error.localizedDescription);
        }
        else {
            NSHTTPURLResponse *resp =(NSHTTPURLResponse *)response;
            if (resp.statusCode==200){
                NSLog(@"network interactions were successful");
                completionHandler(data);
            }
        }
    }];
    [task resume];
}




@end
