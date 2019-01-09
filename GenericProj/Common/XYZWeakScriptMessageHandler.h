//
//  XYZWeakScriptMessageHandler.h
//  GenericProj
//
//  Created by Haiping Wu on 2018/4/11.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface XYZWeakScriptMessageHandler : NSObject <
    WKScriptMessageHandler
>

@property (nonatomic, weak) id<WKScriptMessageHandler> delegate;

@end
