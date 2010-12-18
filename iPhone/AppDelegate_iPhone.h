//
//  AppDelegate_iPhone.h
//  CleanCity
//
//  Created by Martin Gratzer on 18.12.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"

@interface AppDelegate_iPhone : NSObject <UIApplicationDelegate, FBRequestDelegate> {
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UIViewController* postViewController;
@end

