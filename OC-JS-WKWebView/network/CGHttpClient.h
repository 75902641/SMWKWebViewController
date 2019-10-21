//
//  CGHttpClient.h
//  SaaSNurse
//
//  Created by houchenguang on 2019/10/21.
//  Copyright © 2019 sss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGHttpClient : NSObject
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;
+ (void)get:(NSString *)url success:(void (^)(id))success failure:(void (^)(NSError *))failure;

@end

NS_ASSUME_NONNULL_END
