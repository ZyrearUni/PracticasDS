import 'package:flutter/material.dart';
import 'package:huggingface_client/huggingface_client.dart';
import 'Strategies.dart';
import 'token.dart' as token_file;


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter HuggingFace API',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter HuggingFace'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _promptController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _promptResult = 'You: ';
  late Future<List<ApiResponseNLPTextGeneration?>?> futureResponse;
  bool _buttonDisabled = false;
  var last_token_received;
  List<String> fragmented_last_response = [];
  late String lastPrompt;

  List<String> past_prompts = [];
  List<String> past_answers = [];

  late String _model;

  void runPrompt() {
    Strategy strat = Strategy();
    if (!_tokenController.text.startsWith('hf_')) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Token is invalid: must start with hf_'),
      ));
    }

    _promptResult += _promptController.text + '\nAI: ';
    strat.sendRequest(_promptController.text,_tokenController.text, onValueReceived, past_prompts, past_answers, _model);
    lastPrompt = _promptController.text;

  }

  void onValueReceived(String response) {
    _promptResult += response.toString();
    fragmented_last_response.add(response.toString());

    last_token_received = DateTime.now().millisecondsSinceEpoch;
    _buttonDisabled = true; // disable button

    const int millis_to_wait = 500; // set timer:
    Future.delayed(const Duration(milliseconds: millis_to_wait),() {
      // if after millis_to_wait no new reponse token was received: enable button and add to past_answers
      if (DateTime.now().millisecondsSinceEpoch - last_token_received> millis_to_wait && _buttonDisabled==true) {
        // the second condition is necessary to avoid repeated execution of the part inside
        _buttonDisabled = false;
        past_answers.add( fragmented_last_response.join(''));
        past_prompts.add(lastPrompt);
        _promptResult += '\nYou:';

      }
    });

    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  void setup() {
    _tokenController.text = token_file.huggingFace_token;
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child:SizedBox(
          width: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Insert the API token here'),
            TextField(controller: _tokenController,),

            SizedBox(height: 150,
              child: Center(
                child: DropdownMenu(label:Text('AI Model'), width:300, textAlign: TextAlign.center,

                  onSelected: (value) {
                    if (value!= null) {
                      _model = value;
                    }
                  },
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: 'microsoft/Phi-3.5-mini-instruct', label: 'Microsoft Phi-4 Mini'),
                    //DropdownMenuEntry(value: 'Qwen/Qwen2.5-Coder-32B-Instruct', label: 'Qwen'),
                    DropdownMenuEntry(value: 'mistralai/Mistral-Nemo-Instruct-2407', label: 'Mistal nemo'),
                    DropdownMenuEntry(value: 'microsoft/DialoGPT-small', label: 'microsoft/DialoGPT-small'), // ON DRUGS ?
                  ],
                ),
              ),
            ),
            const Text('Insert your prompt here'),
            TextField(controller: _promptController,),
            SizedBox(height: 50,),
            SizedBox(
              height: 200,
            child:
            SingleChildScrollView(

                padding: EdgeInsets.all(8.0),
                controller: _scrollController,
              child: Text('$_promptResult',style: TextStyle(fontSize: 16)),
            ),
            ),
          ],
        ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _buttonDisabled ? {}: runPrompt(),
        tooltip: 'Execute',
        child: const Icon(Icons.arrow_right),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
