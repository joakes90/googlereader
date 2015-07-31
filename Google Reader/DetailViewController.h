//
//  DetailViewController.h
//  Google Reader
//
//  Created by Justin Oakes on 7/30/15.
//  Copyright (c) 2015 Oklasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Story.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Story *story;

@end
