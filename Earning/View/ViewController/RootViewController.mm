//
//  RootViewController.m
//  Earning
//
//  Created by 淞 柴 on 15/4/16.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import "RootViewController.h"
#import "AddCategoryViewController.h"
#import "EarningMainService.h"
#import "CategoryProfileViewController.h"
#import "BaseTableViewCell.h"
#import "CSExtensionCenter.h"
#import "EarningUtil.h"
#import "EGORefreshTableHeaderView.h"

@interface RootViewController()<IDataChangeExt, EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}
@end

@implementation RootViewController


- (void) viewDidLoad
{
    REGISTER_EXTENSION(IDataChangeExt, self);
    _needTableview = YES;
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self configNavBar];
    _tableview.frame = CGRectMake(0, 64, _tableview.width, self.view.height - 64);
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _tableview.height, self.view.width, _tableview.height)];
        view.delegate = self;
        [_tableview addSubview:view];
        _refreshHeaderView = view;
    }
    [self reloadTableViewDataSource];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) dealloc
{
    UNREGISTER_EXTENSION(IDataChangeExt, self);
}

#pragma - mark init
- (void) configNavBar
{
    self.title = @"持仓盈亏";
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:(UIBarButtonItemStylePlain) target:self action:@selector(editTableView:)];
    self.navigationItem.leftBarButtonItem = item;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:(UIBarButtonItemStylePlain) target:self action:@selector(addNew:)];
}

#pragma - mark action
- (void) editTableView:(id)sender
{
    [_tableview setEditing:!_tableview.editing animated:YES];
}

- (void) addNew:(id)sender
{
    AddCategoryViewController* addViewController = [[AddCategoryViewController alloc]init];
    [self.navigationController pushViewController:addViewController animated:YES];
}

#pragma - mark delegate

#pragma - mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryItem* item = [_dataArray objectAtIndex:indexPath.row];
    CategoryProfileViewController* profileViewController = [[CategoryProfileViewController alloc]init];
    profileViewController.categoryItem = item;
    [self.navigationController pushViewController:profileViewController animated:YES];
}

#pragma - mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryItem* item = [_dataArray objectAtIndex:indexPath.row];
    BaseTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"RootList"];
    if (cell == nil) {
        cell = [[BaseTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"RootList"];
    }
    double earn = 0;
    BOOL isGS = NO;
    NSString* pre;
    if ([EarningUtil calc:item TodayEarning:&earn isGS:&isGS]) {
        pre = [NSString stringWithFormat:@"%@今日%.1f", isGS ?@"[估]" :@"", earn];
    }
    else
    {
        pre = @"";
    }

    [cell setContentText: [NSString stringWithFormat:@"%@-%@(%@)", pre, item.name, item.code]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{

}

#pragma - mark IDataChangeExt

/**
 *  数据回调，才是真正完成的时候
 */
- (void) categoryRefresh
{
    _reloading = NO;
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:[MainService selectAllCategory]];

    [_tableview reloadData];
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableview];
}

- (void) categoryInsert
{
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:[MainService selectAllCategory]];
    
    NSMutableArray* codeArray = [NSMutableArray arrayWithCapacity:_dataArray.count];
    for (CategoryItem *item in _dataArray) {
        if (item.type == CategoryEnumFund) {
            [codeArray addObject:item.code];
        }
    }
    [MainService requestCategoryCurPrice:codeArray];
    [_tableview reloadData];
}

#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource
{
    _reloading = YES;
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:[MainService selectAllCategory]];
    NSMutableArray* codeArray = [NSMutableArray arrayWithCapacity:_dataArray.count];
    for (CategoryItem *item in _dataArray) {
        [codeArray addObject:item.code];
    }
    [_tableview reloadData];
    [MainService requestCategoryCurPrice:codeArray];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date]; // should return date data source was last changed
    
}
@end
