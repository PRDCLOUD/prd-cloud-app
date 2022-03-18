import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/theme.dart';

typedef ProductSetter = void Function(int? newValue);
class ProductSelectionPage extends StatefulWidget {
  ProductSelectionPage({
    Key? key,
    required List<Product> products, 
    required this.selectedProductId,
    required this.onChange
  }) : 
  _products = products..sort(((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()))), 
  super(key: key);

  final int? selectedProductId;
  final List<Product> _products;
  final ProductSetter onChange;

  @override
  State<ProductSelectionPage> createState() => _ProductSelectionPageState();
}

class _ProductSelectionPageState extends State<ProductSelectionPage> {

  List<Product> filteredProducts = List.empty();

  void _runFilter(String? searchValue) {

    var lcSearchValue = searchValue?.toLowerCase() ?? "";

    List<Product> results;
    if (lcSearchValue.isEmpty) {
      results = widget._products;
    } else {
      results = widget._products
          .where((user) {
            if (user.code != null && user.code!.toLowerCase().contains(lcSearchValue)) {
              return true;
            }
            if (user.name.toLowerCase().contains(lcSearchValue)) {
              return true;
            }
            return false;
          })
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

      // Refresh the UI
    setState(() {
      filteredProducts = results;
    });

  }

    @override
  void initState() {
    filteredProducts = widget._products;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Produtos"),
        
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 500,
            child: TextField(
              onChanged: (value) => _runFilter(value),
              decoration: const InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(40.0))),
                labelText: 'Pesquisa', suffixIcon: Icon(Icons.search)
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredProducts.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Card(
                      shape: AppTheme.cardShape,
                      color: widget.selectedProductId == filteredProducts[index].id ? Theme.of(context).colorScheme.primary : null,
                      child: Container(
                        padding: const EdgeInsets.all(13),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                filteredProducts[index].name,
                                style: widget.selectedProductId == filteredProducts[index].id ? Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white) : null,
                              )
                            ),
                            Text(
                              filteredProducts[index].code ?? "",
                              style: widget.selectedProductId == filteredProducts[index].id ? Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white) : null
                            )
                          ],
                        )
                      )
                    ),
                    onTap: () { 
                      widget.onChange(filteredProducts[index].id);
                      Navigator.pop(context);
                    }
                  );
                },
              ),
          ),
        ],
      ),
    );
  }
}