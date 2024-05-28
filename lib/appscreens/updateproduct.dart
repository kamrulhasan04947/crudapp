import 'dart:convert';
import 'package:crudapp/appscreens/widgets/appbutton.dart';
import 'package:crudapp/appscreens/widgets/applicationbar.dart';
import 'package:crudapp/appscreens/widgets/apptextfield.dart';
import 'package:crudapp/models/productmodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UpdateProduct extends StatefulWidget {
  const UpdateProduct({
    super.key,
    required this.product,
  });
  final ProductModel product;
  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  final TextEditingController _nameTeController = TextEditingController();
  final TextEditingController _priceTeController = TextEditingController();
  final TextEditingController _quantityTeController = TextEditingController();
  final TextEditingController _totalPriceTeController = TextEditingController();
  final TextEditingController _imageTeController = TextEditingController();
  final TextEditingController _productCodeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _addInProgress = false;

  @override
  void initState(){
    super.initState();
    _nameTeController.text = widget.product.productName;
    _productCodeController.text = widget.product.productCode;
    _quantityTeController.text = widget.product.productQuantity.toString();
    _priceTeController.text = widget.product.unitPrice.toString();
    _totalPriceTeController.text = widget.product.totalPrice.toString();
    _imageTeController.text = widget.product.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ApplicationBar(title: 'Add New Product'),
      body: SingleChildScrollView(
        child: _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
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
                      _updateProduct();
                    }
                  },
                )
            ),

          ],
        ),
      ),
    );
  }

  Future<void> _updateProduct() async{
    setState(() {
      _addInProgress = true;
    });
    String updateUrl = "https://crud.teamrabbil.com/api/v1/UpdateProduct/${widget.product.id}";
    Map<String , dynamic> updateData = {
      'Img': _imageTeController.text.trim(),
      'ProductCode': _productCodeController.text,
      'ProductName': _nameTeController.text,
      'Qty': _quantityTeController.text,
      'TotalPrice': _totalPriceTeController.text,
      'UnitPrice': _priceTeController.text,
    };
    Uri uri = Uri.parse(updateUrl);
    Response response = await post(
      uri,
      headers: {'content-type': 'application/json'},
      body: jsonEncode(updateData),
    );
    if(response.statusCode == 200){
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Product update successfully done!',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
        Navigator.pop(context, true);
      }
      setState(() {
        _addInProgress = false;
      });
    }else{
      setState(() {
        _addInProgress = false;
      });
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              'Product update failed!',
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