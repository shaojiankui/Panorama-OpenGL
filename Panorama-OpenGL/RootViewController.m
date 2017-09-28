//
//  RootViewController.m
//  Panorama-OpenGL
//
//  Created by Jakey on 2016/10/27.
//  Copyright © 2016年 www.skyfox.org. All rights reserved.
//

#import "RootViewController.h"
#import "SphericalViewController.h"
#import "CubicViewController.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cubicTouched:(id)sender {
    CubicViewController *cubic = [CubicViewController new];
    [self.navigationController pushViewController:cubic animated:YES];
    
}

- (IBAction)sphericalTouched:(id)sender {
    SphericalViewController *demo = [SphericalViewController new];
//    demo.view.frame = self.view.bounds;
//    demo.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
//    [self.view addSubview:demo.view];
//    [self addChildViewController:demo];
    [self.navigationController pushViewController:demo animated:YES];
}
@end
