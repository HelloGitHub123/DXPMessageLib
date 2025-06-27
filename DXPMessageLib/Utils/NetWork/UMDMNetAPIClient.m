//
//  UMDMNetAPIClint.m
//  DataMall
//
//  Created by 刘伯洋 on 16/1/4.
//  Copyright © 2016年 刘伯洋. All rights reserved.
//

#import "UMDMNetAPIClient.h"
#import "NSString+umSHA256.h"
#import "NSString+umJson.h"
#import <AFNetworking/AFNetworking.h>
#import <DXPToolsLib/HJMBProgressHUD+Category.h>
#import <DXPToolsLib/SNAlertMessage.h>
#import "MessageHeader.h"

@interface UMDMNetAPIClient ()

@property (nonatomic, copy) NSString *reqToken;
@end


@implementation UMDMNetAPIClient

static UMDMNetAPIClient *_sharedClient = nil;
static dispatch_once_t onceToken;


+ (UMDMNetAPIClient *)sharedClient {
//    return [self sharedClient:nil];
    dispatch_once(&onceToken, ^{
        _sharedClient = [[UMDMNetAPIClient alloc] init];
    });
    return _sharedClient;
}

//+ (UMDMNetAPIClient *)sharedClient:(NSString *)url {
//    dispatch_once(&onceToken, ^{
//        _sharedClient = [[UMDMNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
//    });
//    return _sharedClient;
//}

- (void)setBaseUrl:(NSString *)baseUrl {
    _baseUrl = baseUrl;
    [self initWithBaseURL:[NSURL URLWithString:baseUrl]];
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", @"application/octet-stream", nil];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];
    self.securityPolicy.allowInvalidCertificates = YES;
    self.securityPolicy.validatesDomainName = NO;
    return self;
}

- (void)setRequestToken:(NSString *)token {
    self.reqToken = token;
}

- (void)GET:(NSString *)url paramaters:(NSDictionary *)paramaters CompleteBlock:(UMCompleteBlock)completeBlock {
    [self requestJsonDataWithPath:url withParams:paramaters withMethodType:Get elementPath:@"" andBlock:completeBlock];
}

