//
//  ForecastTableViewCell.m
//  WeatherForecast
//
//  Created by Shannon on 13/11/2015.
//  Copyright © 2015 Shannon Jiang. All rights reserved.
//

#import "ForecastTableViewCell.h"

@implementation ForecastTableViewCell

-(void)configureWith:(Forecast*)forecast {
    
    if (forecast) {
        self.timeLabel.text = forecast.time;
        self.temperatureLabel.text = forecast.temperature;
        self.summaryLabel.text = forecast.summary;
    }
    else {
        self.timeLabel.text = @"";
        self.temperatureLabel.text = @"";
        self.summaryLabel.text = @"";
    }
}

@end
