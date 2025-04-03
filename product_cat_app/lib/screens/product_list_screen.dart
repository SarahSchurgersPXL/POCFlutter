import 'package:flutter/material.dart';
import 'package:product_cat_app/models/product.dart';
import 'package:product_cat_app/screens/product_detail_screen.dart';
import 'package:product_cat_app/services/api_service.dart';

class ProductListScreen extends StatefulWidget{
  const ProductListScreen({super.key});

  @override
  State<StatefulWidget> createState() => ProductListState();
}

class ProductListState extends State<ProductListScreen> {
  List<Product> _products = [];
  List<Product> _filtered = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    final products = await ApiService.fetchProducts();
    setState(() {
      _products = products;
      _filtered = products;
      _isLoading = false;
    });
  }

  void _filterProducts(String query) {
    final filtered = _products
        .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() => _filtered = filtered);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Producten')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Zoek product'),
                    onChanged: _filterProducts,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final product = _filtered[index];
                      return ListTile(
                        leading: Image.network(product.image, height: 50),
                        title: Text(product.title),
                        subtitle: Text('\u20ac${product.price.toStringAsFixed(2)}'),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailScreen(product: product),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}