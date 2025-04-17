import 'huggingface/api/inference_api.dart';
import 'huggingface/api_query_nlp_chat_completion.dart';
import 'huggingface/huggingface_client.dart';


class Strategy {
  final String _token;
  final String _model;
  Strategy (this._token, this._model);

  void sendRequest(String prompt, var callback,
      List<String> pastPrompts, List<String> pastAnswers) async {

    final client = HuggingFaceClient.getInferenceClient(_token, HuggingFaceClient.inferenceBasePath);
    final apiInstance = InferenceApi(client);

    while (pastPrompts.length > pastAnswers.length) {
      pastPrompts.removeLast();
    }

    var reconstructed_chat = '';
    for (int i=0; i<pastPrompts.length; i++) {
      reconstructed_chat+=pastPrompts[i];
      reconstructed_chat+=pastAnswers[i];
    }
    reconstructed_chat+= prompt;

    final params = ApiQueryChatCompletion(
      model: _model,
      stream: true,
      maxLength: 200,
      message: [
        {"role": "user", "content": reconstructed_chat}
      ],
    );

    final streamresult = apiInstance.chatStreamCompletion(query: params);
    streamresult.listen((pri) => callback(pri.delta.content));
  }
}

class MistralStrategy extends Strategy {
  MistralStrategy(String token) : super(token,'mistralai/Mistral-Nemo-Instruct-2407');
}

class DialoGPTStrategy extends Strategy {
  DialoGPTStrategy(String token) : super(token,'microsoft/DialoGPT-small');
}

class Phi3Strategy extends Strategy {
  Phi3Strategy(String token) : super(token, 'microsoft/Phi-3.5-mini-instruct');
}