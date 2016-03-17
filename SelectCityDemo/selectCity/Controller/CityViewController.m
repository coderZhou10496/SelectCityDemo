//
//  CityViewController.m
//  MySelectCityDemo
//
//  Created by 李阳 on 15/9/1.
//  Copyright (c) 2015年 WXDL. All rights reserved.
//

#import "CityViewController.h"
#import "CustomTopView.h"
#import "CustomSearchView.h"
#import "ResultCityController.h"
#import "CityModel.h"
#import "CityTableViewCell.h"
#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface CityViewController ()<CustomTopViewDelegate,CustomSearchViewDelegate,ResultCityControllerDelegate>
@property (nonatomic,retain) CustomTopView *navView; //自定义导航栏
@property (nonatomic,retain) CustomSearchView *searchView; //searchBar所在的view
@property (nonatomic,retain)UIView *blackView; //输入框编辑时的黑色背景view
@property (nonatomic,retain)NSDictionary *bigDic; // 读取本地plist文件的字典
@property (nonatomic,retain)NSMutableArray *sectionTitlesArray; // 区头数组
@property (nonatomic,retain)NSMutableArray *rightIndexArray; // 右边索引数组
@property (nonatomic,retain)NSMutableArray *dataArray;// cell数据源数组
@property (nonatomic,retain)NSMutableArray *pinYinArray; // 地区名字转化为拼音的数组
@property (nonatomic,retain)ResultCityController *resultController;//显示结果的controller
@property (nonatomic,retain)NSArray *currentCityArray;// 当前城市
@property (nonatomic,retain)NSArray *hotCityArray; // 热门城市
@end

