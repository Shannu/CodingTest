//
//  ViewController.m
//  WeatherForecast
//
//  Created by Shannon on 12/11/2015.
//  Copyright © 2015 Shannon Jiang. All rights reserved.
//

#import "ViewController.h"
#import "ForecastJsonParser.h"
#import "ForecastTableViewCell.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.forecastTableView.dataSource = self;
    self.forecastTableView.delegate = self;
}

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.activityIndicator startAnimating];
    
    // Get current location first
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManager Delegates

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    [self.activityIndicator stopAnimating];
    
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:@"There was an error retrieving your location"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
    [errorAlert show];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *loc = [locations lastObject];
    [locationManager stopUpdatingLocation];

    // Fetch forecast info of current location
    [self getForecastInfoForLocation:loc.coordinate];
}

-(void) getForecastInfoForLocation:(CLLocationCoordinate2D)location {
    
    // Send forecast request
    NSString* urlString = [NSString stringWithFormat:@"%@/%@/%.8f,%.8f", kForecastURL, kForecastAPIKey, location.latitude, location.longitude];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                               [self.activityIndicator stopAnimating];
                               
                               if (!error) {
                                   
                                   // Succeed, parse the response
                                   self.queue = [[NSOperationQueue alloc] init];
                                   ForecastJsonParser *parser = [[ForecastJsonParser alloc] initWithData:data];
                                   
                                   // Handle parsing error
                                   parser.errorHandler = ^(NSError *parseError) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           NSString *errorMessage = [error localizedDescription];
                                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Weather Format Failure"
                                                                                               message:nil
                                                                                              delegate:nil
                                                                                     cancelButtonTitle:@"OK"
                                                                                     otherButtonTitles:nil];
                                           [alertView show];
                                       });
                                   };
                                   
                                   __strong ForecastJsonParser *weakParser = parser;
                                   
                                   parser.completionBlock = ^(void) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           
                                           if (weakParser.currentWeather)
                                               self.currentlyWeather = weakParser.currentWeather;
                                           if (weakParser.hourlyForecastList)
                                               self.hourlyForecasts = [weakParser.hourlyForecastList copy];
                                           if (weakParser.dailyForecastList)
                                               self.dailyForecasts = [weakParser.dailyForecastList copy];
                                           
                                           [self refreshCurrentWeatherUI];
                                           [self.forecastTableView reloadData];
                                       });
                                       
                                       self.queue = nil;
                                   };
                                   
                                   [self.queue addOperation:parser];
                               } else {
                                   // Failed
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Failure"
                                                                                       message:nil
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"OK"
                                                                             otherButtonTitles:nil];
                                   [alertView show];
                               }
                           }];
}

-(void) refreshCurrentWeatherUI {
    
    if (self.currentlyWeather) {
        self.currentSummary.text = self.currentlyWeather.summary;
        self.currentTemperature.text = self.currentlyWeather.temperature;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger index = self.segmentedControl.selectedSegmentIndex;
    
    switch (index)
    {
        case 0:
        {
            return self.hourlyForecasts.count;
            break;
        }
        case 1:
        {
            return self.dailyForecasts.count;
            break;
        }
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ForecastTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Forecast Cell" forIndexPath:indexPath];
    
    Forecast* forecast = nil;
    NSInteger segmentIndex = self.segmentedControl.selectedSegmentIndex;

    if (segmentIndex == 0)
        forecast = (Forecast *)self.hourlyForecasts[indexPath.row];
    else if (segmentIndex == 1)
        forecast = (Forecast *)self.dailyForecasts[indexPath.row];

    [cell configureWith:forecast];
    return cell;
}

- (IBAction)segmentedControlChanged:(id)sender {
    [self.forecastTableView reloadData];
}

@end
