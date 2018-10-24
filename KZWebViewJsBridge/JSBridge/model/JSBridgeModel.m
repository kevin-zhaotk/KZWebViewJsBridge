//
//  JSBridgeModel.m
//  iOSApm
//
//  Created by kevin on 10/22/18.
//  Copyright © 2018 kevin. All rights reserved.
//

#import "JSBridgeModel.h"

@implementation JSBridgeModel

- (instancetype) initWithJson:(NSDictionary*) json {
    
    if (json != nil) {
        _handler = [json valueForKey:@"handler"];
        _parameter = [json valueForKey:@"parameter"];
        _callback = [json valueForKey:@"callback"];
        
    }
    
    return self;
}

- (instancetype) initWithJsonString:(NSString *) json {
    if (json == nil) {
        return self;
    }
    NSData* data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error;
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"--->parse invoke message error: %@\n", error);
    }
    return [self initWithJson:dict];
}


@end
