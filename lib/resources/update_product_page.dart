import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:point_of_sell/resources/colors.dart';
import 'package:point_of_sell/resources/styles.dart';

import '../data/bloc/products/products_bloc.dart';
import '../data/bloc/products/products_event.dart';
import '../data/bloc/products/products_state.dart';
import '../data/model/products_model.dart';

class UpdateProductPage extends StatefulWidget {
  final String productId;

  UpdateProductPage({required this.productId});

  @override
  _UpdateProductPageState createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _categoryController = TextEditingController();
  String _status = 'Available';
  File? _imageFile;
  String? _existingImageUrl; // To store the existing image URL
  final ImagePicker _picker = ImagePicker();
  final List<String> _statusOptions = ['Available', 'Not Available'];

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }

  void _loadProductDetails() {
    final productBlocState = BlocProvider.of<ProductsBloc>(context).state;
    if (productBlocState is ProductsLoadedState) {
      final product = productBlocState.products.firstWhere(
        (product) => product.id == widget.productId,
        orElse: () => _createEmptyProduct(),
      );

      _productNameController.text = product.productName;
      _descriptionController.text = product.description;
      _priceController.text = product.price.toString();
      _stockController.text = product.stock.toString();
      _categoryController.text = product.category;
      _status = product.status == 'available' ? 'Available' : 'Not Available';
      _existingImageUrl = product.imageUrl; // Assign existing image URL
    }
  }

  ProductsModel _createEmptyProduct() {
    return ProductsModel(
      id: '',
      productName: 'No Name',
      description: 'No Description',
      price: 0.0,
      stock: 0,
      category: 'Unknown',
      imageUrl: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: 'unknown',
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        surfaceTintColor: backgroundColor,
        title: Text(
          'Update Product',
          style: Styles.appbarText,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: softBlack),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name", style: Styles.title),
            const SizedBox(height: 8),
            TextField(
              controller: _productNameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Product Name',
                hintStyle: Styles.description,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: lightGray),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: lightGray),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text("Description", style: Styles.title),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Product Description',
                hintStyle: Styles.description,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: lightGray),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: lightGray),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text("Price", style: Styles.title),
            const SizedBox(height: 8),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Product Price',
                hintStyle: Styles.description,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: lightGray),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: lightGray),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text("Stock", style: Styles.title),
            const SizedBox(height: 8),
            TextField(
              controller: _stockController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Product Stock',
                hintStyle: Styles.description,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: lightGray),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: lightGray),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text("Category", style: Styles.title),
            const SizedBox(height: 8),
            TextField(
              controller: _categoryController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Product Category',
                hintStyle: Styles.description,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: lightGray),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: lightGray),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text("Image", style: Styles.title),
            const SizedBox(height: 8),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: _imageFile == null
                    ? (_existingImageUrl != null &&
                            _existingImageUrl!.isNotEmpty
                        ? 'Existing Image Loaded'
                        : 'No Image Selected')
                    : 'Image Selected',
                hintStyle: Styles.description,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: lightGray),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: lightGray),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.image, color: primaryColor),
                  onPressed: _pickImage,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text("Status", style: Styles.title),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _status,
              hint: Text('Select Status', style: Styles.description),
              items: _statusOptions.map((status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _status = value ?? 'Available';
                });
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: lightGray),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: lightGray),
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                final updatedProduct = ProductsModel(
                  id: widget.productId,
                  productName: _productNameController.text,
                  description: _descriptionController.text,
                  price: double.parse(_priceController.text),
                  stock: int.parse(_stockController.text),
                  category: _categoryController.text,
                  imageUrl: _imageFile != null
                      ? _imageFile!.path
                      : _existingImageUrl ?? '',
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  status:
                      _status == 'Available' ? 'available' : 'not available',
                );

                BlocProvider.of<ProductsBloc>(context).add(
                  UpdateProductEvent(updatedProduct, imageFile: _imageFile),
                );
                context.pop(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: primaryColor,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Update Product'),
            ),
          ],
        ),
      ),
    );
  }
}
