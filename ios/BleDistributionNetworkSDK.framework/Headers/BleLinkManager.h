//
//  BleLinkManager.h
//  IngenicAudioNetworkConfigDemo
//
//  Created by 君正时代 on 2018/3/22.
//  Copyright © 2018年 Ingenic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBPeripheral;

@protocol BleLinkManagerDelegate <NSObject>

@required

/**
 * 蓝牙状态变化
 */
- (void)didPowerOn:(BOOL)isOn;

/**
 * 发现外设时回调
 */
- (void)didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary <NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI;

@end

@interface BleLinkManager : NSObject

@property (weak, nonatomic) id <BleLinkManagerDelegate> delegate;


+ (instancetype)sharedInstance;

- (BOOL)startDiscover;

- (BOOL)stopDiscover;

- (BOOL)connectPeripheral:(CBPeripheral *)peripheral;

- (int)read:(char *)buffer size:(int)size;

- (BOOL)write:(const char *)buffer size:(int)size;

- (BOOL)disconnect;

@end
