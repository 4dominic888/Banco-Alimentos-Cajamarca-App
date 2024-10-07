import 'dart:async';

import 'package:bancalcaj_app/domain/classes/paginate_data.dart';
import 'package:bancalcaj_app/domain/classes/result.dart';
import 'package:bancalcaj_app/domain/models/employee.dart';
import 'package:bancalcaj_app/domain/services/employee_service_base.dart';
import 'package:bancalcaj_app/presentation/empleados/ver_empleados/widgets/employee_card_element.dart';
import 'package:bancalcaj_app/presentation/widgets/big_static_size_box.dart';
import 'package:bancalcaj_app/presentation/widgets/pagination_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class VerEmpleadosScreen extends StatefulWidget {
  const VerEmpleadosScreen({super.key});

  @override
  State<VerEmpleadosScreen> createState() => _VerEmpleadosScreenState();
}

class _VerEmpleadosScreenState extends State<VerEmpleadosScreen> {

  final _employeeService = GetIt.I<EmployeeServiceBase>();
  final _nameController = TextEditingController();
  final _paginateMetadaDataController = StreamController<PaginateMetaData>();

  int _page = 1;
  int _limit = 10; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        title: const Text("Panel de administracion de empleados"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: IntrinsicWidth(
                  child: Row(
                    children: [
                      Expanded(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(icon: Icon(Icons.search), hintText: 'Buscar por nombre'),
                            onChanged: (value) => setState(() { }),
                          )
                        )
                      ),
                    ],
                  ),
                ),
              ),
          
              FutureBuilder<Result<PaginateData<EmployeeView>>>(
                future: _employeeService.verEmpleados(pagina: _page, limite: _limit, nombre: _nameController.text),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return BigStaticSizeBox(context, child: const Center(child: CircularProgressIndicator()));
                  }
                  if(snapshot.hasError || snapshot.data == null){
                    return BigStaticSizeBox(context, child: Center(child: Text('Ha ocurrido un error al mostrar la informacion, ${snapshot.error}')));
                  }
                  if(!snapshot.data!.success){
                    return BigStaticSizeBox(context, child: Center(child: Text(snapshot.data!.message!)));
                  }
                  if(snapshot.data!.data == null || snapshot.data!.data!.data.isEmpty){
                    return BigStaticSizeBox(context, child: const Center(child: Text('Sin proveedores a mostrar')));
                  }
                  final currentList = snapshot.data!.data!.data; //* data data data
                  _paginateMetadaDataController.add(snapshot.data!.data!.metadata); 
          
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        BigStaticSizeBox(context, child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: currentList.length,
                          itemBuilder: (context, index) {
                            final employeeView = currentList[index];
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: IntrinsicWidth(
                                child: EmployeeCardElement(
                                  employeeView: employeeView,
                                  onDataUpdate: () => setState(() { }),
                                ),
                              ),
                            );
                          },
                        ))
                      ],
                    ),
                  );
                },
              ),
          
              StreamBuilder<PaginateMetaData>(
                stream: _paginateMetadaDataController.stream,
                builder: (context, snapshot) {
                  return PaginationWidget(
                    currentPages: snapshot.data?.currentPage ?? 1,
                    onNextPagePressed: _page != (snapshot.data?.totalPages ?? 1) ? () => setState(() => _page++) : null,
                    totalPages: snapshot.data?.totalPages ?? 1,
                    onPreviousPagePressed: _page != 1 ? () => setState(() => _page--) : null
                  );
                }
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}