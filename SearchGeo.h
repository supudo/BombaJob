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
#import "WebService.h"

@interface SearchGeo : UIViewController <MKMapViewDelegate, WebServiceDelegate> {
	MKMapView *mapView;
	BOOL pinsDropped;
	NSString *searchTerm;
	BOOL freelanceOn, searchOffline;
	WebService *webService;
}

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property BOOL pinsDropped;
@property (nonatomic, strong) NSString *searchTerm;
@property BOOL freelanceOn, searchOffline;
@property (nonatomic, strong) WebService *webService;

- (void)getOffers;
- (void)drawPins;

@end
