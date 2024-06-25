//
//  UMHJBaseViewModel.m
//  UserMessage
//
//  Created by 李标 on 2022/11/19.
//

#import "UMHJBaseViewModel.h"

@implementation UMHJBaseViewModel

- (id)init {
    self = [super init];
    if (self) {
        self.code = @"";
        self.resultCode = @"";
        self.resultMsg = @"";
    }
    return self;
}

@end
