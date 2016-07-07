//
//  ViewController.h
//  BasicWeatherApp
//
//  Created by Anne Lindsley on 1/26/16.
//  Copyright © 2016 Anne Lindsley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Forcast.h"
#import "Constants.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *lblCurrentHumidity;
@property (strong, nonatomic) IBOutlet UILabel *lblCurrentPrecipProb;
@property (strong, nonatomic) IBOutlet UILabel *lblCurrentWeatherSummary;
@property (strong, nonatomic) IBOutlet UILabel *lblCurrentTemp;
@property (strong, nonatomic) IBOutlet UIImageView *imgWeatherIcon;

@property (strong, nonatomic) Forcast *weatherForcast;

@property (strong, nonatomic) UIImageView *imgConnection;
@property (strong, nonatomic) UIView *viewWaitingScreen;
@property (nonatomic) BOOL displayingWaitingScreen;

@end

