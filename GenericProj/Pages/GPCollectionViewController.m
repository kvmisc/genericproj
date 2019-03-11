//
//  GPCollectionViewController.m
//  GenericProj
//
//  Created by Haiping Wu on 2019/3/11.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "GPCollectionViewController.h"
#import "GPCollectionViewCell.h"

@interface GPCollectionViewController () <
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation GPCollectionViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  if ( @available(iOS 11.0, *) ) {
    _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
  } else {
    self.automaticallyAdjustsScrollViewInsets = NO;
  }

  [_collectionView registerNib:[UINib nibWithNibName:@"GPCollectionViewCell" bundle:[NSBundle mainBundle]]
    forCellWithReuseIdentifier:@"GPCollectionViewCell"];

  // 修改 layout，也可以用下面的四个代理方法来修改
  UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)(_collectionView.collectionViewLayout);
  CGFloat itemWidth = ceil( (XYZ_SCREEN_WID - 2*20 - 2*10) / 3.0 );
  flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
  flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
  flowLayout.minimumLineSpacing = 5;
  flowLayout.minimumInteritemSpacing = 0;


  _collectionView.layer.borderColor = [[UIColor redColor] CGColor];
  _collectionView.layer.borderWidth = 1.0;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *identifier = @"GPCollectionViewCell";

  GPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

  cell.titleLabel.text = [NSString stringWithFormat:@"%d-%d", (int)indexPath.section, (int)indexPath.row];

  return cell;
}



//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//  CGFloat width = ceil( (XYZ_SCREEN_WID - 2*20 - 2*10) / 3.0 );
//  return CGSizeMake(width, width);
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//  //return UIEdgeInsetsMake(0, 0, 0, 0);
//  return UIEdgeInsetsMake(10, 20, 10, 20);
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//  //return 0;
//  return 5;
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//  return 0;
//}


//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;

@end
