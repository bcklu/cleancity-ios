//
//  CCIncident.h
//  CleanCity
//
//  Created by Martin Gratzer on 18.12.10.
//  Copyright 2010 CodeCamp Klagenfurt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCProgressCallbackProtocol.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class CCIncident;

@protocol CCIncidentDelegate <NSObject>
- (void)incidentImageFetched:(CCIncident*)incident;
- (void)incidentImageFetchFailed:(CCIncident*)incident;
@end

@interface CCIncident : NSObject <MKAnnotation> {
	NSString* text;
	NSString* user;
	UIImage* image;
	double latitude;
	double longitude;	
	NSString* imageLink;
	
	NSObject<CCProgressCallbackProtocol>* callback;
	NSObject<CCIncidentDelegate>* delegate;
}

@property (retain,nonatomic) NSString* text;
@property (readonly) NSString* user;
@property (retain,nonatomic) UIImage* image;
@property (assign) double latitude;
@property (assign) double longitude;
@property (retain,nonatomic) NSString* imageLink;
@property (assign) NSObject<CCIncidentDelegate>* delegate;

- (id)initWithDescription:(NSString*)desc andImage:(UIImage*)img andLat:(double)latitude andLon:(double)longitude;
- (id)initWithDescription:(NSString*)desc andImage:(UIImage*)img andLat:(double)latitude andLon:(double)longitude andImageLink:(NSString*)imgUrl;
- (void)send:(NSObject<CCProgressCallbackProtocol>*)callback;
- (void)fetchIncidentImage:(NSObject<CCIncidentDelegate>*)del;
+ (NSArray*)fetchIncidentsAround:(CLLocationCoordinate2D)location withLonDelta:(double)lonDelta andLatDelta:(double)latDelta;
+ (void)testFetch;

@end
