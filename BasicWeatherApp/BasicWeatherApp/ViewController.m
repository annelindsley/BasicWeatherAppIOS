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

@property (strong, nonatomic) UIImageView *imgConnection;
@property (strong, nonatomic) UIView *viewWaitingScreen;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initWeatherForecast];
    
    [self registerForUpdatedForecast];
    
    [self registerForDisplayWaitingScreen];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateForecastView];
    
    [self createWaitingScreen];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//------------------------------------------------------------------------------
#pragma mark - Forecast Class -
//------------------------------------------------------------------------------

- (void)initWeatherForecast
{
    self.weatherForecast = [[Forecast alloc] init];
    
    [self.weatherForecast initLocationManager];
    [self.weatherForecast updateForecastData];
}

- (void)updateForecastView
{
    if (self.weatherForecast.weatherReport)
    {
        self.weatherForecast.hasDisplayedCurrentForecastData = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self setForecastDataToLabels];
            
            [self setWeatherIcon];
            
            [self hideWaitingScreen];
            
        });
    }
    else
    {
        //[self createWaitingScreen];
        
        self.weatherForecast.hasDisplayedCurrentForecastData = NO;
    }
    

}

//------------------------------------------------------------------------------
#pragma mark - Registrations -
//------------------------------------------------------------------------------

- (void)registerForUpdatedForecast
{
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(updateForecastView)
                                                 name: KEY_UPDATED_FORECAST
                                               object: nil];
}

- (void)registerForDisplayWaitingScreen
{
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(createWaitingScreen)
                                                 name: KEY_DISPLAY_WAITING
                                               object: nil];
    
}

//------------------------------------------------------------------------------
#pragma mark - Set Data to UI -
//------------------------------------------------------------------------------

- (void)setForecastDataToLabels
{
    [self formatTemperature];
    [self formatHumidity];
    [self formatPrecipProb];
    self.lblCurrentWeatherSummary.text = self.weatherForecast.currentWeatherSummary;
}

- (void)setWeatherIcon
{
    if ([self.weatherForecast.currentWeatherIcon isEqualToString: @"clear-day"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"clear-day"];
    }
    else if ([self.weatherForecast.currentWeatherIcon isEqualToString: @"clear-night"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"clear-day"];
    }
    else if ([self.weatherForecast.currentWeatherIcon isEqualToString: @"rain"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"rain"];
    }
    else if ([self.weatherForecast.currentWeatherIcon isEqualToString: @"snow"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"snow"];
    }
    else if ([self.weatherForecast.currentWeatherIcon isEqualToString: @"sleet"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"sleet"];
    }
    else if ([self.weatherForecast.currentWeatherIcon isEqualToString: @"wind"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"wind"];
    }
    else if ([self.weatherForecast.currentWeatherIcon isEqualToString: @"fog"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"fog"];
    }
    else if ([self.weatherForecast.currentWeatherIcon isEqualToString: @"cloudy"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"cloudy"];
    }
    else if ([self.weatherForecast.currentWeatherIcon isEqualToString: @"partly-cloudy-day"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"cloudy-day"];
    }
    else if ([self.weatherForecast.currentWeatherIcon isEqualToString: @"partly-cloudy-night"])
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"cloudy-night"];
    }
    else
    {
        self.imgWeatherIcon.image = [UIImage imageNamed:@"default"];
    }
}

//------------------------------------------------------------------------------
#pragma mark - Formatting For Display -
//------------------------------------------------------------------------------

- (void)formatTemperature
{
    int tempFloat = round([self.weatherForecast.currentTemp floatValue]);
    
    self.lblCurrentTemp.text =  [NSString stringWithFormat:@"%d°",tempFloat];
}


- (void)formatHumidity
{
    int humidityFloat = ([self.weatherForecast.currentHumidity floatValue] *100);
    
    self.lblCurrentHumidity.text =  [NSString stringWithFormat:@"%d%@",humidityFloat, @"%"];
}

- (void)formatPrecipProb
{
    int precipProbFloat = ([self.weatherForecast.currentPrecipProbability floatValue] *100);
    
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
