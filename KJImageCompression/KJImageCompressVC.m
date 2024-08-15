//
//  KJImageCompressVC.m
//  KJImageCompression
//
//  Created by TigerHu on 2024/8/15.
//

#import "KJImageCompressVC.h"
#import "UIImage+Compression.h"

@interface KJImageCompressVC ()

@property (nonatomic, strong) UILabel *presiousSizeLabel;
@property (nonatomic, strong) UILabel *finalSizeLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *compressionBtn;

@end

@implementation KJImageCompressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self createView];
    [self setData];
}

- (void)createView {
    self.imageView = [UIImageView new];
    self.imageView.frame = CGRectMake(10, 64 + 90, self.view.bounds.size.width - 20, self.view.bounds.size.height - 64 - 100);
    [self.view addSubview:self.imageView];
    
    self.presiousSizeLabel = [UILabel new];
    self.presiousSizeLabel.frame = CGRectMake(10, 100, self.view.bounds.size.width / 2 - 10, 30);
    self.presiousSizeLabel.text = @"压缩前:";
    [self.view addSubview:self.presiousSizeLabel];
    
    self.finalSizeLabel = [UILabel new];
    self.finalSizeLabel.frame = CGRectMake(self.view.bounds.size.width / 2, CGRectGetMinY(self.presiousSizeLabel.frame), CGRectGetWidth(self.presiousSizeLabel.frame), 30);
    self.finalSizeLabel.text = @"压缩后:";
    [self.view addSubview:self.finalSizeLabel];
    
    self.compressionBtn = [UIButton new];
    self.compressionBtn.frame = CGRectMake(20, CGRectGetMaxY(self.presiousSizeLabel.frame), self.view.bounds.size.width - 40, 40);
    [self.compressionBtn setTitle:@"压  缩" forState:UIControlStateNormal];
    self.compressionBtn.backgroundColor = [UIColor greenColor];
    [self.compressionBtn addTarget:self action:@selector(compressionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.compressionBtn];
}

- (void)setData {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        UIImage *image = [UIImage imageNamed:self.imageName];
        NSData *data;
        if (self.imageFormat == KJImageFormatPNG) {
            data = UIImagePNGRepresentation(image);
        }
        
        if (self.imageFormat == KJImageFormatJPEG) {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        
        if (self.imageFormat == KJImageFormatGIF) {
            NSString *path = [[NSBundle mainBundle] pathForResource:self.imageName ofType:nil];
            data = [NSData dataWithContentsOfFile:path];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.presiousSizeLabel.text = [NSString stringWithFormat:@"压缩前:%.2fMB",data.length / 1000.0 / 1000.0];
            });
            
            CGImageSourceRef imageRef = CGImageSourceCreateWithData((CFDataRef)data, nil);
            NSInteger count = CGImageSourceGetCount(imageRef);
            NSMutableArray<UIImage *> *images = [NSMutableArray array];
            for (int i = 0; i < count; i++) {
                CGImageRef image = CGImageSourceCreateImageAtIndex(imageRef, i, NULL);
                [images addObject:[UIImage imageWithCGImage:image]];
                CGImageRelease(image);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = [UIImage animatedImageWithImages:images duration:1.0/20 * count];
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
            self.presiousSizeLabel.text = [NSString stringWithFormat:@"压缩前:%.2fMB",data.length / 1000.0 / 1000.0];
        });
    });
}

- (void)compressionBtnClicked:(UIButton *)btn {
    
    if (!self.imageView.image) return;
    
    NSString *title = self.title;
    self.title = @"压缩中...";
    btn.enabled = NO;
    
    __block UIImage *image = self.imageView.image;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        image = [UIImage kj_compressWithImage:image imageType:self.imageFormat specifySize:self.specifySize];
        
        NSData *data;
        if (self.imageFormat == KJImageFormatPNG) {
            data = UIImagePNGRepresentation(image);
        } else if (self.imageFormat == KJImageFormatJPEG) {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.title = title;
            btn.enabled = YES;
            self.imageView.image = image;
            self.finalSizeLabel.text = [NSString stringWithFormat:@"压缩后:%.2fMB",data.length / 1000.0 / 1000.0];
        });
    });
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
