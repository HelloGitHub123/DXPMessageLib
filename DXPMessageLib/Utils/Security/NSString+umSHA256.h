//
//  NSString+umSHA256.h
//  MMDataMall
//
//  Created by OO on 2020/3/9.
//  Copyright © 2020 libiao. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (umSHA256)
- (NSString *)SHA256;
- (NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
