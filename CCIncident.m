//
//  CCIncident.m
//  CleanCity
//
//  Created by Martin Gratzer on 18.12.10.
//  Copyright 2010 CodeCamp Klagenfurt. All rights reserved.
//

#import "CCIncident.h"
#import "NSString+SBJSON.h"
#import "NSObject+SBJSON.h"

#import "CCDebugMacros.h"

#define kWebServiceUrl @""

@interface CCIncident()

@property (assign) NSObject<CCProgressCallbackProtocol>* callback;

- (void)sendRequest:(NSURLRequest*)req;

@end


@implementation CCIncident

@synthesize description, user, lat, lon, image, callback;

- (id)initWithDescription:(NSString*)desc andImage:(UIImage*)img andLat:(double)latitude andLon:(double)longitude {	
	if((self=[self init])!=nil) {
		self.description = desc;
		self.image = img;
		self.lat = latitude;
		self.lon = longitude;
	}	
	
	return self;
}

- (void)send:(NSObject<CCProgressCallbackProtocol>*)cb {
	
	self.callback = cb;
	
	NSDictionary *jsonDict = [NSDictionary dictionaryWithObjectsAndKeys:
							  self.image, @"image",
							  self.description, @"description",
							  self.lat, @"latitude",
							  self.lon, @"longitude",
/*							  self.user, @"user",*/ 
							  @"", @"author_id", nil];	
	
	NSDictionary *incident = [NSDictionary dictionaryWithObjectsAndKeys:jsonDict, @"incident_report", nil];
	
	NSString *jsonRequest = [incident JSONRepresentation];
	
	CCLOG(@"jsonRequest is %@", jsonRequest);
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kWebServiceUrl]
														   cachePolicy:NSURLRequestUseProtocolCachePolicy 
													   timeoutInterval:60.0];	
	
	NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
	
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: requestData];	
	
	[self.callback startProgress:[NSNumber numberWithInt:1]];
	[self performSelectorInBackground:@selector(sendRequest:) withObject:request];
	[self.callback endProgress];
}

- (void)sendRequest:(NSURLRequest*)req {
	
	NSURLResponse* response = nil;
	NSError* error = nil;
	
	[NSURLConnection sendSynchronousRequest:req 
						  returningResponse:&response 
									  error:&error];
	
	if(error) {
			
	}	
}

- (void)dealloc {	
	self.description = nil;
	self.image = nil;	
	[super dealloc];
}

@end
