//
//  CCIncident.h
//  CleanCity
//
//  Created by Martin Gratzer on 18.12.10.
//  Copyright 2010 CodeCamp Klagenfurt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCProgressCallbackProtocol.h"

@interface CCIncident : NSObject {
	NSString* description;
	NSString* user;
	UIImage* image;
	double lat;
	double lon;	
	
	NSObject<CCProgressCallbackProtocol>* callback;
}

@property (retain,nonatomic) NSString* description;
@property (readonly) NSString* user;
@property (retain,nonatomic) UIImage* image;
@property () double lat;
@property () double lon;

- (id)initWithDescription:(NSString*)desc andImage:(UIImage*)img andLat:(double)latitude andLon:(double)longitude;
- (void)send:(NSObject<CCProgressCallbackProtocol>*)callback;

@end
