//
//  MessageStyleModel.m
//  DXPMessageLib
//
//  Created by 李标 on 2024/6/25.
//

#import "MessageStyleModel.h"
#import "MessageHeader.h"

@implementation MessageStyleModel

- (id)init {
	self = [super init];
	if (self) {
		self.navMainTitle = @"Message";
		self.tip_MessageRead = @"Do you want to set all messages as read?";
		self.btn_yes = @"Yes";
		self.btn_cancel = @"Cancel";
		self.btn_ok = @"OK";
		self.tip_DeleteMessage = @"Do you want to delete this message?";
		self.tip_DeleteMessages = @"Do you want to delete this messages?";
		self.read = @"Read";
		self.text_delete = @"Delete";
		self.noResults = @"No Results";
		self.noMessage = @"You have no messages now.";
		self.edit = @"Edit";
		self.selectAll = @"Select All";
		self.deleteAll = @"Delete";
		self.rightBarButtonColor = UIColorFromRGB_um(0x1700E8);
		self.popOKButtonColor = UIColorFromRGB_um(0xFF5E00);
		self.popBgOKButtonColor = UIColorFromRGB_um(0xFFFFFF);
		self.bottomDeleteButtonBgColor = UIColorFromRGB_um(0xFF5E00);
		self.bottomDeleteButtonTitleColor = UIColorFromRGB_um(0xFFFFFF);
		self.details = @"Details";
		self.jan = @"Jan"; // 1
		self.feb = @"Feb"; // 2
		self.mar = @"Mar"; // 3
		self.apr = @"Apr"; // 4
		self.may = @"May"; // 5
		self.jun = @"Jun"; // 6
		self.jul = @"Jul"; // 7
		self.aug = @"Aug"; // 8
		self.sep = @"Sep"; // 9
		self.oct = @"Oct"; // 10
		self.nov = @"Nov"; // 11
		self.dec = @"Dec"; // 12
		self.titleColor = UIColorFromRGB_um(0x719E19);
		self.unSelectedTitleColor = UIColorFromRGB_um(0x242424);
		self.lineColor = UIColorFromRGB_um(0x719E19);
		self.tabTitleArr = @[@"Message",@"Notice"];
	}
	return self;
}
@end
