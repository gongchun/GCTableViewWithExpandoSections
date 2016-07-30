//
//  ViewController.m
//  GCTableViewWithExpandoSections
//
//  Created by 龚纯 on 16/7/28.
//  Copyright © 2016年 龚纯. All rights reserved.
//


#import "ViewController.h"
#import "HeaderView.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,hearderViewDelegate>

@property (assign) BOOL isOpen;
@property (strong,nonatomic) NSArray *sectionNameArray;
@property (strong,nonatomic) NSArray *detailNameArray;
@property (strong,nonatomic) HeaderView *headerView;
@property (strong,nonatomic) NSMutableArray<HeaderView*> *viewArray;
@property (assign) NSInteger selectSection;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //initDataSource
    _sectionNameArray = @[@"中国",@"美国",@"日本"];
    _detailNameArray = @[@[@"江苏",@"上海",@"北京"],@[@"夏威夷",@"华盛顿",@"其他地区"],@[@"冲绳",@"长崎"]];
    _viewArray = [NSMutableArray array];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _isOpen = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark tableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionNameArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_viewArray.count > 0 && ((HeaderView*)[_viewArray objectAtIndex:section]).clickFlage) {
        return ((NSArray*)[_detailNameArray objectAtIndex:section]).count;
    }else{
        return 0;
    }
}

#pragma mark tableView delegate
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentified = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentified];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentified];
    }
    cell.textLabel.text = _detailNameArray[indexPath.section][indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//自定义headerView
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_viewArray.count <= _sectionNameArray.count) {
        _headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 40) headerInSection:section sectionName:_sectionNameArray[section]];
        _headerView.hearderDelegate = self;
        _headerView.tag = section;
        _headerView.clickFlage = NO;
        [_viewArray addObject:_headerView];
    }else{
            if (section == _selectSection) {
                ((HeaderView*)_viewArray[section]).clickFlage = _isOpen;
            }
                _headerView = _viewArray[section];
    }
    return _headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

#pragma mark 
-(void)noticeReloadTableView:(BOOL)isReload selectSection:(NSInteger)selectSection{
    _selectSection = selectSection;
    _isOpen = isReload;
    //[self changeDataSource];
    [self.tableView reloadData];
}

//-(NSMutableArray*)changeDataSource{
//    for (NSInteger i = 0;i < _viewArray.count;i++) {
//        if (i == _selectSection) {
//            ((HeaderView*)_viewArray[i]).clickFlage = _isOpen;
//        }
//    }
//    return _viewArray;
//}
@end
