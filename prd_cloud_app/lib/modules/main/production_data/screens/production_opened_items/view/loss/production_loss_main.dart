import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';

class ProductionLossMain extends StatelessWidget {
  const ProductionLossMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductionLossCubit, ProductionLossState>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),

          backgroundColor: Colors.green,
          onPressed: () {
          },
        ),
          body: ListView.builder(
            shrinkWrap: true,
            itemCount: state.losses.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(state.losses[index].name),
              );
            },
          ),
        );
      },
    );
  }

  
  

}
