import 'dart:convert';

import 'package:crudapp/appscreens/addproduct.dart';
import 'package:crudapp/appscreens/common/apptextstyle.dart';
import 'package:crudapp/appscreens/updateproduct.dart';
import 'package:crudapp/appscreens/widgets/alertdialog.dart';
import 'package:crudapp/appscreens/widgets/applicationbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../models/productmodel.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key,});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  bool _isProductListInProgress = true;
  List<ProductModel> products = [];

  @override
  void initState(){
    super.initState();
    _getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ApplicationBar(title: 'Product List',),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: RefreshIndicator(
          onRefresh: _getProducts,
          child: Visibility(
            visible: _isProductListInProgress == false,
            replacement: const Center(
              child: CircularProgressIndicator(
                color: Colors.deepOrange,
              ),
            ),
            child: ListView.separated(
              itemCount: products.length,
              itemBuilder: (context, index){
                return _buildListTile(context, index);
              },
              separatorBuilder: (_, __) => const SizedBox(
                height: 10,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProduct(),
            ),
          );
          if (result == true) {
            // Reload the products after adding a new one
            _getProducts();
          }
        },
        child:const Icon(Icons.add),
      ),
    );
  }

  //Product Card by ListTyle
  Widget _buildListTile(BuildContext context, index) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    var brightness = Theme.of(context).brightness;
    return ListTile(
          leading: AspectRatio(
            aspectRatio: 1.1,
            child: Container(
              width: screenWidth *.20,
              height: screenHeight * 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(products[index].imageUrl),
                  fit: BoxFit.fill,
                )
              ),
            ),
          ),
          title: Text(
               products[index].productName,
               style: AppTextStyle.semiMedium,
          ),
          subtitle: Wrap(
            children: [
              Text(
                'Unit Price: ${products[index].unitPrice}',
                style: AppTextStyle.small.copyWith(
                  color: Colors.grey,
                ),
              ),
              Text(
                'Quantity:  ${products[index].productQuantity}',
                style: AppTextStyle.small.copyWith(
                    color: Colors.grey,
                ),
              ),
              Text(
                'Total Price:  ${products[index].totalPrice}',
                style: AppTextStyle.small.copyWith(
                    color: Colors.grey,
                ),
              ),
            ],
          ),
          trailing: Wrap(
            children: [
              IconButton(
                  onPressed: () async{
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateProduct(product: products[index])
                      ),
                    );
                    if (result == true) {
                      // Reload the products after adding a new one
                      _getProducts();
                    }
                  },
                  icon: Icon(
                    Icons.edit,
                    color: brightness == Brightness.dark?Colors.white:Colors.black,
                    size: 20,
                  ),
              ),
              IconButton(
                onPressed: (){
                  _showConfirmDeleteWithDialog(products[index].id);
                },
                icon: Icon(
                  Icons.delete,
                  color: brightness == Brightness.dark?Colors.deepOrange:Colors.red,
                  size: 20,
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _getProducts() async {
    setState(() {
      _isProductListInProgress = true;
      products.clear();
    });
    const String apiURL = 'https://crud.teamrabbil.com/api/v1/ReadProduct';
    Uri uri = Uri.parse(apiURL);
    Response response = await get(uri);
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      List<dynamic> jsonProductList = decodedData['data'];
      for (Map<String, dynamic> product in jsonProductList) {
        ProductModel loadableProduct = ProductModel(
          id: product['_id'] ?? '',
          productName: product['ProductName'] ?? '',
          productCode: product['ProductCode'] ?? '',
          imageUrl: product['Img'] ?? '',
          unitPrice: double.tryParse(product['UnitPrice'].toString()) ?? 0.0,
          productQuantity: int.tryParse(product['Qty'].toString()) ?? 0,
          totalPrice: double.tryParse(product['TotalPrice'].toString()) ?? 0.0,
        );
        products.add(loadableProduct);
      }

      setState(() {
        _isProductListInProgress = true;
      });
    } else {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            'Something went wrong here ...',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ));
      }
    }
    setState(() {
      _isProductListInProgress = false;
    });
  }


  Future<void> _deleteProduct(String productId) async{
    setState(() {
      _isProductListInProgress = true;
    });
    String deleteUrl = 'https://crud.teamrabbil.com/api/v1/DeleteProduct/$productId';
    Uri uri = Uri.parse(deleteUrl);
    Response response = await get(uri);
    if(response.statusCode == 200){
      _getProducts();
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'product deleted successfully!',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      }
      _isProductListInProgress = false;
    }else{
      setState(() {
        _isProductListInProgress =false;
      });
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'product not deleted successfully!',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      }
    }
  }


  void _showConfirmDeleteWithDialog(String productId){
     showDialog(
         context: context,
         builder: (context){
           return AppAlertDialog(
               title: "Are you sure to delete!",
               onTap: (){
                 _deleteProduct(productId);
                 Navigator.pop(context, true);
               },
           );
         },
     );
  }

}
