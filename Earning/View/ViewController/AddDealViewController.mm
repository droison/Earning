//
//  AddDealViewController.m
//  Earning
//
//  Created by 淞 柴 on 15/4/17.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import "AddDealViewController.h"
#import "EarningMainService.h"
#import "MMDateFormat.h"

@interface AddDealViewController ()
{
    UISwitch* _switch;
    UILabel* _sellLabel;
    
    UITextField* _num;
    UITextField* _price;
    UITextField* _fee;
    UIDatePicker* _datePicker;
    
    UIView* _contentView;
}

@end

@implementation AddDealViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    if (_categoryItem == nil) {
        [self alert:@"categoryItem不能为空"];
        return;
    }
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self configNavBar];
    
    _contentView = [[UIView alloc]init];
    
    _switch = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 50, 45)];
    [_switch addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
    _sellLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 45)];
    _sellLabel.text = @"买入";
    _sellLabel.x = _switch.right + 5;
    [_contentView addSubview:_sellLabel];
    [_contentView addSubview:_switch];
    
    _num = [[UITextField alloc]initWithFrame:CGRectMake(0, _switch.bottom + 5, QDScreenWidth - 20, 45)];
    _num.keyboardType = UIKeyboardTypeNumberPad;
    _num.placeholder = @"持仓数量";
    [_contentView addSubview:_num];
    
    _price = [[UITextField alloc]initWithFrame:_num.bounds];
    _price.y = _num.bottom + 5;
    _price.placeholder = @"购买价格";
    _price.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [_contentView addSubview:_price];
    
    _fee = [[UITextField alloc]initWithFrame:_num.bounds];
    _fee.y = _price.bottom + 5;
    _fee.placeholder = @"手续费";
    _fee.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [_contentView addSubview:_fee];
    
    _datePicker = [[UIDatePicker alloc]initWithFrame:_num.bounds];
    _datePicker.y = _fee.bottom + 5;
    _datePicker.date = [NSDate date]; // 设置初始时间
    // [oneDatePicker setDate:[NSDate dateWithTimeIntervalSinceNow:48 * 20 * 18] animated:YES]; // 设置时间，有动画效果
    _datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GTM+8"]; // 设置时区，中国在东八区
    //        _datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:72 * 60 * 60 * -1]; // 设置最小时间
    _datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:1*60*60]; // 设置最大时间
    _datePicker.datePickerMode = UIDatePickerModeDate; // 设置样式
    //        [_datePicker addTarget:self action:@selector(oneDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_contentView addSubview:_datePicker];
    
    _contentView.frame = CGRectMake(10, 70, _datePicker.width, _datePicker.bottom);
    
    [self.view addSubview:_contentView];
}

#pragma - mark init
- (void) configNavBar
{
    self.title = [NSString stringWithFormat:@"%@(%@)", _categoryItem.name, _categoryItem.code];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:(UIBarButtonItemStylePlain) target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void) save:(id)sender
{
    DealItem* item = [[DealItem alloc]init];
    item.categoryLocalId = _categoryItem.localId;
    item.price = [_price.text doubleValue];
    item.number = [_num.text doubleValue];
    item.dealTime = [MMDateFormat formatPriceDate:_datePicker.date];
    item.sell = _switch.on;
    item.fee = [_fee.text floatValue];
    [MainService insertDealItem:item];
    
    _categoryItem.totalNumber += item.number;
    _categoryItem.totalPrice += item.number * item.price;
    _categoryItem.totalPrice += ceil(item.number * item.price * item.fee);
    [MainService updateCategoryItem:_categoryItem];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma - mark action
- (void) switchValueChange:(UISwitch*)sender
{
    _sellLabel.text = sender.on ? @"卖出":@"买入";
}
@end
