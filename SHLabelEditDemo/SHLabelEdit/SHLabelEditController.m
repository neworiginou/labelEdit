//
//  SHLabelEditController.m
//  SHLabelEdit
//
//  Created by shshy on 15/11/18.
//  Copyright © 2015年 expai. All rights reserved.
//

#import "SHLabelEditController.h"
#import "SHLabelEditCell.h"
#import "SHLabelModel.h"

#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height
#define interItemMargin 5
#define lineMargin      5
#define itemW           (kScreenWidth-30-interItemMargin*3)/4
#define itemH           itemW*2/5

static NSString *const cellIdentifier   = @"cellIdentifier";
static NSString *const headerIdentifier = @"headerIdentifier";

static const NSInteger headerLabelTag = 10000;

@interface SHLabelEditController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,assign) BOOL              edit;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray   *data;

@property (nonatomic,  copy) selectHandler     selectHandler;
@property (nonatomic,  copy) resultHandler     resultHandler;

@end

@implementation SHLabelEditController


- (instancetype)initWithCurrentChannelIndex:(NSInteger)index myChannels:(NSArray *)myChannels recChannels:(NSArray *)recChannels selectHandler:(selectHandler)select resultHandler:(resultHandler)result {
    self = [super init];
    if (self) {
        if (select) {
            self.selectHandler = select;
            self.resultHandler = result;
        }
    }
    return self;
}

#pragma mark - customNavigationBar

