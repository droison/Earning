//
//  AddCategoryViewController.mm
//  Earning
//
//  Created by 淞 柴 on 15/4/16.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import "AddCategoryViewController.h"
#import "DateFormat.h"
#import "EarningMainService.h"

#define ChooseStockOrFundAlertTag 10001

@interface AddCategoryViewController ()
{
    UIView* _contentView;
    UITextField* _name;
    UITextField* _code;
    UITextField* _price;
    
    UIDatePicker* _datePicker;
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
    if (_categoryItem) {
        _name.text = _categoryItem.name;
        _name.enabled = NO;
    }
    else
    {
        _name.placeholder = @"输入基金或者股票名称";
    }
    [_contentView addSubview:_name];
    
    _code = [[UITextField alloc]initWithFrame:_name.bounds];
    _code.y = _name.bottom + 5;
    if (_categoryItem) {
        _code.text = _categoryItem.code;
        _code.enabled = NO;
    }
    else
    {
        _code.placeholder = @"基金或股票代码";
    }
    _code.keyboardType = UIKeyboardTypeNumberPad;
    [_contentView addSubview:_code];
    
    _contentView.frame = CGRectMake(10, 70, _code.width, _code.bottom);
    
    if (_categoryItem) {
        _price = [[UITextField alloc]initWithFrame:_name.bounds];
        _price.y = _code.bottom + 5;
        if (_categoryItem) {
            _price.placeholder = @"单价";
        }
        else
        {
            _price.placeholder = @"今日单价";
        }
        _price.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [_contentView addSubview:_price];
        
        _datePicker = [[UIDatePicker alloc]initWithFrame:_name.bounds];
        _datePicker.y = _price.bottom + 5;
        _datePicker.date = [NSDate date]; // 设置初始时间
        // [oneDatePicker setDate:[NSDate dateWithTimeIntervalSinceNow:48 * 20 * 18] animated:YES]; // 设置时间，有动画效果
        _datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GTM+8"]; // 设置时区，中国在东八区
//        _datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:72 * 60 * 60 * -1]; // 设置最小时间
//        _datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:72 * 60 * 60]; // 设置最大时间
        _datePicker.datePickerMode = UIDatePickerModeDate; // 设置样式
//        [_datePicker addTarget:self action:@selector(oneDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_contentView addSubview:_datePicker];
        _contentView.height = _datePicker.bottom;
    }
    
    [self.view addSubview:_contentView];
    
    if (_categoryItem && _categoryItem.shouldAutoSync == YES)
    {
        LogE(@"不该出现，自动更新的就不能手动输入了");
        [self alert:@"可以自动更新的就不能手动更新了"];
    }
    
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
    [self.view endEditing:YES];
    if ( _categoryItem == nil) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"这个是基金还是股票？" delegate:self cancelButtonTitle:@"基金" otherButtonTitles:@"股票", nil];
        alert.tag = ChooseStockOrFundAlertTag;
        [alert show];
    }
    else
    {
        _categoryItem.curPriceTime = [DateFormat formatPriceDate:[_datePicker date]];
        _categoryItem.curPrice = [_price.text doubleValue];
        [MainService updateCategoryItem:_categoryItem];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    if (alertView.tag == ChooseStockOrFundAlertTag)
    {
        CategoryItem* item = [[CategoryItem alloc]init];
        item.name = _name.text;
        item.code = _code.text;
        item.curPrice = [_price.text doubleValue];
        item.curPriceTime = [DateFormat formatPriceDate:[NSDate date]];
        item.type = buttonIndex == 0? CategoryEnumFund : CategoryEnumStock;
        item.shouldAutoSync = NO;
        [MainService insertCategoryItem:item];
        [_name setEnabled:NO];
        [_code setEnabled:NO];
        [_price setEnabled:NO];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
