import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Direct MySQL Connection')),
        body: MySQLExample(),
      ),
    );
  }
}

class MySQLExample extends StatefulWidget {
  @override
  _MySQLExampleState createState() => _MySQLExampleState();
}

class _MySQLExampleState extends State<MySQLExample> {
  String _result = '';
  String? _selectedOption = 'Consulta 1'; // Default selected value
  List<String> _dropdownOptions = ['Consulta 1', 'Consulta 2', 'Consulta 3']; // Dropdown options

  @override
  void initState() {
    super.initState();
    _connectToMySQL(); // Run default query when the app starts
  }

  Future<void> _connectToMySQL() async {
    // Define your connection settings
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'localhost', // e.g., 'localhost' or your server IP
      port: 3306, // Default MySQL port
      user: 'fmora',
      password: 'password',
      db: 'AppQuery',
    ));

    // Select query based on the dropdown selection
    String query = _getQueryBasedOnSelection();

    // Perform the query
    var results = await conn.query(query);

    // Process results
    StringBuffer sb = StringBuffer();
    for (var row in results) {
      sb.writeln('Row: ${row[0]}, ${row[1]}'); // Adjust based on your table structure
    }

    // Close the connection
    await conn.close();

    // Update the UI
    setState(() {
      _result = sb.toString();
    });
  }

  String _getQueryBasedOnSelection() {
    // Return different queries based on the selected option
    switch (_selectedOption) {
      case 'Consulta 1':
        return 'SELECT * FROM productos WHERE Id = 1'; // Example for Consulta 1
      case 'Consulta 2':
        return 'SELECT * FROM productos WHERE Id = 2'; // Example for Consulta 2
      case 'Consulta 3':
        return 'SELECT * FROM productos WHERE Id = 3'; // Example for Consulta 3
      default:
        return 'SELECT * FROM productos'; // Default query
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown Menu
          DropdownButton<String>(
            value: _selectedOption,
            onChanged: (String? newValue) {
              setState(() {
                _selectedOption = newValue;
              });
              _connectToMySQL(); // Run the query again when the dropdown selection changes
            },
            items: _dropdownOptions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          // Display MySQL query results
          Expanded(
            child: SingleChildScrollView(
              child: Text(_result),
            ),
          ),
        ],
      ),
    );
  }
}
