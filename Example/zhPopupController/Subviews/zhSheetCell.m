//
//  zhSheetCell.m
//  zhPopupControllerDemo
//
//  Created by zhanghao on 2016/11/3.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "zhSheetCell.h"
#import "zhSheetViewConfig.h"

static NSString *zh_CellIdentifier = @"zh_sheetCollectionCell";

@interface zhSheetCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) zhSheetViewLayout *zh_layout;
@property (nonatomic, strong) zhSheetViewAppearance *zh_appearance;

@end

@implementation zhSheetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                       layout:(zhSheetViewLayout *)layout
                   appearance:(zhSheetViewAppearance *)appearance {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = appearance.sectionBackgroundColor;
        _zh_layout = layout;
        _zh_appearance = appearance;

        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = layout.itemSpacing;
        _flowLayout.itemSize = layout.itemSize;
        _flowLayout.sectionInset = layout.itemEdgeInset;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_flowLayout];
        _collectionView.bounces = YES;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [self addSubview:_collectionView];
        [_collectionView registerClass:[SnailSheetCollectionCell class] forCellWithReuseIdentifier:zh_CellIdentifier];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _collectionView.frame = self.bounds;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _arrays.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SnailSheetCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:zh_CellIdentifier forIndexPath:indexPath];
    if (indexPath.row < _arrays.count) {
        id object = [_arrays objectAtIndex:indexPath.row];
        NSAssert([object isKindOfClass:[zhSheetItemModel class]], @"zhSheetView - 传入的数据必须使用zhSheetItemModel进行打包，不能是其它对象！");
        [cell setLayout:_zh_layout appearance:_zh_appearance model:object];
    }
    cell.imageView.tag = indexPath.row;
    [cell.imageView addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)itemClicked:(UIButton *)sender {
    if (nil != self.itemClicked) {
        self.itemClicked(sender.tag);
    }
}

- (void)setArrays:(NSArray *)arrays {
    _arrays = arrays;
    [_collectionView reloadData];
}

@end


/// - zhSheetCollectionCell
@implementation SnailSheetCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _imageView = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageView.userInteractionEnabled = YES;
        _imageView.clipsToBounds = NO;
        _imageView.layer.masksToBounds = YES;
        [self addSubview:_imageView];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.userInteractionEnabled = NO;
        _textLabel.numberOfLines = 0;
        _textLabel.textColor = [UIColor darkGrayColor];
        _textLabel.font = [UIFont systemFontOfSize:12];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)setLayout:(zhSheetViewLayout *)layout appearance:(zhSheetViewAppearance *)appearance model:(zhSheetItemModel *)model {
   
    [_imageView setImage:model.image forState:UIControlStateNormal];
    _textLabel.text = model.text;
    
    // appearance
    self.backgroundColor = appearance.itemBackgroundColor;
    _imageView.layer.cornerRadius = appearance.imageViewCornerRadius;
    _imageView.imageView.contentMode = appearance.imageViewContentMode;
    [_imageView setBackgroundImage:[UIImage imageWithColor:appearance.imageViewBackgroundColor] forState:UIControlStateNormal];
    [_imageView setBackgroundImage:[UIImage imageWithColor:appearance.imageViewHighlightedColor] forState:UIControlStateHighlighted];
    _textLabel.backgroundColor = appearance.textLabelBackgroundColor;
    _textLabel.textColor = appearance.textLabelTextColor;
    _textLabel.font = appearance.textLabelFont;
    
    // layout
    _imageView.size = CGSizeMake(layout.imageViewWidth, layout.imageViewWidth);
    _imageView.centerX = layout.itemSize.width / 2;
    if (_textLabel.text.length > 0) {
        CGFloat h = layout.itemSize.height - layout.imageViewWidth - layout.subSpacing;
        CGSize size = [_textLabel sizeThatFits:CGSizeMake(layout.itemSize.width, MAXFLOAT)];
        if (size.height > h) size.height = h;
        _textLabel.size = CGSizeMake(layout.itemSize.width, size.height);
        _textLabel.y = _imageView.bottom + layout.subSpacing;
        _textLabel.centerX = layout.itemSize.width / 2;
    }
}

@end
