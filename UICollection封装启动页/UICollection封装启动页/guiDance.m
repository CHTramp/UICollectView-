//
//  guiDance.m
//  表格封装启动页
//
//  Created by liu on 17/5/9.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "guiDance.h"
#import "guiDanceCollectionViewCell.h"
#define GUIDANCEBOUNDS ([UIScreen mainScreen].bounds)

/*复用标识符*/
static NSString *indentifier_GuiDanceCell = @"cell";


@interface guiDance()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

/*申明一个UICollectionView*/
@property (nonatomic, strong) UICollectionView *collectionView;
/*申明一个存储图片的数组*/
@property (nonatomic, strong) NSArray *imageArray;
/*申明一个pageContrl*/
@property (nonatomic, strong) UIPageControl *pageControl;
/*申明按钮的标题，默认是立即体验*/
@property (nonatomic, strong) NSString *title;
/*申明按钮的背景颜色*/
@property (nonatomic, strong) UIColor *backGroundColor;
/*申明按钮标题文字的颜色*/
@property (nonatomic, strong) UIColor *titleColor;
/*申明按钮边框的颜色*/
@property (nonatomic, strong) UIColor *borderColor;

@end

@implementation guiDance


//- (NSMutableArray *)imageArray{
//    if (!_imageArray) {
//        _imageArray = [NSMutableArray array];
//    }
//    return _imageArray;
//}

#pragma mark -- 创建单例
+(instancetype)sharedGuiDanceInstance{
    static guiDance *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
             instance = [guiDance new];
        }
       
    });
    return instance;
}

#pragma mark -- 懒加载创建collectionView
-(UICollectionView *)collectionView{
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = GUIDANCEBOUNDS.size;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:GUIDANCEBOUNDS collectionViewLayout:flowLayout];
        
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[guiDanceCollectionViewCell class] forCellWithReuseIdentifier:indentifier_GuiDanceCell];
       
           }
    return _collectionView;
}

#pragma mark -- 初始化pageControl
-(UIPageControl *)pageControl{
    
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.frame = CGRectMake(0, 0, GUIDANCEBOUNDS.size.width, 44.0f);
        _pageControl.center = CGPointMake(GUIDANCEBOUNDS.size.width / 2.0f, GUIDANCEBOUNDS.size.height - 60);
    }
    return _pageControl;
}

#pragma mark --实现方法
- (void)showGuiDanceViewWithImages:(NSArray *)images andExperienceButtonTitle:(NSString *)title andExperienceButtonTitleColor:(UIColor *)titleColor andExpersienceButtonBackGroundColor:(UIColor *)backGroundColor andExperienceButtonBorderColor:(UIColor *)borderColor{
    
    
    NSLog(@"%@", images);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *version = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //根据版本号来判断是否加载引导页
    BOOL show = [userDefaults boolForKey:[NSString stringWithFormat:@"version_%@", version]];
    if (!show) {
        self.imageArray = images;
        
        NSLog(@"%@", self.imageArray);
        self.backGroundColor = backGroundColor;
        self.title = title;
        self.titleColor = titleColor;
        self.borderColor = borderColor;
        self.pageControl.numberOfPages = images.count;
        //这里千万不要写这句话，因为这样会有两个window出现，而展示的时候就是展示的系统默认的，你可以结合UI结构图看。
//        self.window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        
        if (nil == self.window) {
            self.window = [UIApplication sharedApplication].keyWindow;
        }
        [self.window addSubview:self.collectionView];
        [self.window addSubview:self.pageControl];
        [userDefaults setBool:YES forKey:[NSString stringWithFormat:@"version_%@",version]];
        [userDefaults synchronize];
    }
}

#pragma mark -- 实现协议方法

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.imageArray.count;
    
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    guiDanceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentifier_GuiDanceCell forIndexPath:indexPath];
    UIImage *image = [self.imageArray objectAtIndex:indexPath.row];
    CGSize size = [self adapterSizeImageSize:image.size compareSize:GUIDANCEBOUNDS.size];
    
    cell.GuiDanceImageView.frame = CGRectMake(0, 0, size.width, size.height);
    cell.GuiDanceImageView.image = image;
    cell.GuiDanceImageView.center = CGPointMake(GUIDANCEBOUNDS.size.width /2, GUIDANCEBOUNDS.size.height / 2);
    if (indexPath.row == self.imageArray.count - 1) {
        
        [cell.experienceButton setHidden:NO];
        [cell.experienceButton addTarget:self action:@selector(nextVControllerHandler:) forControlEvents:UIControlEventTouchUpInside];
        [cell.experienceButton setBackgroundColor:self.backGroundColor];
        [cell.experienceButton setTitle:self.title forState:UIControlStateNormal];
        [cell.experienceButton setTitleColor:self.titleColor forState:UIControlStateNormal];
        cell.experienceButton.layer.borderColor = [self.borderColor CGColor];
    }else{
        [cell.experienceButton setHidden:YES];
    }
    
    return cell;
}
#pragma mark - 计算自适图片
/**
 *  计算自适应的图片
 *
 *  @param is 需要适应的尺寸
 *  @param cs 适应到的尺寸
 *
 *  @return 适应后的尺寸
 */
- (CGSize)adapterSizeImageSize:(CGSize)is compareSize:(CGSize)cs
{
    CGFloat w = cs.width;
    CGFloat h = cs.width / is.width * is.height;
    
    if (h < cs.height) {
        w = cs.height / h * w;
        h = cs.height;
    }
    return CGSizeMake(w, h);
}

#pragma mark -- 实现UIScrollViewDelegate方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.pageControl.currentPage = (scrollView.contentOffset.x / GUIDANCEBOUNDS.size.width);
}

#pragma mark -- 立即体验按钮响应事件
- (void)nextVControllerHandler:(UIButton *)button{
    
    [self.pageControl removeFromSuperview];
    [self.collectionView removeFromSuperview];
    [self setWindow:nil];
    [self setCollectionView:nil];
    [self setPageControl:nil];
    
}

@end
