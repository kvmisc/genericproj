//
//  GPImageViewController.h
//  GenericProj
//
//  Created by Haiping Wu on 28/02/2018.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPImageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *imageAry;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
