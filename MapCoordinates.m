//
//  MapCoordinates.m
//  BombaJob
//
//  Created by supudo on 7/4/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import "MapCoordinates.h"

@implementation MapCoordinates

@synthesize delegate, locationManager;

- (void)startCoor {
	self.locationManager = [[[CLLocationManager alloc] init] autorelease];
	[self.locationManager setDelegate:self];
	[self.locationManager setDistanceFilter:kCLDistanceFilterNone];
	[self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
	[self.locationManager setPurpose:NSLocalizedString(@"Coordinates_Reason", @"")];
	[self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	[bSettings sharedbSettings].LocationLatitude = manager.location.coordinate.latitude;
	[bSettings sharedbSettings].LocationLongtitude = manager.location.coordinate.longitude;
	[[bSettings sharedbSettings] LogThis:@"Map coordinates - %f - %f", [bSettings sharedbSettings].LocationLatitude, [bSettings sharedbSettings].LocationLongtitude];
	if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(coordinatesUpdate:latitude:)])
		[delegate coordinatesUpdate:manager.location.coordinate.longitude latitude:manager.location.coordinate.latitude];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	[[bSettings sharedbSettings] LogThis:@"Getting map coordinates failed: %@", [error localizedDescription]];
}

- (void)dealloc {
    [super dealloc];
}

@end
