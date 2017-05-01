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
}


@end
