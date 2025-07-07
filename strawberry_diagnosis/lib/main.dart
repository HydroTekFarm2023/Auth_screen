import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase core
import 'package:firebase_auth/firebase_auth.dart'; // Firebase auth
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart'; // GraphQL API
import 'package:image_picker/image_picker.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:path/path.dart' as path;

import 'amplifyconfiguration.dart'; // Make sure this exists
import 'login_screen.dart'; // Import your login screen

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AppWrapper());
}

/// This widget decides whether to show the login screen or the main app
class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Strawberry Diagnosis',
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading while checking auth state
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            // User is logged in
            return const StrawberryDiagnosisApp();
          } else {
            // User is NOT logged in
            return const LoginScreen();
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
  String _status = 'App initialized';
  List<Diagnosis> _diagnoses = [];
  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.addPlugin(AmplifyAPI());
      await Amplify.addPlugin(AmplifyStorageS3());
      await Amplify.configure(amplifyconfig);
      setState(() {
        _amplifyConfigured = true;
        _status = 'Amplify configured';
      });
    } catch (e) {
      setState(() => _status = 'Failed to configure Amplify: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile == null) return;
    setState(() {
      _selectedImage = pickedFile;
      _status = 'Image selected. Ready to upload or delete.';
    });
  }

  Future<void> _uploadSelectedImage() async {
    if (_selectedImage == null) return;
    setState(() {
      _status = 'Uploading image...';
    });

    final fileKey =
        'public/image_${DateTime.now().millisecondsSinceEpoch}${path.extension(_selectedImage!.path)}';
    try {
      await Amplify.Storage.uploadFile(
        path: StoragePath.fromString(fileKey),
        localFile: AWSFile.fromPath(_selectedImage!.path),
      ).result;

      final fileUrl = await Amplify.Storage.getUrl(
        path: StoragePath.fromString(fileKey),
      ).result;

      setState(() {
        _status = 'Image uploaded: ${fileUrl.url}';
        _selectedImage = null;
      });
    } catch (e) {
      setState(() {
        _status = 'Failed to upload image: $e';
      });
    }
  }

  void _deleteSelectedImage() {
    setState(() {
      _selectedImage = null;
      _status = 'Image selection cleared.';
    });
  }

  Future<void> _fetchDiagnoses() async {
    setState(() {
      _status = 'Fetching diagnoses...';
    });

    const String graphQLDocument = '''query ListDiagnoses {
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
    }''';

    try {
      final request = GraphQLRequest<String>(
        document: graphQLDocument,
      );

      final response = await Amplify.API.query(request: request).response;

      final decoded = jsonDecode(response.data!);
      final items = decoded['listDiagnoses']['items'] as List;

      final diagnoses = items
          .where((item) => item != null)
          .map((item) => Diagnosis.fromJson(item as Map<String, dynamic>))
          .toList();

      setState(() {
        _diagnoses = diagnoses;
        _status = 'Fetched ${_diagnoses.length} diagnoses';
      });
    } catch (e) {
      setState(() {
        _status = 'Query failed: $e';
        _diagnoses = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Strawberry Diagnosis'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _amplifyConfigured
                  ? () => _pickImage(ImageSource.gallery)
                  : null,
              child: const Text('Pick Image from Gallery'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed:
                  _amplifyConfigured ? () => _pickImage(ImageSource.camera) : null,
              child: const Text('Take Image with Camera'),
            ),
            if (_selectedImage != null) ...[
              const SizedBox(height: 12),
              Image.file(
                File(_selectedImage!.path),
                height: 200,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _uploadSelectedImage,
                    child: const Text('Upload'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _deleteSelectedImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ],
            ElevatedButton(
              onPressed: _amplifyConfigured ? _fetchDiagnoses : null,
              child: const Text('Fetch Diagnoses from DynamoDB'),
            ),
            const SizedBox(height: 12),
            Text(_status),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _diagnoses.length,
                itemBuilder: (context, index) {
                  final diag = _diagnoses[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text('${diag.disease} (${diag.severity})'),
                      subtitle: Text(
                          'Image: ${diag.imageKey}\nResult: ${diag.result}\nTreatment: ${diag.treatment}\nTime: ${diag.createdAt}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Diagnosis {
  final String id;
  final String imageKey;
  final String result;
  final String disease;
  final String severity;
  final String treatment;
  final String? createdAt;

  Diagnosis({
    required this.id,
    required this.imageKey,
    required this.result,
    required this.disease,
    required this.severity,
    required this.treatment,
    this.createdAt,
  });

  factory Diagnosis.fromJson(Map<String, dynamic> json) {
    return Diagnosis(
      id: json['id'] as String,
      imageKey: json['image_key'] as String,
      result: json['result'] as String,
      disease: json['disease'] as String,
      severity: json['severity'] as String,
      treatment: json['treatment'] as String,
      createdAt: json['createdAt'] as String?,
    );
  }
}
