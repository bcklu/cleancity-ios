//
//  CCPostView.m
//  CleanCity
//
//  Created by codecamp on 12/18/10.
//  Copyright 2010 CodeCamp Klagenfurt. All rights reserved.
//

#import "CCPostView.h"
#import "NSData+Base64.h"
#import "UIImage+Extras.h"

@implementation CCPostView

@synthesize commenttext;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[comment becomeFirstResponder];
	
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	[locationManager startUpdatingLocation];

	UIImageView *navbarimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar"]];
	[navbar addSubview:navbarimg];
	[navbar sendSubviewToBack:navbarimg];
	
	map = [[CCNearIncidentsMapView alloc] init];
	map.postView = self;
	
	if (commenttext) comment.text = self.commenttext;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	static BOOL firstLaunch = YES;
	
	if (![[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] && firstLaunch) {
		CCFacebookLoginView *fblogin = [[CCFacebookLoginView alloc] init];
		[self presentModalViewController:fblogin animated:NO];
		firstLaunch = NO;
	}
	
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
		[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
		map.displayedForRotation = YES;
		[self showMapView];
	} else {
		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
		if (map.displayedForRotation) {
			[self closeMapView];
			map.displayedForRotation = NO;
		}
	} 
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
	[comment release];
	[imageSourceChooser release];
	[imagePicker release];
	[pickedImage release];
	[locationManager stopUpdatingLocation];
	[locationManager release];
	[location release];
	
	[super dealloc];
}

#pragma mark Interface Builder

- (IBAction) cancel {
	[comment setText:@""];
	[pickedImage release];
	pickedImage = nil;
	[pickedImagePreview removeFromSuperview];
	[pickedImagePreview release], pickedImagePreview=nil;
}

- (IBAction) post {
	
	if (pickedImage) {
		CCIncident *incident = [[CCIncident alloc] initWithDescription:comment.text andImage:pickedImage andLat:location.coordinate.latitude andLon:location.coordinate.longitude];
		CCLOG(@"incident: %@",incident);
		
		if (!alert) { 
			alert = [[CCAlertView alloc] initWithFrame:CGRectMake(70.0f, 50.0f, 180.0f, 180.0f)];
		}
		
		[self.view addSubview:alert];

		[incident send:self];
		[incident release];
	} else {
			//TODO: Present Error
	}

}

- (IBAction) showImageSourceChooser {	
	if (!imageSourceChooser) {
		
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
					imageSourceChooser = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"IMAGE_SOURCE_TITLE", @"") 
																	 delegate:self 
															cancelButtonTitle:NSLocalizedString(@"IMAGE_SOURCE_CANCEL", @"") 
													   destructiveButtonTitle:nil 
															otherButtonTitles:NSLocalizedString(@"IMAGE_SOURCE_LIBRARY", @""), NSLocalizedString(@"IMAGE_SOURCE_CAMERA", @""), nil];
		} else {
					imageSourceChooser = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"IMAGE_SOURCE_TITLE", @"") 
																	 delegate:self
															cancelButtonTitle:NSLocalizedString(@"IMAGE_SOURCE_CANCEL", @"") 
													   destructiveButtonTitle:nil 
															otherButtonTitles:NSLocalizedString(@"IMAGE_SOURCE_LIBRARY", @""), nil];
		}
	}
	
	[imageSourceChooser showInView:self.view];
}

- (IBAction) showMapView {
	
	if (!map) {
		map = [[CCNearIncidentsMapView alloc] init];
	}
	
	map.view.frame = CGRectMake(0, 0, 320, 480);
	map.view.alpha = 0;
	[UIView animateWithDuration:0.5 animations:^(void){
		map.view.alpha = 1;
		[map viewDidAppear:YES];
	}];
	
	[self.view addSubview:map.view];
	[comment resignFirstResponder];
	[map viewWillAppear:YES];
}

