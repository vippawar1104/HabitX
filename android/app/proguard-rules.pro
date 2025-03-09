-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class com.google.firebase.** { *; }  # If you're using Firebase

# Keep your application class if you have one
-keep class com.example.habitx.** { *; }

# Uncomment this if you use kotlinx.serialization
#-keepattributes *Annotation*, InnerClasses
#-dontnote kotlinx.serialization.AnnotationsKt