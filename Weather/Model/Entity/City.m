//
//  City.m
//  Weather
//
//  Created by Yan Saraev on 5/19/15.
//  Copyright (c) 2015 Next Technology. All rights reserved.
//

#import "City.h"
#import "Weather.h"
#import "AppDelegate.h"

@implementation City

@dynamic grnd_level;
@dynamic id;
@dynamic lat;
@dynamic lon;
@dynamic name;
@dynamic sea_level;
@dynamic weather;

+ (City *)cityFromDictionary:(NSDictionary *)dict {
	NSManagedObjectContext * ctx = [[AppDelegate sharedDelegate] managedObjectContext];
	City * city = [NSEntityDescription insertNewObjectForEntityForName:@"City"
																							inManagedObjectContext:ctx];

	NSDictionary * info = dict[@"city"];
	city.id = info[@"id"];
	city.lat = [dict[@"city"][@"coord"][@"lat"] stringValue];
	city.lon = [dict[@"city"][@"coord"][@"lon"] stringValue];
	city.name = dict[@"city"][@"name"];

	return city;
}

+ (City *)createCityIfNeeded:(NSDictionary *)dict {
	NSManagedObjectContext * ctx = [[AppDelegate sharedDelegate] managedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"City"
																						inManagedObjectContext:ctx];
	[fetchRequest setEntity:entity];
	// Specify criteria for filtering which objects to fetch
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id==%@", dict[@"city"][@"id"]];
	[fetchRequest setPredicate:predicate];
	// Specify how the fetched objects should be sorted
	
	NSError *error = nil;
	NSArray *fetchedObjects = [ctx executeFetchRequest:fetchRequest error:&error];
	
	City * city = [fetchedObjects firstObject];
	if (!city) {
		city = [City cityFromDictionary:dict];
	}
		
	for (NSDictionary * weatherInfo in dict[@"list"]) {
		Weather * weather = [Weather weatherWithInfo:weatherInfo forCityName:city.name];
		[city addWeatherObject:weather];
	}

	return city;
}

- (NSArray *)forecastCount:(NSInteger)count {
	NSMutableArray * weathers = [[self.weather allObjects] mutableCopy];
	
	[weathers sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
	NSMutableArray * retVal = [NSMutableArray array];
	if (weathers.count >= count) {
		for (NSInteger idx = 0; idx < count; idx++) {
			[retVal addObject:weathers[idx]];
		}
	}
	return retVal;
}

@end
