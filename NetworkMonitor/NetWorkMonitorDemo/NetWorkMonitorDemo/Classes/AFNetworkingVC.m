//
//  AFNetworkingVC.m
//  NetworkMonitorSample
//
//   Created by fengsl on 2020/8/25.
//  Copyright © Copyright © 2020 fengsl. All rights reserved.
//

#import "AFNetworkingVC.h"
#import <AFNetworking/AFNetworking.h>
#import <HLLNetworkMonitor/HLLNetworkMonitor.h>


extern NSString *rtpKey;
extern NSString *rspKey;
extern NSString *urlKey;

#define TEST_URL @"https://m.taobao.com"
//#define TEST_URL @"https://apptest.61draw.coma/v1/student/loginV2"
//#define TEST_URL @"https://wj.ahga.gov.cn/business-services/h5/remove-car-record"
//#define TEST_URL @"https://m.taobao.com"
#define DOWNLOAD_URL @"http://download.voicecloud.cn/ygxt/20180605/85ee0f89-a95f-4424-8abc-4f6243ef79b2.zip"

#define UPLOAD_URL @"http://test.cystorage.cycore.cn"

@interface AFNetworkingVC () {
    NSURLSessionTask *task1;
    NSDictionary *rtp;
    NSDictionary *rsp;
    NSString *urlString;
}

@end

@implementation AFNetworkingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"AFNetworking";
    rtp = [[NSUserDefaults standardUserDefaults] objectForKey:rtpKey];
    rsp = [[NSUserDefaults standardUserDefaults] objectForKey:rspKey];
    urlString = [[NSUserDefaults standardUserDefaults] objectForKey:urlKey];
}

- (IBAction)get:(id)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    for (NSString *key in rtp) {
        [manager.requestSerializer setValue:rtp[key] forHTTPHeaderField:HEAD_KEY_MAKE(key)];
    }
    [manager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nullable(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull response, NSURLRequest * _Nonnull request) {
        return request;
    }];
    NSString *url;
    if (urlString && ![urlString isEqualToString:@""]) {
        url = urlString;
    } else {
        url = TEST_URL;
    }
    task1 =  [manager GET:url parameters:@{@"password":@"670b14728ad9902aecba32e22fa4f6bd",@"account":@"12388600001",@"deviceId":@"C1E0A82B-85A4-4C3E-9CF6-F50F9A252565",@"deviceToken":@"c6513c88ee20e6979a7c678776e9f0b7e8c4819cd0c9d1646d03476d28969de2"} progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableURLRequest *mrq = (NSMutableURLRequest *)task.originalRequest;
        NSString *traceId = mrq.allHTTPHeaderFields[HEAD_KEY_EETRACEID];
        [[HLLNetworkMonitorManager sharedNetworkMonitorManager] setExtendedParameter:self->rsp traceId:traceId];
        if ([[HLLNetworkMonitorManager sharedNetworkMonitorManager] getConfig].enableInterferenceMode) {
            [[HLLNetworkMonitorManager sharedNetworkMonitorManager] finishColection:traceId];
        }
        [manager invalidateSessionCancelingTasks:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSMutableURLRequest *mrq = (NSMutableURLRequest *)task.originalRequest;
        NSString *traceId = mrq.allHTTPHeaderFields[HEAD_KEY_EETRACEID];
        if ([[HLLNetworkMonitorManager sharedNetworkMonitorManager] getConfig].enableInterferenceMode) {
            [[HLLNetworkMonitorManager sharedNetworkMonitorManager] finishColection:traceId];
        }
    }];
}

- (IBAction)post:(id)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    for (NSString *key in rtp) {
        [manager.requestSerializer setValue:rtp[key] forHTTPHeaderField:HEAD_KEY_MAKE(key)];
    }
    [manager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nullable(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull response, NSURLRequest * _Nonnull request) {
        return request;
    }];
    NSString *url;
    if (urlString && ![urlString isEqualToString:@""]) {
        url = urlString;
    } else {
        url = TEST_URL;
    }
    task1 =  [manager POST:url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableURLRequest *mrq = (NSMutableURLRequest *)task.originalRequest;
        NSString *traceId = mrq.allHTTPHeaderFields[HEAD_KEY_EETRACEID];
        [[HLLNetworkMonitorManager sharedNetworkMonitorManager] setExtendedParameter:self->rsp traceId:traceId];
        if ([[HLLNetworkMonitorManager sharedNetworkMonitorManager] getConfig].enableInterferenceMode) {
            [[HLLNetworkMonitorManager sharedNetworkMonitorManager] finishColection:traceId];
        }
        [manager invalidateSessionCancelingTasks:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSMutableURLRequest *mrq = (NSMutableURLRequest *)task.originalRequest;
        NSString *traceId = mrq.allHTTPHeaderFields[HEAD_KEY_EETRACEID];
        if ([[HLLNetworkMonitorManager sharedNetworkMonitorManager] getConfig].enableInterferenceMode) {
            [[HLLNetworkMonitorManager sharedNetworkMonitorManager] finishColection:traceId];
        }
    }];
}

