//
//  City.h
//  Weather
//
//  Created by Yan Saraev on 5/19/15.
//  Copyright (c) 2015 Next Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Weather;

@interface City : NSManagedObject

@property (nonatomic, retain) NSString * grnd_level;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * lat;
@property (nonatomic, retain) NSString * lon;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sea_level;
@property (nonatomic, retain) NSSet *weather;

+ (City *)cityFromDictionary:(NSDictionary *)dict;
+ (City *)createCityIfNeeded:(NSDictionary *)dict;
- (NSArray *)forecastCount:(NSInteger)count;

@end

@interface City (CoreDataGeneratedAccessors)

- (void)addWeatherObject:(Weather *)value;
- (void)removeWeatherObject:(Weather *)value;
- (void)addWeather:(NSSet *)values;
- (void)removeWeather:(NSSet *)values;

@end
