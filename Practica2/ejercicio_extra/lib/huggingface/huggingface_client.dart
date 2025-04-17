/*
 * Package : huggingface_client
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 02/08/2023
 * Copyright :  S.Hamblett
 */
// ignore_for_file: type=lint

import 'package:ejercicio_grupal2/huggingface/inference_api_client.dart';
import 'package:huggingface_client/src/openapi/api.dart';

class Unsafe {
  final String name;
  const Unsafe(this.name);
}

///
/// Hugging Face client class.
/// Provides a thin wrapper around the Open API implementation.
///
class HuggingFaceClient {
  /// Get an Inference API client with API Key authentication.
  /// [basePath] the API base path i.e. [inferenceBasePath]
  static InferenceApiClient getInferenceClient(
          String apiKey, String basePath) =>
      InferenceApiClient(
          authentication: ApiKeyAuth('header', 'Authorization')
            ..apiKey = apiKey
            ..apiKeyPrefix = 'Bearer',
          basePath: basePath);

  static String inferenceBasePath =
      'https://api-inference.huggingface.co/models';
  static String endpointBasePath = 'https://api.endpoints.huggingface.cloud';
}
