//
//  StoryTableViewCell.h
//  Google Reader
//
//  Created by Justin Oakes on 7/30/15.
//  Copyright (c) 2015 Oklasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Story.h"

@interface StoryTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIWebView *abstractWebViw;

@property (strong, nonatomic) Story *cellStory;

@end
