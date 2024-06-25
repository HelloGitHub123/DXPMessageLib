//
//  MessageListModel.m
//  UserMessage
//
//  Created by 李标 on 2022/11/21.
//

#import "MessageListModel.h"

@implementation MessageListModelRes

@end



@implementation MessageListModel

- (NSDictionary *)hj_setupObjectClassInArray {
    return @{
        @"messageList" : [Message class],
    };
}
@end



@implementation Message

// model cell 高度
- (CGFloat)getCellHeight {
    CGFloat totalHeight = 0;
    // 计算内容的高度
    NSInteger H_Content = 0;
    if (self.content && ![self.content isEqualToString:@""]) {
        // todo
        
    }
    __block NSInteger imgHeight = 0; // 图片高度
    if (self.thumbUrl && ![self.thumbUrl isEqualToString:@""] && ([self.thumbUrl containsString:@"https://"] || [self.thumbUrl containsString:@"http://"])) {
        
//        dispatch_async(dispatch_get_global_queue(0, 0),^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//            });
//        });
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.thumbUrl]];
        UIImage *image = [UIImage imageWithData:data];
        CGSize imageSize = image.size;
        imgHeight =  [[UIScreen mainScreen] bounds].size.width * imageSize.height / imageSize.width;
        self.imgHeight = imgHeight;
    }
    
    NSInteger H_CellTopBottomPadding = 8; // cell距离分割线的距离（包含上下）
    NSInteger H_TitleTopPadding = 16; //标题距离Backview 顶部的距离
    NSInteger H_Title = 24;
    NSInteger H_DateTopPadding = 8; // 日期距离标题底部的距离
    NSInteger H_Date = 22;
    NSInteger H_ImgTopPadding = imgHeight > 0 ? 8: 0; // 图片距离上面日期底部的距离。如果图片为空，则该距离为0
    NSInteger H_ContentPadding = 12;// 内容距离图片底部的距离
    NSInteger H_ContentBottom = 16;
    // 计算cell的高度
    totalHeight = H_CellTopBottomPadding*2 + H_TitleTopPadding + H_Title + H_DateTopPadding + H_Date + H_ImgTopPadding + imgHeight + H_ContentPadding + H_ContentBottom + H_CellTopBottomPadding;
    return totalHeight;
}

@end



@implementation ContentParamMap


@end


@implementation PageInfo

@end


