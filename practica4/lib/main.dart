import 'package:flutter/material.dart';
import 'package:practica4/product.dart';
import 'package:practica4/client.dart';
import 'package:practica4/marketplace_context.dart';

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
  late MarketplaceContext marketplace;
  late List<Client> clients;
  late Client currentClient;

  int? selectedToBuy;
  int? selectedToSell;

  @override
  void initState() {
    super.initState();
    marketplace = MarketplaceContext();

    clients = [
      Client('Alice', 100),
      Client('Bob', 50),
      Client('Carol', 75),
    ];

    // Por defecto, usamos al primero
    currentClient = clients.first;

    // Productos de ejemplo
    var item1 = Item('Book', clients[1], 30); // Bob vende
    var item2 = Item('Lamp', clients[2], 45); // Carol vende

    clients[1].sellableProducts.add(item1);
    clients[2].sellableProducts.add(item2);
    marketplace.availableProducts.addAll([item1, item2]);
  }

  void _buy() {
    if (selectedToBuy == null) {
      _showError("Select a product to buy");
      return;
    }

    try {
      var product = marketplace.availableProducts[selectedToBuy!];
      marketplace.buyProduct(selectedToBuy!, product.owner, currentClient);
      selectedToBuy = null;
      setState(() {});
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _sell() {
    if (selectedToSell == null || currentClient.sellableProducts.isEmpty) {
      _showError("Select one of your products to sell");
      return;
    }

    var product = currentClient.sellableProducts[selectedToSell!];
    marketplace.sellProduct(product, currentClient);
    selectedToSell = null;
    setState(() {});
  }

  void _retire() {
    if (selectedToBuy == null) {
      _showError("Select your product from marketplace to retire");
      return;
    }

    var product = marketplace.availableProducts[selectedToBuy!];
    if (product.owner != currentClient) {
      _showError("You can only retire your own products");
      return;
    }

    marketplace.retireProduct(selectedToBuy!, currentClient);
    selectedToBuy = null;
    setState(() {});
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title} - Logged in as ${currentClient.name}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Selector de identidad
            Row(
              children: [
                const Text('Logged in as: '),
                const SizedBox(width: 8),
                DropdownButton<Client>(
                  value: currentClient,
                  onChanged: (Client? newClient) {
                    setState(() {
                      currentClient = newClient!;
                      selectedToBuy = null;
                      selectedToSell = null;
                    });
                  },
                  items: clients.map((Client client) {
                    return DropdownMenuItem<Client>(
                      value: client,
                      child: Text('${client.name} (\$${client.balance})'),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Row(
                children: [
                  // Productos disponibles
                  Expanded(
                    child: Column(
                      children: [
                        const Text('Marketplace', style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                          child: ListView.builder(
                            itemCount: marketplace.availableProducts.length,
                            itemBuilder: (context, index) {
                              var product = marketplace.availableProducts[index];
                              return ListTile(
                                title: Text('${product.name} - \$${product.getPrice()}'),
                                subtitle: Text('Seller: ${product.owner.name}'),
                                selected: selectedToBuy == index,
                                onTap: () {
                                  setState(() {
                                    selectedToBuy = index;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const VerticalDivider(),

                  // Productos del usuario actual
                  Expanded(
                    child: Column(
                      children: [
                        Text('${currentClient.name}\'s Products',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                          child: ListView.builder(
                            itemCount: currentClient.sellableProducts.length,
                            itemBuilder: (context, index) {
                              var product = currentClient.sellableProducts[index];
                              return ListTile(
                                title: Text('${product.name} - \$${product.getPrice()}'),
                                selected: selectedToSell == index,
                                onTap: () {
                                  setState(() {
                                    selectedToSell = index;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _buy, child: const Text('Buy')),
                ElevatedButton(onPressed: _sell, child: const Text('Sell')),
                ElevatedButton(onPressed: _retire, child: const Text('Retire')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}