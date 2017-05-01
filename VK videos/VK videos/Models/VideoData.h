//
//  VideoData.h
//  VK videos
//
//  Created by 1 on 21.03.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VideoData : NSObject
@property(strong,nonatomic)NSString*videoName;
@property(strong,nonatomic)NSString*videoDuration;
@property(strong,nonatomic)NSString*imageURL;
@property(strong,nonatomic)NSString *videoURL;
@property(strong,nonatomic)UIImage *image;
@property(strong,nonatomic) NSURLSessionDataTask *task;
+ (VideoData*)videoWithDictionary: (NSDictionary*)dict;
@end

