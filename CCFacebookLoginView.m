//
//  LoginView.m
//  CleanCity
//
//  Created by Lukas on 19.12.10.
//  Copyright 2010 CodeCamp Klagenfurt. All rights reserved.
//

#import "CCFacebookLoginView.h"


@implementation CCFacebookLoginView

- (void)dealloc {
    [super dealloc];
}

- (IBAction) login {
	Facebook* facebook = [[Facebook alloc] initWithAppId:FB_APP_ID];
	[self dismissModalViewControllerAnimated:NO];
	[facebook authorize:[NSArray arrayWithObjects:@"offline_access", @"email", nil] delegate:self];
	[facebook release];
}

@end
