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

  String _promptResult = 'You: ';
  late Future<List<ApiResponseNLPTextGeneration?>?> futureResponse;
  bool _buttonDisabled = false;
  var last_token_received;
  List<String> fragmented_last_response = [];
  late String lastPrompt;

  List<String> past_prompts = [];
  List<String> past_answers = [];

  String _model = 'unset';

  void runPrompt() {
    if (_model=='unset') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a model'),
      ));
      return;
    }
    if (!_tokenController.text.startsWith('hf_')) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Token is invalid: must start with hf_'),
      ));
      return;
    }
    Strategy strat = Strategy();

    _promptResult += _promptController.text + '\nAI: ';
    strat.sendRequest(_promptController.text,_tokenController.text, onValueReceived, past_prompts, past_answers, _model);
    lastPrompt = _promptController.text;

  }

  void onValueReceived(String response) {
    _promptResult += response.toString();
    fragmented_last_response.add(response.toString());

    last_token_received = DateTime.now().millisecondsSinceEpoch;
    _buttonDisabled = true; // disable button

    setState(() {

    });

    const int millis_to_wait = 500; // set timer:
    Future.delayed(const Duration(milliseconds: millis_to_wait),() {
      // if after millis_to_wait no new reponse token was received: enable button and add to past_answers
      if (DateTime.now().millisecondsSinceEpoch - last_token_received> millis_to_wait && _buttonDisabled==true) {
        // the second condition is necessary to avoid repeated execution of the part inside
        _buttonDisabled = false;
        past_answers.add( fragmented_last_response.join(''));
        past_prompts.add(lastPrompt);
        _promptResult += '\nYou: ';

      }
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Input section
            Center(
              child: SizedBox(
                width: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'API Token',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _tokenController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your HuggingFace token',
                      ),
                    ),
                    const SizedBox(height: 24),
                    DropdownMenu(
                      label: const Text('Select AI Model'),
                      width: 400,
                      textAlign: TextAlign.center,
                      onSelected: (value) {
                        if (value != null) {
                          _model = value;
                        }
                      },
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(
                            value: 'microsoft/Phi-3.5-mini-instruct',
                            label: 'Microsoft Phi-4 Mini'),
                        DropdownMenuEntry(
                            value: 'mistralai/Mistral-Nemo-Instruct-2407',
                            label: 'Mistral Nemo'),
                        DropdownMenuEntry(
                            value: 'microsoft/DialoGPT-small',
                            label: 'DialoGPT-small'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Your Prompt',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _promptController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Type your prompt here...',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Response Section
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: 800,
                    child: Text(
                      _promptResult,
                      style: const TextStyle(fontSize: 16),
                    ),
                 ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _buttonDisabled ? null : runPrompt(),
        label: const Text('Run Prompt'),
        icon: const Icon(Icons.send),
      ),
    );
  }
}
