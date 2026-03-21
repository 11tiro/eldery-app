import 'package:flutter/material.dart';

class ProductListScreen extends StatelessWidget {
  final String category;
  final List<Map<String, dynamic>> products;
  final Function(Map<String, dynamic>) onAddItem;

  ProductListScreen({
    required this.category,
    required this.products,
    required this.onAddItem,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$category の商品'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3列表示
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          mainAxisExtent: 150, // カードの高さを調整
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          var item = products[index];
          String imagePath = 'assets/images/${item['image'] ?? 'default.png'}'; // 画像がない場合はデフォルト画像を適用

          return GestureDetector(
            onTap: () {
              onAddItem(item); // 商品を買い物リストに追加
              Navigator.pop(context);
            },
            child: Card(
              elevation: 3.0,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 商品画像を適用
                  Image.asset(
                    imagePath,
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 8),
                  // 商品名
                  Text(
                    item['name'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
