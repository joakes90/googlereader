//
//  StoryManager.h
//  Google Reader
//
//  Created by Justin Oakes on 7/30/15.
//  Copyright (c) 2015 Oklasoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoryManager : NSObject

@property (strong, readonly) NSMutableArray *Stories;

+ (instancetype) sharedInstance;

-(void)parseForNewContent;

@end
