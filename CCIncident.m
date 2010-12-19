//
//  CCIncident.m
//  CleanCity
//
//  Created by Martin Gratzer on 18.12.10.
//  Copyright 2010 CodeCamp Klagenfurt. All rights reserved.
//

#import "CCIncident.h"
#import "CCDebugMacros.h"
#import "CCDefinedConstants.h"

#import "JSON.h"

#import "NSData+Base64.h"
#import "UIImage+Extras.h"

@interface CCIncident()

@property (assign) NSObject<CCProgressCallbackProtocol>* callback;
- (void)sendRequest:(NSURLRequest*)req;
@end

@implementation CCIncident

@synthesize text, user, latitude, longitude, image, callback;

- (id)initWithDescription:(NSString*)desc andImage:(UIImage*)img andLat:(double)lat andLon:(double)lon {	
	if((self=[self init])!=nil) {
		self.text = desc;
		self.image = img;
		self.latitude = lat;
		self.longitude = lon;
	}	
	
	return self;
}

- (void)send:(NSObject<CCProgressCallbackProtocol>*)cb {
	
	self.callback = cb;	
	[self.callback startProgress:[NSNumber numberWithInt:1]];
	 
	NSString* userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
	
	if(userId) {
		UIImage *scaledImage = [self.image imageByScalingProportionallyToSize:kImageTargetSize];
		NSData *imageData = UIImageJPEGRepresentation(scaledImage, 0.8f);	
		NSDictionary *incident = [NSDictionary dictionaryWithObjectsAndKeys: [imageData base64EncodingWithLineLength:0], @"image", self.text, @"description", [NSNumber numberWithDouble:self.latitude], @"latitude", [NSNumber numberWithDouble:self.longitude], @"longitude", ((userId) ? userId : @""), @"user", nil];	
		NSDictionary *incident_report = [NSDictionary dictionaryWithObjectsAndKeys:incident, @"incident_report", nil];	
		
		NSString *jsonRequest = [incident_report JSONRepresentation];
		
		NSMutableURLRequest *request = 	[NSMutableURLRequest requestWithURL:[NSURL URLWithString:kRestSendIncident]];	
		NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
		
		[request setHTTPMethod:@"POST"];
		[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
		[request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
		[request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
		[request setHTTPBody:requestData];
		
		[self performSelectorInBackground:@selector(sendRequest:) withObject:request];
	}
	else {
		CCLOGERR(@"Error. User not authenticated!");
	}
}

- (void)sendRequest:(NSURLRequest*)req {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSURLResponse* response = nil;
	NSError* error = nil;
	
	NSData* resp = [NSURLConnection sendSynchronousRequest:req 
						  returningResponse:&response 
									  error:&error];
	
	if(error) {
		CCLOGERR(@"error uploading: %@", [error userInfo]);
	}
	else {
		CCLOG(@"response: %@ %@", response, resp);
	}

	
	// TODO: do anything with response data
	
    [self.callback performSelectorOnMainThread:@selector(endProgress) withObject:nil waitUntilDone:YES];
	
	[pool release];
}

- (void)fetchIncidentImage:(void (^)(CCIncident incident))block {
	
}

- (NSString*)description {
	return [NSString stringWithFormat:@"%@, %d, %d", self.text, self.latitude, self.longitude];
}

- (void)dealloc {	
	self.callback = nil;
	self.text = nil;
	self.image = nil;	
	[super dealloc];
}

+ (NSArray*)fetchIncidentsAround:(CLLocation*)location {
	NSMutableArray *incidents = [NSMutableArray array];
	
	// TOOD: fetch
	
	return incidents;
}

@end