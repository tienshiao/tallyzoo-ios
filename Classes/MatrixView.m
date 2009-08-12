//
//  MatrixView.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MatrixView.h"
#import "MatrixButton.h"
#import "TallyZooAppDelegate.h"
#import "TZActivity.h"

@implementation MatrixView

- (void)reloadData {
	FMDatabase *dbh = UIAppDelegate.database;
	FMResultSet *rs = [dbh executeQuery:@"SELECT id FROM activities WHERE deleted = 0 AND screen = ?",
					   [NSNumber numberWithInt:_page]];
	while ([rs next]) {
		TZActivity *a = [[TZActivity alloc] initWithKey:[rs intForColumn:@"id"]];
		MatrixButton *button = [[MatrixButton alloc] initWithActivity:a];
		
		// setup frame
		CGRect r = CGRectMake(0, 0, self.bounds.size.width/3, self.bounds.size.height/3);
		r.origin.x = (a.position % 3) * r.size.width;
		r.origin.y = (a.position / 3) * r.size.height;
		button.frame = r;
		
		[buttons replaceObjectAtIndex:a.position withObject:button];
		[self addSubview:button];
		[a release];
		[button release];
	}	
}

- (id)initWithFrame:(CGRect)frame andScreenNumber:(int)page {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		buttons = [[NSMutableArray alloc] init];
		for (int i = 0; i < 9; i++) {
			[buttons addObject:[NSNull null]];
		}
		
		_page = page;
		
		[self reloadData];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
	
	[buttons release];
}


@end
