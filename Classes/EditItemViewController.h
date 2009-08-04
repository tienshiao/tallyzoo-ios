//
//  AddItemViewController.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZItem.h"

@class EditItemViewController;

@protocol EditItemDelegate <NSObject>
@optional
-(void)editItemDone:(EditItemViewController *)controller new:(BOOL)new;
@end


@interface EditItemViewController : UITableViewController {
	TZItem *item;
	
	id<EditItemDelegate> delegate;
}

@property(nonatomic, retain) TZItem *item;
@property(assign, nonatomic) id delegate;

- (id)initWithItem:(TZItem *)i;

@end
