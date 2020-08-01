//
//  BleNetworkPlugin.m
//  Runner
//
//  Created by Ren on 2020/7/31.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "BleNetworkPlugin.h"
#import <BleDistributionNetworkSDK/BleDistributionNetworkSDK.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <SystemConfiguration/CaptiveNetwork.h>

NSString *const KEY_PERIPHERAL = @"Peripheral";
NSString *const KEY_LOCAL_NAME = @"LocalName";

@interface BleNetworkPlugin ()<BleLinkManagerDelegate, NetworkConfigDelegate>

@property (strong, nonatomic) NSMutableArray *devices;
@property (strong, nonatomic) BleLinkManager *bleLinkManager;
@property (strong, nonatomic) NetworkConfigClient *client;
@property (strong, nonatomic) FlutterBasicMessageChannel* stopScanChannel;
@property (strong, nonatomic) FlutterBasicMessageChannel* scanResultChannel;


@property (strong, nonatomic) FlutterResult setupResult;

@end

@implementation BleNetworkPlugin

- (instancetype)init
{
    self = [super init];
    if (self) {
        /*! 初始化配网对象*/
        _bleLinkManager = [BleLinkManager sharedInstance];
        _bleLinkManager.delegate = self;
        _client = [[NetworkConfigClient alloc] initWithLinkManager:_bleLinkManager delegate:self];

        _devices = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc
{
    [_bleLinkManager stopDiscover];
}


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FlutterMethodChannel *channel =
      [FlutterMethodChannel methodChannelWithName:@"blenetworkplugin_plugin"
                                  binaryMessenger:registrar.messenger];
  BleNetworkPlugin *plugin = [[BleNetworkPlugin alloc] init];
  [registrar addMethodCallDelegate:plugin channel:channel];
    
    plugin.stopScanChannel = [FlutterBasicMessageChannel messageChannelWithName:@"stopScan" binaryMessenger:[registrar messenger]];
    plugin.scanResultChannel = [FlutterBasicMessageChannel messageChannelWithName:@"scanResult" binaryMessenger:[registrar messenger]];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
  if ([@"currentNetworkSSID" isEqualToString:call.method]) {
      result(@"");
  } if ([@"startScan" isEqualToString:call.method]) {
      [self startScan:call result:result];
  } if ([@"stopScan" isEqualToString:call.method]) {
      [self stopScan:call result:result];
  } if ([@"setup" isEqualToString:call.method]) {
      [self setup:call result:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)startScan:(FlutterMethodCall *)call result:(FlutterResult)result  {
    [_bleLinkManager stopDiscover];
    [_bleLinkManager startDiscover];
}

- (void)stopScan:(FlutterMethodCall *)call result:(FlutterResult)result  {
    [_bleLinkManager stopDiscover];
}

- (void)setup:(FlutterMethodCall *)call result:(FlutterResult)result  {

    [_bleLinkManager stopDiscover];
    _setupResult = result;
    
    NSString *ssid = call.arguments[@"ssid"];
    NSString *password = call.arguments[@"password"];
    NSString *name = call.arguments[@"name"];
    
    CBPeripheral *peripheral = nil;
    
    for (NSMutableDictionary * item in _devices)
    {
        if(item[KEY_LOCAL_NAME]==name) {
            peripheral = item[KEY_PERIPHERAL];
        }
        NSLog(@"stKEY_LOCAL_NAMEr = %@",name);
    }
    
    if(peripheral == nil) {
        result([FlutterError errorWithCode:@"Error" message:[NSString stringWithFormat:@"Name invalid"] details:nil]);
        return;
    }
    
    NSString * time = [NSString stringWithFormat:@"1000012880_%@",[self getNowTimeTimestamp]];
    UIViewController *controller = [[self getViewControllerWindow] rootViewController];
    if (![_client configNetworkWithPeripheral:peripheral ssid:ssid psk:password date:time targetViewController:controller]) {
        NSLog(@"已在配网中，请不要反复点击！");
    }
}

- (void)didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"didDiscoverPeripheral");
    if (peripheral == nil) {
           return;
       }
       /*根据设备名，可以过滤设备*/
       NSString *deviceLocalName = [self matchDevice:advertisementData];
       if (deviceLocalName == nil )
           return;
       
       BOOL isAdd = true;
       for (int i = 0; i<_devices.count; i++) {
           if ([_devices[i][KEY_LOCAL_NAME] isEqualToString:deviceLocalName]) {
               isAdd = false;
           }
       }
       if (isAdd == true) {
           NSMutableDictionary *deviceDict = [NSMutableDictionary dictionary];
           [deviceDict setObject:peripheral forKey:KEY_PERIPHERAL];
           [deviceDict setObject:deviceLocalName forKey:KEY_LOCAL_NAME];
           [_devices addObject:deviceDict];
       }

    
       NSMutableArray *items = [[NSMutableArray alloc] init];
       for (int i = 0; i<_devices.count; i++) {
           [items addObject:_devices[i][KEY_LOCAL_NAME]];
       }
       
       [_scanResultChannel sendMessage:items];
}

- (void)didPowerOn:(BOOL)isOn {
    NSLog(@"isOn");
}

- (void)onNetworkConfigResult:(NetConfigResultCode)resultCode data:(NSString *)data {
    NSLog(@"onNetworkConfigResult");
    
    if (resultCode == NetConfigSuccess) {
        NSLog(@"配网成功 pid=%@", data);
        _setupResult(@"success");
    } else {
         NSLog(@"配网失败");
        _setupResult([FlutterError errorWithCode:@"Error" message:[NSString stringWithFormat:@"配网失败"] details:nil]);
    }
}

- (UIWindow*)getViewControllerWindow{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [UIApplication sharedApplication].windows;
        for (UIWindow *target in windows) {
            if (target.windowLevel == UIWindowLevelNormal) {
                window = target;
                break;
            }
        }
    }
    return window;
}

- (NSString *)matchDevice:(NSDictionary <NSString *, id> *)advertisementData
{
    NSString *localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    
    if (!localName || ![localName hasPrefix:@"A1"]) {
        return nil;
    }
    
    return localName;
}

-(NSString *)getNowTimeTimestamp{
 
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    return timeString;
}

@end
