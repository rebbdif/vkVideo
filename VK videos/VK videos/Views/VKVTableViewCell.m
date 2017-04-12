//
//  VKVTableViewCell.m
//  VK videos
//
//  Created by 1 on 18.03.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import "VKVTableViewCell.h"



@implementation VKVTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    UITableViewCellStyle styleSubt = UITableViewCellStyleSubtitle;
    self = [super initWithStyle:styleSubt reuseIdentifier:@"tableViewCell"];
    
    [self.textLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    
    /*
     if (self) {
     // Helpers
     CGSize size = self.contentView.frame.size;
     
     // Initialize Main Label
     self.mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 8.0, size.width - 16.0, size.height - 16.0)];
     
     // Configure Main Label
     [self.mainLabel setFont:[UIFont boldSystemFontOfSize:24.0]];
     [self.mainLabel setTextAlignment:NSTextAlignmentCenter];
     [self.mainLabel setTextColor:[UIColor orangeColor]];
     [self.mainLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
     
     // Add Main Label to Content View
     [self.contentView addSubview:self.mainLabel];
     }
     */
    return self;
}

- (void)prepareForReuse{
    [self clearCell];
    [super prepareForReuse];
}

-(void) clearCell{
    self.imageView.image=nil;
    self.textLabel.text=nil;
    self.detailTextLabel.text=nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
