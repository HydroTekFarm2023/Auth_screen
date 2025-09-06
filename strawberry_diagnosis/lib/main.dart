import 'firebase_env_config.dart'; // ✅ using env config instead of firebase_options.dart
import 'login_screen.dart';
import 'home_screen.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart'; // GraphQL API
import 'package:image_picker/image_picker.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:path/path.dart' as path;

import 'amplifyconfiguration.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase from env config
  final firebaseOptions = await getFirebaseOptionsFromEnv();
  await Firebase.initializeApp(options: firebaseOptions);

  runApp(const StrawberryDiagnosisApp());
}

class StrawberryDiagnosisApp extends StatefulWidget {
  const StrawberryDiagnosisApp({super.key});

  @override
  State<StrawberryDiagnosisApp> createState() => _StrawberryDiagnosisAppState();
}

class _StrawberryDiagnosisAppState extends State<StrawberryDiagnosisApp> {
  bool _amplifyConfigured = false;
  String _status = 'Initializing...';
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
      await _fetchDiagnoses();
    } catch (e) {
      setState(() => _status = 'Failed to configure Amplify: $e');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    setState(() {
      _selectedImage = pickedFile;
      _status = 'Image selected';
    });
  }

  Future<void> _uploadSelectedImage() async {
    if (_selectedImage == null) return;
    setState(() => _status = 'Uploading image...');

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

      await _fetchDiagnoses();
    } catch (e) {
      setState(() => _status = 'Failed to upload image: $e');
    }
  }

  void _deleteSelectedImage() {
    setState(() {
      _selectedImage = null;
      _status = 'Selection cleared';
    });
  }

  Future<void> _fetchDiagnoses() async {
    setState(() => _status = 'Fetching diagnoses...');

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
      final request = GraphQLRequest<String>(document: graphQLDocument);
      final response = await Amplify.API.query(request: request).response;

      if (response.data == null) {
        setState(() {
          _diagnoses = [];
          _status = 'No data';
        });
        return;
      }

      final decoded = jsonDecode(response.data!);
      final items = (decoded['listDiagnoses']['items'] as List)
          .where((item) => item != null)
          .map((item) => Diagnosis.fromJson(item as Map<String, dynamic>))
          .toList();

      setState(() {
        _diagnoses = items;
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
    return MaterialApp(
      title: 'Strawberry Diagnosis',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomeScreen(
        status: _status,
        diagnoses: _diagnoses,
        selectedImage: _selectedImage,
        amplifyConfigured: _amplifyConfigured,
        onPickImage: _pickImage,
        onUploadImage: _uploadSelectedImage,
        onDeleteImage: _deleteSelectedImage,
        onFetchDiagnoses: _fetchDiagnoses,
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
