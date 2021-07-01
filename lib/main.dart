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
  LoadMoreInfiniteScrollingDemo({Key? key}) : super(key: key);

  @override
  _LoadMoreInfiniteScrollingDemoState createState() =>
      _LoadMoreInfiniteScrollingDemoState();
}

class _LoadMoreInfiniteScrollingDemoState
    extends State<LoadMoreInfiniteScrollingDemo> {
  List<Employee> _employees = <Employee>[];
  late EmployeeDataSource _employeeDataSource;

  @override
  void initState() {
    _populateEmployeeData(20);
    _employeeDataSource = EmployeeDataSource(employees: _employees);
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
          GridColumn(
              columnName: 'id',
              label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.center,
                  child: Text(
                    'ID',
                  ))),
          GridColumn(
              columnName: 'name',
              label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.center,
                  child: Text('Name'))),
          GridColumn(
              width: 120.0,
              columnName: 'designation',
              label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.center,
                  child: Text(
                    'Designation',
                    overflow: TextOverflow.ellipsis,
                  ))),
          GridColumn(
              columnName: 'salary',
              label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.center,
                  child: Text('Salary'))),
        ],
      ),
    );
  }

  void _populateEmployeeData(int count) {
    final Random _random = Random();
    int startIndex = _employees.isNotEmpty ? _employees.length : 0,
        endIndex = startIndex + count;
    for (int i = startIndex; i < endIndex; i++) {
      _employees.add(Employee(
        1000 + i,
        _names[_random.nextInt(_names.length - 1)],
        _designation[_random.nextInt(_designation.length - 1)],
        10000 + _random.nextInt(10000),
      ));
    }
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

class Employee {
  Employee(this.id, this.name, this.designation, this.salary);

  final int id;

  final String name;

  final String designation;

  final int salary;
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List<Employee> employees}) {
    _employeeData = employees
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<String>(
                  columnName: 'designation', value: e.designation),
              DataGridCell<int>(columnName: 'salary', value: e.salary),
            ]))
        .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  void _addMoreRows(int count) {
    final Random _random = Random();
    int startIndex = _employeeData.isNotEmpty ? _employeeData.length : 0,
        endIndex = startIndex + count;
    for (int i = startIndex; i < endIndex; i++) {
      _employeeData.add(DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: 1000 + i),
        DataGridCell<String>(
            columnName: 'name',
            value: _names[_random.nextInt(_names.length - 1)]),
        DataGridCell<String>(
            columnName: 'designation',
            value: _designation[_random.nextInt(_designation.length - 1)]),
        DataGridCell<int>(
            columnName: 'salary', value: 10000 + _random.nextInt(10000)),
      ]));
    }
  }

  @override
  Future<void> handleLoadMoreRows() async {
    await Future.delayed(Duration(seconds: 5));
    _addMoreRows(10);
    notifyListeners();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}
