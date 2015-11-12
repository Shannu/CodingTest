//
//  ViewController.h
//  WeatherForecast
//
//  Created by Shannon on 12/11/2015.
//  Copyright © 2015 Shannon Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Forecast.h"

#define kForecastURL @"https://api.forecast.io/forecast"
#define kForecastAPIKey @"046c160f8956ce4d61fc21bbd9f62937"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate> {
    
    CLLocationManager *locationManager;
}

@property (nonatomic, strong) Forecast *currentlyWeather;
@property (nonatomic, strong) NSMutableArray *dailyForecasts;
@property (nonatomic, strong) NSMutableArray *hourlyForecasts;

@property (nonatomic, strong) NSOperationQueue *queue;


@property (weak, nonatomic) IBOutlet UILabel *currentSummary;
@property (weak, nonatomic) IBOutlet UILabel *currentTemperature;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *forecastTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

