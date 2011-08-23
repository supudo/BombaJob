//
//  BMMapAnnotation.m
//  BombaJob
//
//  Created by supudo on 7/4/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import "BMMapAnnotation.h"

@implementation BMMapAnnotation

@synthesize coordinate = _coordinate;
@synthesize annotationType = _annotationType;
@synthesize userData = _userData;
@synthesize url = _url;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate annotationType:(BMMapAnnotationType)annotationType title:(NSString *)title {
	self = [super init];
	_coordinate = coordinate;
	_annotationType = annotationType;
	_title = [title retain];
	return self;
}

- (NSString *)title {
	return _title;
}

- (NSString *)subtitle {
	return _userData;
}

- (void)dealloc {
	[_title release];
	[_userData release];
	[_url release];
	[super dealloc];
}

@end
