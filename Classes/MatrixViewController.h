//
//  MatrixViewController.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatrixView.h"

@interface MatrixViewController : UIViewController<UIScrollViewDelegate, UIAlertViewDelegate> {
	NSMutableArray *matrices;
	
	UIPageControl *_pageControl;
	UIScrollView *_scrollView;
	BOOL _pageControlUsed;
	
	UIBarButtonItem *editBarButtonItem;
	UIBarButtonItem *doneBarButtonItem;
	BOOL editting;
	
	int button_behavior;
	int undo_count_id;
}

- (int)getNumberOfScreens;

- (void)addItem:(id)sender;
- (void)editButtons:(id)sender;
- (void)wobbleView:(UIView *)v;
- (void)stopWobbleView:(UIView *)v;


@end
