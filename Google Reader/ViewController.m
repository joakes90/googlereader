//
//  ViewController.m
//  Google Reader
//
//  Created by Justin Oakes on 7/30/15.
//  Copyright (c) 2015 Oklasoft. All rights reserved.
//

#import "ViewController.h"
#import "StoryManager.h"
#import "StoryTableViewCell.h"
#import "Story.h"
#import "DetailViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshController = [[UIRefreshControl alloc] init];
    self.refreshController.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    [self.refreshController addTarget:[StoryManager sharedInstance] action:@selector(parseForNewContent) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableView) name:@"storiesUpdated" object:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    [[StoryManager sharedInstance] parseForNewContent];
    if ([[StoryManager sharedInstance].Stories count] == 0) {
        [self performSegueWithIdentifier:@"noContent" sender:self];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)updateTableView {
    [self.refreshController endRefreshing];
    [self.tableView reloadData];
}

#pragma mark Tableview Delegate/Datasource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[StoryManager sharedInstance].Stories count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
     cell.cellStory = [[StoryManager sharedInstance].Stories objectAtIndex:([[StoryManager sharedInstance].Stories count] - (indexPath.row + 1))];
    cell.titleLabel.text = cell.cellStory.title;
    [cell.abstractWebViw loadHTMLString:[cell.cellStory.text stringByReplacingOccurrencesOfString:@"src=\"//" withString:@"src=\"https://"] baseURL:nil];
    return cell;
}

#pragma mark Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        DetailViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.story = [[StoryManager sharedInstance].Stories objectAtIndex:([[StoryManager sharedInstance].Stories count] - ([self.tableView indexPathForSelectedRow].row + 1))];
        
    }
}
@end
