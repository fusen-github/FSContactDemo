//
//  FSResultViewController.m
//  测试中文数组按首字母索引排序
//
//  Created by 四维图新 on 15/12/14.
//  Copyright (c) 2015年 四维图新. All rights reserved.
//

#import "FSResultViewController.h"
#import "FSModel.h"

@interface FSResultViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FSResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];
    
}

- (void)setResultArr:(NSArray *)resultArr
{
    _resultArr = resultArr;
    
    [self.tableView reloadData];
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView = tableView;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.bounds.size.height);
    
    [self.view addSubview:tableView];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    FSModel *model = self.resultArr[indexPath.row];
    
    cell.textLabel.text = model.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",self.resultArr[indexPath.row]);
}




@end
