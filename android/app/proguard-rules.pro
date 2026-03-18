# Please add these rules to your existing keep rules in order to suppress warnings.
# This is generated automatically by the Android Gradle plugin.
-dontwarn com.google.errorprone.annotations.CanIgnoreReturnValue
-dontwarn com.google.errorprone.annotations.CheckReturnValue
-dontwarn com.google.errorprone.annotations.Immutable
-dontwarn com.google.errorprone.annotations.RestrictedApi
-dontwarn javax.annotation.Nullable
-dontwarn javax.annotation.concurrent.GuardedBy
-dontwarn org.bouncycastle.jce.provider.BouncyCastleProvider
-dontwarn org.bouncycastle.pqc.jcajce.provider.BouncyCastlePQCProvider
-keep class org.xmlpull.v1.** { *; }

# 🔥 MANTENER clases personalizadas de base64/GZIP/Imágenes
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.app.** { *; }
-keep class io.flutter.view.** { *; }

# 🔥 MANTENER funciones de conversión de archivos
-keepclassmembers class * {
    ** convertBase64StringToUploadFiles(**);
    ** convertUploadsListtoJSON(**);
    ** convertirFormatoSQLiteAJSON(**);
    ** convertirJSONaFormatoSQLite(**);
}

# 🔥 MANTENER clases de SQLite
-keep class * extends android.database.sqlite.SQLiteOpenHelper { *; }
-keep class * implements android.database.Cursor { *; }

# 🔥 NO ofuscar dart:io y dart:convert
-keep class dart.** { *; }

# 🔥 MANTENER todas las clases de imagen/video
-keep class android.graphics.** { *; }
-keep class android.media.** { *; }





