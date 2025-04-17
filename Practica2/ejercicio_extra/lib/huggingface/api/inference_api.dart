/*
 * Package : huggingface_client
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 02/08/2023
 * Copyright :  S.Hamblett
 */
// ignore_for_file: type=lint

import 'dart:convert';
import 'dart:io';

import 'package:ejercicio_grupal2/huggingface/api/response_transformers.dart';

import 'package:huggingface_client/huggingface_client.dart' show ApiResponseNLPChatCompletion, ChatStreamResponse;

import 'package:ejercicio_grupal2/huggingface/api/http/http.dart';

import '../api_query_nlp_chat_completion.dart';
import '../inference_api_client.dart';

import 'package:huggingface_client/src/openapi/api.dart';

class InferenceApi {
  InferenceApi([InferenceApiClient? apiClient])
      : apiClient = apiClient ?? InferenceApiClient();

  final InferenceApiClient apiClient;

  ///
  /// _queryWithHttpInfo
  ///
  /// Simple inference query
  /// Note: This method returns the HTTP [Response].
  ///
  Future<Response> _queryWithHttpInfo(String queryString, String model) async {
    final path = '/$model';

    Object? postBody;
    // Check for an inference endpoint
    if (model.isEmpty) {
      final text = <String, String>{'text': queryString};
      final body = <String, dynamic>{'inputs': text};
      postBody = body;
    } else {
      postBody = json.encode(queryString);
    }

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  ///
  /// query
  ///
  /// Simple inference query.
  ///
  /// [queryString]
  /// The inference query string
  ///
  /// [model]
  /// The model to perform inference on
  ///
  ///
  ///
  Stream<ChatStreamResponse> chatStreamCompletion(
      {required ApiQueryChatCompletion query}) async* {
    query.stream = true;
    final response = await _withHttpInfo(query.toJson(), query.model);


    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (query.stream) {
      yield* ByteStream.fromBytes(response.bodyBytes)
          .transform(StreamResponseTransformer())
          .map((e) => ChatStreamResponse.fromJson(e));
    }
  }
  ///
  /// chat
  ///
  /// Simple chat completion query.
  ///
  /// [query]
  /// The chat completion query string
  ///
  ///
  Future<ApiResponseNLPChatCompletion?> chatCompletion(
      {required ApiQueryChatCompletion query}) async {
    final response = await _withHttpInfo(query.toJson(), query.model);

    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    //   if (query.stream) {
    //  return   ByteStream.fromBytes(response.bodyBytes)
    //         .transform(StreamResponseTransformer())
    //         .map((e) => ChatStreamResponse.fromJson(e["choices"][0]["delta"]));
    //   }
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return await apiClient.deserializeAsync(responseBody, 'ChatCompletions');
    }
    return null;
  }

  Future<String?> query(
      {required String queryString, required String model}) async {
    final response = await _queryWithHttpInfo(queryString, model);

    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'QueryStandard')
          as String);
    }
    return null;
  }


Future<Response> _withHttpInfo(
      Map<String, dynamic> taskParameters, String model) async {
    var path = '/$model';
    final chatPath = '/$model/v1/chat/completions';
    if (taskParameters.containsKey("messages")) {
      path = chatPath;
    }

    final headerParams = <String, String>{};
    final contentTypes = <String>[];
    final queryParams = <QueryParam>[];
    final formParams = <String, String>{};

    Object? postBody;
    if ((taskParameters.length == 1) &&
        (taskParameters.containsKey('mediaFile'))) {
      postBody = taskParameters[r'mediaFile'];
      contentTypes.add('application/octet-stream');
    } else {
      contentTypes.add('application/json');
      // Check for inference endpoint
      if (model.isEmpty) {
        if (!taskParameters.containsKey('inputs')) {
          final inputs = <String, dynamic>{'inputs': taskParameters};
          postBody = inputs;
        } else {
          postBody = taskParameters;
        }
      } else {
        postBody = taskParameters;
      }
    }

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }


  /// Returns the decoded body as UTF-8 if the given headers indicate an 'application/json'
  /// content type. Otherwise, returns the decoded body as decoded by dart:http package.
  Future<String> _decodeBodyBytes(Response response) async {
    final contentType = response.headers['content-type'];
    return contentType != null &&
            contentType.toLowerCase().startsWith('application/json')
        ? response.bodyBytes.isEmpty
            ? ''
            : utf8.decode(response.bodyBytes)
        : response.body;
  }
}
