//
//  Weather.m
//  Weather
//
//  Created by Yan Saraev on 5/19/15.
//  Copyright (c) 2015 Next Technology. All rights reserved.
//

#import "Weather.h"
#import "AppDelegate.h"

@implementation Weather

@dynamic date;
@dynamic temperature;
@dynamic type;
@dynamic city;

+ (Weather *)weatherWithInfo:(NSDictionary *)info forCityName:(NSString *)name {
	NSManagedObjectContext * ctx = [[AppDelegate sharedDelegate] managedObjectContext];

	Weather * weather = [Weather weatherExists:info forCityName:name];
	if (!weather) {
		  weather = [NSEntityDescription insertNewObjectForEntityForName:@"Weather" inManagedObjectContext:ctx];
	}
	weather.temperature = info[@"temp"][@"day"];
	weather.date = info[@"dt"];
	return weather;
}

+ (Weather *)weatherExists:(NSDictionary *)dict forCityName:(NSString *)name {
	NSManagedObjectContext * ctx = [[AppDelegate sharedDelegate] managedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Weather"
																						inManagedObjectContext:ctx];
	[fetchRequest setEntity:entity];
	// Specify criteria for filtering which objects to fetch
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date==%@ AND city.name==%@", dict[@"dt"], name];
	[fetchRequest setPredicate:predicate];
	// Specify how the fetched objects should be sorted
	
	NSError *error = nil;
	NSArray *fetchedObjects = [ctx executeFetchRequest:fetchRequest error:&error];
	
	Weather * weather = [fetchedObjects firstObject];
	return weather;
}


@end
