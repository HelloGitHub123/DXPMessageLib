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

- (NSDictionary *)messageListModelToDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSMutableArray *messageListArray = [NSMutableArray array];
    for (Message *message in self.messageList) {
        [messageListArray addObject:[message toDictionary]];
    }
    [dict setObject:messageListArray forKey:@"messageList"];
    
    if (self.pageInfo) {
        [dict setObject:[self.pageInfo toDictionary] forKey:@"pageInfo"];
    }
    
    return dict;
}

- (NSDictionary *)hj_setupObjectClassInArray {
    return @{
        @"messageList" : [Message class],
    };
}
@end



@implementation Message

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.eventCode ?: @"" forKey:@"eventCode"];
    [dict setObject:self.userId ?: @"" forKey:@"userId"];
    [dict setObject:self.priority ?: @"" forKey:@"priority"];
    [dict setObject:self.messageId ?: @"" forKey:@"messageId"];
    [dict setObject:self.msgType ?: @"" forKey:@"msgType"];
    [dict setObject:self.thumbUrl ?: @"" forKey:@"thumbUrl"];
    [dict setObject:self.title ?: @"" forKey:@"title"];
    [dict setObject:self.brief ?: @"" forKey:@"brief"];
    [dict setObject:self.content ?: @"" forKey:@"content"];
    [dict setObject:self.rule ?: @"" forKey:@"rule"];
    [dict setObject:self.ruleData ?: @"" forKey:@"ruleData"];
    [dict setObject:self.link ?: @"" forKey:@"link"];
    [dict setObject:self.msgAttr ?: @"" forKey:@"msgAttr"];
    [dict setObject:self.effDate ?: @"" forKey:@"effDate"];
    [dict setObject:self.expDate ?: @"" forKey:@"expDate"];
    [dict setObject:self.pushDate ?: @"" forKey:@"pushDate"];
    [dict setObject:self.state ?: @"" forKey:@"state"];
    [dict setObject:self.stateDate ?: @"" forKey:@"stateDate"];
    [dict setObject:@(self.isSelected) forKey:@"isSelected"];
    [dict setObject:@(self.imgHeight) forKey:@"imgHeight"];
    
    if (self.contentParamMap) {
        [dict setObject:[self.contentParamMap toDictionary] forKey:@"contentParamMap"];
    }
    
    return dict;
}


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

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.offerCode ?: @"" forKey:@"offerCode"];
    return dict;
}

@end


@implementation PageInfo

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.pageSize ?: @"" forKey:@"pageSize"];
    [dict setObject:self.currentPage ?: @"" forKey:@"currentPage"];
    [dict setObject:self.total ?: @"" forKey:@"total"];
    return dict;
}

@end


