# react-native-lan-scanner

## Getting started

`$ npm install react-native-lan-scanner --save`

### Mostly automatic installation

`$ react-native link react-native-lan-scanner`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-lan-scanner` and add `RNLanScanner.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNLanScanner.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainApplication.java`
  - Add `import com.reactlibrary.RNLanScannerPackage;` to the imports at the top of the file
  - Add `new RNLanScannerPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-lan-scanner'
  	project(':react-native-lan-scanner').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-lan-scanner/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-lan-scanner')
  	```


## Usage
```javascript
import RNLanScanner from 'react-native-lan-scanner';

// TODO: What to do with the module?
RNLanScanner;
```
