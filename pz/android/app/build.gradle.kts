plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // FlutterFire Configuration
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Flutter Gradle Plugin
}

android {
    namespace = "com.example.pz"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973" // Update this to the installed version

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.pz"
        minSdk = 23 // Correct syntax for minSdk
        targetSdk = 33 // Correct syntax for targetSdk
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug") // Correctly reference signingConfig
        }
    }
}

flutter {
    source = "../.." // Correct syntax for source
}


