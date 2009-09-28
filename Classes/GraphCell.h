//
//  GraphCellView.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 8/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZActivity.h"
#import "SelectLayer.h"

@class GraphCell;

@protocol GraphCellDelegate <NSObject>
@optional
- (void)graphCellAccessoryClicked:(GraphCell *)gc;
@end


@interface GraphCell : UITableViewCell {
	BOOL first;
	BOOL last;
	int index;
	TZActivity *activity;
	
	UIView *shading;
	SelectLayer *selectLayer;
	UILabel *alabel;
	UIButton *accessoryButton;
	
	id<GraphCellDelegate> delegate;
}

@property(assign, nonatomic) int index;
@property(assign, nonatomic) BOOL first;
@property(assign, nonatomic) BOOL last;
@property(nonatomic, retain) TZActivity *activity;
@property(assign, nonatomic) id<GraphCellDelegate> delegate;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

	
@end