- (void) closeMapView {
	self.view.frame = CGRectMake(0, 20, 320, 460);
	[comment becomeFirstResponder];
	[UIView animateWithDuration:0.5 animations:^(void){
		map.view.alpha = 0;
	} completion:^(BOOL x){
		[map.view removeFromSuperview];
	}];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	CCLOG(@"Button %d tapped", buttonIndex);
	
	if (!imagePicker) {
		imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.allowsEditing = NO;
	}
	
	imagePicker.delegate = self;
	
	if (buttonIndex == 0) imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	else if (buttonIndex == 1 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	else return;

	self.commenttext = comment.text;
	
	[self presentModalViewController:imagePicker animated:YES];
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	[pickedImage release];
	pickedImage = [[info objectForKey:UIImagePickerControllerOriginalImage] retain];
	
	if (!pickedImagePreview) {
		pickedImagePreview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 200, 30, 30)];
		
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomPreview)];
		[pickedImagePreview addGestureRecognizer:tap];
		[tap release];
		pickedImagePreview.userInteractionEnabled = YES;
	}
	
	[self.view addSubview:pickedImagePreview];
	[self.view bringSubviewToFront:pickedImagePreview];	
	pickedImagePreview.image = [pickedImage imageByScalingProportionallyToSize:CGSizeMake(200, 200)];
	
	[self dismissModalViewControllerAnimated:YES];
	CCLOG(@"Selected Image");	

}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	[location release];
	location = [newLocation retain];
	if (map) {
		map.location = location;
	}
	CCLOG(@"Got location %@", location);
}

#pragma mark CCProgressCallbackProtocol

-(void) startProgress:(NSNumber*)count {
	[alert startProgress:count];
}

-(void) doProgress:(NSNumber*)progressIndex {
	[alert doProgress:progressIndex];
}

-(void) endProgress {
	[alert endProgress];
	[alert removeFromSuperview];
	[self cancel];
}

-(void) subProgress:(NSString*)message {
	[alert subProgress:message];
}

#pragma mark Animations

- (void) zoomPreview {
	static BOOL zoomed = NO;
	if (zoomed) {
		[self greyOutBackground:NO];
		
		[UIView animateWithDuration:0.5 animations:^(void){
			pickedImagePreview.frame = CGRectMake(20, 200, 30, 30);
			[[self.view viewWithTag:33] setAlpha:0];
			[[self.view viewWithTag:33] setFrame:CGRectMake(4, 184, 31, 31)];
		} completion:^(BOOL finished) {
			[[self.view viewWithTag:33] removeFromSuperview];
		}];
	} else {
		[self greyOutBackground:YES];
		UIImageView *closeButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"close_button"]];
		closeButton.alpha = 0;
		closeButton.frame = CGRectMake(4, 184, 31, 31);
		closeButton.tag = 33;
		closeButton.userInteractionEnabled = YES;
		
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomPreview)];
		[closeButton addGestureRecognizer:tap];
		[self.view addSubview:closeButton];
		[UIView animateWithDuration:0.5 animations:^(void){
			pickedImagePreview.frame = CGRectMake(70, 60, 170, 170);
			closeButton.alpha = 1;
			closeButton.frame = CGRectMake(54, 44, 31, 31);
		}];	
	}
	
	
	zoomed = !zoomed;
}

- (void) greyOutBackground:(BOOL)yesOrNo {
	if (yesOrNo) {
		UIView *black = [[UIView alloc] initWithFrame:CGRectMake(-20, 0, 480, 320)];
		black.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
		black.alpha = 0;
		black.tag = 42;
		[self.view addSubview:black];
		[self.view bringSubviewToFront:pickedImagePreview];
		[self.view bringSubviewToFront:[self.view viewWithTag:33]];
		[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
			black.alpha = 0.5;
		} completion:nil];
		
		[black release];
	} else {
		[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^(void){
			 [[self.view viewWithTag:42] setAlpha:0];
		} completion:^(BOOL x){
			[[self.view viewWithTag:42] removeFromSuperview];
		}];
	}
}



@end
