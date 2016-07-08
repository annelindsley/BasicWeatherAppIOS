//
//  ViewController.m
//  BasicWeatherApp
//
//  Created by Anne Lindsley on 1/26/16.
//  Copyright © 2016 Anne Lindsley. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

{
    NSMutableArray *connectingImages;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initWeatherForcast];
    
    [self registerForUpdatedForcast];
    
    [self registerForDisplayWaitingScreen];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateForcastView];
    
    [self createWaitingScreen];
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
            
            [self hideWaitingScreen];
            
        });
    }
    else
    {
        //[self createWaitingScreen];
        
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

- (void)registerForDisplayWaitingScreen
{
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(createWaitingScreen)
                                                 name: KEY_DISPLAY_WAITING
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
#pragma mark - Waiting Screen -
//------------------------------------------------------------------------------

- (void)createWaitingScreen
{
    if (!self.displayingWaitingScreen)
    {
        self.viewWaitingScreen = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
        
        self.viewWaitingScreen.backgroundColor = [UIColor colorWithRed: 0
                                                                 green: 60
                                                                  blue: 60
                                                                 alpha: .95];
        
        self.imgConnection = [[UIImageView alloc] initWithFrame: CGRectMake (self.viewWaitingScreen.frame.origin.x,
                                                                             self.viewWaitingScreen.frame.origin.y,
                                                                             100,
                                                                             100)];
        
        self.imgConnection.center = self.viewWaitingScreen.center;
        
        [self initConnectionImages];
        
        [self startConnectionAnimation];
        
        self.imgConnection.backgroundColor = [UIColor purpleColor];
        
        [self.viewWaitingScreen addSubview:self.imgConnection];
        
        [self.view addSubview: self.viewWaitingScreen];
        
        self.displayingWaitingScreen = YES;
    }
}

- (void)hideWaitingScreen
{
    [UIView transitionWithView: self.view
                      duration: 0.5f
                       options: UIViewAnimationOptionTransitionCrossDissolve
                    animations: ^{
                        
                        [self.viewWaitingScreen removeFromSuperview];
                        [self stopConnectionAnimation];
                        self.displayingWaitingScreen = NO;
                        
                    } completion:nil];

}


- (void)initConnectionImages
{
    connectingImages = [[NSMutableArray alloc] initWithObjects:
                        [UIImage imageNamed:@"rain"],
                        [UIImage imageNamed:@"snow"],
                        [UIImage imageNamed:@"fog"],
                        [UIImage imageNamed:@"cloudy-night"],
                        nil];
    
    
    self.imgConnection.animationImages = connectingImages;
    self.imgConnection.animationDuration = 1;
}

- (void)startConnectionAnimation
{
    [self.imgConnection startAnimating];
}

- (void)stopConnectionAnimation
{
    [self.imgConnection stopAnimating];
}


@end
