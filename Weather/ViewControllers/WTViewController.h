//
//  WTViewController.h
//  Weather
//
//  Created by Yan Saraev on 5/19/15.
//  Copyright (c) 2015 Next Technology. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WTViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextField *cityName;
@property (weak, nonatomic) IBOutlet UILabel *currentTemp;
@property (weak, nonatomic) IBOutlet UITableView *forecastTableView;
@property (weak, nonatomic) IBOutlet UILabel *currentTimestamp;
@property (weak, nonatomic) IBOutlet UILabel *weather;

@property (weak, nonatomic) IBOutlet UISegmentedControl * segmentedControl;

@end
