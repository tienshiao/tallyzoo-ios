//
//  MatrixView.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatrixButton.h"


@interface MatrixView : UIView {
	NSMutableArray *pages;
	int currentPage;
	
	BOOL editting;
	BOOL moved;
	MatrixButton *selected;
	
	id delegate;
	CGPoint original_position;
	CGPoint original_center;
	CGPoint current_touch;
	BOOL setScrollTimeout;
	
	UIScrollView *scrollView;
}

@property (assign,nonatomic) NSMutableArray *pages;
@property (assign,nonatomic) int currentPage;
@property (assign,nonatomic) BOOL editting;
@property (assign,nonatomic) id delegate;
@property (assign,nonatomic) UIScrollView *scrollView;

- (id)initWithFrame:(CGRect)frame;
- (void)clearButtons:(int)page;

@end
