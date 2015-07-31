//
//  AppearanceController.m
//  Google Reader
//
//  Created by Justin Oakes on 7/31/15.
//  Copyright (c) 2015 Oklasoft. All rights reserved.
//

#import "AppearanceController.h"
@import UIKit;

@implementation AppearanceController

+(void)updateAppearance{
    [[UINavigationBar appearance] setBackgroundColor:[UIColor lightGrayColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor darkGrayColor]];
}

@end
