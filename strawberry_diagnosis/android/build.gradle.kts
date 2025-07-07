buildscript {
    // THIS IS WHAT WAS MISSING: Define repositories for the buildscript dependencies
    repositories {
        google()       // Important: Google's Maven repository for Google services plugin
        mavenCentral() // Common repository for other buildscript dependencies
    }
    dependencies {
       
        classpath("com.google.gms:google-services:4.4.1") // Latest as of mid-2025
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}