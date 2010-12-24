//
//  CCNearIncidentsMapView.m
//  CleanCity
//
//  Created by Lukas on 19.12.10.
//  Copyright 2010 CodeCamp Klagenfurt. All rights reserved.
//

#import "CCNearIncidentsMapView.h"
#import "CCPostView.h"


@implementation CCNearIncidentsMapView

@synthesize location, displayedForRotation, postView;


- (void)viewWillAppear:(BOOL)animated {
	if (displayedForRotation) closeButton.hidden = YES;
	else closeButton.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
	MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.01, 0.01));
	[mapView setRegion:region animated:NO];	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)dealloc {
	[postView release];
	[location release];
	[incidents release];
	[reloadTimer release];
	[updateThread release];
	
    [super dealloc];
}

- (void)updateMap {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[incidents release];
	incidents = [CCIncident fetchIncidentsAround:mapView.region.center withLonDelta:mapView.region.span.longitudeDelta andLatDelta:mapView.region.span.latitudeDelta];
	CCLOG(@"Got incidents: %@", incidents);
	[mapView removeAnnotations:[mapView annotations]];
	[mapView addAnnotations:incidents];
	[pool drain];
	[pool release];
}

#pragma mark Interface Builder

- (IBAction) closeMap {
	[postView closeMapView];
}

- (void)setLocation:(CLLocation *)loc {
	if (location != loc) {
		[location release];
		location = [loc retain];
	}
}

#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mv regionDidChangeAnimated:(BOOL)animated {
	if (!updateThread || [updateThread isFinished]) {
		[updateThread release];
		updateThread = [[NSThread alloc] initWithTarget:self selector:@selector(updateMap) object:nil];
	}
	
	if (reloadTimer) {
		[reloadTimer invalidate];
		[reloadTimer release];
		reloadTimer = nil;
	}

	reloadTimer = [[NSTimer scheduledTimerWithTimeInterval:2 target:updateThread selector:@selector(start) userInfo:nil repeats:NO] retain];
	
}

@end
