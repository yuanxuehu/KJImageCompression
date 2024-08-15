//
//  ViewController.m
//  KJImageCompression
//
//  Created by TigerHu on 2024/8/15.
//

#import "ViewController.h"
#import "KJImageCompressVC.h"
#import "NSData+ImageFormat.h"

static NSString *const cellID = @"cell";

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *cellDatas;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"图片压缩";
    self.cellDatas = @[@"PNG图片压缩",@"JPEG图片压缩",@"GIF 图片压缩"];
    [self createTableView];
}

- (void)createTableView {
    self.tableView = [UITableView new];
    self.tableView.frame = self.view.bounds;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.cellDatas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    KJImageCompressVC *vc = [KJImageCompressVC new];
    if (indexPath.row == 0) {
        vc.title = @"PNG图片压缩";
        vc.imageName = @"png";
        vc.imageFormat = KJImageFormatPNG;
        vc.specifySize = 0.5;//压缩至500k以内
    }
    
    if (indexPath.row == 1) {
        vc.title = @"JPEG图片压缩";
        vc.imageName = @"jpg.jpg";
        vc.imageFormat = KJImageFormatJPEG;
        vc.specifySize = 1.0;
    }
    
    if (indexPath.row == 2) {
        vc.title = @"GIF 图片压缩";
        vc.imageName = @"gif.gif";
        vc.imageFormat = KJImageFormatGIF;
        vc.specifySize = 0.5;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
