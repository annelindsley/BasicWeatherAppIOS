//
//  ViewController.h
//  BasicWeatherApp
//
//  Created by Anne Lindsley on 1/26/16.
//  Copyright © 2016 Anne Lindsley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) NSMutableDictionary *weatherForcasts;

@property (strong, nonatomic) IBOutlet UILabel *lblCurrentHumidity;
@property (strong, nonatomic) IBOutlet UILabel *lblCurrentPrecipProb;
@property (strong, nonatomic) IBOutlet UILabel *lblCurrentWeatherSummary;
@property (strong, nonatomic) IBOutlet UILabel *lblCurrentTemp;
@property (strong, nonatomic) IBOutlet UIImageView *imgWeatherIcon;

@property (strong, nonatomic) NSNumber *currentTemp;
@property (strong, nonatomic) NSNumber *currentHumidity;
@property (strong, nonatomic) NSNumber *currentPrecipProbability;
@property (strong, nonatomic) NSString *currentWeatherSummary;
@property (strong, nonatomic) NSString *currentWeatherIcon;

@end

