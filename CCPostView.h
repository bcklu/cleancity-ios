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


@interface CCPostView : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, FBSessionDelegate> {
	
	IBOutlet UITextView *comment;

	UIActionSheet *imageSourceChooser;
	UIImagePickerController *imagePicker;
	UIImage *pickedImage;
	UIImageView *pickedImagePreview;
	
	CLLocationManager *locationManager;
	CLLocation *location;
}

- (IBAction) cancel;
- (IBAction) post;
- (IBAction) showImageSourceChooser;


@end
