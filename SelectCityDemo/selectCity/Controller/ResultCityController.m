//
//  ResultCityController.m
//  MySelectCityDemo
//
//  Created by 李阳 on 15/9/2.
//  Copyright (c) 2015年 WXDL. All rights reserved.
//

#import "ResultCityController.h"

@implementation ResultCityController
-(void)viewDidLoad
{
    [super viewDidLoad];
  //  NSLog(@"ResultCityController");
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
   // _tableView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:@"Cell"] ;
    }
    
    // 一般我们就可以在这开始设置这个cell了，比如设置文字等：
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *string = _dataArray[indexPath.row];
    if([_delegate respondsToSelector:@selector(didSelectedString:)])
    {
        [_delegate didSelectedString:string];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   if([_delegate respondsToSelector:@selector(didScroll)])
   {
       [_delegate didScroll];
   }
}
@end
