//
//  Forecast.h
//  WeatherForecast
//
//  Created by Shannon on 12/11/2015.
//  Copyright © 2015 Shannon Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, ForecastType) {
    ForecastTypeCurrently = 0,
    ForecastTypeHourly,
    ForecastTypeDaily,
    ForecastTypeUnknown,
};


@interface Forecast : NSObject

@property (nonatomic) ForecastType type;
@property (nonatomic, retain) NSString* time;
@property (nonatomic, retain) NSString* summary;
@property (nonatomic, retain) NSString* temperature;
@property (nonatomic, retain) NSString* minTemperature;
@property (nonatomic, retain) NSString* maxTemperature;

@end
