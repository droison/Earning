//
//  CategoryProfileViewController.m
//  Earning
//
//  Created by 淞 柴 on 15/4/17.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import "CategoryProfileViewController.h"
#import "AddCategoryViewController.h"
#import "AddDealViewController.h"
#import "EarningMainService.h"
#import "BaseTableViewCell.h"
#import "CSExtensionCenter.h"
#import "EarningUtil.h"

@interface CategoryProfileViewController ()<IDataChangeExt>
{
    UILabel* _headLabel;
}

@end

@implementation CategoryProfileViewController

- (instancetype) init
{
    self = [super init];
    if (self) {
        _needTableview = YES;
        REGISTER_EXTENSION(IDataChangeExt, self);
    }
    return self;
}

- (void) viewDidLoad
{
    _needTableview = YES;
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (_categoryItem == nil) {
        LogE(@"_categoryItem is nil");
        [self alert:@"categoryItem不能为空"];
        return;
    }
    [self configNavBar];
    
    [_dataArray addObjectsFromArray:[MainService getDealArrayByCategoryId:_categoryItem.localId]];
    
    [self configHeaderView];
    [_tableview reloadData];
    
    { //验证一次计算的对不对
        double totalNum = 0;
        double totalPrice = 0;
        for (DealItem* item in _dataArray) {
            if (item.sell) {
                totalNum -= item.number;
                totalPrice += ceil(item.price * item.number * item.fee);
                totalPrice -= item.price * item.number;
            }
            else
            {
                totalNum += item.number;
                totalPrice += item.price * item.number;
                totalPrice += ceil(item.price * item.number * item.fee);
            }
        }
        if (totalNum != _categoryItem.totalNumber || totalPrice != _categoryItem.totalPrice) {
            _categoryItem.totalNumber = totalNum;
            _categoryItem.totalPrice = totalPrice;
            [MainService updateCategoryItem:_categoryItem];
        }
    }
}

- (void)dealloc
{
    UNREGISTER_EXTENSION(IDataChangeExt, self);
}

#pragma - mark init
- (void) configNavBar
{
    self.title = [NSString stringWithFormat:@"%@(%@)", _categoryItem.name, _categoryItem.code];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:(UIBarButtonItemStylePlain) target:self action:@selector(add:)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void) configHeaderView
{
    UIView* headView = [[UIView alloc]initWithFrame:CGRectMake(5, 0, UIWidth - 10, 0)];
    _headLabel = [[UILabel alloc]initWithFrame:headView.bounds];
    [self refreshHeadLabel];
    _headLabel.numberOfLines = 0;
    [_headLabel sizeToFit];
    _headLabel.width = UIWidth - 10;
    [headView addSubview:_headLabel];
    headView.height = _headLabel.height;
    if (_categoryItem.shouldAutoSync == NO)
    {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, _headLabel.bottom, 150, 30)];
        [btn setTitle:@"手动修改净值" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(categoryEdit:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:btn];
        headView.height = btn.bottom;
    }
    [_tableview setTableHeaderView:headView];
}

#pragma - mark action
- (void) categoryEdit:(id)sender
{
    AddCategoryViewController* categoryViewController = [[AddCategoryViewController alloc] init];
    categoryViewController.categoryItem = _categoryItem;
    [self.navigationController pushViewController:categoryViewController animated:YES];
}

- (void) add:(id)sender
{
    AddDealViewController* addDealViewController = [[AddDealViewController alloc]init];
    addDealViewController.categoryItem = _categoryItem;
    [self.navigationController pushViewController:addDealViewController animated:YES];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DealItem* item = [_dataArray objectAtIndex:indexPath.row];
    
    BaseTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DealItemList"];
    if (cell == nil) {
        cell = [[BaseTableViewCell alloc]initWithStyle:(UITableViewCellStyleValue2) reuseIdentifier:@"DealItemList"];
    }
    [cell setContentText:[NSString stringWithFormat:@"%@ %@ %.2f股  %.3f元", item.dealTime, item.sell?@"卖出":@"买入", item.number, item.price]];
    return cell;
}

- (void) refreshHeadLabel
{
    double curTotal = _categoryItem.totalNumber * _categoryItem.curPrice;
    double earn = curTotal - _categoryItem.totalPrice;
    _headLabel.text = [NSString stringWithFormat:@"%@\n净值时间：%@\n当前总资产：%.2f\n总成本：%.2f\n当前净值：%.2f\n总持仓笔数：%.2f\n当前总收益：%.2f", [EarningUtil calcTodayEarning:_categoryItem],_categoryItem.curPriceTime, curTotal, _categoryItem.totalPrice, _categoryItem.curPrice, _categoryItem.totalNumber, earn];
}

#pragma - mark IDataChangeExt
- (void) categoryUpdate:(CategoryItem*)item
{
    if (item.localId == _categoryItem.localId) {
        _categoryItem = item;
        [self refreshHeadLabel];
    }
}

- (void) dealInsert:(DealItem*)item
{
    [_dataArray insertObject:item atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableview insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
@end
