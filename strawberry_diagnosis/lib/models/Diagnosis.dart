/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;


/** This is an auto generated class representing the Diagnosis type in your schema. */
class Diagnosis extends amplify_core.Model {
  static const classType = const _DiagnosisModelType();
  final String id;
  final String? _image_key;
  final String? _result;
  final String? _disease;
  final String? _severity;
  final String? _treatment;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  DiagnosisModelIdentifier get modelIdentifier {
      return DiagnosisModelIdentifier(
        id: id
      );
  }
  
  String get image_key {
    try {
      return _image_key!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get result {
    try {
      return _result!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get disease {
    try {
      return _disease!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get severity {
    try {
      return _severity!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get treatment {
    try {
      return _treatment!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Diagnosis._internal({required this.id, required image_key, required result, required disease, required severity, required treatment, createdAt, updatedAt}): _image_key = image_key, _result = result, _disease = disease, _severity = severity, _treatment = treatment, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Diagnosis({String? id, required String image_key, required String result, required String disease, required String severity, required String treatment, amplify_core.TemporalDateTime? createdAt}) {
    return Diagnosis._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      image_key: image_key,
      result: result,
      disease: disease,
      severity: severity,
      treatment: treatment,
      createdAt: createdAt);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Diagnosis &&
      id == other.id &&
      _image_key == other._image_key &&
      _result == other._result &&
      _disease == other._disease &&
      _severity == other._severity &&
      _treatment == other._treatment &&
      _createdAt == other._createdAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Diagnosis {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("image_key=" + "$_image_key" + ", ");
    buffer.write("result=" + "$_result" + ", ");
    buffer.write("disease=" + "$_disease" + ", ");
    buffer.write("severity=" + "$_severity" + ", ");
    buffer.write("treatment=" + "$_treatment" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Diagnosis copyWith({String? image_key, String? result, String? disease, String? severity, String? treatment, amplify_core.TemporalDateTime? createdAt}) {
    return Diagnosis._internal(
      id: id,
      image_key: image_key ?? this.image_key,
      result: result ?? this.result,
      disease: disease ?? this.disease,
      severity: severity ?? this.severity,
      treatment: treatment ?? this.treatment,
      createdAt: createdAt ?? this.createdAt);
  }
  
  Diagnosis copyWithModelFieldValues({
    ModelFieldValue<String>? image_key,
    ModelFieldValue<String>? result,
    ModelFieldValue<String>? disease,
    ModelFieldValue<String>? severity,
    ModelFieldValue<String>? treatment,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt
  }) {
    return Diagnosis._internal(
      id: id,
      image_key: image_key == null ? this.image_key : image_key.value,
      result: result == null ? this.result : result.value,
      disease: disease == null ? this.disease : disease.value,
      severity: severity == null ? this.severity : severity.value,
      treatment: treatment == null ? this.treatment : treatment.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value
    );
  }
  
  Diagnosis.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _image_key = json['image_key'],
      _result = json['result'],
      _disease = json['disease'],
      _severity = json['severity'],
      _treatment = json['treatment'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'image_key': _image_key, 'result': _result, 'disease': _disease, 'severity': _severity, 'treatment': _treatment, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'image_key': _image_key,
    'result': _result,
    'disease': _disease,
    'severity': _severity,
    'treatment': _treatment,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<DiagnosisModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<DiagnosisModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final IMAGE_KEY = amplify_core.QueryField(fieldName: "image_key");
  static final RESULT = amplify_core.QueryField(fieldName: "result");
  static final DISEASE = amplify_core.QueryField(fieldName: "disease");
  static final SEVERITY = amplify_core.QueryField(fieldName: "severity");
  static final TREATMENT = amplify_core.QueryField(fieldName: "treatment");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Diagnosis";
    modelSchemaDefinition.pluralName = "Diagnoses";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PUBLIC,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Diagnosis.IMAGE_KEY,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Diagnosis.RESULT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Diagnosis.DISEASE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Diagnosis.SEVERITY,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Diagnosis.TREATMENT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Diagnosis.CREATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _DiagnosisModelType extends amplify_core.ModelType<Diagnosis> {
  const _DiagnosisModelType();
  
  @override
  Diagnosis fromJson(Map<String, dynamic> jsonData) {
    return Diagnosis.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Diagnosis';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Diagnosis] in your schema.
 */
class DiagnosisModelIdentifier implements amplify_core.ModelIdentifier<Diagnosis> {
  final String id;

  /** Create an instance of DiagnosisModelIdentifier using [id] the primary key. */
  const DiagnosisModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'DiagnosisModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is DiagnosisModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}