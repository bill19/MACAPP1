//
//  ViewController.m
//  MACAPP1
//
//  Created by HaoSun on 2017/11/6.
//  Copyright © 2017年 YHKIT. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "Masonry.h"
#import "SHChildNodeView.h"
#import "SHNetModel.h"
#import "SHParmsModel.h"
#import "SHTransform.h"
#import "SHTableViewRowView.h"
#import "SHTableViewParmsView.h"
#import "CreateModel.h"
#import "SHNetHeaderView.h"
#define KVIEWHALFHEIGHT 500.0f
#define KVIEWHEIGHT  1500.0f
@interface ViewController()<NSTableViewDelegate,NSTableViewDataSource,SHChildNodeViewDelegate,SHTableViewRowViewDelegate,SHTableViewParmsViewDelegate>
/***url的tableview*/
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *parmsSource;
@property (strong, nonatomic) NSTableView * tableView;


@property (strong, nonatomic) NSScrollView * parmsContent;
@property (strong, nonatomic) NSTableView * parmsTableView;

@property (nonatomic, weak) SHChildNodeView *childNodeView;
@property (nonatomic, strong) NSArray *parmsTypesArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupChildNodeView];
    [self setupTableView];
    [self setupParmsTableView];
    self.view.frame = CGRectMake(0, 0, KVIEWHEIGHT, KVIEWHEIGHT);
}

- (void)request {
    NSArray *source = [SHTransform shTransformWithString:_childNodeView.childNodeLab.stringValue];

    for (NSUInteger index = 0; index < source.count; index ++) {
        SHNetModel *model = [[SHNetModel alloc] init];
        model.nodeName = [source objectAtIndex:index];
        model.nodeType = index+1;
        [self.dataSource addObject:model];
    }

    [self.tableView reloadData];
}


- (void)setupChildNodeView {
    SHChildNodeView *childNodeView = [[SHChildNodeView alloc] init];
    childNodeView.frame = CGRectMake(30, KVIEWHALFHEIGHT, 300, 300);
    childNodeView.delegate = self;
    _childNodeView = childNodeView;
    [self.view addSubview:_childNodeView];
}

- (void)setupTableView {

    NSScrollView * tableViewContent = [[NSScrollView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_childNodeView.frame) + 30, KVIEWHALFHEIGHT, KVIEWHALFHEIGHT,300)];

    NSTableColumn *tableColumn = [[NSTableColumn alloc]initWithIdentifier:@"cell"];
    tableColumn.width = self.view.frame.size.width;
    tableColumn.title = @"获取到url的集合";

    [self.view addSubview:tableViewContent];

    self.tableView = [[NSTableView alloc]initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.view addSubview:self.tableView];
    [self.tableView addTableColumn:tableColumn];
    [tableViewContent setDocumentView:self.tableView];
    [tableViewContent setHasVerticalScroller:YES];
    [tableViewContent setHasHorizontalScroller:YES];
}


- (void)setupHeaserView {

    SHNetHeaderView *headerView = [[SHNetHeaderView alloc] init];
}

- (void)setupParmsTableView {

    NSScrollView * tableViewContent = [[NSScrollView alloc]initWithFrame:CGRectMake(30, 100, KVIEWHALFHEIGHT,300)];

    NSTableColumn *tableColumn = [[NSTableColumn alloc]initWithIdentifier:@"cell"];
    tableColumn.width = self.view.frame.size.width;
    tableColumn.title = @"参数集合";

    [self.view addSubview:tableViewContent];

    self.parmsTableView = [[NSTableView alloc]initWithFrame:self.view.frame];
    self.parmsTableView.delegate = self;
    self.parmsTableView.dataSource = self;

    [self.view addSubview:self.parmsTableView];
    [self.parmsTableView addTableColumn:tableColumn];
    [tableViewContent setDocumentView:self.parmsTableView];
    [tableViewContent setHasVerticalScroller:YES];
    [tableViewContent setHasHorizontalScroller:YES];

    NSButton *parmsBtn = [NSButton buttonWithTitle:@"点击生成文档" target:self action:@selector(parmsBtnClick)];
    parmsBtn.frame = CGRectMake(30, 30, KVIEWHALFHEIGHT,30);
    [self.view addSubview:parmsBtn];

    NSButton *clearParmsBtn = [NSButton buttonWithTitle:@"点击清除所有信息" target:self action:@selector(clearParmsBtnClick)];
    clearParmsBtn.frame = CGRectMake(30, 60, KVIEWHALFHEIGHT,30);
    [self.view addSubview:clearParmsBtn];
}

#pragma mark - 生成文档
- (void)parmsBtnClick {
    NSLog(@"点击生成文档");
}

- (void)clearParmsBtnClick {
    NSLog(@"点击清除所有信息");
    [self.parmsSource removeAllObjects];
    [self.parmsTableView reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {

    if (aTableView == self.tableView) {

        return self.dataSource.count;
    }

    if (aTableView == self.parmsTableView) {

        return self.parmsSource.count;
    }
    return 1;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (tableView == self.tableView) {
        SHTableViewRowView *shtabView = [[SHTableViewRowView alloc] init];
        shtabView.netModel = self.dataSource[row];
        shtabView.delegate = self;
        return shtabView;
    }
    if (tableView == self.parmsTableView) {
        SHTableViewParmsView *parmsView = [[SHTableViewParmsView alloc] init];
        parmsView.delegate = self;
        parmsView.parmsModel = self.parmsSource[row];
        return parmsView;
    }
    return [[NSView alloc] init];
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{

    return YES;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 50;
}

#pragma mark - SHTableViewRowViewDelegate
- (void)tableButtonClick:(SHNetModel *)model rowView:(SHTableViewRowView *)rowView{

    NSArray *source = [SHTransform shTransformWithString:rowView.parameterText.stringValue];

    if (source.count>0) {
        for (NSUInteger i = 0; i < source.count; i++) {
            SHParmsModel *parmsModel = [[SHParmsModel alloc] init];
            parmsModel.netUrl = model.nodeName;
            parmsModel.netParameterName = [source objectAtIndex:i];
            parmsModel.netNoteName = @"";
            parmsModel.netTypeName = @"";
            parmsModel.netRequest = rowView.comboBoxItemArr[rowView.requestComBox.integerValue];
            [self.parmsSource addObject:parmsModel];
        }
        [self.parmsTableView reloadData];
    }
}

#pragma mark - SHChildNodeViewDelegate
- (void)saveBtnAcion {
//    [self showAlertText:@"点击"];
    [self request];
}

- (void)clearBtnAcion {
    [self.dataSource removeAllObjects];
    self.childNodeView.childNodeLab.stringValue = @"";
    [self.tableView reloadData];
}

- (void)showAlertText:(NSString *)text {

    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = text;
    [alert addButtonWithTitle:@"确定"];
    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {

    }];
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (NSMutableArray *)parmsSource {

    if (!_parmsSource) {
        _parmsSource = [NSMutableArray array];
    }
    return _parmsSource;

}

@end
