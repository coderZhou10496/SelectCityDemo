//
//  CustomTopView.m
//  MySelectCityDemo
//
//  Created by 李阳 on 15/9/1.
//  Copyright (c) 2015年 WXDL. All rights reserved.
//

#import "CustomTopView.h"

@implementation CustomTopView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 33, 22, 20)];
       // [btn setTitle:@"返回"  forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"cancelBtn" ] forState:0];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.center = CGPointMake(frame.size.width/2, (frame.size.height/2)+10);
        label.bounds = CGRectMake(0, 0, 100, 30);
        label.text = @"选择城市";
        label.font = [UIFont systemFontOfSize:19];
        label.textColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
        [self addSubview:label];
    
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-1, frame.size.width, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
        [self addSubview:lineView];
    }
    return self;
}
-(void)click
{
    if([_delegate respondsToSelector:@selector(didSelectBackButton)])
    {
        [_delegate didSelectBackButton];
    }
}
@end
