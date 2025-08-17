import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:path/path.dart' as path;

import 'firebase_options.dart';
import 'amplifyconfiguration.dart';
import 'login_screen.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AppWrapper());
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Strawberry Diagnosis',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'DM Sans'),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            return const StrawberryDiagnosisApp();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}

class StrawberryDiagnosisApp extends StatefulWidget {
  const StrawberryDiagnosisApp({super.key});

  @override
  State<StrawberryDiagnosisApp> createState() => _StrawberryDiagnosisAppState();
}

class _StrawberryDiagnosisAppState extends State<StrawberryDiagnosisApp> {
  bool _amplifyConfigured = false;
  List<Map<String, dynamic>> _diagnoses = [];
  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
    _fetchDiagnoses();
  }

  Future<void> _configureAmplify() async {
    try {
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.addPlugin(AmplifyAPI());
      await Amplify.addPlugin(AmplifyStorageS3());
      await Amplify.configure(amplifyconfig);
      setState(() {
        _amplifyConfigured = true;
      });
    } catch (e) {
      debugPrint('Amplify error: $e');
    }
  }

  Future<void> _fetchDiagnoses() async {
    const String graphQLDocument = '''
      query ListDiagnoses {
        listDiagnoses {
          items {
            id
            image_key
            result
            disease
            severity
            treatment
            createdAt
          }
        }
      }
    ''';

    try {
      final request = GraphQLRequest<String>(document: graphQLDocument);
      final response = await Amplify.API.query(request: request).response;
      final decoded = jsonDecode(response.data!);
      final items = decoded['listDiagnoses']['items'] as List;

      final diagnoses = items
          .where((item) => item != null)
          .map((item) {
            final map = item as Map<String, dynamic>;
            final createdAt = map['createdAt'];
            final dateTime = DateTime.tryParse(createdAt ?? '') ?? DateTime.now();
            return {
              'plantName': map['disease'] ?? 'Unknown',
              'diagnosis': map['result'] ?? '',
              'date': '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}',
              'time': '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}',
            };
          })
          .toList();

      setState(() {
        _diagnoses = diagnoses;
      });
    } catch (e) {
      debugPrint('Error fetching diagnoses: $e');
    }
  }

  void _onScanNow() {
    // Hook your scanner or image picker flow here
    debugPrint('Scan Now pressed!');
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final username = user?.displayName ?? 'User';

    return HomeScreen(
      username: username,
      recentDiagnoses: _diagnoses,
    );
  }
}
