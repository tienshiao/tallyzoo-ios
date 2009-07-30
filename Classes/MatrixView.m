//
//  MatrixView.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MatrixView.h"
#import "MatrixButton.h"

@implementation MatrixView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.backgroundColor = [UIColor blackColor];
		
		MatrixButton *button = [[MatrixButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
		button.title = @"test";
		button.backgroundColor = [UIColor yellowColor];
		
		
		[self addSubview:button];
		[button release];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}


@end
