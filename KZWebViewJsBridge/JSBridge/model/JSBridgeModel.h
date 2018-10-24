//
//  JSBridgeModel.h
//  iOSApm
//
//  Created by kevin on 10/22/18.
//  Copyright © 2018 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSBridgeModel : NSObject

@property (nonatomic, copy) NSString* handler;
@property (nonatomic, copy) NSString* parameter;
@property (nonatomic, copy) NSString* callback;

- (instancetype) initWithJson:(NSDictionary*) json;
- (instancetype) initWithJsonString:(NSString *) json;
@end
