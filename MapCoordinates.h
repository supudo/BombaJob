//
//  MapCoordinates.h
//  BombaJob
//
//  Created by supudo on 7/4/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol MapCoordinatesDelegate <NSObject>
@optional
- (void)coordinatesUpdate:(float)longitude latitude:(float)latitude;
@end

@interface MapCoordinates : NSObject<CLLocationManagerDelegate> {
	id<MapCoordinatesDelegate> delegate;
	CLLocationManager *locationManager;
}

@property (assign) id<MapCoordinatesDelegate> delegate;
@property (nonatomic, retain) CLLocationManager *locationManager;

- (void)startCoor;

@end
