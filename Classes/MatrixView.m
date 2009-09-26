//
//  MatrixView.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MatrixView.h"

@implementation MatrixView

@synthesize currentPage;
@synthesize pages;
@synthesize delegate;
@synthesize scrollView;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		pages = [[NSMutableArray alloc] init];
		
		editting = NO;
		moved = NO;
    }
    return self;
}

- (void)addPage {
	NSMutableArray *buttons;
	buttons = [[NSMutableArray alloc] init];
	[pages addObject:buttons];
	[buttons release];
}

- (void)clearButtons:(int)page {
	for (int i = [pages count]; i <= page; i++) {
		[self addPage];
	}
	
	NSMutableArray *buttons = [pages objectAtIndex:page];
	for (int i = 0; i < [buttons count]; i++) {
		MatrixButton *button = [buttons objectAtIndex:i];
		[button removeFromSuperview];
	}		
	buttons = [[NSMutableArray alloc] init];
	[pages replaceObjectAtIndex:page withObject:buttons];
	[buttons release];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)timeoutTouch {
	// check that we are still touching the same button
	if (!CGRectContainsPoint(selected.frame, current_touch)) {
		// not in the button anymore, ignore it
		selected = nil;
		return;
	}
	
	// enlarge button, and disable scrollview's handling
	selected.alpha = .6;

	// move to out of scrollview, movements will be done there
	[selected retain];
	[selected removeFromSuperview];
	[scrollView.superview addSubview:selected];
	[selected release];
	
	CGPoint center = selected.center;
	center.x = center.x - currentPage * 320;
	selected.center = center;
	
	[selected stopWobble];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.2];
	selected.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
	
	moved = YES;
	
	scrollView.canCancelContentTouches = NO;
	scrollView.delaysContentTouches = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!editting) {
		return;
	}


	for (UITouch *t in touches) {
		CGPoint position = [t locationInView:self];
		NSMutableArray *buttons = [pages objectAtIndex:currentPage];
		for (MatrixButton *b in buttons) {
			if (CGRectContainsPoint(b.frame, position)) {
				selected = b;
				original_position = position;
				current_touch = position;
				original_center = selected.center;
				[self performSelector:@selector(timeoutTouch) withObject:nil afterDelay:.5];
				
			}
		}
	}
}

- (void)reflowButtons {
	// update positions on current page
	NSMutableArray *buttons = [pages objectAtIndex:currentPage];

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.2];
	for (int i = 0; i < [buttons count]; i++) {
		MatrixButton *b = [buttons objectAtIndex:i];
		
		if (b == selected) {
			continue;
		}
		
		if (i < 9 ) {
			b.center  = CGPointMake((i % 3) * b.bounds.size.width + b.bounds.size.width / 2 + currentPage * 320,
									(i / 3) * b.bounds.size.height + b.bounds.size.height / 2);
		} else {
			// overflow the page
			[buttons removeObject:b];
			MatrixButton *currentButton = b;
			int j = currentPage + 1;
			while (true) {
				NSMutableArray *newbuttons = [pages objectAtIndex:j];
				[newbuttons insertObject:currentButton atIndex:0];
				for (int k = 0; k < [newbuttons count]; k++) {
					MatrixButton *kb = [newbuttons objectAtIndex:k];
					kb.center = CGPointMake((k % 3) * b.bounds.size.width + b.bounds.size.width / 2 + j * 320,
											(k / 3) * b.bounds.size.height + b.bounds.size.height / 2);
				}
				if ([newbuttons count] <= 9) {
					break;
				}
				
				currentButton = [newbuttons objectAtIndex:9];
				[newbuttons removeObject:currentButton];
				j++;
			}			
		}
	}
	selected.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];	
}

#define SCROLL_THRESHOLD 15
#define SCROLL_TIMEOUT	1

- (void)timeoutScroll {
	BOOL scrolled = NO;
	CGRect frame = scrollView.frame;
	frame.origin.y = 0;
	
	// scroll to next/prev page
	if (selected.center.x < SCROLL_THRESHOLD) {
		if (currentPage != 0) {
			frame.origin.x = frame.size.width * (currentPage - 1);
			scrolled = YES;
		}
	} else if (selected.center.x > 320 - SCROLL_THRESHOLD) {
		if (currentPage != [pages count] - 1) {
			frame.origin.x = frame.size.width * (currentPage + 1);
			scrolled = YES;
		}
	}
	
	if (scrolled) {
		[scrollView scrollRectToVisible:frame animated:YES];
		
		// remove selected from current page
		NSMutableArray *buttons = [pages objectAtIndex:currentPage];
		[buttons removeObject:selected];
		
		[self reflowButtons];
	}
		
	// after handling scroll, reset flag
	setScrollTimeout = NO;
}
		
		
- (void)updatePositions {
	int x = selected.center.x / selected.bounds.size.width; 
	int y = selected.center.y / selected.bounds.size.height;
	int position = y * 3 + x;
	
	if (selected.center.x < SCROLL_THRESHOLD ||
		selected.center.x > 320 - SCROLL_THRESHOLD) {
		if (!setScrollTimeout) {
			[self performSelector:@selector(timeoutScroll) withObject:nil afterDelay:SCROLL_TIMEOUT];
			setScrollTimeout = YES;
		}
		return;
	} else {
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeoutScroll) object:nil];
		setScrollTimeout = NO;
	}

