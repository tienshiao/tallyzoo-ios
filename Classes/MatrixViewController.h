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
#import "CountTipView.h"
#import "AdWhirlDelegateProtocol.h"


@interface MatrixViewController : UIViewController<UIScrollViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate, AdWhirlDelegate> {
	MatrixView *matrixView;
	
	UIScrollView *_scrollView;
	
	UIBarButtonItem *editBarButtonItem;
	UIBarButtonItem *doneBarButtonItem;
	BOOL editting;
	
	int button_behavior;
	int undo_count_id;
	
	UIActionSheet *locationSheet;
	MatrixButton *tmp_button;
	LocationBusyView *locationBusyView;
	
	CountTipView *countTipView;
}

@property(assign, nonatomic) BOOL editting;

- (int)getNumberOfScreens;

- (void)addItem:(id)sender;
- (void)editButtons:(id)sender;
- (void)doneButtons:(id)sender;

- (void)waitForLocation;


@end
