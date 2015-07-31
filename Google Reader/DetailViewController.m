//
//  DetailViewController.m
//  Google Reader
//
//  Created by Justin Oakes on 7/30/15.
//  Copyright (c) 2015 Oklasoft. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation DetailViewController

-(void)viewDidAppear:(BOOL)animated {
//    NSString *htmlString = [self.story.text stringByReplacingOccurrencesOfString:@"src=\"//" withString:@"src=\"https://"];
    [self.webView loadHTMLString:self.story.destinationText baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
