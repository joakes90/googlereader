//
//  StoryManager.m
//  Google Reader
//
//  Created by Justin Oakes on 7/30/15.
//  Copyright (c) 2015 Oklasoft. All rights reserved.
//

#import "StoryManager.h"
#import "Stack.h"
#import "Story.h"

@interface StoryManager () <NSXMLParserDelegate>

@property (strong, nonatomic) NSMutableArray *Stories;
@property (strong, nonatomic) Story *Story;
@property (strong, nonatomic) NSString *elementBeingParsed;

@end

@implementation StoryManager

NSString *kEntityName = @"Story";
NSString *kFeedURLString = @"https://news.google.com/?output=rss";
NSString *kNotificationName = @"storiesUpdated";

+ (instancetype) sharedInstance {
    static StoryManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[StoryManager alloc] init];
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:kEntityName];
        sharedInstance.Stories = [NSMutableArray arrayWithArray:[[Stack sharedInstance].managedObjectContext executeFetchRequest:request error:nil]];
        sharedInstance.elementBeingParsed = [[NSString alloc] init];
    });
    return sharedInstance;
}

-(void)parseForNewContent {
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:kFeedURLString]];
    parser.delegate = self;
    
    [parser parse];
}


-(BOOL)checkIfStoryWithTitle:(NSString *)title {
    for (Story *story in self.Stories) {
        if ([story.title isEqualToString:title]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark NSXMLParser Delegate Methods

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    self.elementBeingParsed = elementName;
    if ([elementName isEqualToString:@"item"]) {
        self.Story = [NSEntityDescription insertNewObjectForEntityForName:kEntityName inManagedObjectContext:[Stack sharedInstance].managedObjectContext];
    }
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([self.elementBeingParsed isEqualToString:@"title"] && self.Story && self.Story.title) {
        if (![string containsString:@"Top Stories"]) {
            self.Story.title = [NSString stringWithFormat:@"%@%@", self.Story.title, string];
        }
    } else if ([self.elementBeingParsed isEqualToString:@"title"] && self.Story){
        self.Story.title = string;
    } else if ([self.elementBeingParsed isEqualToString:@"description"] && self.Story && self.Story.text){
        self.Story.text = [NSString stringWithFormat:@"%@%@", self.Story.text, string];
    }else if ([self.elementBeingParsed isEqualToString:@"description"] && self.Story){
        self.Story.text = string;
    }
    
    if ([self.elementBeingParsed isEqualToString:@"link"] && self.Story.link) {
        self.Story.link = [NSString stringWithFormat:@"%@%@", self.Story.link, string];
    }else if ([self.elementBeingParsed isEqualToString:@"link"] && self.Story){
        self.Story.link = string;
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"item"]) {
        if ([self checkIfStoryWithTitle:self.Story.title]) {
            [[Stack sharedInstance].managedObjectContext deleteObject:self.Story];
        } else {
            NSURL *linkURL = [NSURL URLWithString:self.Story.link];
            NSString *articalString = [NSString stringWithContentsOfURL:linkURL encoding:NSUTF8StringEncoding error:nil];
            self.Story.destinationText = articalString;
        }
    }else if ([elementName isEqualToString:@"rss"]){

        [[Stack sharedInstance].managedObjectContext save:nil];
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:kEntityName];
        self.Stories = [NSMutableArray arrayWithArray:[[Stack sharedInstance].managedObjectContext executeFetchRequest:request error:nil]];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationName object:nil];
    }
    
}

@end
