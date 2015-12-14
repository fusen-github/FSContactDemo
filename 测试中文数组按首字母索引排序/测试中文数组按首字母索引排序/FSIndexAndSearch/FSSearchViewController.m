//
//  FSSearchViewController.m
//  测试中文数组按首字母索引排序
//
//  Created by 四维图新 on 15/12/14.
//  Copyright (c) 2015年 四维图新. All rights reserved.
//

#import "FSSearchViewController.h"
#import "FSModel.h"
#import "FSResultViewController.h"

@interface FSSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) UILocalizedIndexedCollation *collation;

@property (nonatomic, strong) NSMutableArray *indexTitleArr;

@property (nonatomic, strong) NSMutableArray *searchResultArr;

@property (nonatomic, strong) UISearchController *searchController;

//@property (nonatomic, strong) NSArray *sourceData;

@end

@implementation FSSearchViewController

- (NSMutableArray *)searchResultArr
{
    if (_searchResultArr == nil)
    {
        _searchResultArr = [NSMutableArray array];
    }
    return _searchResultArr;
}

- (NSMutableArray *)indexTitleArr
{
    if (_indexTitleArr == nil)
    {
        _indexTitleArr = [NSMutableArray array];
    }
    return _indexTitleArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadData];
    
    [self setupTableView];
    
}

- (void)loadData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"name" ofType:@"plist"];
    
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
//    self.sourceData = array;
    
    NSMutableArray *modelArr = [NSMutableArray arrayWithCapacity:array.count];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        FSModel *model = [[FSModel alloc] init];
        
        model.name = obj;
        
        [modelArr addObject:model];
        
    }];
    
    // 实例化 整理对象
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    self.collation = collation;
    
    [self.indexTitleArr addObjectsFromArray:collation.sectionIndexTitles];
    
//    collation.sectionTitles.count  A~Z #
    
    NSMutableArray *sectionArr = [NSMutableArray arrayWithCapacity:collation.sectionTitles.count];
    
    [collation.sectionTitles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        NSMutableArray *itemArr = [NSMutableArray array];
        
        [sectionArr addObject:itemArr];
        
    }];
    
    
    [modelArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        NSInteger index = [collation sectionForObject:(FSModel *)obj collationStringSelector:@selector(name)];
        
        NSMutableArray *itemArr = sectionArr[index];
        
        [itemArr addObject:obj];
        
    }];
    
    NSMutableArray *sectionTmpArr = [NSMutableArray array];
    
    [sectionTmpArr addObjectsFromArray:sectionArr];
    
    __block NSInteger integer = 0;
    
    [sectionArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        NSArray *tmpArr = (NSArray *)obj;
        
        if (tmpArr.count == 0)
        {
            [self.indexTitleArr removeObjectAtIndex:idx - integer];
            
            [sectionTmpArr removeObject:tmpArr];
            
            integer++;
        }
    
    }];
    
    
    [sectionTmpArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        NSMutableArray *itemArr = sectionArr[idx];
        
        NSArray *sortedArr = [collation sortedArrayFromArray:itemArr collationStringSelector:@selector(name)];
        
        sectionArr[idx] = [sortedArr mutableCopy];
        
    }];
    
    self.dataArr = sectionTmpArr;
    
    [self.tableView reloadData];
    
}

- (void)setupTableView
{
    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame];
    
    self.tableView = tableView;
    
    tableView.sectionHeaderHeight = 40;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    FSResultViewController *resultController = [[FSResultViewController alloc] init];
    
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:resultController];
    
    self.searchController = searchController;
    
    searchController.searchResultsUpdater = self;
    
    searchController.searchBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, 40);
    
    tableView.tableHeaderView = searchController.searchBar;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
    }
    
    NSArray *itemArr = self.dataArr[indexPath.section];
    
    cell.textLabel.text = [(FSModel *)itemArr[indexPath.row] name];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.self.indexTitleArr[section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    // 可以根据需要返回只存在的数据的索引。
//    return self.indexTitleArr;
    
    return self.collation.sectionTitles; // 返回默认的索引。
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if (searchController.searchBar.text.length)
    {
        [self.searchResultArr removeAllObjects];
        
        [self.dataArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           
            NSArray *arr = (NSArray *)obj;
            
            [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
               
                FSModel *model = (FSModel *)obj;
                
                if ([model.name containsString:searchController.searchBar.text])
                {
                    [self.searchResultArr addObject:model];
                }
                
            }];
            
        }];
    }
    
    if (searchController.searchResultsController)
    {
        FSResultViewController *resultController = (FSResultViewController *)searchController.searchResultsController;
        
        resultController.resultArr = self.searchResultArr;
    }
}





@end





