#import "YoureGM.h"
#include <asl.h>
#include <stdio.h>
#include <CommonCrypto/CommonDigest.h>
@implementation YoureGM

- (NSString *)getCodeChallenge:(char *)arg0
{
    NSString * verifier = [NSString stringWithUTF8String: arg0];

    u_int8_t buffer[CC_SHA256_DIGEST_LENGTH * sizeof(u_int8_t)];
    memset(buffer, 0x0, CC_SHA256_DIGEST_LENGTH);
    NSData *data = [verifier dataUsingEncoding:NSUTF8StringEncoding];
    CC_SHA256([data bytes], (CC_LONG)[data length], buffer);
    NSData *hash = [NSData dataWithBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
    NSString *challenge = [[[[hash base64EncodedStringWithOptions:0]
                             stringByReplacingOccurrencesOfString:@"+" withString:@"-"]
                             stringByReplacingOccurrencesOfString:@"/" withString:@"_"]
                             stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"="]];

    return challenge;
}


@end
