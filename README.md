Original file: https://github.com/londonappbrewery/flash-chat-flutter
This stub is the updated version of the project after fixing the errors. 

I have used the following these steps to update the file so that it can run on my PC (I am using Android Studio Arctic Fox & Android SDK 32):

Enable Dart support:
1. File > Setting > Languages & Frameworks > Dart: Tick 'Enable Dart Support for the project 'flash-chat-flutter'
2. Locate Dart SDK path where you have installed it. Mine is in C:\tools\dart-sdk or C:\src\flutter\bin\cache\dart-sdk
3. Enable Dart Support for the following modules: 
- Project 'flash-chat-flutter'
- 'flash-chat-flutter'
5. Click Apply

Enable Flutter: 
1. File > Setting > Languages & Frameworks> Flutter
2. Locate Flutter SDK. Mine is in C:\src\flutter
3. Click Apply & OK. 
4. Go to pubspec.yaml and click get dependencies & update. 

Migrate to latest SDK: 
1. Run the code, you will get error because it is using old version. The console will give instruction to migrate to the latest version. Follow this step to migrate the project: https://github.com/flutter/flutter/wiki/Upgrading-pre-1.12-Android-projects
a)  If during Step 4 you have added this into AndroidManifest.xml 
            <!-- Theme to apply as soon as Flutter begins rendering frames -->
            <meta-data
                android:name="io.flutter.embedding.android.NormalTheme"
                android:resource="@style/NormalTheme"
                />
Please check your android/app/src/main/res/values/styles.xml & make sure the NormalTheme exist: 

    <style name="NormalTheme" parent="@android:style/Theme.Black.NoTitleBar">
        <item name="android:windowBackground">@drawable/launch_background</item>
    </style>

2. Update android/app/src/main/AndroidManifest.xml, add android:exported="true":
       <activity
            android:name=".MainActivity"
            android:exported="true" <-------------Add this
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
        android:configChanges="orientation|keyboardHidden|keyboard|screenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">

3. In android/app/src/build.gradle: update compileSdkVersion and targetSdkVersion to latest version installed. Mine is SDK 32. 

android {
    compileSdkVersion 32 <------ Update this 

    lintOptions {
        disable 'InvalidPackage'
    }

    defaultConfig {
        applicationId "co.appbrewery.bitcoin_ticker"
        minSdkVersion 16
        targetSdkVersion 32 <------ Update this 
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }
    
    ...
}	
4. Run the code. It should be working
