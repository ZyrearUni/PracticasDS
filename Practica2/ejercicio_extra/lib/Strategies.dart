import 'package:huggingface_client/huggingface_client.dart';

class Strategy {

  void sendRequest(String prompt,String token, var callback,
      List<String> pastPrompts, List<String> pastAnswers, String model) async {

    final client = HuggingFaceClient.getInferenceClient(token, HuggingFaceClient.inferenceBasePath);
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
      model: model,
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