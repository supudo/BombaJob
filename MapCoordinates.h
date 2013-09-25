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
	id<MapCoordinatesDelegate> __weak delegate;
	CLLocationManager *locationManager;
}

@property (weak) id<MapCoordinatesDelegate> delegate;
@property (nonatomic, strong) CLLocationManager *locationManager;

- (void)startCoor;

@end
