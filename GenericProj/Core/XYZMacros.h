//
//  XYZMacros.h
//  GenericProj
//
//  Created by Kevin Wu on 8/8/16.
//  Copyright © 2016 firefly.com. All rights reserved.
//

#ifndef XYZMacros_h
#define XYZMacros_h

///------------
/// AppDelegate
///------------

#define XYZ_APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])


///---------
/// App Info
///---------

#define XYZ_APP_ID               @"961330940"
#define XYZ_APP_STORE_URL        @"https://itunes.apple.com/app/id"XYZ_APP_ID"?mt=8"
#define XYZ_APP_STORE_REVIEW_URL @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id="XYZ_APP_ID"&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"

#define XYZ_APP_NAME    ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"])
#define XYZ_APP_VERSION ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
#define XYZ_APP_BUILD   ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])


///-------
/// Screen
///-------
////////////////////////////////////////////////////////////////////////////////
//
// Screen Resolution
//
// Device       bounds      nativeBounds  scale nativeScale
//
// 4/4s         {320, 480}  {640, 960}    2.0   2.0
//
// 5/5s/SE      {320, 568}  {640, 1136}   2.0   2.0
//
// 6 /6s /7 /8  {375, 667}  {750, 1334}   2.0   2.0
//
// 6P/6sP/7P/8P {414, 736}  {1242, 2208}  3.0   3.0
//
// XR           {375, 812}  {750, 1624}   2.0   2.0   (SafeArea: top44 bottom34)
// X/XS/XSM     {375, 812}  {1125, 2436}  3.0   3.0   (SafeArea: top44 bottom34)
//
////////////////////////////////////////////////////////////////////////////////

#define XYZ_SCREEN_WID  ([UIScreen mainScreen].bounds.size.width)
#define XYZ_SCREEN_HET ([UIScreen mainScreen].bounds.size.height)
#define XYZ_SAFE_AREA_TOP ((fabs(([UIScreen mainScreen].bounds.size.height)-812.0)<2.0)?44.0:0.0)
#define XYZ_SAFE_AREA_BOT ((fabs(([UIScreen mainScreen].bounds.size.height)-812.0)<2.0)?34.0:0.0)


///--------
/// Logging
///--------

#define XYZPrintMethod() DDLogError(@"[%p][%@ %@]", self, NSStringFromClass([self class]), NSStringFromSelector(_cmd))


///-------
/// Number
///-------

#define XYZStringRep(_a_) (@(_a_).stringValue)


///--------
/// Compare
///--------

// equal
#define XYZEqual(_a_,_b_)       ([_a_ isEqual:_b_])
// not nil and equal
#define XYZEqualStrong(_a_,_b_) ((_a_)&&([_a_ isEqual:_b_]))
// both nil or equal
#define XYZEqualWeak(_a_,_b_)   ((!(_a_)&&!(_b_))||([_a_ isEqual:_b_]))

#define XYZEqualFlt(_a_,_b_)  (fabsf(_a_-_b_)<FLT_EPSILON)
#define XYZEqualDbl(_a_,_b_)  (fabs(_a_-_b_)<DBL_EPSILON)

#endif /* XYZMacros_h */
