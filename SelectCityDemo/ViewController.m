//
//  ViewController.m
//  SelectCityDemo
//
//  Created by ZJ on 15/11/4.
//  Copyright © 2015年 WXDL. All rights reserved.
//

#import "ViewController.h"
#import "CityViewController.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)click:(id)sender
{
    
    CityViewController *controller = [[CityViewController alloc] init];
    controller.currentCityString = @"杭州";
    controller.selectString = ^(NSString *string){
        self.cityLabel.text = string;
    };
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
