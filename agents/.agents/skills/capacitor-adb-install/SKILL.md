---
name: capacitor-adb-install
description: Build, sync, install, and launch a local Capacitor Android app on a connected phone through ADB. Use when asked to install, deploy, or run the current Capacitor project on an Android device.
compatibility: Requires Node.js, Java, Android SDK/ADB, a Capacitor Android project, and an authorized connected device.
---

# Install a Capacitor app through ADB

Run commands from the project root.

## Workflow

1. Read `capacitor.config.*` to confirm `webDir` and `appId`.
2. Check the device connection:

```bash
adb devices -l
```

Stop and explain the problem if no authorized device is listed. If multiple devices are connected, select the intended serial with `adb -s <serial>` and pass it to Gradle as needed.

3. Build and copy the current web app into Android:

```bash
npm run build
npx cap sync android
```

4. Build and install the debug APK:

```bash
cd android
./gradlew installDebug
```

5. Launch the installed app, using the `appId` from `capacitor.config.*`:

```bash
adb shell monkey -p <appId> -c android.intent.category.LAUNCHER 1
```

With a selected device, add `-s <serial>` immediately after `adb`.

## Validation

Require all of the following before reporting success:

- Capacitor sync completes successfully.
- Gradle reports `BUILD SUCCESSFUL` and `Installed on 1 device`.
- The launch command reports `Events injected: 1`.

Do not add deployment scripts or modify project configuration unless the user asks.
