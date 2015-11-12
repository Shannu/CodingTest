//
//  ForecastTableViewCell.h
//  WeatherForecast
//
//  Created by Shannon on 13/11/2015.
//  Copyright © 2015 Shannon Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Forecast.h"

@interface ForecastTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;

-(void)configureWith:(Forecast*)forecast;

@end
