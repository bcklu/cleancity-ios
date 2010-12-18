//
//  CCPostView.h
//  CleanCity
//
//  Created by codecamp on 12/18/10.
//  Copyright 2010 CodeCamp Klagenfurt. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CCPostView : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	
	IBOutlet UITextView *comment;

	UIActionSheet *imageSourceChooser;
	UIImagePickerController *imagePicker;
	UIImage *pickedImage;
}

- (IBAction) cancel;
- (IBAction) post;
- (IBAction) showImageSourceChooser;


@end
