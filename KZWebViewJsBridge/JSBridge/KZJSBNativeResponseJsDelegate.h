//
//  KZJSBNativeResponseJsDelegate.h
//  iOSApm
//
//  Created by kevin on 2018/10/10.
//  Copyright © 2018年 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KZJSBNativeResponseJsDelegate <NSObject>

- (void) responseJs:(NSString *) message;

@end
