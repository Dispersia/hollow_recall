plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.android)
    alias(libs.plugins.kotlin.compose)
}

android {
    namespace = "io.dispersia.hollow_recall"
    compileSdk = 36

    defaultConfig {
        applicationId = "io.dispersia.hollow_recall"
        minSdk = 30
        targetSdk = 36
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_21.toString()
    }

    sourceSets.getByName("main") {
        kotlin.srcDirs("src")
        res.srcDirs("src/res")
        manifest.srcFile("src/AndroidManifest.xml")
    }

    useLibrary("wear-sdk")

    buildFeatures {
        compose = true
    }
}

dependencies {
    implementation(platform(libs.compose.bom))
    implementation(libs.activity.compose)
    implementation(libs.compose.ui)
    implementation(libs.compose.ui.graphics)
    implementation(libs.compose.ui.tooling.preview)
    implementation(libs.core.splashscreen)
    implementation(libs.wear.compose.foundation)
    implementation(libs.wear.compose.material3)
    implementation(libs.wear.compose.ui.tooling)
    implementation(libs.wear.protolayout.material3)
    implementation(libs.wear.protolayout)
    implementation(libs.wear.tiles.tooling.preview)
    implementation(libs.wear.tiles)
    implementation(libs.wear.watchface.complications.data.source.ktx)
    implementation(libs.wear.tooling.preview)
    implementation(libs.play.services.wearable)
    implementation(libs.guava)

    androidTestImplementation(platform(libs.compose.bom))
    androidTestImplementation(libs.compose.ui.test.junit4)

    debugImplementation(libs.compose.ui.test.manifest)
    debugImplementation(libs.compose.ui.tooling)
    debugImplementation(libs.wear.tiles.renderer)
    debugImplementation(libs.wear.tiles.tooling)
}
