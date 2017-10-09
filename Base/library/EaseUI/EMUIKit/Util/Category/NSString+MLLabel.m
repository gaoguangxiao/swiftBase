//
//  NSString+MLLabel.m
//  Pods
//
//  Created by molon on 15/6/13.
//
//

#import "NSString+MLLabel.h"
#import <CommonCrypto/CommonCrypto.h>
@implementation NSString (MLLabel)

- (NSUInteger)lineCount
{
    if (self.length<=0) { return 0; }
    
    NSUInteger numberOfLines, index, stringLength = [self length];
    for (index = 0, numberOfLines = 0; index < stringLength; numberOfLines++) {
        index = NSMaxRange([self lineRangeForRange:NSMakeRange(index, 0)]);
    }
    
    if ([self isNewlineCharacterAtEnd]) {
        return numberOfLines+1;
    }
    
    return numberOfLines;
}

- (BOOL)isNewlineCharacterAtEnd
{
    if (self.length<=0) {
        return NO;
    }
    //检查最后是否有一个换行符
    NSCharacterSet *separator = [NSCharacterSet newlineCharacterSet];
    NSRange lastRange = [self rangeOfCharacterFromSet:separator options:NSBackwardsSearch];
    return (NSMaxRange(lastRange) == self.length);
}

- (NSString*)subStringToLineIndex:(NSUInteger)lineIndex
{
    NSUInteger index = [self lengthToLineIndex:lineIndex];
    
    return [self substringToIndex:index];
}

- (NSUInteger)lengthToLineIndex:(NSUInteger)lineIndex
{
    if (self.length<=0) {
        return 0;
    }
    
    NSUInteger numberOfLines, index, stringLength = [self length];
    for (index = 0, numberOfLines = 0; index < stringLength; numberOfLines++) {
        NSRange lineRange = [self lineRangeForRange:NSMakeRange(index, 0)];
        index = NSMaxRange(lineRange);
        
        if (numberOfLines==lineIndex) {
            NSString *lineString = [self substringWithRange:lineRange];
            if (![lineString isNewlineCharacterAtEnd]) {
                return index;
            }
            //把这行对应的换行符给忽略
            if (NSMaxRange([lineString rangeOfString:@"\r\n"])==lineString.length) {
                return index-2;
            }
            
            return index - 1;
        }
    }
    
    return 0;
}
#pragma mark - 32位 小写
+(NSString *)MD5ForLower32Bate:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
        
    }
    return digest;
}
//小写16位
+(NSString *)MD5ForLower16Bate:(NSString *)str{
    NSString *md5Str = [self MD5ForLower32Bate:str];
    
    NSString *string;
    for (int i=0; i<24; i++) {
        string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}

@end
