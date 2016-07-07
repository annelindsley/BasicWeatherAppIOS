//
//  Forcast.h
//  BasicWeatherApp
//
//  Created by Anne Lindsley on 7/6/16.
//  Copyright © 2016 Anne Lindsley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Constants.h"

@interface Forcast : NSObject <CLLocationManagerDelegate>

- (void)initLocationManager;
- (void)updateForcastData;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) NSMutableDictionary *weatherReport;

@property (strong, nonatomic) NSNumber *currentTemp;
@property (strong, nonatomic) NSNumber *currentHumidity;
@property (strong, nonatomic) NSNumber *currentPrecipProbability;
@property (strong, nonatomic) NSString *currentWeatherSummary;
@property (strong, nonatomic) NSString *currentWeatherIcon;

@property (nonatomic) BOOL hasDisplayedCurrentForcastData;
@property (nonatomic) BOOL hasFinishedRetrivingForcast;
@property (nonatomic) float previousLatitude;
@property (nonatomic) float previousLongitude;
@property (nonatomic) float currentLatitude;
@property (nonatomic) float currentLongitude;

@end
