//
//  VKVTableViewModel.m
//  VK videos
//
//  Created by 1 on 17.03.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

/*
 https://oauth.vk.com/authorize?client_id=5932466&display=page&redirect_uri=https://oauth.vk.com/blank.html&scope=video&response_type=token&v=5.52
 */


#import "VKVTableViewModel.h"
@interface VKVTableViewModel()
@property(nonatomic, getter=isNetworkActivityIndicatorVisible) BOOL networkActivityIndicatorVisible;
@end




@implementation VKVTableViewModel

-(void)getVideosWithOffset:(NSNumber*)offset forQueury:(NSString *)searchQuiery0{
    
    NSString *searchIntro=@"https://api.vk.com/method/video.search?q=";
    NSCharacterSet *allowedCharSet= [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *searchQuiery1=[searchQuiery0 stringByAddingPercentEncodingWithAllowedCharacters: allowedCharSet];
    
    NSString *otherParameters=@"&sort=2&count=40&offset=";
    if (offset) {otherParameters=[NSString stringWithFormat:@"%@%@", otherParameters,offset];}
    NSString *searchQuiery2=[searchQuiery1 stringByAppendingString:otherParameters];
    NSString *searchQuiery3=[searchIntro stringByAppendingString: searchQuiery2];
    
    NSString*accessToken= [self getAccessTokenFromSafePlace];
    NSString *accessTokenFinal=[@"&access_token="stringByAppendingString:accessToken];
    
    NSURL *finalURL=[NSURL URLWithString:[searchQuiery3 stringByAppendingString:accessTokenFinal]];
    
    [self performRequestWithHTTPS:finalURL];
    
}

-(NSString*)getAccessTokenFromSafePlace{
    NSString* accessToken=[[NSString alloc]init];
    accessToken=[[NSUserDefaults standardUserDefaults] objectForKey:@"VKAccessToken"];
    
    return accessToken;
}

-(void) performRequestWithHTTPS: (NSURL*) url {
    
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        if (error) {
            NSLog(@"ERROR %@",error.localizedDescription);
        }
        else {
            NSHTTPURLResponse *resp =(NSHTTPURLResponse *)response;
            if (resp.statusCode==200){
                NSLog(@"network interactions were successful");
                [self useData:data];
            }
        }
    }];
    [task resume];
}

-(void) useData: (NSData *_Nullable)  data{
    
    if(!_videoArray) _videoArray=[[NSMutableArray alloc]init];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
    if (!json) {
        NSLog(@"Error parsing JSON: %@", error);
        return;
    }
    
    if ([json valueForKey:@"error"]) {
        NSLog(@"useData: error_code: %@",[json valueForKey:@"error_code"]);
        NSLog(@"useData: error_msg : %@",[json valueForKey:@"error_msg"]);
    }
    else{
        for (id dict in [json valueForKey:@"response"]){
            VideoData* videoInfo=[[VideoData alloc]initWithDictionary:dict];
            [_videoArray addObject:videoInfo];
            
        }
        dispatch_async(dispatch_get_main_queue(),^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"got forty" object:self];
        });
    }
}

-(void)getImagesForObject:(VideoData*) videoData forIndexPath:(NSIndexPath*)indexpath withCompletionHandler:(void(^)())completionHandler{
    NSLog(@"started loading image for indexpath %ld %@",indexpath.row, videoData.imageURL);
    if (videoData.imageURL!=nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        });
        
        NSURL*url=[NSURL URLWithString:videoData.imageURL];
        NSURLSession *imageSession=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        videoData.task=[imageSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });
            if (error) {
                NSLog(@"getImages: ERROR %@",error.localizedDescription);
            }
            else{
                videoData.image= [[UIImage alloc]initWithData:data];
                CGSize itemSize = CGSizeMake(100, 100);
                UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
                CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                [videoData.image drawInRect:imageRect];
                videoData.image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                
                NSLog(@"finished loading image for indexpath %ld",indexpath.row);
                dispatch_async(dispatch_get_main_queue(), ^{ completionHandler();});
            }
            
        }];
        
        [videoData.task resume];
        
    }
}

-(void)stopDownloads:(NSMutableDictionary *)downloadsDict{
    for ( VideoData* data in downloadsDict) {
        [data.task cancel];
    }
}

-(void)clear{
    [_videoArray removeAllObjects];
}

@end
