//
//  ViewController.m
//  BasicWeatherApp
//
//  Created by Anne Lindsley on 1/26/16.
//  Copyright © 2016 Anne Lindsley. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initWeatherForcast];
    
    [self registerForUpdatedForcast];
    
    [self updateForcastView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)initWeatherForcast
{
    self.weatherForcast = [[Forcast alloc] init];
    
    [self.weatherForcast initLocationManager];
    [self.weatherForcast updateForcastData];
}

- (void)updateForcastView
{
    if (self.weatherForcast.weatherReport)
    {
        self.weatherForcast.hasDisplayedCurrentForcastData = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self setForcastDataToLabels];
            
            [self setWeatherIcon];
            
            [self hideHud];
            
        });
    }
    else
    {
        [self initHudWithMessage: @"Updating Info"];
        self.weatherForcast.hasDisplayedCurrentForcastData = NO;
    }
    

}
- (void)registerForUpdatedForcast
{
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(updateForcastView)
                                                 name: KEY_UPDATED_FORCAST
                                               object: nil];
}

- (void)setForcastDataToLabels
{
    [self formatTemperature];
    [self formatHumidity];
    [self formatPrecipProb];
    self.lblCurrentWeatherSummary.text = self.weatherForcast.currentWeatherSummary;
}

- (void)setWeatherIcon
{
    if ([self.weatherForcast.currentWeatherIcon isEqualToString: @"clear-day"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"clear-day"];
    }
    else if ([self.weatherForcast.currentWeatherIcon isEqualToString: @"clear-night"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"clear-day"];
    }
    else if ([self.weatherForcast.currentWeatherIcon isEqualToString: @"rain"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"rain"];
    }
    else if ([self.weatherForcast.currentWeatherIcon isEqualToString: @"snow"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"snow"];
    }
    else if ([self.weatherForcast.currentWeatherIcon isEqualToString: @"sleet"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"sleet"];
    }
    else if ([self.weatherForcast.currentWeatherIcon isEqualToString: @"wind"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"wind"];
    }
    else if ([self.weatherForcast.currentWeatherIcon isEqualToString: @"fog"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"fog"];
    }
    else if ([self.weatherForcast.currentWeatherIcon isEqualToString: @"cloudy"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"cloudy"];
    }
    else if ([self.weatherForcast.currentWeatherIcon isEqualToString: @"partly-cloudy-day"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"cloudy-day"];
    }
    else if ([self.weatherForcast.currentWeatherIcon isEqualToString: @"partly-cloudy-night"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"cloudy-night"];
    }
    else
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"default"];
    }
}

- (void)formatTemperature
{
    int tempFloat = round([self.weatherForcast.currentTemp floatValue]);
    
    self.lblCurrentTemp.text =  [NSString stringWithFormat:@"%d°",tempFloat];
}


- (void)formatHumidity
{
    int humidityFloat = ([self.weatherForcast.currentHumidity floatValue] *100);
    
    self.lblCurrentHumidity.text =  [NSString stringWithFormat:@"%d%@",humidityFloat, @"%"];
}

- (void)formatPrecipProb
{
    int precipProbFloat = ([self.weatherForcast.currentPrecipProbability floatValue] *100);
    
    self.lblCurrentPrecipProb.text =  [NSString stringWithFormat:@"%d%@",precipProbFloat, @"%"];
}

//------------------------------------------------------------------------------
#pragma mark - Hud -
//------------------------------------------------------------------------------

- (void)initHudWithMessage: (NSString *)message
{
    if (![self.HUD isHidden])
    {
        [self hideHud];
    }
    
    self.HUD = [MBProgressHUD showHUDAddedTo: self.view animated: YES];
    self.HUD.detailsLabelText = message;
}

- (void)hideHud
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
    
    [self.HUD hide: YES];
}


@end
