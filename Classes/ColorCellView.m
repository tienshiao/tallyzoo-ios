//
//  ColorCellView.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 8/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ColorCellView.h"
#import "ColorView.h"
#import "UIColor-Expanded.h"

@implementation ColorCellView
@synthesize color;
@synthesize label;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		label = [[UILabel alloc] initWithFrame:CGRectMake(36, 3, 320-60, 38)];
		label.font = [UIFont boldSystemFontOfSize:18];
		[self.contentView addSubview:label];
		
		colorView = [[ColorView alloc] initWithFrame:CGRectMake(6, 8, 25, 25)];
		colorView.color = color;
		[self.contentView addSubview:colorView];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIColor *)color {
	return color;
}

- (void)setColor:(UIColor *)c {
	[c retain];
	[color release];
	color = c;
	
	colorView.color = color;
	[colorView setNeedsDisplay];
}

- (void)dealloc {	
	[color release];
	[label release];
	
	[colorView release];
    
    [super dealloc];
}


@end
