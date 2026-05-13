{
  description = "Hollow Recall Flutter App";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;

          config = {
            allowUnfree = true;
            android_sdk.accept_license = true;
          };
        };

        android = pkgs.androidenv.composeAndroidPackages {
          buildToolsVersions = [
            "35.0.0"
            "36.0.0"
          ];

          platformVersions = [
            "35"
            "36"
          ];

          abiVersions = [
            "arm64-v8a"
            "x86_64"
          ];

          toolsVersion = "26.1.1";
          platformToolsVersion = "37.0.0";

          cmakeVersions = [
            "3.22.1"
          ];

          includeNDK = true;
          ndkVersions = [
            "28.2.13676358"
          ];

          includeEmulator = true;
          includeSystemImages = true;

          systemImageTypes = [
            "android-wear"
            "google_apis_playstore"
          ];
        };

        androidSdk = "${android.androidsdk}/libexec/android-sdk";
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            flutter
            dart

            android.androidsdk
            jdk21
            gradle

            git
            curl
            unzip

            clang
            cmake

            gtk3
            glib
            gsettings-desktop-schemas

            hicolor-icon-theme
            adwaita-icon-theme

            shared-mime-info

            ninja
            pkg-config

            sysprof

            librsvg
            gdk-pixbuf

            alejandra
          ];

          ANDROID_SDK_ROOT = androidSdk;
          ANDROID_HOME = androidSdk;
          JAVA_HOME = pkgs.jdk21;
          JAVA_TOOL_OPTIONS = "-Dcom.jetbrains.ls.imports.gradle.java.home=${pkgs.jdk21}";

          shellHook = ''
            export PATH="$ANDROID_SDK_ROOT/platform-tools:$PATH"

            export XDG_DATA_DIRS="${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS"

            export GDK_PIXBUF_MODULE_FILE="${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"

            export GTK_THEME=Adwaita

            export QT_QPA_PLATFORM=xcb
           
            if ! emulator -list-avds | grep -q wearos; then
              echo "Creating Wear OS AVD..."

              yes | avdmanager create avd \
                -n wearos \
                -k "system-images;android-36;android-wear-signed;x86_64" \
                --device "wearos_large_round"

              sed -i 's/hw.keyboard=no/jw.keyboard=yes/' \
                "$HOME/.android/avd/wearos.avd/config.ini"
            fi

            if ! emulator -list-avds | grep -q phone; then
              echo "Creating Phone AVD..."

              yes | avdmanager create avd \
                -n phone \
                -k "system-images;android-36;google_apis_playstore;x86_64" \
                --device "pixel_9_pro"

              sed -i 's/hw.keyboard=no/hw.keyboard=yes/' \
                "$HOME/.android/avd/phone/avd/config.ini"
            fi
          '';
        };

        formatter.${system} = pkgs.alejandra;
      });
}
