//
//  SearchGeo.h
//  BombaJob
//
//  Created by supudo on 8/15/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKReverseGeocoder.h>

@interface SearchGeo : UIViewController <MapCoordinatesDelegate, MKMapViewDelegate> {
	MKMapView *mapView;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@end
