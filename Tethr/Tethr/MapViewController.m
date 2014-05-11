//
//  MapViewController.m
//  Tethr
//
//  Created by Zeinab Khan on 4/13/14.
//  Copyright (c) 2014 Daniel Fein Zeinab Khan. All rights reserved.
//

#import "MapViewController.h"

#define METERS_PER_MILE 1609.344

@implementation MapViewController

-(void)viewDidLoad{
    [super viewDidLoad];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    CLLocationManager *locationManager= [[CLLocationManager alloc] init];
    CLLocation *location= [locationManager location];
    CLLocationCoordinate2D coordinate= [location coordinate];
    coordinate.latitude = self.latitude ;
    coordinate.longitude = self.longitude;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    
    [_mapView setRegion:viewRegion animated:YES];
    
}





@end
