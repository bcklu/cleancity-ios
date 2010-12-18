//
//  CCAlertView.h
//  CleanCity
//
//  Created by Martin Gratzer on 18.12.10.
//  Copyright 2010 CodeCamp Klagenfurt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCProgressCallbackProtocol.h"

@interface CCAlertView : UIView {
	UIActivityIndicatorView *indicatorView;
	UIProgressView* progress;
	UILabel *descriptionLabel;
	NSInteger maxcount;
	NSString* originalMessage;
}

@property (retain,nonatomic) UIActivityIndicatorView *indicatorView;
@property (retain,nonatomic) UIProgressView *progress;
@property (retain,nonatomic) UILabel *descriptionLabel;

- (id)initWithCenterProgress:(CGPoint)point ;
@end
