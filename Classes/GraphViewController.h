//
//  GraphViewController.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"
#import "LandscapeGraphView.h"

@interface GraphViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	NSMutableArray *activities;
	
	UITableView *_tableView;
	int oldSelection;
	
	GraphView *graphView;
	LandscapeGraphView *landscapeView;
	UIView *portraitView;
}

@end
