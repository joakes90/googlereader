//
//  Google_ReaderTests.m
//  Google ReaderTests
//
//  Created by Justin Oakes on 7/30/15.
//  Copyright (c) 2015 Oklasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "StoryManager.h"
#import "Stack.h"
#import "Story.h"

@interface Google_ReaderTests : XCTestCase

@end

@implementation Google_ReaderTests

- (void)setUp {
    [super setUp];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StoriesAreSuccessfulyBeingSaved) name:@"storiesUpdated" object:nil];
}

- (void)tearDown {
    [super tearDown];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)StoriesAreSuccessfulyBeingSaved {
    if ([[StoryManager sharedInstance].Stories count] > 0) {
        NSLog(@"Stories are saved");
    }
}


-(void)testParsingForNewStoriesPerformance {
    [self measureBlock:^{
        [[StoryManager sharedInstance] parseForNewContent];
    }];
}



@end
