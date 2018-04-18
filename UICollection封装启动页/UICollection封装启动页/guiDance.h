//
//  guiDance.h
//  表格封装启动页
//
//  Created by liu on 17/5/9.
//  Copyright © 2017年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface guiDance : NSObject
/*声明一个根试图作为系统自带的window的交接桥良*/

@property (nonatomic, strong)UIWindow *window;
/*利用单例创建该类，目的就是使其唯一*/

+(instancetype)sharedGuiDanceInstance;

/**
 *  引导页图片
 *
 *  @param images      引导页图片
 *  @param title       按钮文字
 *  @param titleColor  文字颜色
 *  @param backGroundColor     按钮背景颜色
 *  @param borderColor 按钮边框颜色
 */

- (void)showGuiDanceViewWithImages:(NSArray *)images
          andExperienceButtonTitle:(NSString *)title
     andExperienceButtonTitleColor:(UIColor *)titleColor
andExpersienceButtonBackGroundColor:(UIColor *)backGroundColor
    andExperienceButtonBorderColor:(UIColor *)borderColor;


@end
