//
//  JSBInvokeAction.h
//  JSBridge
//
//  Created by kevin on 2018/9/20.
//  Copyright © 2018年 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CLASS_METHOD = 1,
    INSTANCE_METHOD = 2
} MethodOwner;

@interface KZJSBInvokeAction : NSObject

- (instancetype) initAction:(Class) clazz handler:(nonnull NSString *) handler parameters:(NSString* _Nullable) parameters;

- (id)action;

@end
