import 'package:flutter/material.dart';

import 'package:practica3/bankservice.dart';
import 'package:practica3/transaction.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final BankService _bankService = BankService();
  final TextEditingController _ownerController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String? _selectedAccount;
  String? _transferTargetAccount;

  void _createAccount() {
    if (_ownerController.text.isNotEmpty) {
      setState(() {
        _bankService.createAccount(_ownerController.text);
        _ownerController.clear();
      });
    }
  }

  void _deposit() {
    final amount = double.tryParse(_amountController.text);
    if (_selectedAccount != null && amount != null && amount > 0) {
      setState(() {
        _bankService.deposit(_selectedAccount!, amount);
        _amountController.clear();
      });
    }
  }

  void _withdraw() {
    final amount = double.tryParse(_amountController.text);
    if (_selectedAccount != null && amount != null && amount > 0) {
      try {
        setState(() {
          _bankService.withdraw(_selectedAccount!, amount);
          _amountController.clear();
        });
      } catch (e) {
        _showErrorDialog('Withdrawal failed: ${e.toString()}');
      }
    }
  }

  void _transfer() {
    final amount = double.tryParse(_amountController.text);
    if (_selectedAccount != null &&
        _transferTargetAccount != null &&
        _selectedAccount != _transferTargetAccount &&
        amount != null &&
        amount > 0) {
      try {
        setState(() {
          _bankService.transfer(_selectedAccount!, _transferTargetAccount!, amount);
          _amountController.clear();
          _transferTargetAccount = null; // ✅ Clear after transfer
        });
      } catch (e) {
        _showErrorDialog('Transfer failed: ${e.toString()}');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _bankService.transactionList.length,
      itemBuilder: (context, index) {
        final tx = _bankService.transactionList[index];
        String type = tx.runtimeType.toString();
        String info = "ID: ${tx.id}, Amount: €${tx.amount.toStringAsFixed(2)}";

        if (tx is TransferTransaction) {
          final recipient = _bankService.accountList.entries
              .firstWhere((e) => e.value == tx.toAccount, orElse: () => MapEntry("Unknown", tx.toAccount));
          info += " → ${recipient.key}";
        }

        return ListTile(
          title: Text(type),
          subtitle: Text(info),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final accounts = _bankService.accountList;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Create Account'),
            TextField(
              controller: _ownerController,
              decoration: const InputDecoration(labelText: 'Owner Name'),
            ),
            ElevatedButton(
              onPressed: _createAccount,
              child: const Text('Create'),
            ),
            const Divider(height: 30),

            const Text('Select Account'),
            DropdownButton<String>(
              hint: const Text('Select an account'),
              value: _selectedAccount,
              onChanged: (value) {
                setState(() {
                  _selectedAccount = value;

                  // ✅ Prevent crash: Clear target if it's the same as selected
                  if (_selectedAccount == _transferTargetAccount) {
                    _transferTargetAccount = null;
                  }
                });
              },
              items: accounts.keys.map((accountNumber) {
                return DropdownMenuItem<String>(
                  value: accountNumber,
                  child: Text('$accountNumber - ${accounts[accountNumber]!.owner}'),
                );
              }).toList(),
            ),
            if (_selectedAccount != null)
              Text(
                'Balance: €${_bankService.getBalance(_selectedAccount!).toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            const Divider(height: 30),

            const Text('Transaction Amount'),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _deposit, child: const Text('Deposit')),
                ElevatedButton(onPressed: _withdraw, child: const Text('Withdraw')),
              ],
            ),
            const Divider(height: 30),

            const Text('Transfer to Another Account'),
            DropdownButton<String>(
              hint: const Text('Select target account'),
              value: _transferTargetAccount,
              onChanged: (value) {
                setState(() {
                  _transferTargetAccount = value;
                });
              },
              items: accounts.keys
                  .where((key) => key != _selectedAccount)
                  .map((accountNumber) {
                return DropdownMenuItem<String>(
                  value: accountNumber,
                  child: Text('$accountNumber - ${accounts[accountNumber]!.owner}'),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: _transfer,
              child: const Text('Transfer'),
            ),
            const Divider(height: 30),

            const Text('Transaction History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildTransactionList(),
          ],
        ),
      ),
    );
  }
}