- (void)setupNavigation {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"quit.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(quit)];
    UIButton *edit = [UIButton buttonWithType:UIButtonTypeCustom];
    edit.frame = CGRectMake(0, 0, 40, 20);
    edit.titleLabel.font = [UIFont systemFontOfSize:16];
    [edit setTitle:@"编辑" forState:UIControlStateNormal];
    [edit setTitle:@"完成" forState:UIControlStateSelected];
    [edit setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [edit addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:edit];
}

#pragma mark - actionHandler

- (void)quit {
    if (self.resultHandler) {
        NSArray *result = self.data[0];
        self.resultHandler(result);
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)editAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.edit = !self.edit;
    
    NSArray *array = self.data[0];
    for (NSInteger i = 1; i<array.count; i++) {
        SHLabelModel *model = array[i];
        model.edit = self.edit;
    }
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigation];
    self.data = [[NSMutableArray alloc]init];
    NSArray *array = @[@"推荐",@"体育",@"数码",@"科技",@"情感",@"精选",@"时尚",@"辟谣",@"电影",@"奇葩",@"旅游",@"历史",@"探索",@"故事",@"美文",@"语录",@"美图",@"游戏",@"房产",@"家居"];
    NSArray *array1 = @[@"育儿",@"养生",@"美食",@"政务",@"搞笑",@"星座",@"文化",@"毕业生",@"教育",@"热点",@"财经",@"正能量",@"汽车",@"北京",@"图片",@"订阅",@"美女",@"健康",@"国际",@"特卖",@"视频",@"趣图",@"段子",@"娱乐",@"军事",@"社会",@"三农",@"收藏"];
    NSMutableArray *oldArray = [NSMutableArray array];
    NSMutableArray *newArray = [NSMutableArray array];
    for (NSString *str in array) {
        SHLabelModel *model = [[SHLabelModel alloc]init];
        model.edit = NO;
        model.title = str;
        [oldArray addObject:model];
    }
    for (NSString *str in array1) {
        SHLabelModel *model = [[SHLabelModel alloc]init];
        model.edit = NO;
        model.title = str;
        [newArray addObject:model];
    }
    [self.data addObject:oldArray];
    [self.data addObject:newArray];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = interItemMargin;
    layout.minimumLineSpacing = lineMargin;
    layout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.headerReferenceSize = CGSizeMake(kScreenWidth, 35);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[SHLabelEditCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    [self.view addSubview:self.collectionView];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 0.35;
    [self.collectionView addGestureRecognizer:longPress];
}

#pragma mark - longPress move

- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    if (!self.edit) {
        return;
    }
    static UILabel *moveLabel = nil;
    static NSIndexPath *previousIndexPath = nil;
    UICollectionView *collectionView = (UICollectionView *)longPress.view;
    CGPoint p = [longPress locationInView:collectionView];
    NSIndexPath *selIndexPath = [collectionView indexPathForItemAtPoint:p];
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            if (selIndexPath) {
                if (selIndexPath.section == 0 && selIndexPath.item != 0) {
                    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:selIndexPath];
                    if (moveLabel == nil) {
                        moveLabel = [[UILabel alloc]init];
                        moveLabel.bounds = CGRectMake(0, 0, itemW, itemH);
                        moveLabel.backgroundColor = [UIColor whiteColor];
                        moveLabel.textAlignment = NSTextAlignmentCenter;
                        moveLabel.alpha = 0.9;
                        moveLabel.font = [UIFont systemFontOfSize:15];
                        [collectionView addSubview:moveLabel];
                    }
                    NSArray *array = self.data[0];
                    SHLabelModel *model = array[selIndexPath.item];
                    moveLabel.text = model.title;
                    cell.alpha = 0;
                    moveLabel.center = p;
                    previousIndexPath = selIndexPath;
                }
            }
            
        }
            break;
        case UIGestureRecognizerStateChanged: {
            moveLabel.center = p;
            if (selIndexPath) {
                if (selIndexPath.section == 0 && selIndexPath.item != 0) {
                    if (![self isIndexPath1:selIndexPath equalIndexPath2:previousIndexPath]) {
                        NSMutableArray *array = self.data[0];
                        SHLabelModel *model = array[previousIndexPath.item];
                        [array removeObjectAtIndex:previousIndexPath.item];
                        [array insertObject:model atIndex:selIndexPath.item];
                        [collectionView moveItemAtIndexPath:previousIndexPath toIndexPath:selIndexPath];
                        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:selIndexPath];
                        cell.alpha = 0;
                        previousIndexPath = selIndexPath;
                    }
                }
            }
        }
            break;
        case UIGestureRecognizerStateEnded: {
            if (selIndexPath) {
                if (selIndexPath.section == 1) {
                    NSMutableArray *section0 = self.data[0];
                    NSMutableArray *section1 = self.data[1];
                    SHLabelModel *model = section0[previousIndexPath.item];
                    model.edit = NO;
                    [section1 insertObject:model atIndex:0];
                    [section0 removeObjectAtIndex:previousIndexPath.item];
                    NSIndexPath *newIndex = [NSIndexPath indexPathForItem:0 inSection:1];
                    [moveLabel removeFromSuperview];
                    moveLabel = nil;
                    [collectionView performBatchUpdates:^{
                        [collectionView deleteItemsAtIndexPaths:@[previousIndexPath]];
                        [collectionView insertItemsAtIndexPaths:@[newIndex]];
                    } completion:nil];
                }
                else {
                    UICollectionViewCell *preCell = [collectionView cellForItemAtIndexPath:previousIndexPath];
                    [moveLabel removeFromSuperview];
                    moveLabel = nil;
                    preCell.alpha = 1;
                }
            }
            else {
                UICollectionViewCell *preCell = [collectionView cellForItemAtIndexPath:previousIndexPath];
                [UIView animateWithDuration:0.3 animations:^{
                    moveLabel.center = preCell.center;
                } completion:^(BOOL finished) {
                    [moveLabel removeFromSuperview];
                    moveLabel = nil;
                    preCell.alpha = 1;
                }];
            }
            previousIndexPath = nil;
        }
        default:
            break;
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.data.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *array = self.data[section];
    return array.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        UILabel *label = (UILabel *)[reusableView viewWithTag:headerLabelTag];
        if (label == nil) {
            label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, reusableView.bounds.size.width-30, reusableView.bounds.size.height)];
            label.tag = headerLabelTag;
            label.font = [UIFont systemFontOfSize:16];
            [reusableView addSubview:label];
        }
        if (indexPath.section == 0) {
            label.text = @"我的频道";
        }
        else if (indexPath.section == 1) {
            label.text = @"频道推荐";
        }
        return reusableView;
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SHLabelEditCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSArray *array = self.data[indexPath.section];
    SHLabelModel *model = array[indexPath.item];
    [cell commitModel:model index:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.edit) {
        if (indexPath.section == 0 && indexPath.item == 0) {
            return;
        }
        NSIndexPath *oldIndex;
        NSIndexPath *newIndex;
        NSMutableArray *oldArray = self.data[0];
        NSMutableArray *newArray = self.data[1];
        if (indexPath.section == 0) {
            SHLabelModel *model = oldArray[indexPath.item];
            model.edit = NO;
            oldIndex = [NSIndexPath indexPathForItem:indexPath.item inSection:0];
            newIndex = [NSIndexPath indexPathForItem:0 inSection:1];
            [newArray insertObject:model atIndex:0];
            [oldArray removeObjectAtIndex:indexPath.item];
        }
        else if (indexPath.section == 1) {
            SHLabelModel *model = newArray[indexPath.item];
            model.edit = YES;
            oldIndex = [NSIndexPath indexPathForItem:indexPath.item inSection:1];
            newIndex = [NSIndexPath indexPathForItem:oldArray.count inSection:0];
            [oldArray addObject:model];
            [newArray removeObjectAtIndex:indexPath.item];
        }
        [collectionView performBatchUpdates:^{
            [collectionView deleteItemsAtIndexPaths:@[oldIndex]];
            [collectionView insertItemsAtIndexPaths:@[newIndex]];
        } completion:nil];
    }
    else {
        NSArray *array = self.data[indexPath.section];
        SHLabelModel *model = array[indexPath.item];
        if (self.selectHandler) {
            self.selectHandler(model,indexPath.item);
        }
        [self quit];
    }
}

#pragma mark - private

- (BOOL)isIndexPath1:(NSIndexPath *)indexPath1 equalIndexPath2:(NSIndexPath *)indexPath2 {
    if (indexPath1.item==indexPath2.item && indexPath1.section==indexPath2.section) {
        return YES;
    }
    return NO;
}



@end
