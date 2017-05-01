//
//  VKVTableViewModel.m
//  VK videos
//
//  Created by 1 on 17.03.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import "VKVTableViewModel.h"
#import "NetworkService.h"

@interface VKVTableViewModel()

@property(strong,nonatomic) NetworkService *networkService;

@end

@implementation VKVTableViewModel

-(instancetype)init{
    self=[super init];
    if(self){
        _networkService=[NetworkService new];
    }
    return self;
}

-(void)getVideosWithOffset:(NSNumber*)offset forQueury:(NSString *)searchQuiery0{
    NSString *searchQuiery1=[searchQuiery0 stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *otherParameters=@"&sort=2&count=40&offset=";
    if (offset) {otherParameters=[NSString stringWithFormat:@"%@%@", otherParameters,offset];}
    NSString*accessToken= [self getAccessTokenFromSafePlace];
    NSString *url=[NSString stringWithFormat:@"https://api.vk.com/method/video.search?q=%@%@&access_token=%@",searchQuiery1,otherParameters,accessToken];

    __weak typeof(self) weakself=self;
    [self.networkService performRequestWithHTTPS:[NSURL URLWithString:url] andCompletionHandler:^(NSData *data) {
        [weakself useData:data];
    }];
}

-(NSString*)getAccessTokenFromSafePlace{
    NSString* accessToken=[[NSString alloc]init];
    accessToken=[[NSUserDefaults standardUserDefaults] objectForKey:@"VKAccessToken"];
    return accessToken;
}

- (void) useData: (NSData *_Nullable)  data{
    if(!self.videoArray) self.videoArray=[[NSMutableArray alloc]init];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
    if (!json) {
        NSLog(@"Error parsing JSON: %@", error);
        return;
    }
    if ([json valueForKey:@"error"]) {
        NSLog(@"useData: error_msg : %@",[json valueForKey:@"error_msg"]);
    }
    else{
        NSMutableArray *newVideos=[[NSMutableArray alloc]initWithArray:self.videoArray];
        for (id dict in [json valueForKey:@"response"]){
            [newVideos addObject:[VideoData videoWithDictionary:dict]];
        }
        self.videoArray=newVideos;
        dispatch_async(dispatch_get_main_queue(),^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"got forty" object:self];
        });
    }
}

- (void)getImagesForObject:(VideoData*) videoData forIndexPath:(NSIndexPath*)indexpath withCompletionHandler:(void(^)())completionHandler{
    NSLog(@"started loading image for indexpath %ld %@",indexpath.row, videoData.imageURL);
    if (videoData.imageURL!=nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        });
        
        videoData.task=[self.networkService.session dataTaskWithURL:[NSURL URLWithString:videoData.imageURL] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
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
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler();
                });
            }
        }];
        [videoData.task resume];
        
    }
}

- (void)stopDownloads:(NSMutableDictionary *)downloadsDict{
    for ( VideoData* data in downloadsDict) {
        [data.task cancel];
    }
}

- (void)clear{
    _videoArray=nil;
}

@end
