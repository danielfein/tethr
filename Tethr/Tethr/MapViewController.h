//
//  MapViewController.h
//  Tethr
//
//  Created by Zeinab Khan on 4/13/14.
//  Copyright (c) 2014 Daniel Fein Zeinab Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController

@property (nonatomic,assign)double latitude;
@property (nonatomic,assign)double longitude;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(readonly, nonatomic) CLLocationCoordinate2D center;
@property(readonly, nonatomic) CLLocationDistance radius;
@property(readonly, nonatomic) NSString *identifier;


@end
