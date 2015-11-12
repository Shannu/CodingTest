//
//  ForecastJsonParser.h
//  WeatherForecast
//
//  Created by Shannon on 12/11/2015.
//  Copyright © 2015 Shannon Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Forecast.h"

@interface ForecastJsonParser : NSOperation


@property (nonatomic, strong) NSData* inputData;

@property (nonatomic, strong, readonly) Forecast* currentWeather;
@property (nonatomic, strong, readonly) NSMutableArray* hourlyForecastList;
@property (nonatomic, strong, readonly) NSMutableArray* dailyForecastList;

@property (nonatomic, copy) void (^errorHandler)(NSError *error);

-(instancetype) initWithData:(NSData *)data;

@end
