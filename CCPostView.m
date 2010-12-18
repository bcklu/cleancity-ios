//
//  CCPostView.m
//  CleanCity
//
//  Created by codecamp on 12/18/10.
//  Copyright 2010 CodeCamp Klagenfurt. All rights reserved.
//

#import "CCPostView.h"
#import "CCDebugMacros.h"

@implementation CCPostView

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[comment becomeFirstResponder];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark IB

- (IBAction) cancel {
	[comment setText:@""];
	[pickedImage release];
	pickedImage = nil;
}

- (IBAction) post {
	
		// Send
	
}

- (IBAction) showImageSourceChooser {
	

	if (!imageSourceChooser) {
		
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
					imageSourceChooser = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"IMAGE_SOURCE_TITLE", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"IMAGE_SOURCE_CANCEL", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"IMAGE_SOURCE_LIBRARY", @""), NSLocalizedString(@"IMAGE_SOURCE_CAMERA", @""), nil];
		} else {
					imageSourceChooser = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"IMAGE_SOURCE_TITLE", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"IMAGE_SOURCE_CANCEL", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"IMAGE_SOURCE_LIBRARY", @""), nil];
		}


	}
	
	
	[imageSourceChooser showInView:self.view];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (!imagePicker) {
		imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.allowsEditing = NO;
		imagePicker.delegate = self;
	}
	
	if (buttonIndex == 0) imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	else if (buttonIndex == 1) imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	
	[self presentModalViewController:imagePicker animated:YES];
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	pickedImage = [[info objectForKey:UIImagePickerControllerOriginalImage] retain];
}

@end
