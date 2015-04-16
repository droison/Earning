//
//  RootViewController.m
//  Earning
//
//  Created by 淞 柴 on 15/4/16.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import "RootViewController.h"
#import "AddCategoryViewController.h"

@interface RootViewController()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView* _tableView;
}

@end

@implementation RootViewController


- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self configNavBar];
    [self configTableView];
}

#pragma - mark init
- (void) configNavBar
{
    self.title = @"持仓盈亏";
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:(UIBarButtonItemStylePlain) target:self action:@selector(editTableView:)];
    self.navigationItem.leftBarButtonItem = item;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:(UIBarButtonItemStylePlain) target:self action:@selector(addNew:)];
}

- (void) configTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma - mark action
- (void) editTableView:(id)sender
{
    [_tableView setEditing:!_tableView.editing animated:YES];
}

- (void) addNew:(id)sender
{
    AddCategoryViewController* addViewController = [[AddCategoryViewController alloc]init];
    [self.navigationController pushViewController:addViewController animated:YES];
}

#pragma - mark delegate

#pragma - mark UITableViewDelegate


#pragma - mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"EarnList"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleValue2) reuseIdentifier:@"EarnList"];
        cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    }
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
@end
