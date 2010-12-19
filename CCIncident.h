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

@interface CCIncident : NSObject {
	NSString* text;
	NSString* user;
	UIImage* image;
	double latitude;
	double longitude;	
	
	NSObject<CCProgressCallbackProtocol>* callback;
}

@property (retain,nonatomic) NSString* text;
@property (readonly) NSString* user;
@property (retain,nonatomic) UIImage* image;
@property (assign) double latitude;
@property (assign) double longitude;

- (id)initWithDescription:(NSString*)desc andImage:(UIImage*)img andLat:(double)latitude andLon:(double)longitude;
- (void)send:(NSObject<CCProgressCallbackProtocol>*)callback;
- (void)fetchIncidentImage:(void (^)(CCIncident incident))block;

+ (NSArray*)fetchIncidentsAround:(CLLocation*)location;

@end