- (IBAction)downloadStart:(id)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    for (NSString *key in rtp) {
        [manager.requestSerializer setValue:rtp[key] forHTTPHeaderField:HEAD_KEY_MAKE(key)];
    }
    [manager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nullable(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull response, NSURLRequest * _Nonnull request) {
        return request;
    }];
    NSString *url;
    if (urlString && ![urlString isEqualToString:@""]) {
        url = urlString;
    } else {
        url = DOWNLOAD_URL;
    }
    task1 = [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableURLRequest *mrq = (NSMutableURLRequest *)task.originalRequest;
        NSString *traceId = mrq.allHTTPHeaderFields[HEAD_KEY_EETRACEID];
        [[HLLNetworkMonitorManager sharedNetworkMonitorManager] setExtendedParameter:self->rsp traceId:traceId];
        if ([[HLLNetworkMonitorManager sharedNetworkMonitorManager] getConfig].enableInterferenceMode) {
            [[HLLNetworkMonitorManager sharedNetworkMonitorManager] finishColection:traceId];
        }
        [manager invalidateSessionCancelingTasks:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSMutableURLRequest *mrq = (NSMutableURLRequest *)task.originalRequest;
        NSString *traceId = mrq.allHTTPHeaderFields[HEAD_KEY_EETRACEID];
        if ([[HLLNetworkMonitorManager sharedNetworkMonitorManager] getConfig].enableInterferenceMode) {
            [[HLLNetworkMonitorManager sharedNetworkMonitorManager] finishColection:traceId];
        }
        [manager invalidateSessionCancelingTasks:NO];
    }];
}

- (IBAction)downloadCancel:(id)sender {
    [task1 cancel];
}

- (IBAction)uploadStart:(id)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    for (NSString *key in rtp) {
        [manager.requestSerializer setValue:rtp[key] forHTTPHeaderField:HEAD_KEY_MAKE(key)];
    }
    [manager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nullable(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull response, NSURLRequest * _Nonnull request) {
        return request;
    }];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"pdf"];
    NSData *httpBody = [self createBodyWithBoundary:@"" parameters:@{} paths:@[filePath] fieldName:@"file"];
    task1 = [manager POST:UPLOAD_URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithHeaders:nil body:httpBody];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableURLRequest *mrq = (NSMutableURLRequest *)task.originalRequest;
        NSString *traceId = mrq.allHTTPHeaderFields[HEAD_KEY_EETRACEID];
        [[HLLNetworkMonitorManager sharedNetworkMonitorManager] setExtendedParameter:self->rsp traceId:traceId];
        if ([[HLLNetworkMonitorManager sharedNetworkMonitorManager] getConfig].enableInterferenceMode) {
            [[HLLNetworkMonitorManager sharedNetworkMonitorManager] finishColection:traceId];
        }
        [manager invalidateSessionCancelingTasks:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSMutableURLRequest *mrq = (NSMutableURLRequest *)task.originalRequest;
        NSString *traceId = mrq.allHTTPHeaderFields[HEAD_KEY_EETRACEID];
        if ([[HLLNetworkMonitorManager sharedNetworkMonitorManager] getConfig].enableInterferenceMode) {
            [[HLLNetworkMonitorManager sharedNetworkMonitorManager] finishColection:traceId];
        }
        [manager invalidateSessionCancelingTasks:NO];
    }];
}

- (IBAction)uploadCancel:(id)sender {
    [task1 cancel];
}

- (NSData *)createBodyWithBoundary:(NSString *)boundary
                        parameters:(NSDictionary *)parameters
                             paths:(NSArray *)paths
                         fieldName:(NSString *)fieldName {
    NSMutableData *httpBody = [NSMutableData data];
    
    // 文本参数
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    // 本地文件的NSData
    for (NSString *path in paths) {
        NSString *filename = [path lastPathComponent];
        NSData   *data     = [NSData dataWithContentsOfFile:path];
        
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:data];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return httpBody;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
