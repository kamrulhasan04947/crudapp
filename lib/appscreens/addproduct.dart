import 'dart:convert';
import 'package:crudapp/appscreens/widgets/appbutton.dart';
import 'package:crudapp/appscreens/widgets/applicationbar.dart';
import 'package:crudapp/appscreens/widgets/apptextfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController _nameTeController = TextEditingController();
  final TextEditingController _priceTeController = TextEditingController();
  final TextEditingController _quantityTeController = TextEditingController();
  final TextEditingController _totalPriceTeController = TextEditingController();
  final TextEditingController _imageTeController = TextEditingController();
  final TextEditingController _productCodeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _addInProgress = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ApplicationBar(title: 'Add New Product'),
      body: SingleChildScrollView(
        child: _buildForm(),
      ),
    );
  }

  Padding _buildForm() {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                hint: 'Product Name',
                label: 'Product Name',
                controller:_nameTeController,
                inputType: TextInputType.text,
              ),
              AppTextField(
                hint: 'Unit Price',
                label: 'Unit Price',
                controller: _priceTeController,
                inputType: TextInputType.number,
              ),
              AppTextField(
                hint: 'Product Quantity',
                label: 'Product Quantity',
                controller: _quantityTeController,
                inputType: TextInputType.number,
              ),
              AppTextField(
                hint: 'Total Price',
                label: 'Total Price',
                controller: _totalPriceTeController,
                inputType: TextInputType.number,
              ),
              AppTextField(
                hint: 'Product Code',
                label: 'Product Code',
                controller: _productCodeController,
                inputType: TextInputType.text,
              ),
              AppTextField(
                hint: 'Image',
                label: 'Image',
                controller: _imageTeController,
                inputType: TextInputType.url,
              ),

              Visibility(
                visible: _addInProgress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: AppButton(
                  title: 'Submit',
                  onTap: (){
                    if(_formKey.currentState!.validate()){
                      _addProduct();
                    }
                  },
                )
              ),

            ],
          ),
        ),
      );
  }

  Future<void> _addProduct() async {
    setState(() {
      _addInProgress = true;
    });
    const String addProductURL =
        'https://crud.teamrabbil.com/api/v1/CreateProduct';

    Map<String, dynamic> inputData = {
      'Img': _imageTeController.text.trim(),
      'ProductCode': _productCodeController.text,
      'ProductName': _nameTeController.text,
      'Qty': _quantityTeController.text,
      'TotalPrice': _totalPriceTeController.text,
      'UnitPrice': _priceTeController.text,
    };

    Uri uri = Uri.parse(addProductURL);
    Response response = await post(
      uri,
      body: jsonEncode(inputData),
      headers: {'Content-Type': 'application/json'},
    );
    // print(response.statusCode);
    // print(response.body);
    // print(response.headers);
    if (response.statusCode == 200) {
      _nameTeController.clear();
      _productCodeController.clear();
      _priceTeController.clear();
      _quantityTeController.clear();
      _totalPriceTeController.clear();
      _imageTeController.clear();
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'New product added successfully!',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
        Navigator.pop(context, true);
      }

      setState(() {
        _addInProgress = true;
      });
    } else {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              'Add product failed!',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose(){
    _nameTeController.dispose();
    _priceTeController.dispose();
    _quantityTeController.dispose();
    _totalPriceTeController.dispose();
    _imageTeController.dispose();
    super.dispose();
  }
}
