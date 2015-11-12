//
//  WeatherForecastTests.m
//  WeatherForecastTests
//
//  Created by iPhone on 12/11/2015.
//  Copyright © 2015 Shannon Jiang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ForecastJsonParser.h"

@interface WeatherForecastTests : XCTestCase

@end

@implementation WeatherForecastTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testParser {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    ForecastJsonParser *parser = [[ForecastJsonParser alloc] initWithData:jsonData];
    
    __strong ForecastJsonParser *weakParser = parser;
    
    parser.completionBlock = ^(void) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            XCTAssertEqualObjects(weakParser.currentWeather.summary, @"Drizzle");
            XCTAssert(weakParser.hourlyForecastList.count == 49);
            XCTAssert(weakParser.dailyForecastList.count == 8);
        });
    };
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
