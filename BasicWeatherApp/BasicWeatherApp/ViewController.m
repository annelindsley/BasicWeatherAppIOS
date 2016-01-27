//
//  ViewController.m
//  BasicWeatherApp
//
//  Created by Anne Lindsley on 1/26/16.
//  Copyright © 2016 Anne Lindsley. All rights reserved.
//

#import "ViewController.h"


#define CURRENT_LAT  45.5200
#define CURRENT_LON -122.6819

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self makeForcasterAPICall];
    
    [self getForcastData];
    
    [self setForcastDataToLabels];
    
    [self setWeatherIcon];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeForcasterAPICall
{
    NSString *url = [NSString stringWithFormat:@"https://api.forecast.io/forecast/b344a0c781804387d143eaae20e6333e/%f,%f", CURRENT_LAT, CURRENT_LON];
    
    NSURL *weatherURL = [NSURL URLWithString:url];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:weatherURL];
    
    NSError *error = nil;
    
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    NSLog(@"%@",dataDictionary);
    
    self.weatherForcasts = [NSMutableDictionary dictionary];
    
    self.weatherForcasts = [dataDictionary objectForKey:@"currently"];
}

- (void)getForcastData
{
    self.currentTemp = [self.weatherForcasts objectForKey:@"apparentTemperature"];
    self.currentHumidity = [self.weatherForcasts objectForKey:@"humidity"];
    self.currentPrecipProbability = [self.weatherForcasts objectForKey:@"precipProbability"];
    self.currentWeatherSummary = [self.weatherForcasts objectForKey:@"summary"];
    self.currentWeatherIcon = [self.weatherForcasts objectForKey:@"icon"];
}

- (void)setForcastDataToLabels
{
    self.lblCurrentHumidity.text = [NSString stringWithFormat: @"%@", self.currentHumidity];
    self.lblCurrentPrecipProb.text = [NSString stringWithFormat: @"%@", self.currentPrecipProbability];
    self.lblCurrentTemp.text =  [NSString stringWithFormat: @"%@", self.currentTemp];
    self.lblCurrentWeatherSummary.text = self.currentWeatherSummary;
}

- (void)setWeatherIcon
{
    if ([self.currentWeatherIcon isEqualToString: @"clear-day"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"clear-day"];
    }
    else if ([self.currentWeatherIcon isEqualToString: @"clear-night"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"clear-day"];
    }
    else if ([self.currentWeatherIcon isEqualToString: @"rain"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"rain"];
    }
    else if ([self.currentWeatherIcon isEqualToString: @"snow"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"snow"];
    }
    else if ([self.currentWeatherIcon isEqualToString: @"sleet"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"sleet"];
    }
    else if ([self.currentWeatherIcon isEqualToString: @"wind"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"wind"];
    }
    else if ([self.currentWeatherIcon isEqualToString: @"fog"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"fog"];
    }
    else if ([self.currentWeatherIcon isEqualToString: @"cloudy"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"cloudy"];
    }
    else if ([self.currentWeatherIcon isEqualToString: @"partly-cloudy-day"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"cloudy-day"];
    }
    else if ([self.currentWeatherIcon isEqualToString: @"partly-cloudy-night"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"cloudy-night"];
    }
    else
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"default"];
    }
    
}


@end
