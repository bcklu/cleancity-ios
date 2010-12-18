//
//  CCProgressCallbackProtocol.h
//  CleanCity
//
//  Created by Martin Gratzer on 18.12.10.
//  Copyright 2010 CodeCamp Klagenfurt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCProgressCallbackProtocol

-(void) startProgress:(NSNumber*)count;
-(void) doProgress:(NSNumber*)progressIndex;
-(void) endProgress;
-(void) subProgress:(NSString*)message;

@end
