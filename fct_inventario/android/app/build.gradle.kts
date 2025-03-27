plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // Plugin de Firebase
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Plugin de Flutter
}

android {
    namespace = "com.example.fct_inventario"
    compileSdk = 34  // Asegúrate de usar una versión compatible
    ndkVersion = "25.2.9519653" // Usa la versión de tu NDK si es necesaria

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.fct_inventario"
        minSdk = 21  // Asegúrate de que tu versión mínima es compatible con Firebase
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.google.firebase:firebase-auth-ktx:22.1.1")  // Firebase Auth
    implementation("com.google.firebase:firebase-firestore-ktx:24.9.0")  // Firestore
}
