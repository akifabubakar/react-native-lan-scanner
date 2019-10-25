#if __has_include("RCTBridgeModule.h")
#import "RCTEventEmitter.h"
#else
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#endif

@interface RNLanScanner : RCTEventEmitter <RCTBridgeModule>

@property(nonatomic,strong)NSArray *connectedDevices;
@property(nonatomic,strong)NSMutableArray *connectedDevicesIp;

@end
