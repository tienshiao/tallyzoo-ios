//
//  MatrixView.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MatrixView.h"

@implementation MatrixView

@synthesize buttons;

- (id)initWithFrame:(CGRect)frame andScreenNumber:(int)page {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		buttons = [[NSMutableArray alloc] init];
		for (int i = 0; i < 9; i++) {
			[buttons addObject:[NSNull null]];
		}
		
		_page = page;
		
    }
    return self;
}

- (void)clearButtons {
	for (int i = 0; i < 9; i++) {
		MatrixButton *button = [buttons objectAtIndex:i];
		if ([button isKindOfClass:[UIView class]]) {
			[button removeFromSuperview];
		}
	}		
	[buttons release];
	buttons = [[NSMutableArray alloc] init];
	for (int i = 0; i < 9; i++) {
		[buttons addObject:[NSNull null]];
	}	
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}



- (void)dealloc {
    [super dealloc];
	
	[buttons release];
}


@end
