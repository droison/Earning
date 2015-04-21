//
//  DataRequest.h
//  QuickWatch
//
//  Created by Frank on 14-5-10.
//  Copyright (c) 2014年 Frank. All rights reserved.
//

#import <Foundation/Foundation.h>


#define SYMBOL @"#"

#define kConfigURL(url, method)             [NSString stringWithFormat:@"%@%@%@", method, SYMBOL, url]

//首页
#define DataRequestFavInfo                  kConfigURL(@"http://fundex2.eastmoney.com/FundWebServices/MyFavorInformation.aspx",                @"GET") // ?pstart=0&psize=30&fc=519670,519677,270025,110031,163113,519652&t=kf&dt=1429255593


@class AFHTTPRequestOperationManager;
@class AFHTTPRequestOperation;

static NSInteger DataRequestPageSize = 20;

typedef NS_ENUM(NSInteger, DataRequestErrorType) {
    DataRequestErrorTypeNoNet,
    DataRequestErrorTypeTimeout,
    DataRequestErrorTypeServerError
};

typedef void(^DataRequestSuccess)(id item);
typedef void(^DataRequestFail)(id item);

typedef void (^AFHTTPRequestSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^AFHTTPRequestRequestFail)(AFHTTPRequestOperation *operation, NSError *error);

@protocol DataRequestDelegate <NSObject>
@optional
- (UIView*)progressView;
@end

/**
 *  数据请求类
 */
@interface DataRequest : NSObject
{
}

@property (nonatomic, assign) id<DataRequestDelegate> delegate;
/**
 *  请求request实例
 */
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

/**
 *  发送请求
 *
 *  @param url          请求的URL
 *  @param params       请求参数
 *  @param successBlock 请求成功Block
 *  @param fail         请求失败Block
 */
- (void)sendRequestWithUrl:(NSString *)url params:(NSDictionary *)params success:(DataRequestSuccess)successBlock fail:(DataRequestFail)failBlock;
- (void)sendRequestWithUrl:(NSString *)url params:(NSDictionary *)params andImgData:(NSData*)data success:(DataRequestSuccess)successBlock fail:(DataRequestFail)failBlock;
- (void)sendRequestWithUrl:(NSString *)url params:(NSDictionary *)params andImgData:(NSData*)data imgFileName:(NSString*)fileName imgName:(NSString*)imgName success:(DataRequestSuccess)successBlock fail:(DataRequestFail)failBlock;
/**
 *  发送请求 （自定义图片）
 *
 *  @param url          请求的URL
 *  @param params       请求参数
 *  @param successBlock 请求成功Block
 *  @param fail         请求失败Block
 *  @param fileName     图片路径名称
 *  @param imgName      图片名称
 *  @param caches       是否需要缓存
 */
- (void)sendRequestWithUrl:(NSString *)url params:(NSDictionary *)params andImgData:(NSData*)data imgFileName:(NSString*)fileName imgName:(NSString*)imgName success:(DataRequestSuccess)successBlock fail:(DataRequestFail)failBlock andCaches:(BOOL)caches;
@end
