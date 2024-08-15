//
//  KJImageCompressVC.h
//  KJImageCompression
//
//  Created by TigerHu on 2024/8/15.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KJImageFormat);

@interface KJImageCompressVC : UIViewController

/** 图片名称 */
@property(nonatomic,copy) NSString *imageName;
/** 图片类型 */
@property(nonatomic,assign) KJImageFormat imageFormat;
/** 期望压缩后的大小,单位:MB */
@property(nonatomic,assign) CGFloat specifySize;

@end
