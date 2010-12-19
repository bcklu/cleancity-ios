//
//  CCPostView.h
//  CleanCity
//
//  Created by codecamp on 12/18/10.
//  Copyright 2010 CodeCamp Klagenfurt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CCDebugMacros.h"
#import "CCIncident.h"
#import "Facebook.h"
#import "CCDefinedConstants.h"
#import "CCAlertView.h"
#import "CCFacebookLoginView.h"
#import "CCNearIncidentsMapView.h"


@interface CCPostView : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, CCProgressCallbackProtocol> {
	
	IBOutlet UITextView *comment;
	IBOutlet UINavigationBar *navbar;

	UIActionSheet *imageSourceChooser;
	UIImagePickerController *imagePicker;
	UIImage *pickedImage;
	UIImageView *pickedImagePreview;
	CCAlertView *alert;
	CCNearIncidentsMapView *map;
	
	CLLocationManager *locationManager;
	CLLocation *location;
}

- (IBAction) cancel;
- (IBAction) post;
- (IBAction) showImageSourceChooser;
- (IBAction) showMapView;

- (void) zoomPreview;
- (void) greyOutBackground:(BOOL)yesOrNo;
- (void) closeMapView;
- (void) closeMapView;


@end
