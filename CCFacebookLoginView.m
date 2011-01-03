//
//  LoginView.m
//  CleanCity
//
//  Created by Lukas on 19.12.10.
//  Copyright 2010 CodeCamp Klagenfurt. All rights reserved.
//

#import "CCFacebookLoginView.h"


@implementation CCFacebookLoginView

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIImageView *navbarimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar"]];
	[navbar addSubview:navbarimg];
	[navbar sendSubviewToBack:navbarimg];
}


- (void)dealloc {
    [super dealloc];
}

- (IBAction) login {
	Facebook* facebook = [[Facebook alloc] initWithAppId:FB_APP_ID];
	[self dismissModalViewControllerAnimated:NO];
	[facebook authorize:[NSArray arrayWithObjects:@"offline_access", @"email", nil] delegate:self];
	[facebook release];
}

- (IBAction) cancel {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DAVE_TITLE", @"") message:NSLocalizedString(@"DAVE_MESSAGE", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"DAVE_OKAY", @"") otherButtonTitles:nil];
	[alert show];
	[alert release];
}

@end
