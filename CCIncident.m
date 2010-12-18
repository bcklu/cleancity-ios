//
//  CCIncident.m
//  CleanCity
//
//  Created by Martin Gratzer on 18.12.10.
//  Copyright 2010 CodeCamp Klagenfurt. All rights reserved.
//

#import "CCIncident.h"
#import "JSON.h"
#import "NSData+Base64.h"
#import "UIImage+Extras.h"

#import "CCDebugMacros.h"

#define kWebServiceUrl @"http://cleancity.dyndns.org/1/incident_reports"
#define kImageTargetSize CGSizeMake(640.0f, 480.0f)

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
	
	NSData *imageData = UIImageJPEGRepresentation([self.image imageByScalingProportionallyToSize:kImageTargetSize], 0.8f);	
	NSDictionary *incident = [NSDictionary dictionaryWithObjectsAndKeys: [imageData base64EncodingWithLineLength:76], @"image", self.text, @"description", [NSNumber numberWithDouble:self.latitude], @"latitude", [NSNumber numberWithDouble:self.longitude], @"longitude", @"", @"author_id", nil];	
	NSDictionary *incident_report = [NSDictionary dictionaryWithObjectsAndKeys:incident, @"incident_report", nil];	
	
	NSString *jsonRequest = [incident_report JSONRepresentation];	
//	CCLOG(@"jsonRequest is %@", jsonRequest);
	
	NSMutableURLRequest *request = 	[NSMutableURLRequest requestWithURL:[NSURL URLWithString:kWebServiceUrl]];	
	NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
	
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:requestData];
	
	[self performSelectorInBackground:@selector(sendRequest:) withObject:request];
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

- (NSString*)description {
	return [NSString stringWithFormat:@"%@, %d, %d", self.text, self.latitude, self.longitude];
}

- (void)dealloc {	
	self.callback = nil;
	self.text = nil;
	self.image = nil;	
	[super dealloc];
}

@end