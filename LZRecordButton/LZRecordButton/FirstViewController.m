//
//  FirstViewController.m
//  LZRecordButton
//
//  Created by Artron_LQQ on 2017/2/14.
//  Copyright © 2017年 Artup. All rights reserved.
//

#import "FirstViewController.h"
#import "LZRecordButton.h"

@interface FirstViewController ()

@property (nonatomic, strong) LZRecordButton *record;
@end

@implementation FirstViewController
- (void)dealloc {
    
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    
    LZRecordButton *btn = [[LZRecordButton alloc]init];
    btn.frame = CGRectMake(100, 100, 100, 100);
    btn.interval = 3;
    [self.view addSubview:btn];

    btn.style = LZRecordButtonStyleBlack;
    [btn actionWithBlock:^(LZRecordButtonState state) {
       
        NSLog(@">>>>>>%ld", (long)state);
    }];
    self.record = btn;
    
    LZRecordButton *btn2 = [[LZRecordButton alloc]init];
    btn2.frame = CGRectMake(100, 300, 100, 100);
    //    btn.interval = 30;
    [self.view addSubview:btn2];
    
    btn2.style = LZRecordButtonStyleGray;
    [btn2 actionWithBlock:^(LZRecordButtonState state) {
        
        NSLog(@">>>>>>%ld", (long)state);
    }];
    self.record = btn;
    
    LZRecordButton *btn1 = [[LZRecordButton alloc]init];
    btn1.frame = CGRectMake(100, 200, 100, 100);
    //    btn.interval = 30;
    [self.view addSubview:btn1];
    
    btn1.style = LZRecordButtonStyleWhite;
    [btn1 actionWithBlock:^(LZRecordButtonState state) {
        
        NSLog(@">>>>>>%ld", (long)state);
    }];
    self.record = btn;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(200, 400, 100, 100);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)btnClick {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
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

@end
