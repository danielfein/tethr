//
//  MapViewController.m
//  Tethr
//
//  Created by Zeinab Khan on 4/13/14.
//  Copyright (c) 2014 Daniel Fein Zeinab Khan. All rights reserved.
//

#import "MapViewController.h"

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
    
    MKMapRect mapRect= [self.mapView visibleMapRect];
    MKMapPoint pt= MKMapPointForCoordinate(coordinate);
    mapRect.origin.x = pt.x - mapRect.size.width * 0.5;
    mapRect.origin.y = pt.y - mapRect.size.height * 0.25;
    [self.mapView setVisibleMapRect:mapRect];
    
    
    [self.mapView setCenterCoordinate:coordinate animated:animated];
    
    MKCoordinateRegion region= self.mapView.region;
    region.span.longitudeDelta= 1.0;
    region.span.latitudeDelta= 1.0;
    [self.mapView setRegion:region];
    
}





@end
