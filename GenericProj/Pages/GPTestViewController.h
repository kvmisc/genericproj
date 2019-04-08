//
//  GPTestViewController.h
//  GenericProj
//
//  Created by Kevin Wu on 5/25/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>


#ifdef DEBUG

//NSLog(@"[xx] debug: debug server");
#define BaseUrl          @"http://debug"

#elif defined DAILY_DEBUG

//NSLog(@"[xx] daily: debug server");
#define BaseUrl          @"http://daily.debug"

#elif defined DAILY_RELEASE

//NSLog(@"[xx] daily: debug server");
#define BaseUrl          @"http://daily.release"

#else

//NSLog(@"[xx] release: release server");
#define BaseUrl          @"http://release"

#endif


@interface GPTestViewController : XYZBaseViewController

@property (weak, nonatomic) IBOutlet UIButton *button;

@property (weak, nonatomic) IBOutlet UIView *greenView;

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;

@end
