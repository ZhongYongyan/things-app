//
//  NetworkConfigClient.h
//  IngenicAudioNetworkConfigDemo
//
//  Created by 君正时代 on 2018/3/23.
//  Copyright © 2018年 Ingenic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CBPeripheral;
@class BleLinkManager;

/**
 * 配网结果码
 */
typedef NS_ENUM(NSUInteger, NetConfigResultCode) {
    /**配网成功*/
    NetConfigSuccess                     = 0,
    /**无法连接到远程设备*/
    NetConfigUnableConnectToRemoteDevice = 1,
    /**无法匹配配网协议*/
    NetConfigUnableMatchProtocol         = 2,
};

/**
 * 配网成功获取PID对应的NSDictionary的Key
 */
extern NSString *const EXTRA_PID;

/**
 * 配网成功获取DSN对应的NSDictionary的Key
 */
extern NSString *const EXTRA_DSN;

/**
 * 配网结果回调
 */
@protocol NetworkConfigDelegate <NSObject>

@required

/**
 * 配网完成时回调
 * resultCode: NetConfigSuccess || NetConfigUnableConnectToRemoteDevice || NetConfigUnableMatchProtocol
 * data: 配网失败将返回nil;
 *       配网成功，则返回设备端发送过来的数据。
 */
- (void)onNetworkConfigResult:(NetConfigResultCode)resultCode data:(NSString *)data;

@end

@interface NetworkConfigClient : NSObject

/**
 * 配网结果码转字符串
 */
+ (NSString *)resultCodeToString:(NetConfigResultCode)resultCode;

/**
 * 初始化配网客户端
 * linkManager: 具体的配网链路管理者（BLE/SoftAp,暂时只支持BLE）
 * delegate: 配网结果回调
 */
- (instancetype)initWithLinkManager:(BleLinkManager *)linkManager delegate:(id<NetworkConfigDelegate>)delegate;

/**
 * 为远程外设配网
 * peripheral: 扫描到的外设
 * ssid: 需要配置的网络名称
 * psk: 需要配置的网络密码
 * date:硬件需要的时间戳
 * targetViewController 用于显示授权页面的目标UIViewController
 */
- (BOOL)configNetworkWithPeripheral:(CBPeripheral *)peripheral ssid:(NSString *)ssid psk:(NSString *)psk date:(NSString *)date targetViewController:(UIViewController *)targetViewController;

@end
