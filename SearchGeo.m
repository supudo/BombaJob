//
//  SearchGeo.m
//  BombaJob
//
//  Created by supudo on 8/15/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import "SearchGeo.h"
#import "SearchOffer.h"
#import "BMMapAnnotation.h"
#import "Offer.h"

static NSString *kMapAnnonIdentifier = @"identifMapAnnon";

@implementation SearchGeo

@synthesize mapView, pinsDropped, searchTerm, freelanceOn, searchOffline, webService;

#pragma mark -
#pragma mark Workers

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = NSLocalizedString(@"Search", @"Search");
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-pattern.png"]];

	mapView.showsUserLocation = YES;
	[mapView setDelegate:self];
	[mapView setMapType:MKMapTypeHybrid];
	[mapView setZoomEnabled:YES];
	[mapView setScrollEnabled:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if (!pinsDropped)
		[self getOffers];
}

- (void)getOffers {
	if (self.webService == nil)
		self.webService = [[WebService alloc] init];
	[webService setDelegate:self];
	[webService geoSearchOffers:searchTerm freelance:freelanceOn latitude:[bSettings sharedbSettings].LocationLatitude longitude:[bSettings sharedbSettings].LocationLongtitude];
}

- (void)geoSearchOffersFinished:(id)sender results:(NSMutableArray *)offers {
	[[bSettings sharedbSettings] stopLoading:self.view];
	[bSettings sharedbSettings].latestSearchResults = offers;
	UITabBarItem *tb = (UITabBarItem *)[[appDelegate tabBarController].tabBar.items objectAtIndex:3];
	tb.badgeValue = [NSString stringWithFormat:@"%i", [[bSettings sharedbSettings].latestSearchResults count]];
	[self drawPins];
}

#pragma mark -
#pragma mark Map

- (void)drawPins {
	pinsDropped = YES;
#if TARGET_IPHONE_SIMULATOR
	CLLocationCoordinate2D coord = {.latitude = 42.688019, .longitude = 23.32891};
#else
	CLLocationCoordinate2D coord = {.latitude = [bSettings sharedbSettings].LocationLatitude, .longitude = [bSettings sharedbSettings].LocationLongtitude};
#endif
	MKCoordinateSpan span = {.latitudeDelta =  0.010, .longitudeDelta =  0.010};
	MKCoordinateRegion region = {coord, span};
	[mapView setRegion:region animated:TRUE];

	NSMutableArray *arrPoints = [[NSMutableArray alloc] initWithCapacity:[[bSettings sharedbSettings].latestSearchResults count]];
	SearchOffer *off;
	BMMapAnnotation *annotation;
	for (int i=0; i<[[bSettings sharedbSettings].latestSearchResults count]; i++) {
		off = [[bSettings sharedbSettings].latestSearchResults objectAtIndex:i];
		CLLocation *offPoint = [[CLLocation alloc] initWithLatitude:off.gLatitude longitude:off.gLongitude];
		annotation = [[BMMapAnnotation alloc] initWithCoordinate:[offPoint coordinate] annotationType:((off.HumanYn) ? BMMapAnnotationTypeCompany : BMMapAnnotationTypeHuman) title:off.Title];
		[annotation setUserData:off.Positivism];
		[annotation setUrl:[NSString stringWithFormat:@"%i", off.OfferID]];
		[arrPoints addObject:annotation];
	}
	[mapView addAnnotations:arrPoints];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	MKAnnotationView *annotationView = nil;
	BMMapAnnotation *bmAnnotation = (BMMapAnnotation *)annotation;
	MKPinAnnotationView *pin = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:kMapAnnonIdentifier];
	if (pin == nil) {
		pin = [[MKPinAnnotationView alloc] initWithAnnotation:bmAnnotation reuseIdentifier:kMapAnnonIdentifier];
		[pin setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure]];
		[pin setAnimatesDrop:YES];
	}

	//if (bmAnnotation.annotationType == BMMapAnnotationTypeCompany)
	//	[pin setPinColor:MKPinAnnotationColorRed];
	//else
		[pin setPinColor:MKPinAnnotationColorGreen];
	
	annotationView = pin;
	[annotationView setEnabled:YES];
	[annotationView setCanShowCallout:YES];
	return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	BMMapAnnotation *annotation = (BMMapAnnotation *)view.annotation;
	if (annotation.url != nil) {
		Offer *tvc = [[Offer alloc] initWithNibName:@"Offer" bundle:nil];
		SearchOffer *off;
		for (int i=0; i<[[bSettings sharedbSettings].latestSearchResults count]; i++) {
			off = [[bSettings sharedbSettings].latestSearchResults objectAtIndex:i];
			if (off.OfferID == [annotation.url intValue])
				tvc.searchOffer = off;
		}
		[[self navigationController] pushViewController:tvc animated:YES];
	}
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
	searchTerm = nil;
	webService = nil;
    [super viewDidUnload];
}


@end
