//
//  JSBInvokeAction.m
//  JSBridge
//  Created by kevin on 2018/9/20.
//  Copyright © 2018年 kevin. All rights reserved.
//
/**
 This JSBInvokeAction is a middleware use to deal with JavaScript invoke Native methods
 A brief description of the strategy:
 1) A common prototype of the url loaded by webview, like this:
      jlcInvoke://ClassName/method?p1=v1&p2=v2
 2) The scheme part, "jlcInvoke://", means a invokation action from JS to Native(Objective-C) code;
 3) Host part, String "ClassName" mentioned above, is the Class name which invoked method belongs to
 4) Path part, String "method" in the above URL, represents the method to be invoked
 5) Params part, from "?" to the end, contains all parameters of this method
*/
#import <objc/runtime.h>
#import "KZJSBInvokeAction.h"


@interface KZJSBInvokeAction()


@property (nonatomic) SEL selector;
@property (nonatomic, nonnull) Class clazz;
@property (nonatomic, nonnull, copy) NSString* method;
@property (nonatomic, copy) NSString* parameters;
@property (nonatomic) MethodOwner methodOwner;

@end

@implementation KZJSBInvokeAction

- (instancetype) initAction:(Class) clazz handler:(nonnull NSString *) handler parameters:(NSString* _Nullable) parameters {
    _clazz = clazz;
    _method = handler;
    _parameters = parameters;
    return self;
}

- (id)action {
    [self parse];
    if (_selector == nil || _clazz == nil) {
        return nil;
    }
    id value = nil;
    if(_methodOwner == CLASS_METHOD) {
        value = [self invokeClassMethod:_clazz selector:_selector argument:_parameters];
    } else if (_methodOwner == INSTANCE_METHOD) {
        value = [self invokeInstanceMethod:_clazz selector:_selector argument:_parameters];
    } else {
        NSLog(@"--->unKnown invoke");
    }
    return value;
}

- (void) parse {
   
    // method without any parameter
    if ([self isClassMethod:_method]) {
        _methodOwner = CLASS_METHOD;
    } else if ([self isInstanceMethod:_method]) {
        _methodOwner = INSTANCE_METHOD;
    } else {
        return;
    }
    
}

- (BOOL) isClassMethod:(NSString *) method {
    NSString* m = [NSString stringWithFormat:@"%@", method];
    _selector = NSSelectorFromString(m);
    Method* classMethod = class_getClassMethod(_clazz, _selector);
    if (classMethod != nil) {
        return YES;
    }
    
    m = [NSString stringWithFormat:@"%@:", method];
    _selector = NSSelectorFromString(m);
    classMethod = class_getClassMethod(_clazz, _selector);
    if (classMethod != nil) {
        return YES;
    }
    
    return NO;
}

- (BOOL) isInstanceMethod:(NSString *) method {
    NSString* m = [NSString stringWithFormat:@"%@", method];
    _selector = NSSelectorFromString(m);
    Method* instanceMethod = class_getInstanceMethod(_clazz, _selector);
    if (instanceMethod != nil) {
        return YES;
    }
    
    m = [NSString stringWithFormat:@"%@:", method];
    _selector = NSSelectorFromString(m);
    instanceMethod = class_getInstanceMethod(_clazz, _selector);
    
    if (instanceMethod != nil) {
        return YES;
    }
    return NO;
}

- (id) invokeInstanceMethod:(Class) clazz selector:(SEL) method argument:(NSString *) argument {
    id instance = [[clazz alloc] init];
    NSMethodSignature* signature = [clazz instanceMethodSignatureForSelector:method];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:instance];
    [invocation setSelector:method];
    if (argument != nil && argument.length > 0) {
        [invocation setArgument:&argument atIndex:2];
    }
    
    
    id returnValue;
    [invocation invoke];
    
    
    if (!strcmp(@encode(id), signature.methodReturnType)) {
        [invocation getReturnValue:&returnValue];
        if ([returnValue respondsToSelector:@selector(stringValue)]) {
            NSLog(@"--->id value: %@\n", [returnValue stringValue]);
        } else {
            NSLog(@"--->id value: %@\n", returnValue);
        }
    } else {
        NSUInteger length = signature.methodReturnLength;
        char* buffer = (void *) malloc(length);
        [invocation getReturnValue:buffer];
        if(!strcmp(@encode(BOOL), signature.methodReturnType)) {
            returnValue = [NSNumber numberWithBool:* ((BOOL *)buffer)];
            NSLog(@"--->bool value: %@\n", returnValue);
        } else { //return type: int
            returnValue = [NSNumber numberWithInteger:*((NSInteger *)buffer)];
            NSLog(@"--->int value: %@\n", returnValue);
        }
        free(buffer);
    }
    return returnValue;
}

- (id) invokeClassMethod:(Class) clazz selector:(SEL) method argument:(NSString *) argument {
    NSMethodSignature* signature = [clazz methodSignatureForSelector:method];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:clazz];
    [invocation setSelector:method];
    if (argument != nil && argument.length > 0) {
        [invocation setArgument:&argument atIndex:2];
    }
    
    id returnValue;
    [invocation invoke];
    
    
    if (!strcmp(@encode(id), signature.methodReturnType)) {
        [invocation getReturnValue:&returnValue];
        NSLog(@"--->id value: %@\n", returnValue );
    } else {
        NSUInteger length = signature.methodReturnLength;
        char* buffer = (void *) malloc(length);
        [invocation getReturnValue:buffer];
        if(!strcmp(@encode(BOOL), signature.methodReturnType)) {
            returnValue = [NSNumber numberWithBool:* ((BOOL *)buffer)];
            NSLog(@"--->bool value: %@\n", returnValue);
        } else { //return type: int
            returnValue = [NSNumber numberWithInteger:*((NSInteger *)buffer)];
            NSLog(@"--->int value: %@\n", returnValue);
        }
        free(buffer);
    }
    return returnValue;
}

@end
