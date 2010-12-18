//
//  CCDebugMacros.h
//  CleanCity
//
//  Created by Martin Gratzer on 18.12.10.
//  Copyright 2010 CodeCamp Klagenfurt. All rights reserved.
//

#if defined(APP_STORE_FINAL)
	#define CCLOG(format, ...)
#else
	#define CCLOG(format, ...) CFShow([NSString stringWithFormat: format, \
	## __VA_ARGS__]);
#endif

#define CCLOGERR(format, ...) { NSLog((@"%s [Line %d] " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); }