@implementation CityViewController
-(UIView *)blackView
{
    if(!_blackView)
    {
        _blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _blackView.backgroundColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:0.6];
        _blackView.alpha = 0;
        [self.view addSubview:_blackView];
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectCancelBtn)];
        [_blackView addGestureRecognizer:ges];
    }
    return _blackView;
}
-(ResultCityController *)resultController
{
    if(!_resultController)
    {
        _resultController = [[ResultCityController alloc] init];
        
        _resultController.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        _resultController.delegate = self;
        [self.view addSubview:_resultController.view];
    }
    return _resultController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];

    self.searchView = [[CustomSearchView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 44)];
    _searchView.delegate = self;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView  = _searchView;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.sectionIndexColor = [UIColor redColor];
    [self.view addSubview:_tableView];
    
    self.navView = [[CustomTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    _navView.delegate = self;
    [self.view addSubview:_navView];
    
    
}
#pragma mark --UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionTitlesArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0||section==1)
    {
        return 1;
    }
    else
    {
        return [self.dataArray[section] count];
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *HeaderIdentifier = @"header";
   UITableViewHeaderFooterView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
    if( headerView == nil)
    {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderIdentifier];
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 25)];
        titleLabel.tag = 1;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
        [headerView.contentView addSubview:titleLabel];
    }
    headerView.contentView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    UILabel *label = (UILabel *)[headerView viewWithTag:1];
    label.text = self.sectionTitlesArray[section];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        return 60;
    }
    else if (indexPath.section==1)
    {
        return 150;
    }
    else
    {
        return 44;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section<2)
    {
        __weak typeof(self) weakSelf = self;
        CityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell"];
        if(cell==nil)
        {
            cell = [[CityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cityCell" cityArray:self.dataArray[indexPath.section]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.didSelectedBtn = ^(int tag){
            if(tag==1111)
            {
                weakSelf.selectString(weakSelf.currentCityString);
                
            }
            else
            {
                weakSelf.selectString(weakSelf.hotCityArray[tag]);
            }
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
    
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell==nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        NSArray *array = self.dataArray[indexPath.section];
        cell.textLabel.text = array[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
        return cell;
    }
    return nil;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{

    if(_blackView)
    {
        return nil;
    }
    else
    {
        
        return self.rightIndexArray;
    }

}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //此方法返回的是section的值
    NSLog(@"%d",(int)index);
    if(index==0)
    {
        [tableView setContentOffset:CGPointZero animated:YES];
        
        return -1;
    }
    else
    {
        return index+1;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        
        
    }
    else if(indexPath.section==1)
    {
        
    }
    else
    {
        NSString *string = self.dataArray[indexPath.section][indexPath.row];
        self.selectString(string);
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}
#pragma mark --CustomTopViewDelegate
-(void)didSelectBackButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark --CustomSearchViewDelegate
-(void)searchString:(NSString *)string
{
    
  // ”^[A-Za-z]+$”
     NSMutableArray *resultArray  =  [NSMutableArray array];
    if([self isZimuWithstring:string])
    {
        //证明输入的是字母
        self.pinYinArray = [NSMutableArray array]; //和输入的拼音首字母相同的地区的拼音
        NSString *upperCaseString2 = string.uppercaseString;
        NSString *firstString = [upperCaseString2 substringToIndex:1];
        NSArray *array = [self.bigDic objectForKey:firstString];
        [array enumerateObjectsUsingBlock:^(NSString *cityName, NSUInteger idx, BOOL * _Nonnull stop) {
            CityModel *model = [[CityModel alloc] init];
            NSString *pinYin = [self Charactor:cityName getFirstCharactor:NO];
            model.name = cityName;
            model.pinYinName = pinYin;
            [self.pinYinArray addObject:model];
        }];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"pinYinName BEGINSWITH[c] %@",string];
        NSArray *smallArray = [self.pinYinArray filteredArrayUsingPredicate:pred];
        [smallArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    CityModel *model = obj;
                    [resultArray addObject:model.name];
        }];
    }
    else
    {
        //证明输入的是汉字
        [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSArray *sectionArray  = obj;
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] %@",string];
            NSArray *array = [sectionArray filteredArrayUsingPredicate:pred];
            [resultArray addObjectsFromArray:array];
            
        }];
    }
    self.resultController.dataArray = resultArray;
    [self.resultController.tableView reloadData];
}
-(void)searchBeginEditing
{
    [self.view addSubview:_blackView];

    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.navView.frame = CGRectMake(0, -64, SCREEN_WIDTH, 64);
        _tableView.frame = CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.blackView.alpha = 0.6;
        
    } completion:^(BOOL finished) {
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        view1.tag = 333;
        view1.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        [self.view addSubview:view1];

    }];
    [_tableView reloadData];
}
-(void)didSelectCancelBtn
{
    UIView *view1 = (UIView *)[self.view viewWithTag:333];
    [view1 removeFromSuperview];
    [_blackView removeFromSuperview];
    _blackView = nil;
    [self.resultController.view removeFromSuperview];
    self.resultController=nil;
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.navView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
        _tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        
        [self.searchView.searchBar  setShowsCancelButton:NO animated:YES];
        [self.searchView.searchBar resignFirstResponder];

    } completion:^(BOOL finished) {
    }];
    [_tableView reloadData];
}
#pragma mark --ResultCityControllerDelegate
-(void)didScroll
{
    [self.searchView.searchBar resignFirstResponder];
}
-(void)didSelectedString:(NSString *)string
{
    self.selectString(string);
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)loadData
{
    self.rightIndexArray = [NSMutableArray array];
    self.sectionTitlesArray = [NSMutableArray array]; //区头字母数组
    self.dataArray = [NSMutableArray array]; //包含所有区数组的大数组
    NSString *path=[[NSBundle mainBundle] pathForResource:@"citydict"
                                                   ofType:@"plist"];
    self.bigDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSArray * allKeys = [self.bigDic allKeys];
    [self.sectionTitlesArray addObjectsFromArray:[allKeys sortedArrayUsingSelector:@selector(compare:)]];
    [self.sectionTitlesArray enumerateObjectsUsingBlock:^(NSString *zimu, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *smallArray = self.bigDic[zimu];
        [self.dataArray addObject:smallArray];
    }];
    [self.rightIndexArray addObjectsFromArray:self.sectionTitlesArray];
    [self.rightIndexArray insertObject:UITableViewIndexSearch atIndex:0];
    [self.sectionTitlesArray insertObject:@"热门城市" atIndex:0];
    [self.sectionTitlesArray insertObject:@"定位城市" atIndex:0];
    self.currentCityArray = @[self.currentCityString];
    self.hotCityArray = @[@"上海",@"北京",@"广州",@"深圳",@"武汉",@"天津",@"西安",@"南京",@"杭州"];
    [self.dataArray insertObject:self.hotCityArray atIndex:0];
    [self.dataArray insertObject:self.currentCityArray atIndex:0];
}
- (NSString *)Charactor:(NSString *)aString getFirstCharactor:(BOOL)isGetFirst
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pinYin = [str capitalizedString];
    //转化为大写拼音
    if(isGetFirst)
    {
        //获取并返回首字母
        return [pinYin substringToIndex:1];
    }
    else
    {
        return pinYin;
    }
}
-(BOOL)isZimuWithstring:(NSString *)string
{
    NSString* number=@"^[A-Za-z]+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return  [numberPre evaluateWithObject:string];
}
@end
