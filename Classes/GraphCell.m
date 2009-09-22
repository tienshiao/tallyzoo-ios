//
//  GraphCellView.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 8/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GraphCell.h"
#import "UpperLeftView.h"
#import "UpperRightView.h"
#import "LowerLeftView.h"
#import "LowerRightView.h"
#import "UIColor-Expanded.h"

@implementation GraphCell

@synthesize delegate;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width - 20, self.frame.size.height)];
		containerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
		
		shading = [[UIView alloc] initWithFrame:containerView.bounds];
		shading.backgroundColor = [UIColor blueColor];
		shading.alpha = .1;
		[containerView addSubview:shading];
		
		selectLayer = [[SelectLayer alloc] initWithFrame:containerView.bounds];
		selectLayer.backgroundColor = [UIColor colorWithHexString:@"191970"];
		selectLayer.hidden = YES;
		[containerView addSubview:selectLayer];
		
		alabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 0, 250, self.frame.size.height)];
		alabel.textColor = [UIColor whiteColor];
		alabel.shadowColor = [UIColor darkGrayColor];
		alabel.font = [UIFont boldSystemFontOfSize:20];
		alabel.backgroundColor = [UIColor clearColor];
		alabel.opaque = NO;
		[containerView addSubview:alabel];
		
		accessoryButton = [[UIButton buttonWithType:UIButtonTypeDetailDisclosure] retain];
		CGRect r = accessoryButton.frame;
		r.origin.x = containerView.frame.size.width - 33;
		r.origin.y = 8;
		accessoryButton.frame = r;
		[accessoryButton addTarget:self action:@selector(accessoryClicked:) forControlEvents:UIControlEventTouchUpInside];
		[containerView addSubview:accessoryButton];
		
		UpperLeftView *ulView = [[UpperLeftView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
		ulView.tag = 1;
		[containerView addSubview:ulView];
		[ulView release];
		
		UpperRightView *urView = [[UpperRightView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 30, 0, 10, 10)];
		urView.tag = 2;
		[containerView addSubview:urView];
		[urView release];
		
		LowerLeftView *llView = [[LowerLeftView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 10, 10, 10)];
		llView.tag = 3;
		[containerView addSubview:llView];
		[llView release];
		
		LowerRightView *lrView = [[LowerRightView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 30, self.bounds.size.height - 10, 10, 10)];
		lrView.tag = 4;
		[containerView addSubview:lrView];
		[lrView release];
		
		[self.contentView addSubview:containerView];
		[containerView release];
		
    }
    return self;
}

- (void)accessoryClicked:(id)sender {
	if (delegate && [delegate respondsToSelector:@selector(graphCellAccessoryClicked:)]) { 
		[delegate graphCellAccessoryClicked:self];
	}	
}

- (void)drawRect:(CGRect) rect {

	[[self viewWithTag:3] setHidden:!last];
	[[self viewWithTag:4] setHidden:!last];
	
	[super drawRect:rect];
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
	selectLayer.hidden = !selected;
}

- (int)index {
	return index;
}

- (void)setIndex:(int)i {
	index = i;
	shading.hidden = index % 2 == 1;
}

- (BOOL)first {
	return first;
}

- (void)setFirst:(BOOL)f {
	first = f;
	[[self viewWithTag:1] setHidden:!first];
	[[self viewWithTag:2] setHidden:!first];	
}

- (BOOL)last {
	return last;
}

- (void)setLast:(BOOL)l {
	last = l;
	[[self viewWithTag:3] setHidden:!last];
	[[self viewWithTag:4] setHidden:!last];	
}

- (TZActivity *)activity {
	return activity;
}

- (void)setActivity:(TZActivity *)a {
	activity = a;
	
	alabel.text = activity.name;
}

- (void)dealloc {
    [super dealloc];
	
	[shading release];
	[selectLayer release];
	[alabel release];
	[accessoryButton release];
}


@end
