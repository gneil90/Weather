//
//  WTDescriptionController.h
//  Weather
//
//  Created by Yan Saraev on 5/19/15.
//  Copyright (c) 2015 Next Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
@class City;

@interface WTDescriptionController : UITableViewController

@property (strong, nonatomic) City * city;
@property (weak, nonatomic) IBOutlet UINavigationItem * myNavigationItem;


@end
