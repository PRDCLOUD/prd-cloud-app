import 'package:flutter/material.dart';
import 'filter.dart';
import 'production_data_list.dart';


class ProductionDataListPage extends StatelessWidget {
  const ProductionDataListPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Filter(),
        Expanded(child: ProductionDataList()) 
      ],
    );
  }
}