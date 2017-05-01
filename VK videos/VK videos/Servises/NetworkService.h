//
//  NetworkService.h
//  VK videos
//
//  Created by 1 on 02.05.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkService : NSObject
@property (strong,nonatomic)NSURLSession *session;
- (void) performRequestWithHTTPS: (NSURL*) url andCompletionHandler:(void (^)(NSData *data))completionHandler;

@end
