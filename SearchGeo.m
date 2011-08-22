//
//  SearchGeo.m
//  BombaJob
//
//  Created by supudo on 8/15/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import "SearchGeo.h"

@implementation SearchGeo

@synthesize mapView;

#pragma mark -
#pragma mark Workers

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = NSLocalizedString(@"Search", @"Search");
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-pattern.png"]];

	self.mapView.showsUserLocation = YES;
	[self.mapView setDelegate:self];
	[self.mapView setMapType:MKMapTypeHybrid];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[appDelegate.mapCoordinates setDelegate:self];
	[appDelegate.mapCoordinates startCoor];
}

#pragma mark -
#pragma mark Geo delegates

- (void)coordinatesUpdate:(float)longitude latitude:(float)latitude {
	NSLog(@"coor = %1.2f x %1.2f", appDelegate.mapCoordinates.locationManager.location.coordinate.latitude,
		  appDelegate.mapCoordinates.locationManager.location.coordinate.longitude);
}

#pragma mark -
#pragma mark System

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ? NO : [bSettings sharedbSettings].shouldRotate);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	mapView = nil;
	[mapView release];
    [super viewDidUnload];
}

- (void)dealloc {
	[mapView release];
    [super dealloc];
}

@end
