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
    
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSLog(@"%@",dataDictionary);
    
    self.weatherForcasts = [NSMutableDictionary dictionary];
    
    self.weatherForcasts = [dataDictionary objectForKey:@"currently"];
}

@end
