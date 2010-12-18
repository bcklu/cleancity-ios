//
//  CCPostView.h
//  CleanCity
//
//  Created by codecamp on 12/18/10.
//  Copyright 2010 CodeCamp Klagenfurt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface CCPostView : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate> {
	
	IBOutlet UITextView *comment;

	UIActionSheet *imageSourceChooser;
	UIImagePickerController *imagePicker;
	UIImage *pickedImage;
	
	CLLocationManager *locationManager;
	CLLocation *location;
}

- (IBAction) cancel;
- (IBAction) post;
- (IBAction) showImageSourceChooser;


@end
