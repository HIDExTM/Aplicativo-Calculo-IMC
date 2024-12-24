import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de IMC',
      theme: ThemeData(
        primaryColor: Colors.red, // Color primario rojo
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Colors.white, // Fondo blanco para los campos de texto
          contentPadding: EdgeInsets.all(16.0),
        ),
      ),
      home: CalculadoraIMC(),
    );
  }
}

class CalculadoraIMC extends StatefulWidget {
  @override
  _CalculadoraIMCState createState() => _CalculadoraIMCState();
}

class _CalculadoraIMCState extends State<CalculadoraIMC> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  double _imc = 0;
  String _result = "";

  void _calcular() {
    if (_formKey.currentState!.validate()) {
      final double weight = double.parse(_weightController.text);
      final double height = double.parse(_heightController.text) / 100;

      setState(() {
        _imc = weight / (height * height);
        if (_imc < 18.5) {
          _result = 'Bajo peso';
        } else if (_imc >= 18.5 && _imc < 24.9) {
          _result = 'Peso normal';
        } else if (_imc >= 25 && _imc < 29.9) {
          _result = 'Sobrepeso';
        } else {
          _result = 'Obesidad';
        }
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultadoIMC(bmi: _imc, result: _result),
        ),
      );
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calculadora de IMC',
          style: TextStyle(color: Colors.white), // Texto blanco
        ),
        backgroundColor: Colors.red, // Color de fondo rojo
      ),
      body: Container(
        color: Colors.black, // Cambia el color de fondo a negro
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'CALCULA TU ESTADO CORPORAL',
                style: TextStyle(fontSize: 24, color: Colors.white), // Texto blanco
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(
                  labelText: 'Peso (kg)',
                  prefixIcon: Icon(Icons.monitor_weight, color: Colors.red), // Icono rojo
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce un peso';
                  }
                  final n = num.tryParse(value);
                  if (n == null || n <= 0) {
                    return 'Por favor, introduce un peso válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(
                  labelText: 'Talla (cm)',
                  prefixIcon: Icon(Icons.height, color: Colors.red), // Icono rojo
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce una talla';
                  }
                  final n = num.tryParse(value);
                  if (n == null || n <= 0) {
                    return 'Por favor, introduce una talla valida';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _calcular,
                child: AnimatedDefaultTextStyle(
                  child: Text('Calcular Masa Corporal'),
                  style: TextStyle(fontSize: 18, color: Colors.black), // Texto negro
                  duration: Duration(milliseconds: 500),
                  curve: Curves.linear, // Cambio a una curva lineal
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultadoIMC extends StatelessWidget {
  final double bmi;
  final String result;

  ResultadoIMC({required this.bmi, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultado del IMC'),
        backgroundColor: Colors.red, // Color de fondo rojo
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.black, // Cambia el color de fondo a negro
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Tu IMC es:',
                  style: TextStyle(fontSize: 24, color: Colors.white), // Texto blanco
                ),
                AnimatedDefaultTextStyle(
                  child: Text(
                    bmi.toStringAsFixed(2),
                  ),
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white), // Texto blanco
                  duration: Duration(milliseconds: 500),
                  curve: Curves.linear,
                ),
                SizedBox(height: 20),
                Text(
                  'Tienes $result',
                  style: TextStyle(fontSize: 24, color: Colors.white), // Texto blanco
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: AnimatedDefaultTextStyle(
                    child: Text('Calcular de nuevo'),
                    style: TextStyle(fontSize: 18, color: Colors.black), // Texto negro
                    duration: Duration(milliseconds: 500),
                    curve: Curves.linear, // Cambio a una curva lineal
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
