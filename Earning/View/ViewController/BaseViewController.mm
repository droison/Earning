//
//  BaseViewController.m
//  Earning
//
//  Created by 淞 柴 on 15/4/17.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
{
    UIView* _toastView;
    NSTimer *_toastTimer;
}

@end

@implementation BaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _needTableview = NO;
        _dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_needTableview) {
        [self configTableView];
    }
}

- (void)dealloc
{
    LogI(@"UIViewController dealloc:%@", NSStringFromClass([self class]));
}

- (void)configTableView
{
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UIWidth, UIHeight) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    _tableview.separatorColor = MCOLOR(@"#525252");
    _tableview.showsVerticalScrollIndicator = YES;
//    [_tableview setBackgroundColor:MCOLOR(@"#1F1F1F")];
    [self.view addSubview:_tableview];
    [self.view sendSubviewToBack:_tableview];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArray) {
        return _dataArray.count;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void) alert:(NSString*)text
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:text delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
    alert.tag = ErrorAlertTag;
    [alert show];
}

static int Toast_Label_Tag = 80023;
static int Toast_Label_MaxWidth = 250;

- (void)toast:(NSString*)text
{
    [self toast:text duration:1];
}

- (void)toast:(NSString*)text duration:(int)duration
{
    if (_toastView == nil) {
        _toastView = [[UIView alloc]init];
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 0, 0)];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor whiteColor];
        label.tag = Toast_Label_Tag;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.backgroundColor = [UIColor clearColor];
        [_toastView addSubview:label];
        [_toastView setBackgroundColor:[UIColor grayColor]];
        _toastView.layer.cornerRadius = 5;
        _toastView.clipsToBounds = YES;
    }
    [_toastView removeFromSuperview];
    
    UILabel* label = (UILabel*)[_toastView viewWithTag:Toast_Label_Tag];
    label.text = text;
    [label sizeToFit];
    if (label.frame.size.width > Toast_Label_MaxWidth) {
        label.frame = CGRectMake(10, 5, Toast_Label_MaxWidth, 0);
        [label sizeToFit];
    }
    _toastView.frame = CGRectMake(0, 0, label.frame.size.width + 20, label.frame.size.height + 10);
    _toastView.center = self.view.center;
    [self.view addSubview:_toastView];
    if (_toastTimer != nil) {
        [_toastTimer invalidate];
        _toastTimer = nil;
    }
    _toastTimer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(toastTimerFired:) userInfo:nil repeats:NO];
}

- (void) toastTimerFired:(id)sender
{
    if (_toastTimer && _toastTimer == sender) {
        _toastTimer = nil;
        if (_toastView) {
            [_toastView removeFromSuperview];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == ErrorAlertTag)
    {
       [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
