//
//  CCAlertView.m
//  CleanCity
//
//  Created by Martin Gratzer on 18.12.10.
//  Copyright 2010 CodeCamp Klagenfurt. All rights reserved.
//

#import "CCAlertView.h"

@implementation CCAlertView

@synthesize indicatorView ;
@synthesize descriptionLabel;
@synthesize progress;

- (id)initWithCenterProgress:(CGPoint)point {
	CGRect frame =  CGRectMake(point.x-200.0f/2, point.y-165.0f/2, 200.0f, 165.0f);
	if ((self = [super initWithFrame:frame]) != nil) {
		self.backgroundColor = [UIColor clearColor];
        
		UIProgressView* ind = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
		ind.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) + CGRectGetHeight(self.bounds) * 0.2f);
		self.progress = ind;
		[self addSubview:ind];
		[ind release];
		
		UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 150.0f, 16.0f)];
		
		label.center = CGPointMake(CGRectGetMidX(self.bounds) + 4.0f, CGRectGetMidY(self.bounds) - CGRectGetHeight(self.bounds) * 0.15f);
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = [UIColor whiteColor];
		label.textAlignment = UITextAlignmentCenter;
		label.text = NSLocalizedString(@"Loading...",@"Activity");
		[self addSubview:label];
		self.descriptionLabel =  label;
		[label release];
		
		self.userInteractionEnabled = YES;
		self.multipleTouchEnabled = YES;
		self.exclusiveTouch = YES;
		
		[self becomeFirstResponder];
    }
	
    return self; 
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame]) != nil) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | 
		UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
		
		self.backgroundColor = [UIColor clearColor];
        
		UIActivityIndicatorView* ind = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		ind.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) - CGRectGetHeight(ind.bounds) / 4.0f);
		self.indicatorView = ind;
		[self addSubview:ind];
		[ind release];
		
		UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 150.0f, 16.0f)];
		
		label.center = CGPointMake(CGRectGetMidX(self.bounds) + 4.0f, CGRectGetMidY(self.bounds) + CGRectGetHeight(label.bounds) * 1.5f);
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = [UIColor whiteColor];
		label.textAlignment = UITextAlignmentCenter;
		label.text = NSLocalizedString(@"Loading...",@"Activity");
		[self addSubview:label];
		self.descriptionLabel =  label;
		[label release];
		
		self.userInteractionEnabled = YES;
		self.multipleTouchEnabled = YES;
		self.exclusiveTouch = YES;
		
		[self becomeFirstResponder];
    }
	
    return self;
}

- (void)dealloc {
	[originalMessage release], originalMessage = nil;
	self.descriptionLabel = nil;
	self.progress = nil;
	self.indicatorView = nil;
    [super dealloc];
}

- (CGPathRef)initRoundedRectPath:(CGFloat)lineWidth cornerRadius:(CGFloat)cornerRadius {
	CGMutablePathRef path = CGPathCreateMutable();
	
	CGFloat originX = self.bounds.origin.x;
	CGFloat originY = self.bounds.origin.y;
	CGFloat layerWidth = self.bounds.size.width;
	CGFloat layerHeight = self.bounds.size.height;
	
	CGPathMoveToPoint(path, NULL, originX + cornerRadius, originY + lineWidth / 2.0f);
	CGPathAddLineToPoint(path, NULL, layerWidth - cornerRadius, originY + lineWidth / 2.0f);
	CGPathAddArcToPoint(path, NULL, layerWidth - lineWidth / 2.0f, originY + lineWidth / 2.0f, layerWidth - lineWidth / 2.0f, originY + cornerRadius, cornerRadius);
	CGPathAddLineToPoint(path, NULL, layerWidth - lineWidth / 2.0f, layerHeight - cornerRadius);
	CGPathAddArcToPoint(path, NULL, layerWidth - lineWidth / 2.0f, layerHeight - lineWidth / 2.0f, layerWidth - cornerRadius, layerHeight - lineWidth / 2.0f, cornerRadius);
	CGPathAddLineToPoint(path, NULL, originX + cornerRadius, layerHeight - lineWidth / 2.0f);
	CGPathAddArcToPoint(path, NULL, originX + lineWidth / 2.0f, layerHeight - lineWidth / 2.0f, originX + lineWidth / 2.0f, layerHeight - cornerRadius, cornerRadius);
	CGPathAddLineToPoint(path, NULL, originX + lineWidth / 2.0f, originY + cornerRadius);
	CGPathAddArcToPoint(path, NULL, originX + lineWidth / 2.0f, originY + lineWidth / 2.0f, originX + cornerRadius, originY + lineWidth / 2.0f, cornerRadius);
	
	return path;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
	[super drawRect:rect]; // not mendatory, and actually here it should do nothing but if we move the super class....
	CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f].CGColor);
	
	CGPathRef path = [self initRoundedRectPath:0.0f cornerRadius:12.0f];
	CGContextAddPath(ctx, path);
	CGContextFillPath(ctx);
	
	CFRelease(path);
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
#pragma unused(touches,event)
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
#pragma unused(touches,event)
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
#pragma unused(touches,event)
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
#pragma unused(touches,event)
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
#pragma unused(point,event)
	return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
#pragma unused(point,event)
	return YES;
}

-(void) startProgress:(NSNumber*)count {
	if(originalMessage) {
		[originalMessage release], originalMessage = nil;
	}
	
	self.progress.progress = 0.0f;
	maxcount=[count intValue];
}

-(void) doProgress:(NSNumber*)progressIndex  {
#pragma unused(progressIndex)	
	self.progress.progress += 1.0f / maxcount;
}

-(void) endProgress {
	self.progress.progress = 1.0f;
}

-(void) subProgress:(NSString*)message {
#pragma unused(message)
}

@end
