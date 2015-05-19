//
//  WTDescriptionController.m
//  Weather
//
//  Created by Yan Saraev on 5/19/15.
//  Copyright (c) 2015 Next Technology. All rights reserved.
//

#import "WTDescriptionController.h"
#import "City.h"


@interface WTDescriptionController ()

@property (strong, nonatomic) NSArray * dataSource;

@end

@implementation WTDescriptionController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.myNavigationItem.title = self.city.name;
	self.dataSource = @[@"lat", @"lon", @"grnd_level", @"sea_level"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	cell.textLabel.text = self.dataSource[indexPath.row];
	cell.detailTextLabel.text = [self.city valueForKey:self.dataSource[indexPath.row]];
	return cell;
}

- (IBAction)backPressed:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

@end
