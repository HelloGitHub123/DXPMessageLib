//
//  MessageHeader.h
//  DXPMessageLib
//
//  Created by 李标 on 2024/6/24.
//

#ifndef MessageHeader_h
#define MessageHeader_h


#define umDebugLog(s, ...)         NSLog(@"%s(%d): %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#define objectOrEmptyStr_um(obj)    ((obj) ? (obj) : @"")


#define isNull_um(x)                (!x || [x isKindOfClass:[NSNull class]])
#define HTTP_Code_um                (isNull_um([res objectForKey:@"code"])?@"":[res objectForKey:@"code"])
#define HTTP_ResultMsg_um           (isNull_um([res objectForKey:@"resultMsg"])?@"":[res objectForKey:@"resultMsg"])
#define HTTP_Data_um                (isNull_um([res objectForKey:@"data"])?@"":[res objectForKey:@"data"])

#define isEmptyString_um(x)         (isNull_um(x) || [x isEqual:@""] || [x isEqual:@"(null)"] || [x isEqual:@"null"])

// iPhoneX
#define kScreenIsiPhoneXOrMore_um ([[UIScreen mainScreen] bounds].size.height >= 812 && [[UIScreen mainScreen] bounds].size.height <= 896)
#define kNavigationBarHeight_um (kScreenIsiPhoneXOrMore_um ? 88 : 64)
#define Is_iPhoneX_Or_More_um ([UIScreen mainScreen].bounds.size.height >= 812)

#define SCREEN_WIDTH_um             [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT_um            [UIScreen mainScreen].bounds.size.height

#define UIColorFromRGB_um(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RGBA(r,g,b,a)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r,g,b)               [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define kScreenWidth_um [[UIScreen mainScreen] bounds].size.width

#define normalLabelColor_um  RGBA(0,0,0,0.65)


#define MD5SerectStr_um      @"32BytesString"

#endif /* MessageHeader_h */
