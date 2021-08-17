# app

**一次性生成**

```
flutter packages pub run build_runner build
```

**持续生成**

```
flutter packages pub run build_runner watch
```

**支持真机支行**
```
flutter build apk --target-platform android-arm64
```

**keystore**
```
keytool -genkey -v -keystore key.keystore -alias app -keyalg RSA -keysize 2048 -validity 10000
```

日志新增