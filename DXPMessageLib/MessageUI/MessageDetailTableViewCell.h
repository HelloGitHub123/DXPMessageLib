//
//  MessageDetailTableViewCell.h
//  UserMessage
//
//  Created by 李标 on 2022/12/2.
//

#import <UIKit/UIKit.h>
#import <YYText/YYLabel.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *messageTitleLab;
@property (nonatomic, strong) UILabel *messageDateLab;
@property (nonatomic, strong) UITextView *messageTextView;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, copy) NSString *imgURl;
@property (nonatomic, assign) CGFloat h_imgView;
@property (nonatomic, copy) NSMutableAttributedString *messageStr;
@end

NS_ASSUME_NONNULL_END
