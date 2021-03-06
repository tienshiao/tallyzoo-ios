//
//  MatrixViewController.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatrixButton.h"
#import "MatrixView.h"
#import "LocationBusyView.h"
#import "AddTipView.h"
#import "CountTipView.h"
#import "Syncer.h"


@interface MatrixViewController : UIViewController<UIScrollViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate, SyncerDelegate> {
	MatrixView *matrixView;
	
	UIPageControl *_pageControl;
	UIScrollView *_scrollView;
	BOOL _pageControlUsed;
	
	UIBarButtonItem *editBarButtonItem;
	UIBarButtonItem *doneBarButtonItem;
	BOOL editting;
	
	int button_behavior;
	int undo_count_id;
	
	UIActionSheet *locationSheet;
	MatrixButton *tmp_button;
	LocationBusyView *locationBusyView;

	AddTipView *addTipView;
	CountTipView *countTipView;
	
	UILabel *syncStatus;
}

@property(assign, nonatomic) BOOL editting;
@property(nonatomic, retain) UILabel *syncStatus;

- (int)getNumberOfScreens;

- (void)addItem:(id)sender;
- (void)editButtons:(id)sender;
- (void)doneButtons:(id)sender;

- (void)waitForLocation;


@end
