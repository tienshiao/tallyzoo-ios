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

@interface GraphCell : UITableViewCell {
	BOOL first;
	BOOL last;
	int index;
	TZActivity *activity;
	
	UIView *shading;
	SelectLayer *selectLayer;
	UILabel *alabel;
}

@property(assign, nonatomic) int index;
@property(assign, nonatomic) BOOL first;
@property(assign, nonatomic) BOOL last;
@property(assign, nonatomic) TZActivity *activity;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

	
@end
