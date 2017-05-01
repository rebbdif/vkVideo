//
//  VideoData.m
//  VK videos
//
//  Created by 1 on 21.03.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import "VideoData.h"

@implementation VideoData

+ (VideoData *)videoWithDictionary:(NSDictionary *)dict{
    VideoData*data=nil;
    data=[VideoData alloc];
    data.videoName=[dict valueForKey:@"title"];
    
    double seconds=[[dict valueForKey:@"duration"] doubleValue];
    data.videoDuration=[VideoData getTimeStringFromSeconds:seconds];
    
    data.videoURL=[dict valueForKey:@"player"];
    
    for (id key in dict ){
        if ([key hasPrefix:@"image"]) {
            data.imageURL=[dict valueForKey:key];
            break;
        }
        else if ([key hasPrefix:@"photo"]) {
            data.imageURL=[dict valueForKey:key];
            break;
        }
    }
    
    return data;
}



+ (NSString *)getTimeStringFromSeconds:(double)seconds
{
    NSDateComponentsFormatter *dcFormatter = [[NSDateComponentsFormatter alloc] init];
    dcFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
    dcFormatter.allowedUnits = NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond;
    dcFormatter.unitsStyle = NSDateComponentsFormatterUnitsStylePositional;
    return [dcFormatter stringFromTimeInterval:seconds];
}

@end