- (void)POST:(NSString *)url paramaters:(NSDictionary *)paramaters CompleteBlock:(UMCompleteBlock)completeBlock {
    [self requestJsonDataWithPath:url withParams:paramaters withMethodType:Post elementPath:@"" andBlock:completeBlock];
}

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(UMNetworkMethod)method
                        elementPath:(NSString *)elementPath
                       andBlock:(void (^)(id data, NSError *error))block {
    
    if (!aPath || aPath.length <= 0) return;
    [self.requestSerializer setValue:elementPath forHTTPHeaderField:@"element"];
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970]*1000;
    NSInteger time = interval;
    NSString *timestampStr = [NSString stringWithFormat:@"%zd",time];
    [self.requestSerializer setValue:timestampStr forHTTPHeaderField:@"timestamp"];
    [self.requestSerializer setValue:@"2" forHTTPHeaderField:@"Terminal-Type"];
    [self.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Device-Type"];
    NSString *versionCodeStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [self.requestSerializer setValue:versionCodeStr forHTTPHeaderField:@"appVersion"];
    UIDevice *currentDevice = [UIDevice currentDevice];
    NSString *deviceId = [[currentDevice identifierForVendor] UUIDString];
    [self.requestSerializer setValue:deviceId forHTTPHeaderField:@"Device-Id"];
    [self.requestSerializer setValue:versionCodeStr forHTTPHeaderField:@"Terminal-Version"];
    [self.requestSerializer setValue:self.reqToken forHTTPHeaderField:@"Token"]; // todo
    
	[self.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"cx_language"] forHTTPHeaderField:@"locale"];
	
    if ([aPath containsString:@"/i18n/app/up3/local.json"]) {
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    } else {
        self.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    
    switch (method) {
        case Get:{
            umDebugLog(@"\n===========request===========\n%@\n%@:\n%@", @"Get", aPath, params);
            //所有 Get 请求，增加缓存机制
            NSMutableString *localPath = [aPath mutableCopy];
            __block NSMutableString * aPathStr = [aPath mutableCopy];
            if (params) {
                [localPath appendString:params.description];
                aPathStr = [[aPath stringByAppendingString:@"?"] mutableCopy];
                [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    aPathStr = [[aPathStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,obj]] mutableCopy];
                }];
                
                aPathStr = [[aPathStr substringToIndex:aPathStr.length-1] mutableCopy];
                umDebugLog(@"=========aPathStr========%@",aPathStr);
            }
             
            NSString * apathNew = [aPathStr stringByReplacingOccurrencesOfString:@"/ecare/webs" withString:@""];
            apathNew = [apathNew stringByReplacingOccurrencesOfString:@"ecare/webs" withString:@""];
            apathNew = [apathNew stringByReplacingOccurrencesOfString:@"/promotion-rest-boot" withString:@""];
            apathNew = [apathNew stringByReplacingOccurrencesOfString:@"/ecare" withString:@""];
            NSString * md5str = [NSString stringWithFormat:@"%@%@%@",[NSString stringWithFormat:@"%@",apathNew],@"",MD5SerectStr_um];
            NSString * authToken  = [md5str SHA256];
            [self.requestSerializer setValue:authToken forHTTPHeaderField:@"signcode"];

            [self GET:aPathStr parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                umDebugLog(@"\n===========response===========\n%@:\n%@", aPath, [[responseObject jsonPrettyStringEncoded] jsonStrHandle]);
                
                @try {
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        NSData *data=[NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                        NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"\n===========response===========\n%@:\n%@", aPath, jsonStr);
                    } else {
                        NSLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
                    }
                } @catch (NSException *exception) {
                    
                } @finally {
                    
                }
                
                [self successRequestWithTask:task res:responseObject block:block];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"\n===========response===========\n%@:\n%@", aPath, error);
                [self failRequestWithTask:task error:error path:aPath block:block];
            }];
            break;
        }
            
        case Post:{
            NSString * codeSign = [self dictionaryToJson:params];
            NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"[^a-zA-Z0-9]" options:0 error:NULL];
            codeSign = [regular stringByReplacingMatchesInString:codeSign options:0 range:NSMakeRange(0, [codeSign length]) withTemplate:@""];
            codeSign = [codeSign stringByReplacingOccurrencesOfString:@"null" withString:@""];
            NSString * apathNew = [aPath stringByReplacingOccurrencesOfString:@"/ecare/" withString:@"/"];
            apathNew = [apathNew stringByReplacingOccurrencesOfString:@"ecare/" withString:@"/"];
            
            NSString * md5str = [NSString stringWithFormat:@"%@%@%@%@",apathNew,codeSign,self.reqToken,@"32BytesString"];//登录成功后获取token
            NSString * authToken  = [md5str SHA256];
            [self.requestSerializer setValue:authToken forHTTPHeaderField:@"signcode"];
            
            umDebugLog(@"\n===========request===========\n%@\n%@:\n%@", @"Post", aPath, params);
            [self POST:aPath parameters:params headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                umDebugLog(@"\n===========response===========\n%@:\n%@", aPath, [[responseObject jsonPrettyStringEncoded] jsonStrHandle]);
                @try {
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        NSData *data=[NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                        NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"\n===========response===========\n%@:\n%@", aPath, jsonStr);
                    } else {
                        NSLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
                    }
                } @catch (NSException *exception) {
                    
                } @finally {
                    
                }
                [self successRequestWithTask:task res:responseObject block:block];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"\n===========response===========\n%@:\n%@", aPath, error);
                [self failRequestWithTask:task error:error path:aPath block:block];
            }];
            break;
        }
       
        default:
            break;
    }
}


