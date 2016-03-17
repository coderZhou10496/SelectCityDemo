//
//  CityViewController.h
//  MySelectCityDemo
//
//  Created by 李阳 on 15/9/1.
//  Copyright (c) 2015年 WXDL. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property (nonatomic,copy)void(^selectString)(NSString *string);
@property (nonatomic,copy)NSString *currentCityString;
@end
