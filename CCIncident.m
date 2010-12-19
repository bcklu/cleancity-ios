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

#pragma mark -
#pragma mark 'private' decalrations 
@interface CCIncident()

- (void)postIncidentWithRequest:(NSURLRequest*)req;
- (void)fetchImageFromServer;
+ (NSData*)synchronousSendURLRequest:(NSURLRequest*)req;
+ (NSArray*)convertToIncidents:(NSString*)JSONString;

@property (assign) NSObject<CCProgressCallbackProtocol>* callback;
@property (retain,nonatomic) NSString* imageLink;

@end

@implementation CCIncident

@synthesize text, user, latitude, longitude, image, callback, imageLink, delegate;

#pragma mark -
#pragma mark init and overrides
- (id)initWithDescription:(NSString*)desc andImage:(UIImage*)img andLat:(double)lat andLon:(double)lon {	
	if((self=[self init])!=nil) {
		self.text = desc;
		self.image = img;
		self.latitude = lat;
		self.longitude = lon;
		self.imageLink = @"";
	}	
	
	return self;
}

- (id)initWithDescription:(NSString*)desc andImage:(UIImage*)img andLat:(double)lat andLon:(double)lon andImageLink:(NSString*)imgUrl {
	if((self=[self initWithDescription:desc 
							  andImage:img 
								andLat:lat 
								andLon:lon])!=nil) {
		self.imageLink = imgUrl;
	}
	
	return self;
}

- (NSString*)description {
	return [NSString stringWithFormat:@"Incident '%@' at (%d, %d) with image '%@'.", self.text, self.latitude, self.longitude, self.imageLink];
}

- (void)dealloc {	
	self.callback = nil;
	self.text = nil;
	self.image = nil;	
	self.imageLink = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark public methods
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
		
		NSMutableURLRequest *request = 	[NSMutableURLRequest requestWithURL:[NSURL URLWithString:kRestIncidents]];	
		NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
		
		[request setHTTPMethod:@"POST"];
		[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
		[request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
		[request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
		[request setHTTPBody:requestData];
		
		[self performSelectorInBackground:@selector(postIncidentWithRequest:) withObject:request];
	}
	else {
		CCLOGERR(@"Error. User not authenticated!");
	}
}

- (void)fetchIncidentImage:(NSObject<CCIncidentDelegate>*)del {
	self.delegate = del;
	[self performSelectorInBackground:@selector(fetchImageFromServer) withObject:nil];
}

#pragma mark -
#pragma mark private methods
- (void)postIncidentWithRequest:(NSURLRequest*)req {	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];		
	/*NSData *response = */[CCIncident synchronousSendURLRequest:req];
	// TODO: do anything with response data	
    [self.callback performSelectorOnMainThread:@selector(endProgress) withObject:nil waitUntilDone:NO];	
	[pool release];
}

- (void)fetchImageFromServer {
	if(self.imageLink) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kSiteUrl, self.imageLink]];
		NSURLRequest *req = [NSURLRequest requestWithURL:url];
		NSData *responseData = [CCIncident synchronousSendURLRequest:req];	 
		self.image = [UIImage imageWithData:responseData];
		[self.delegate performSelectorOnMainThread:@selector(incidentImageFetched:) withObject:self waitUntilDone:NO];
		[pool release];	
	}
	else {
		[self.delegate performSelectorOnMainThread:@selector(incidentImageFetchFailed:) withObject:self waitUntilDone:NO];
	}
}

#pragma mark -
#pragma mark Class methods
+ (NSData*)synchronousSendURLRequest:(NSURLRequest*)req {
	NSURLResponse* response = nil;
	NSError* error = nil;
	
	NSData* responseData = [NSURLConnection sendSynchronousRequest:req
												 returningResponse:&response
															 error:&error];
	
	if(error) {
		CCLOGERR(@"request error %@", [error userInfo]);
		return nil;
	}	
	
	return responseData;
}

+ (NSArray*)convertToIncidents:(NSString*)JSONString {	
	SBJSON *parser = [[SBJSON alloc] init];    
	NSArray *incidetsList = [parser objectWithString:JSONString error:nil];	
	
	NSMutableArray *incidents = [NSMutableArray array];
	CCIncident *i;
	for(NSDictionary* d in incidetsList) {
		i = [[CCIncident alloc] initWithDescription:[d objectForKey:@"description"] 
										   andImage:nil 
											 andLat:[[d objectForKey:@"latitude"] doubleValue]  
											 andLon:[[d objectForKey:@"longitude"] doubleValue]
									   andImageLink:[d objectForKey:@"image"]];
		[incidents addObject:i];
		CCLOG(@"%@",i);
		[i release], i=nil;
	}
	
	return incidents;	
}

+ (NSArray*)fetchIncidentsAround:(CLLocationCoordinate2D)location withLonDelta:(double)lonDelta andLatDelta:(double)latDelta {
	/*
	 http://schandfleck.in/1/incident_reports.json?latitude=3.0&longitude=3.0&limit=0&range_x=10&range_y=10	 
	 [{"latitude":5.0,"description":"testthingie","longitude":5.0,"user":"andreas happe","image":"/images/original/missing.png"}]	 
	 */	
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@.json?latitude=%d&longitude=%d&range_x=%d&range_y=%d&limit=20", kRestIncidents, location.latitude, location.longitude, lonDelta, latDelta]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"GET"];
	
	NSData* responseData = [CCIncident synchronousSendURLRequest:request];
	NSString *r = [[NSString alloc] initWithData:responseData 
										encoding:NSUTF8StringEncoding];
	CCLOG(@"response data: %@", r);	
	return [CCIncident convertToIncidents:r];
}

+ (void)testFetch {
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@.json",kRestIncidents]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"GET"];	
	NSData* responseData = [CCIncident synchronousSendURLRequest:request];
	NSString *r = [[NSString alloc] initWithData:responseData 
										encoding:NSUTF8StringEncoding];
//	CCLOG(@"response data: %@", r);	
//	CCLOG(@"test fetch parsed data: %@", [CCIncident convertToIncidents:r]);
}

@end