//
//  DemoViewController.m
//  Demo_Input
//
//  Created by 蔡 雪钧 on 14-4-29.
//  Copyright (c) 2014年 cxjwin. All rights reserved.
//

#import "DemoViewController.h"
#import "ArrayManager.h"

@interface DemoViewController () <UITableViewDataSource, UITableViewDelegate>

// NSArray是线程安全的
@property (copy, nonatomic) NSArray *dataSource;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DemoViewController {
    CGFloat deltaOffsetY;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [[ArrayManager sharedManager] removeObserver:self forKeyPath:kArrayKey];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    self.tableView = [[UITableView alloc] initWithFrame:frame];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    
    [[ArrayManager sharedManager] addObserver:self forKeyPath:kArrayKey options:0 context:NULL];
    
    [ArrayManager sharedManager].realArray = [NSMutableArray arrayWithObjects:@(1), @(2), nil];
    self.dataSource = [[ArrayManager sharedManager].realArray copy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSTimer *timer =
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(move) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:timer forMode:[runLoop currentMode]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSObject *obj = [self.dataSource objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [obj debugDescription];
    
    return cell;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:kArrayKey]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 在主线程Copy一下
            self.dataSource = [[ArrayManager sharedManager].realArray copy];
            [self.tableView reloadData];
        });
    }
}

- (void)move {
    if (++deltaOffsetY > self.tableView.contentOffset.y) {
        deltaOffsetY = 0;
    }
    
    [self.tableView setContentOffset:CGPointMake(0, deltaOffsetY + 1)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
