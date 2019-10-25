#import "RNLanScanner.h"
#import <Foundation/Foundation.h>
#import "MMLANScanner.h"
#import "LANProperties.h"
#import "MMDevice.h"
#import <NetworkExtension/NetworkExtension.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@interface RNLanScanner()<MMLANScannerDelegate>

@property(nonatomic,strong)MMLANScanner *lanScanner;
@property(nonatomic,assign,readwrite)BOOL isScanRunning;
@property(nonatomic,assign,readwrite)float progressValue;

@end

@implementation RNLanScanner
{
    NSMutableArray *connectedDevicesMutable;
    bool hasListeners;
    dispatch_queue_t queue;
}

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

- (dispatch_queue_t)methodQueue
{
    if (!queue) {
        queue = dispatch_queue_create("RNNetworkManager", DISPATCH_QUEUE_SERIAL);
    }
    return queue;
}

RCT_EXPORT_METHOD(sampleMethod:(NSString *)stringArgument numberParameter:(nonnull NSNumber *)numberArgument callback:(RCTResponseSenderBlock)callback)
{
    // TODO: Implement some actually useful functionality
	callback(@[[NSString stringWithFormat: @"numberArgument: %@ stringArgument: %@", numberArgument, stringArgument]]);
}

RCT_EXPORT_METHOD(start) {
    self.isScanRunning=NO;
    self.lanScanner = [[MMLANScanner alloc] initWithDelegate:self];
    [self startNetworkScan];
}

-(void)startNetworkScan {
    
    self.isScanRunning=YES;
    
    connectedDevicesMutable = [[NSMutableArray alloc] init];
    self.connectedDevicesIp = [[NSMutableArray alloc] init];
    
    [self.lanScanner start];
};

-(void)stopNetworkScan {
    
    [self.lanScanner stop];
    
    self.isScanRunning=NO;
}

#pragma mark - MMLANScannerDelegate methods
//The delegate methods of MMLANScanner
-(void)lanScanDidFindNewDevice:(MMDevice*)device{
    
    //Check if the Device is already added
    if (![connectedDevicesMutable containsObject:device]) {
        
        MMDevice *nd = device;
        NSString *ipLabel = nd.ipAddress;
        
        NSLog(@"device %@", device);
        
        [self.connectedDevicesIp addObject:ipLabel];
        [connectedDevicesMutable addObject:device];
    }
    
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ipAddress" ascending:YES];
    
    //Updating the array that holds the data. MainVC will be notified by KVO
    self.connectedDevices = [connectedDevicesMutable sortedArrayUsingDescriptors:@[valueDescriptor]];
}

-(void)lanScanDidFinishScanningWithStatus:(MMLanScannerStatus)status{
    
    self.isScanRunning=NO;
    
    //Checks the status of finished. Then call the appropriate method
    if (status == MMLanScannerStatusFinished) {
        
        //[self.delegate mainPresenterIPSearchFinished];
        NSLog(@"DEBUG : IP SEARCH FINISHED");
        NSLog(@"ipAddress %@", self.connectedDevicesIp);
        [self sendEventWithName:@"finishedScan" body:self.connectedDevicesIp];
    }
    else if (status==MMLanScannerStatusCancelled) {
        
        //[self.delegate mainPresenterIPSearchCancelled];
        NSLog(@"DEBUG : IP SEARCH CANCELLED");
    }
}

-(void)lanScanProgressPinged:(float)pingedHosts from:(NSInteger)overallHosts {
    
    //Updating the progress value. MainVC will be notified by KVO
    self.progressValue=pingedHosts/overallHosts;
}

-(void)lanScanDidFailedToScan {
    
    self.isScanRunning=NO;
    NSLog(@"DEBUG : FAILED TO SCAN");
    //[self.delegate mainPresenterIPSearchFailed];
}

- (NSArray<NSString *> *)supportedEvents {
    return @[@"finishedScan"];
}

@end
