//
//  LoginView.h
//  CleanCity
//
//  Created by Lukas on 19.12.10.
//  Copyright 2010 CodeCamp Klagenfurt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCDefinedConstants.h"
#import "Facebook.h"

@interface CCFacebookLoginView : UIViewController <FBSessionDelegate> {
	IBOutlet UINavigationBar *navbar;

}

- (IBAction) login;
- (IBAction) cancel;

@end
