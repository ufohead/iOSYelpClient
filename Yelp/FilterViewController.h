//
//  FilterViewController.h
//  Yelp
//
//  Created by Ufohead Tseng on 2015/6/24.
//  Copyright (c) 2015年 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterViewController;

@protocol FilterViewControllerDelegate <NSObject>

-(void)filterViewController:(FilterViewController *)filterViewController didChangeFilters:(NSDictionary *)filters;

@end


@interface FilterViewController : UIViewController

@property (nonatomic, weak) id <FilterViewControllerDelegate>
    delegate;
@end
