//
//  ForecastJsonParser.m
//  WeatherForecast
//
//  Created by Shannon on 12/11/2015.
//  Copyright © 2015 Shannon Jiang. All rights reserved.
//

#import "ForecastJsonParser.h"

@implementation ForecastJsonParser


-(instancetype) initWithData:(NSData *)data {
    self = [super init];
    if (self != nil)
    {
        _inputData = data;
    }
    return self;
}


-(void) main {
    
    if (self.inputData) {
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData: self.inputData
                                                            options: NSJSONReadingMutableContainers
                                                              error: &error];
        
        _dailyForecastList = [[NSMutableArray alloc] init];
        
        if (dic != nil) {
            
            // Parse currently values
            NSDictionary* currentlyDictionary = dic[@"currently"];
            if (currentlyDictionary != nil) {
                _currentWeather = [[Forecast alloc] init];
                _currentWeather.type = ForecastTypeCurrently;
                _currentWeather.time = [self formatDateWithValue:[currentlyDictionary[@"time"] doubleValue] type:ForecastTypeCurrently];
                _currentWeather.summary = currentlyDictionary[@"summary"];
                _currentWeather.temperature = [self formatTemperature:currentlyDictionary[@"temperature"]];
                _currentWeather.minTemperature = @"NA";
                _currentWeather.maxTemperature = @"NA";
            }
            
            // Parse hourly values
            NSDictionary* hourlyDictionary = dic[@"hourly"];
            if (hourlyDictionary != nil) {
                
                _hourlyForecastList = [[NSMutableArray alloc] init];
                
                NSArray* hourlyDataList = hourlyDictionary[@"data"];
                for (NSDictionary* hourlyData in hourlyDataList) {
                    Forecast* hourlyForecast = [[Forecast alloc] init];
                    hourlyForecast.type = ForecastTypeHourly;
                    hourlyForecast.time = [self formatDateWithValue:[hourlyData[@"time"] doubleValue] type:ForecastTypeHourly];
                    hourlyForecast.summary = hourlyData[@"summary"];
                    hourlyForecast.temperature = [self formatTemperature:hourlyData[@"temperature"]];
                    hourlyForecast.minTemperature = @"NA";
                    hourlyForecast.maxTemperature = @"NA";
                    
                    [_hourlyForecastList addObject:hourlyForecast];
                }
            }
            
            // Parse daily values
            NSDictionary* dailyDictionary = dic[@"daily"];
            if (dailyDictionary != nil) {
                
                _dailyForecastList = [[NSMutableArray alloc] init];
                
                NSArray* dailyDataList = dailyDictionary[@"data"];
                for (NSDictionary* dailyData in dailyDataList) {
                    Forecast* dailyForecast = [[Forecast alloc] init];
                    dailyForecast.type = ForecastTypeDaily;
                    dailyForecast.time = [self formatDateWithValue:[dailyData[@"time"] doubleValue] type:ForecastTypeDaily];
                    dailyForecast.summary = dailyData[@"summary"];
                    dailyForecast.minTemperature = [self formatTemperature:dailyData[@"temperatureMin"]];
                    dailyForecast.maxTemperature = [self formatTemperature:dailyData[@"temperatureMax"]];
                    dailyForecast.temperature = [NSString stringWithFormat:@"%@-%@", dailyForecast.minTemperature, dailyForecast.maxTemperature];
                    
                    [_dailyForecastList addObject:dailyForecast];
                }
            }
        }
    }
}

-(NSString*) formatDateWithValue:(double)value type:(ForecastType)type {
    
    double timestampval =  value;
    NSTimeInterval timestamp = (NSTimeInterval)timestampval;
    NSDate *updatetimestamp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if (type == ForecastTypeHourly)
        [formatter setDateFormat:@"hha"];
    else if (type == ForecastTypeDaily)
        [formatter setDateFormat:@"d MMM"];
    else
        [formatter setDateFormat:@"dd MMM yyyy hh:mm:ss"];
    
    NSString *stringFromDate = [formatter stringFromDate:updatetimestamp];
    return stringFromDate;
}

-(NSString*) formatTemperature:(NSString*)value {
    if (value != nil) {
        double valueInDegree = ([value doubleValue]-39)*5/9;
        return [NSString stringWithFormat:@"%d°", (int)valueInDegree];
    }
    else
        return @"NA";
}

@end
