//
//  VKVTableViewModel.h
//  VK videos
//
//  Created by 1 on 17.03.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoData.h"

@interface VKVTableViewModel : NSObject
@property(copy,nonatomic) NSArray *videoArray;
@property(nonatomic, strong) NSString *tempToken;

-(void)getVideosWithOffset:(NSNumber*)offset forQueury: (NSString*)searchQuiery0;
-(void)getImagesForObject:(VideoData*) data forIndexPath:(NSIndexPath*)indexpath withCompletionHandler:(void(^)())completionHandler;
-(void)stopDownloads:(NSMutableDictionary*) downloadsDict;
-(void)clear;

@end
