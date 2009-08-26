//
//  ShakeView.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 8/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ShakeView.h"


@implementation ShakeView

@synthesize delegate;

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) {
		if ([delegate respondsToSelector:@selector(shakeHappened:)]) {
			[delegate shakeHappened:self]; //not necessary to pass yourself along.
		}
    }
	
    if ([super respondsToSelector:@selector(motionEnded:withEvent:)]) {
        [super motionEnded:motion withEvent:event];
	}
}

- (BOOL)canBecomeFirstResponder { 
	return YES;
}

@end
