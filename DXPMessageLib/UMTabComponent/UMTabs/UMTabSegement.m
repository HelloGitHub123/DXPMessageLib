//
//  HJTabSegement.m
//  HJControls
//
//  Created by mac on 2022/10/12.
//

#import "UMTabSegement.h"
#import "UMTabCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import <DXPToolsLib/HJTool.h>
#import "MessageHeader.h"

static NSString *tabID = @"UMTabCollectionViewCellIdentifier";

@interface UMTabSegement () <UICollectionViewDelegate, UICollectionViewDataSource> {
    
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger isEqualSplit;
@property (nonatomic, assign) NSInteger totalWidth;

@end

@implementation UMTabSegement

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = UIColorFromRGB_um(0xFFFFFF);
        
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

- (void)setEqualSplit:(BOOL)result totalWidth:(CGFloat)totalWidth {
    _isEqualSplit = result;
    _totalWidth = totalWidth;
    [self.collectionView reloadData];
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
//    if (_delegate && [_delegate respondsToSelector:@selector(tabSegementSelectIndex:)]) {
//        [_delegate tabSegementSelectIndex:_selectIndex];
//    }
    [self.collectionView reloadData];
}

- (void)setScrollEnabled:(NSInteger)result {
    self.collectionView.scrollEnabled = result;
}

#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_isEqualSplit && _totalWidth > 0 && _dataArray.count > 0) {
        return CGSizeMake(_totalWidth/_dataArray.count, 56);
    } else {
		return CGSizeMake([HJTool textWidthByMaxWidth:300 withFont:[UIFont boldSystemFontOfSize:16] string:_dataArray[indexPath.row]]+30, 56);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UMTabCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:tabID forIndexPath:indexPath];
	cell.styleModel = self.styleModel;
    [cell setContentWithText:_dataArray[indexPath.row] currentIndex:indexPath.row selectIndex:_selectIndex];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != _selectIndex) {
        _selectIndex = indexPath.row;
        [self.collectionView reloadData];
        if (_delegate && [_delegate respondsToSelector:@selector(tabSegementSelectIndex:)]) {
            [_delegate tabSegementSelectIndex:_selectIndex];
        }
    }
}

#pragma mark - lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
		_collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = NO;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        [_collectionView registerClass:[UMTabCollectionViewCell class] forCellWithReuseIdentifier:tabID];
    }
    return _collectionView;
}

@end
