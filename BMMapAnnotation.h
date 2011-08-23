//
//  BMMapAnnotation.h
//  BombaJob
//
//  Created by supudo on 7/4/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef enum {
	BMMapAnnotationTypeCompany = 0,
	BMMapAnnotationTypeHuman = 1
} BMMapAnnotationType;

@interface BMMapAnnotation : NSObject <MKAnnotation> {
	CLLocationCoordinate2D _coordinate;
	BMMapAnnotationType _annotationType;
	NSString *_title;
	NSString *_userData;
	NSString *_url;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate annotationType:(BMMapAnnotationType)annotationType title:(NSString *)title;

@property BMMapAnnotationType annotationType;
@property (nonatomic, retain) NSString *userData;
@property (nonatomic, retain) NSString *url;

@end
