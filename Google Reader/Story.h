//
//  Story.h
//  Google Reader
//
//  Created by Justin Oakes on 7/31/15.
//  Copyright (c) 2015 Oklasoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Story : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * destinationText;

@end
