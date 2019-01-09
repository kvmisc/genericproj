//
//  TKCommon.h
//  TapKit
//
//  Created by Kevin on 5/21/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifdef __cplusplus
extern "C" {
#endif

///-------------------------------
/// System message
///-------------------------------

void TKPresentSystemMessage(NSString *message);


///-------------------------------
/// Archive object
///-------------------------------

BOOL TKSaveArchivableObject(id object, NSString *path);

id TKLoadArchivableObject(NSString *path);


///-------------------------------
/// System paths
///-------------------------------

NSString *TKPathForBundleResource(NSBundle *bundle, NSString *relativePath);

NSString *TKPathForDocumentResource(NSString *relativePath);

NSString *TKPathForLibraryResource(NSString *relativePath);

NSString *TKPathForCachesResource(NSString *relativePath);


BOOL TKCreateDirectory(NSString *path);

BOOL TKDeleteFileOrDirectory(NSString *path);

#ifdef __cplusplus
}
#endif
