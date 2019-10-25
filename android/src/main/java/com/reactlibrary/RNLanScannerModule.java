package com.reactlibrary;

import android.support.annotation.Nullable;
import android.util.Log;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.stealthcopter.networktools.IPTools;
import com.stealthcopter.networktools.SubnetDevices;
import com.stealthcopter.networktools.subnet.Device;

import java.net.InetAddress;
import java.util.ArrayList;

public class RNLanScannerModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;
    private WritableArray payload = Arguments.createArray();

    public RNLanScannerModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    private void sendEvent(ReactApplicationContext reactContext,
                           String eventName,
                           @Nullable WritableArray params) {
        reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
    }

    private void arrayMap(ArrayList<Device> devicesFound){
        int length = devicesFound.size();

        for (int i = length - 1; i>=0; i--) {

            payload.pushString(devicesFound.get(i).ip);
        }

        if(length== 0)
        {
            payload = null;
        }
    }

    @Override
    public String getName() {
        return "RNLanScanner";
    }

    SubnetDevices subnetDevices;

    @ReactMethod
    public void start() {

        ArrayList<String> testIP = findAvailableIP();
        WritableArray reachableIP = Arguments.createArray();


        try {
            for(String hostIP : testIP) {
                InetAddress ia = InetAddress.getByName(hostIP);
                if (ia.isReachable(70)) {
                    Device device = new Device(ia);
                    reachableIP.pushString(hostIP);
                    Log.wtf("REACHABLE", hostIP);
                }
            }
            sendEvent(reactContext, "finishedScan", reachableIP);
        }catch(Throwable t){
            Log.wtf("ERROR",t);
        }
    }

    @ReactMethod
    public ArrayList findAvailableIP() {

        ArrayList arrayIP = new ArrayList<String>();

        InetAddress ipv4 = IPTools.getLocalIPv4Address();
        String hostIP = ipv4.getHostAddress();
        String testIp = null;

        String prefix = hostIP.substring(0, hostIP.lastIndexOf(".") + 1);
        for (int i = 0; i < 255; i++) {
            testIp = prefix + String.valueOf(i);
            arrayIP.add(testIp);
        }

        return arrayIP;
    }

    public void cancelSearch() {
        subnetDevices.cancel();
        //payload = 0;
        ArrayList clear = new ArrayList();
        arrayMap(clear);
    }
}
