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

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)viewWillAppear:(BOOL)animated {
	if (displayedForRotation) closeButton.hidden = YES;
	else closeButton.hidden = NO;
	MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.01, 0.01));
	[mapView setRegion:region animated:NO];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
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
	incidents = [CCIncident fetchIncidentsAround:mapView.region.center withLonDelta:mapView.region.span.longitudeDelta andLatDelta:mapView.region.span.latitudeDelta];
	CCLOG(@"%@, Position: %f", incidents, mapView.region.center.latitude);
	[mapView addAnnotations:incidents];
}

@end
