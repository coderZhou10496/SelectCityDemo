//
//  CityTableViewCell.h
//  MySelectCityDemo
//
//  Created by ZJ on 15/10/28.
//  Copyright © 2015年 WXDL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityTableViewCell : UITableViewCell
{
    NSArray * _cityArray;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cityArray:(NSArray*)array;
@property (nonatomic,copy)void(^didSelectedBtn)(int tag);
@end
