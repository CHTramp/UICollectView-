//
//  guiDanceCollectionViewCell.m
//  表格封装启动页
//
//  Created by liu on 17/5/9.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "guiDanceCollectionViewCell.h"

#define GUIDANCEBOUNDS ([UIScreen mainScreen].bounds)


@implementation guiDanceCollectionViewCell


#pragma mark -- init初始化
- (instancetype)init{
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

#pragma mark --坐标初始化
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.layer.masksToBounds = YES;
    self.GuiDanceImageView = [[UIImageView alloc]initWithFrame:GUIDANCEBOUNDS];
    self.GuiDanceImageView.center = CGPointMake(GUIDANCEBOUNDS.size.width / 2, GUIDANCEBOUNDS.size.height / 2);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.hidden = YES;
    [button setFrame:CGRectMake(0, 0, 200, 44)];
    [button setTitle:@"立即体验" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.layer setCornerRadius:5];
    [button.layer setBorderColor:[UIColor grayColor].CGColor];
    [button.layer setBorderWidth:1.0f];
    [button setBackgroundColor:[UIColor whiteColor]];
    self.experienceButton = button;
    [self.contentView addSubview:self.GuiDanceImageView];
    [self.contentView addSubview:self.experienceButton];
    
    self.experienceButton.center = CGPointMake(GUIDANCEBOUNDS.size.width / 2.0f, GUIDANCEBOUNDS.size.height - 100);
    
 

}
@end
