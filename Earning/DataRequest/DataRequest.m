//
//  DataRequest.m
//  QDaily
//
//  Created by Frank on 14-7-20.
//  Copyright (c) 2014年 Frank. All rights reserved.
//

#import "DataRequest.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLResponseSerialization.h"

@implementation DataRequest

- (void)sendRequestWithUrl:(NSString *)url params:(NSDictionary *)params success:(DataRequestSuccess)successBlock fail:(DataRequestFail)failBlock
{
    [self sendRequestWithUrl:url params:params andImgData:nil success:successBlock fail:failBlock];
}

/**
 *  发送请求
 *
 *  @param url          请求的URL
 *  @param params       请求参数
 *  @param successBlock 请求成功Block
 *  @param fail         请求失败Block
 */
- (void)sendRequestWithUrl:(NSString *)url params:(NSDictionary *)params andImgData:(NSData*)data success:(DataRequestSuccess)successBlock fail:(DataRequestFail)failBlock
{
    [self sendRequestWithUrl:url params:params andImgData:data imgFileName:@"head.jpg" imgName:@"user[face]" success:successBlock fail:failBlock];
}
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
- (void)sendRequestWithUrl:(NSString *)url params:(NSDictionary *)params andImgData:(NSData*)data imgFileName:(NSString*)fileName imgName:(NSString*)imgName success:(DataRequestSuccess)successBlock fail:(DataRequestFail)failBlock andCaches:(BOOL)caches
{
    //数据请求
    NSArray *array = [url componentsSeparatedByString:SYMBOL];
    if (array.count > 1) {
        //请求的URL
        NSString *requestUrl = array[1];
        NSString *method = array[0];
        
        //请求成功的block
        AFHTTPRequestSuccessBlock success = ^(AFHTTPRequestOperation *operation, id response)
        {
            LogD(@"request success  operation %@", operation);
            id responseObject;
            if ([response isKindOfClass:[NSData class]]) {
                NSError* jsonError;
                responseObject = [NSJSONSerialization JSONObjectWithData:response options:(NSJSONReadingMutableContainers) error:&jsonError];
            }
            else
            {
                responseObject = response;
            }
            if ([responseObject isKindOfClass:[NSDictionary class]] || [responseObject isKindOfClass:[NSArray class]]) {
                if (successBlock) {
                    successBlock(responseObject);
                }
            }
        };
        
        //请求失败的block
        AFHTTPRequestRequestFail fail = ^(AFHTTPRequestOperation *operation, NSError *error)
        {
            if (failBlock) {
                failBlock(@{@"errorType":@(DataRequestErrorTypeServerError), @"errorInfo":error.userInfo});
            }
            LogE(@"Request: %@, Error: %@", requestUrl, error);
        };
        LogD(@"request %@, params %@", requestUrl, params);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        if ([method isEqualToString:@"GET"]) {
            NSMutableDictionary* mutableParams;
            if (params) {
                mutableParams = [[NSMutableDictionary alloc]initWithDictionary:params];
            }
            else
            {
                mutableParams = [[NSMutableDictionary alloc]init];
            }
            
            [manager GET:requestUrl parameters:mutableParams success:success failure:fail];
        }else if ([method isEqualToString:@"POST"]){
            NSMutableDictionary* mutableParams;
            if (params) {
                mutableParams = [[NSMutableDictionary alloc]initWithDictionary:params];
            }
            else
            {
                mutableParams = [[NSMutableDictionary alloc]init];
            }
            if (data) {
                [manager POST:requestUrl parameters:mutableParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    [formData appendPartWithFileData:data name:imgName fileName:fileName mimeType:@"image/jpg"];
                } success:success failure:fail];
            }
            else
            {
                [manager POST:requestUrl parameters:mutableParams success:success failure:fail];
            }
        }
    }


}



/**
 *  发送请求 （自定义图片）
 *
 *  @param url          请求的URL
 *  @param params       请求参数
 *  @param successBlock 请求成功Block
 *  @param fail         请求失败Block
 *  @param fileName     图片路径名称
 *  @param imgName      图片名称
 */
- (void)sendRequestWithUrl:(NSString *)url params:(NSDictionary *)params andImgData:(NSData*)data imgFileName:(NSString*)fileName imgName:(NSString*)imgName success:(DataRequestSuccess)successBlock fail:(DataRequestFail)failBlock
{
    [self sendRequestWithUrl:url params:params andImgData:data imgFileName:fileName imgName:imgName success:successBlock fail:failBlock andCaches:NO];
}

@end
