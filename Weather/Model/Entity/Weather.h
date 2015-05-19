//
//  Weather.h
//  Weather
//
//  Created by Yan Saraev on 5/19/15.
//  Copyright (c) 2015 Next Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Weather : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * temperature;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSManagedObject *city;


+ (Weather *)weatherWithInfo:(NSDictionary *)info forCityName:(NSString *)name;

@end
