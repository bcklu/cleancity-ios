//
//  CCNearIncidentsMapView.h
//  CleanCity
//
//  Created by Lukas on 19.12.10.
//  Copyright 2010 CodeCamp Klagenfurt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class CCPostView;

@interface CCNearIncidentsMapView : UIViewController <MKMapViewDelegate> {
	IBOutlet MKMapView *mapView;
	IBOutlet UIButton *closeButton;
	CCPostView *postView;
	
	CLLocation *location;
	BOOL displayedForRotation;
	NSArray *incidents;
}

@property (readwrite, retain) CCPostView *postView;
@property (readwrite, retain) CLLocation *location;
@property (readwrite, assign) BOOL displayedForRotation;

- (IBAction) closeMap;

@end
