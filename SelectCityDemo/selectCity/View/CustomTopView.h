//
//  CustomTopView.h
//  MySelectCityDemo
//
//  Created by 李阳 on 15/9/1.
//  Copyright (c) 2015年 WXDL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomTopViewDelegate <NSObject>

-(void)didSelectBackButton;

@end

@interface CustomTopView : UIView
@property (nonatomic,assign) id <CustomTopViewDelegate>delegate;
@end
