import 'dart:math';

import 'package:flutter/material.dart';

// Flutter DataGrid package import
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() {
  runApp(MaterialApp(
      title: 'Syncfusion Flutter DataGrid',
      home: LoadMoreInfiniteScrollingDemo()));
}

class LoadMoreInfiniteScrollingDemo extends StatefulWidget {
  LoadMoreInfiniteScrollingDemo({Key key}) : super(key: key);

  @override
  _LoadMoreInfiniteScrollingDemoState createState() =>
      _LoadMoreInfiniteScrollingDemoState();
}

class _LoadMoreInfiniteScrollingDemoState
    extends State<LoadMoreInfiniteScrollingDemo> {
  List<Employee> _employees = <Employee>[];
  EmployeeDataSource _employeeDataSource;

  @override
  void initState() {
    _addMoreRows(_employees, 20);
    _employeeDataSource = EmployeeDataSource(employeeData: _employees);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Syncfusion Flutter DataGrid')),
      body: SfDataGrid(
        source: _employeeDataSource,
        loadMoreViewBuilder: (BuildContext context, LoadMoreRows loadMoreRows) {
          Future<String> loadRows() async {
            await loadMoreRows();
            return Future<String>.value('Completed');
          }

          return FutureBuilder<String>(
            initialData: 'loading',
            future: loadRows(),
            builder: (context, snapShot) {
              if (snapShot.data == 'loading') {
                return Container(
                    height: 60.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: BorderDirectional(
                            top: BorderSide(
                                width: 1.0,
                                color: Color.fromRGBO(0, 0, 0, 0.26)))),
                    alignment: Alignment.center,
                    child: CircularProgressIndicator());
              } else {
                return SizedBox.fromSize(size: Size.zero);
              }
            },
          );
        },
        columns: <GridColumn>[
          GridNumericColumn(mappingName: 'id', headerText: 'ID'),
          GridTextColumn(mappingName: 'name', headerText: 'Name'),
          GridTextColumn(
            mappingName: 'designation',
            headerText: 'Designation',
            columnWidthMode: ColumnWidthMode.cells,
          ),
          GridNumericColumn(mappingName: 'salary', headerText: 'Salary'),
        ],
      ),
    );
  }
}

final List<String> _names = <String>[
  'Welli',
  'Blonp',
  'Folko',
  'Furip',
  'Folig',
  'Picco',
  'Frans',
  'Warth',
  'Linod',
  'Simop',
  'Merep',
  'Riscu',
  'Seves',
  'Vaffe',
  'Alfki'
];

final List<String> _designation = <String>[
  'Project Lead',
  'Developer',
  'Manager',
  'Designer',
  'System Analyst',
  'CEO'
];

void _addMoreRows(List<Employee> employeeData, int count) {
  final Random _random = Random();
  int startIndex = employeeData.isNotEmpty ? employeeData.length : 0,
      endIndex = startIndex + count;
  for (int i = startIndex; i < endIndex; i++) {
    employeeData.add(Employee(
      1000 + i,
      _names[_random.nextInt(_names.length - 1)],
      _designation[_random.nextInt(_designation.length - 1)],
      10000 + _random.nextInt(10000),
    ));
  }
}

class Employee {
  Employee(this.id, this.name, this.designation, this.salary);

  final int id;

  final String name;

  final String designation;

  final int salary;
}

class EmployeeDataSource extends DataGridSource<Employee> {
  EmployeeDataSource({List<Employee> employeeData}) {
    _employeeData = employeeData;
  }
  List<Employee> _employeeData;

  @override
  List<Employee> get dataSource => _employeeData;

  @override
  Object getValue(Employee employee, String columnName) {
    switch (columnName) {
      case 'id':
        return employee.id;
        break;
      case 'name':
        return employee.name;
        break;
      case 'salary':
        return employee.salary;
        break;
      case 'designation':
        return employee.designation;
        break;
      default:
        return ' ';
        break;
    }
  }

  @override
  Future<void> handleLoadMoreRows() async {
    await Future.delayed(Duration(seconds: 5));
    _addMoreRows(_employeeData, 10);
    notifyListeners();
  }
}
