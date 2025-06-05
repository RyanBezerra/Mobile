import 'dart:io'; // Para exit(0)
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color primaryColor = Colors.teal;

  void updateColor(Color newColor) {
    setState(() {
      primaryColor = newColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(
        primaryColor: primaryColor,
        updateColor: updateColor,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  final Color primaryColor;
  final Function(Color) updateColor;

  const HomePage({
    Key? key,
    required this.primaryColor,
    required this.updateColor,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int count = 0;
  bool allowNegative = false;
  int? maxLimit; // Limite máximo (opcional)
  final List<String> history = []; // Histórico simples

  void decrement() {
    setState(() {
      if (allowNegative) {
        count--;
        history.add('Saiu (-1)');
      } else {
        if (count > 0) {
          count--;
          history.add('Saiu (-1)');
        }
      }
    });
  }

  void increment() {
    setState(() {
      if (maxLimit == null || count < maxLimit!) {
        count++;
        history.add('Entrou (+1)');
      }
    });
  }

  void resetCounter() {
    setState(() {
      count = 0;
      history.add('Resetou contador');
    });
  }

  Color getCountColor() {
    if (maxLimit != null && count >= maxLimit!) {
      return Colors.red;
    }
    return Colors.black;
  }

  Future<bool> onWillPop() async {
    bool? exitApp = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sair'),
        content: Text('Tem certeza que deseja sair do app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Não'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Sim'),
          ),
        ],
      ),
    );
    return exitApp ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('Meu APP FODA'),
          centerTitle: true,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Ação de busca
              },
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'sobre') {
                  showAboutDialog(
                    context: context,
                    applicationName: 'Meu APP FODA',
                    applicationVersion: 'v1.0.0',
                    applicationIcon: Icon(Icons.info_outline,
                        size: 50, color: Theme.of(context).primaryColor),
                    children: [
                      Text('Este é um app de exemplo para contar pessoas.'),
                      SizedBox(height: 10),
                      Text('Desenvolvido por Ryan do Nascimento.'),
                    ],
                  );
                } else if (value == 'reset') {
                  resetCounter();
                } else if (value == 'historico') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HistoryPage(history: history),
                    ),
                  );
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'sobre',
                    child: Text('Sobre'),
                  ),
                  PopupMenuItem<String>(
                    value: 'reset',
                    child: Text('Resetar contador'),
                  ),
                  PopupMenuItem<String>(
                    value: 'historico',
                    child: Text('Histórico'),
                  ),
                ];
              },
            ),
          ],
          backgroundColor: widget.primaryColor,
        ),
        drawer: Drawer(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 56,
                color: widget.primaryColor,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Início'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Configurações'),
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(
                        currentColor: widget.primaryColor,
                        onColorChanged: widget.updateColor,
                        maxLimit: maxLimit,
                        onMaxLimitChanged: (newLimit) {
                          setState(() {
                            maxLimit = newLimit;
                            if (maxLimit != null && count > maxLimit!) {
                              count = maxLimit!;
                            }
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Sair'),
                onTap: () async {
                  bool? confirmExit = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Sair'),
                      content: Text('Tem certeza que deseja sair do app?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('Não'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('Sim'),
                        ),
                      ],
                    ),
                  );
                  if (confirmExit == true) exit(0);
                },
              ),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Pode entrar',
              style: TextStyle(
                fontSize: 26,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$count',
              style: TextStyle(fontSize: 100, color: getCountColor()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: decrement,
                  style: TextButton.styleFrom(
                    backgroundColor: widget.primaryColor,
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Saiu', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 32),
                TextButton(
                  onPressed: increment,
                  style: TextButton.styleFrom(
                    backgroundColor: widget.primaryColor,
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Entrou', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            SizedBox(height: 30),
            // Checkbox para permitir números negativos
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: allowNegative,
                  onChanged: (bool? value) {
                    setState(() {
                      allowNegative = value ?? false;
                      if (!allowNegative && count < 0) {
                        count = 0;
                      }
                    });
                  },
                ),
                Text(
                  'Permitir números negativos',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),

            // Campo para limite máximo mais compacto
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                width: 200, // largura fixa menor
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Limite máximo',
                    hintText: 'Deixe vazio para sem limite',
                    border: OutlineInputBorder(),
                    isDense: true, // deixa o campo mais compacto verticalmente
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        maxLimit = null;
                      } else {
                        maxLimit = int.tryParse(value);
                        if (maxLimit != null && count > maxLimit!) {
                          count = maxLimit!;
                        }
                      }
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  final List<String> history;

  const HistoryPage({Key? key, required this.history}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico'),
      ),
      body: history.isEmpty
          ? Center(child: Text('Nenhuma ação registrada ainda.'))
          : ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[history.length - 1 - index]; // mostra do mais recente
          return ListTile(
            title: Text(item),
          );
        },
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  final Color currentColor;
  final Function(Color) onColorChanged;
  final int? maxLimit;
  final Function(int?) onMaxLimitChanged;

  const SettingsPage({
    Key? key,
    required this.currentColor,
    required this.onColorChanged,
    this.maxLimit,
    required this.onMaxLimitChanged,
  }) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late double red;
  late double green;
  late double blue;
  late TextEditingController maxLimitController;

  @override
  void initState() {
    super.initState();
    red = widget.currentColor.red.toDouble();
    green = widget.currentColor.green.toDouble();
    blue = widget.currentColor.blue.toDouble();
    maxLimitController = TextEditingController(
      text: widget.maxLimit?.toString() ?? '',
    );
  }

  void updateColor() {
    widget.onColorChanged(
      Color.fromARGB(255, red.toInt(), green.toInt(), blue.toInt()),
    );
  }

  @override
  void dispose() {
    maxLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações de Cor'),
        backgroundColor: widget.currentColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Escolha a cor RGB do app', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),

            // Slider Red
            Row(
              children: [
                Text('R', style: TextStyle(fontSize: 18)),
                Expanded(
                  child: Slider(
                    activeColor: Colors.red,
                    min: 0,
                    max: 255,
                    value: red,
                    onChanged: (value) {
                      setState(() {
                        red = value;
                        updateColor();
                      });
                    },
                  ),
                ),
                Text(red.toInt().toString()),
              ],
            ),

            // Slider Green
            Row(
              children: [
                Text('G', style: TextStyle(fontSize: 18)),
                Expanded(
                  child: Slider(
                    activeColor: Colors.green,
                    min: 0,
                    max: 255,
                    value: green,
                    onChanged: (value) {
                      setState(() {
                        green = value;
                        updateColor();
                      });
                    },
                  ),
                ),
                Text(green.toInt().toString()),
              ],
            ),

            // Slider Blue
            Row(
              children: [
                Text('B', style: TextStyle(fontSize: 18)),
                Expanded(
                  child: Slider(
                    activeColor: Colors.blue,
                    min: 0,
                    max: 255,
                    value: blue,
                    onChanged: (value) {
                      setState(() {
                        blue = value;
                        updateColor();
                      });
                    },
                  ),
                ),
                Text(blue.toInt().toString()),
              ],
            ),

            SizedBox(height: 30),

            // Campo limite máximo compacto no SettingsPage
            SizedBox(
              width: 200,
              child: TextField(
                controller: maxLimitController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Limite máximo',
                  hintText: 'Deixe vazio para sem limite',
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                ),
                onChanged: (value) {
                  int? newLimit = int.tryParse(value);
                  widget.onMaxLimitChanged(newLimit);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
