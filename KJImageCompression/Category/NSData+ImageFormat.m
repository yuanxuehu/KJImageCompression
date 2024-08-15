//
//  NSData+ImageFormat.m
//  KJImageCompression
//
//  Created by TigerHu on 2024/8/15.
//

#import "NSData+ImageFormat.h"

@implementation NSData (ImageFormat)

+ (KJImageFormat)kj_imageFormatWithImageData:(nullable NSData *)data {
    if (!data) {
        return KJImageFormatUndefined;
    }
    
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return KJImageFormatJPEG;
            
        case 0x89:
            return KJImageFormatPNG;
            
        case 0x47:
            return KJImageFormatGIF;
            
        case 0x40:
        case 0x4D:
            return KJImageFormatTIFF;
            
        case 0x52:
            if (data.length < 12) {
                return KJImageFormatUndefined;
            }
            
            NSString *str = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([str hasPrefix:@"RIFF"] && [str hasSuffix:@"WEBP"]) {
                return KJImageFormatWebp;
            }
    }
    return KJImageFormatUndefined;
}

@end