#pragma mark - 字典转字符串
-(NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    if (!dic) {
        return @"";
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)upload:(NSString *)url data:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName CompleteBlock:(UMCompleteBlock)completeBlock {
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSString *timestampStr = [NSString stringWithFormat:@"%f",interval*1000];
    [self.requestSerializer setValue:timestampStr forHTTPHeaderField:@"timestamp"];
    [self.requestSerializer setValue:@"2" forHTTPHeaderField:@"terminal-Type"];
    [self.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Device-Type"];
    
    
    NSString *versionCodeStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    UIDevice *currentDevice = [UIDevice currentDevice];
    NSString *deviceId = [[currentDevice identifierForVendor] UUIDString];
    [self.requestSerializer setValue:deviceId forHTTPHeaderField:@"Device-Id"];
    [self.requestSerializer setValue:versionCodeStr forHTTPHeaderField:@"Terminal-Version"];
    [self.requestSerializer setValue:self.reqToken forHTTPHeaderField:@"Token"]; // todo
//    [self.requestSerializer setValue:Single_Language(AppLanguage) forHTTPHeaderField:@"locale"];
    
    NSString *mimeType = @"image/jpeg";
    if ([fileName rangeOfString:@".pdf"].location != NSNotFound)  mimeType = @"application/pdf";
    if ([fileName rangeOfString:@".docx"].location != NSNotFound)  mimeType = @"application/vnd.openxmlformats-officedocument.wordprocessingml.document";
    if ([fileName rangeOfString:@".doc"].location != NSNotFound)  mimeType = @"application/msword";
    
    [self POST:url parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        umDebugLog(@"\n===========response===========\n%@:\n%@", url, [[responseObject jsonPrettyStringEncoded] jsonStrHandle]);
        @try {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSData *data=[NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"\n===========response===========\n%@:\n%@", url, jsonStr);
            } else {
                NSLog(@"\n===========response===========\n%@:\n%@", url, responseObject);
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
        [self successRequestWithTask:task res:responseObject block:completeBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"\n===========response===========\n%@:\n%@", url, error);
        [self failRequestWithTask:task error:error path:url block:completeBlock];
    }];
}

#pragma mark - 成功回调
- (void)successRequestWithTask:(NSURLSessionDataTask *)task res:(id)res block:(void (^)(id data, NSError *error))block {
    NSHTTPURLResponse *responses = (NSHTTPURLResponse *)task.response;
    
    if ([HTTP_Code_um isEqualToString:@"500"]) [HJMBProgressHUD showText:HTTP_ResultMsg_um];
//    if ([NSString isBlankString:HTTP_Code]) [HJMBProgressHUD showText:@"system is busy"];
    block(res, nil);

}

#pragma mark - 失败回调
- (void)failRequestWithTask:(NSURLSessionDataTask *)task error:(NSError *)error path:(NSString *)path block:(void (^)(id data, NSError *error))block {
    NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
    NSData *data = [error.userInfo valueForKey:@"com.alamofire.serialization.response.error.data"];
    NSString *errorString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [errorString JSONValue];
    if (responses.statusCode == 401) {
//        Single_Token = @"";
//        NSUSER_DEF_SET(@"", kLoginToken);
//        [HJMBProgressHUD showText:objectOrEmptyStr([dic objectForKey:@"message"])];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [H3AAPPDELEGATE goToHomeViewController];
        });
    } else if (responses.statusCode == 304) {
        //说明国际化没有要更新
    } else {
//        if (![path isEqualToString:msgNewArriveUrl]) {
            if ([NSString isBlankString:[dic objectForKey:@"message"]]) {
                if ([path containsString:@"local.json"]) {
                    block(nil, nil);
                } else {
//                    [HJMBProgressHUD showText:@"system is busy"];
                }
            } else {
                [HJMBProgressHUD showText:objectOrEmptyStr_um([dic objectForKey:@"message"])];
            }
//        }
        block(dic, error);
    }
}


@end
