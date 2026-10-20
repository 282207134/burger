# The preferences JNI bridge resolves Kotlin suspend methods by their JVM signatures.
-keep,includedescriptorclasses class io.flutter.plugins.sharedpreferences.** { *; }
# JNI also looks up coroutine runtime classes, fields and methods by name.
-keep,includedescriptorclasses class com.github.dart_lang.jni.** { *; }
-keep class kotlin.coroutines.** { *; }
-keep class kotlin.Result** { *; }
-keep class kotlin.Unit { *; }
