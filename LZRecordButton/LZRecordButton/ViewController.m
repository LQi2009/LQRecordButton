//
//  ViewController.m
//  LZRecordButton
//
//  Created by Artron_LQQ on 2017/2/14.
//  Copyright © 2017年 Artup. All rights reserved.
//

#import "ViewController.h"
#import "LZRecordButton.h"
#import "FirstViewController.h"
@interface ViewController ()

@property (nonatomic, strong) CADisplayLink *link;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor grayColor];
    
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(beginRun)];
    _link.preferredFramesPerSecond = 3;
    [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
}

- (void)beginRun {
    
    static NSInteger tmp = 0;
    NSLog(@">>>>> %ld", (long)tmp);
    tmp++;
    
    if (tmp == 10) {
        tmp = 0;
        [_link invalidate];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(beginRun)];
//    _link.preferredFramesPerSecond = 80;
//    [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//    
//    return;
    FirstViewController *fi = [[FirstViewController alloc]init];
    
    [self presentViewController:fi animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
