//
//  VKVTableViewController.m
//  VK videos
//
//  Created by 1 on 17.03.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import "VKVTableViewController.h"
#import "VKVTableViewModel.h"
#import "VKVTableView.h"
#import "VKVTableViewCell.h"
#import "VideoData.h"

#import "VKVVideoViewController.h"

@interface VKVTableViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (strong,nonatomic) VKVTableViewModel * model;
@property(strong, nonatomic) VKVTableView *tableView;
@property(strong,nonatomic) NSMutableDictionary *activeDownloads;
@property(strong,nonatomic)NSString*searchRequest;
@property(strong,nonatomic)UISearchBar *searchBar;
@end

@implementation VKVTableViewController

-(void) viewDidLoad{
    [super viewDidLoad];
    [self addTableView];
    _model=[[VKVTableViewModel alloc]init];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.opaque=NO;
  //  [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleBlackOpaque;
    
    
}

-(void) addTableView{
    _tableView=[[VKVTableView alloc]initWithFrame:self.view.bounds];
    [_tableView configureTableView];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[VKVTableViewCell class] forCellReuseIdentifier:@"tableViewCell"];
    
    _searchBar=[[UISearchBar alloc]init];
    _searchBar.placeholder=@"Введите название видео";
    [_searchBar sizeToFit];
    self.navigationItem.titleView = self.searchBar;
  //  self.navigationController.navigationItem.titleView=_searchBar;
    //self.tableView.tableHeaderView=_searchBar;
    _searchBar.delegate=self;
    [_searchBar becomeFirstResponder];
}

#pragma mark searchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    _searchRequest= searchBar.text;
    NSLog(@"searchBarSearchButtonClicked %@",_searchRequest);
    [searchBar endEditing:YES];
    if(_searchRequest){
        [_model stopDownloads:self.activeDownloads];
        [_model clear];
        [_tableView reloadData];
        [_model getVideosWithOffset:0 forQueury:_searchRequest];
    }

}

-(void) viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotForty) name:@"got forty" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:YES];
}
-(void)gotForty{
    NSLog(@"ready to present new values on TableView");
    [_searchBar resignFirstResponder];
    [_tableView becomeFirstResponder];
    [_tableView refreshControl];
    [_tableView reloadData];


}



#pragma mark - table view
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VKVTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier: @"tableViewCell" ];
    if (!cell){
        NSLog(@"nocell,%ld",(long)indexPath.row);
        cell=[[VKVTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"tableViewCell"];
    }
    VideoData * info=[_model.videoArray objectAtIndex:indexPath.row];
    // NSLog(@"row= %ld", (long)indexPath.row);
    cell.textLabel.text=info.videoName;
    cell.detailTextLabel.text=info.videoDuration;
    
    if (!info.image)
    {
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
        {
            [self askForImageForObject:info forIndexPath:indexPath];
        }
        cell.imageView.image=[UIImage imageNamed:@"noun_860149_cc.png"];
    }
    else
    {
        cell.imageView.image = info.image;
    }
    
    return cell;
}

-(void)askForImageForObject:(VideoData*)info forIndexPath:(NSIndexPath*)indexPath{
    if(info){
        if (!_activeDownloads){
            _activeDownloads= [[NSMutableDictionary alloc]init];
        }
        
        if(!_activeDownloads[indexPath]){
            [_activeDownloads setObject:info forKey:indexPath];
            [_model getImagesForObject:info forIndexPath:indexPath withCompletionHandler:^{
                UITableViewCell *insteadCell=[_tableView cellForRowAtIndexPath:indexPath];
                if (info.image){
                    insteadCell.imageView.image=info.image;
                }
                else {
                    insteadCell.imageView.image=[UIImage imageNamed:@"noun_887845_cc.png"];
                }
                [_activeDownloads removeObjectForKey:indexPath];
            }];
            
        }
    }
}

- (void)loadImagesForVisibleRows
{
    NSArray *visibleRows = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visibleRows)
    {
        VideoData *videoData =[_model.videoArray objectAtIndex:indexPath.row] ;
        if (!videoData.image)
        {
            [self askForImageForObject: videoData forIndexPath:indexPath];
        }
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForVisibleRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForVisibleRows];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==[_model.videoArray count]-1){
        NSLog(@"i need more %ld",indexPath.row);
        [_model getVideosWithOffset:[NSNumber numberWithUnsignedInteger:[_model.videoArray count]]forQueury:_searchRequest];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_model.videoArray) {
        return _model.videoArray.count;
    }
    else return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VKVVideoViewController* vvc=[[VKVVideoViewController alloc] init];
    VideoData *thisVideo= [_model.videoArray objectAtIndex:indexPath.row];
    if (thisVideo.videoURL!=nil) {
        vvc.videoURL= thisVideo.videoURL;
        [self showViewController:vvc sender:self];
    }
    
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [_model stopDownloads:self.activeDownloads];
    [_model clear];
}

-(void)dealloc{
    [_model stopDownloads:self.activeDownloads];
}

@end
