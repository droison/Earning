//
//  AddCategoryViewController.mm
//  Earning
//
//  Created by 淞 柴 on 15/4/16.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import "AddCategoryViewController.h"
#import "DealFlowDBMgr.h"

@interface AddCategoryViewController ()
{
    UIView* _contentView;
    UITextField* _name;
    UITextField* _num;
    UITextField* _code;
    UITextField* _price;
}

@end

@implementation AddCategoryViewController


- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self configNavBar];
    
    _contentView = [[UIView alloc]init];
    
    _name = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, QDScreenWidth - 20, 45)];
    _name.placeholder = @"输入基金或者股票名称";
    [_contentView addSubview:_name];
    
    _code = [[UITextField alloc]initWithFrame:_name.bounds];
    _code.y = _name.bottom + 5;
    _code.placeholder = @"基金或股票代码";
    _code.keyboardType = UIKeyboardTypeNumberPad;
    [_contentView addSubview:_code];
    
    _num = [[UITextField alloc]initWithFrame:_name.bounds];
    _num.y = _code.bottom + 5;
    _num.placeholder = @"";
    _num.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [_contentView addSubview:_num];
    
    _price = [[UITextField alloc]initWithFrame:_name.bounds];
    _price.y = _num.bottom + 5;
    _price.placeholder = @"单价";
    _price.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [_contentView addSubview:_price];
    
    _contentView.frame = CGRectMake(10, 70, _price.width, _price.bottom);
    [self.view addSubview:_contentView];
}

#pragma - mark init
- (void) configNavBar
{
    self.title = @"新增持仓";
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:(UIBarButtonItemStylePlain) target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void) save:(id)sender
{
    DealFlowDBMgr* mgr = [[DealFlowDBMgr alloc]init];
    DealItem* item = [[DealItem alloc]init];
    item.number = [_num.text doubleValue];
    item.price = [_price.text doubleValue];
    [mgr insert:item];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