//	CGSize s = selected.bounds.size;
//	CGRect r = CGRectMake(x * s.width + s.width / 4, y * s.height + s.height / 4, 
//						  s.width / 2, s.height / 2);
//	if (!CGRectContainsPoint(r, selected.center)) {
//		return;
//	}
	
	NSMutableArray *buttons = [pages objectAtIndex:currentPage];
	
	if (position > [buttons count] - 1) {
		position = [buttons count];
	}
	
	if (position == [buttons indexOfObject:selected]) {
		return;
	}
	
	[selected retain];
	[buttons removeObject:selected];
	if (position >= [buttons count]) {
		[buttons addObject:selected];
	} else {
		[buttons insertObject:selected atIndex:position];
	}
	[selected release];
	
	[self reflowButtons];
}

#define MOVE_THRESHOLD 5
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!editting) {
		return;
	}
	if (!moved) {
		return;
	}

	for (UITouch *t in touches) {
		CGPoint position = [t locationInView:scrollView.superview];
		current_touch = position;
		selected.center = position;
		
		[self updatePositions];
	}
}

- (void)saveButtons {
	for (int i = 0; i < [pages count]; i++) {
		NSMutableArray *buttons = [pages objectAtIndex:i];
		for (int j = 0; j < [buttons count]; j++) {
			MatrixButton *b = [buttons objectAtIndex:j];
			
			if (b.activity.screen != i ||
				b.activity.position != j) {
				b.activity.screen = i;
				b.activity.position = j;
				[b.activity save];
			}

			b.center = CGPointMake((j % 3) * b.bounds.size.width + b.bounds.size.width / 2 + i * 320,
								   (j / 3) * b.bounds.size.height + b.bounds.size.height / 2);			
			
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!editting) {
		return;
	}
	
	if (!moved) {
		// treat as a click
		if (selected && delegate && [delegate respondsToSelector:@selector(matrixButtonClicked:)]) { 
			[delegate matrixButtonClicked:selected];
		}
		selected = nil;
		return;
	}

	for (UITouch *t in touches) {
		CGPoint position = [t locationInView:scrollView.superview];
		current_touch = position;
		selected.center = position;
	}
	
	NSMutableArray *buttons = [pages objectAtIndex:currentPage];
	if ([buttons indexOfObject:selected] == NSNotFound) {
		int x = selected.center.x / selected.bounds.size.width; 
		int y = selected.center.y / selected.bounds.size.height;
		int position = y * 3 + x;
		
		if (position > [buttons count] - 1) {
			position = [buttons count];
		}
		
		if (position >= [buttons count]) {
			[buttons addObject:selected];
		} else {
			[buttons insertObject:selected atIndex:position];
		}
		
		[self reflowButtons];		
	}
	
	[selected removeFromSuperview];
	// snap to position
	int i = [buttons indexOfObject:selected];
	selected.center = CGPointMake((i % 3) * selected.bounds.size.width + selected.bounds.size.width / 2 + currentPage * 320,
					   		      (i / 3) * selected.bounds.size.height + selected.bounds.size.height / 2);
	original_center = selected.center;
	[self addSubview:selected];
	
	selected.transform = CGAffineTransformIdentity;
	[selected wobble];
	selected.alpha = 1;
	selected = nil;
	moved = NO;

	scrollView.canCancelContentTouches = YES;
	scrollView.delaysContentTouches = YES;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[selected removeFromSuperview];
	[self addSubview:selected];
	[selected wobble];
	selected.center = original_center;
	selected.alpha = 1;
	selected = nil;
	moved = NO;	

	scrollView.canCancelContentTouches = YES;
	scrollView.delaysContentTouches = YES;

}

- (BOOL)editting {
	return editting;
}

- (void)setEditting:(BOOL)e {
	if (editting == e) {
		return;
	}
	
	editting = e;
	
	if (editting) {
		for (NSMutableArray *p in pages) {
			for (MatrixButton *b in p) {
				[b wobble];
				b.userInteractionEnabled = NO;
			}
		}
	} else {
		
		for (int i = [pages count] - 1; i >= 0; i--) {
			// remove page if nothing there
			if ([[pages objectAtIndex:i] count] == 0) {
				[pages removeObjectAtIndex:i];
			}
		}
		
		[self saveButtons];
		
		for (NSMutableArray *p in pages) {
			for (MatrixButton *b in p) {
				[b stopWobble];
				b.userInteractionEnabled = YES;
			}
		}		
	}
}
			
- (void)dealloc {
    [super dealloc];
	
	[pages release];
}


@end
