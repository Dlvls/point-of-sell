import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:point_of_sell/resources/colors.dart';
import 'package:point_of_sell/resources/styles.dart';

import 'data/bloc/products/products_bloc.dart';
import 'data/bloc/products/products_event.dart';
import 'data/bloc/products/products_state.dart';
import 'data/model/products_model.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _categoryController = TextEditingController();
  File? _imageFile;
  String? _status;

  final List<String> _statusOptions = [
    'Available',
    'Not Available',
  ];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _submitProduct() {
    if (_productNameController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _stockController.text.isNotEmpty &&
        _categoryController.text.isNotEmpty &&
        _status != null) {
      final product = ProductsModel(
        id: '',
        productName: _productNameController.text,
        description: _descriptionController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        stock: int.tryParse(_stockController.text) ?? 0,
        category: _categoryController.text,
        imageUrl: '', // Initially empty, will be updated by the BLoC
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: _status!,
      );

      context
          .read<ProductsBloc>()
          .add(AddProductEvent(product, imageFile: _imageFile));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
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
          'Add Product',
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
      body: Stack(
        children: [
          BlocListener<ProductsBloc, ProductsState>(
            listener: (context, state) {
              if (state is ProductsLoadedState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product added successfully')),
                );
                GoRouter.of(context).pop();
              } else if (state is ProductsErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Failed to add product: ${state.error}')),
                );
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name",
                    style: Styles.title,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _productNameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Product Name',
                      hintStyle: Styles.description,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: lightGray,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: lightGray,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Description",
                    style: Styles.title,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Product Description',
                      hintStyle: Styles.description,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: lightGray,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: lightGray,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Price",
                    style: Styles.title,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Product Price',
                      hintStyle: Styles.description,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: lightGray,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: lightGray,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Stock",
                    style: Styles.title,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _stockController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Product Stock',
                      hintStyle: Styles.description,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: lightGray,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: lightGray,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Category",
                    style: Styles.title,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _categoryController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Product Category',
                      hintStyle: Styles.description,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: lightGray,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: lightGray,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Image",
                    style: Styles.title,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: _imageFile == null
                          ? 'No Image Selected'
                          : 'Image Selected',
                      hintStyle: Styles.description,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: lightGray,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: lightGray,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.image, color: primaryColor),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Status",
                    style: Styles.title,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _status,
                    hint: Text(
                      'Select Status',
                      style: Styles.description,
                    ),
                    items: _statusOptions.map((status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _status = value;
                      });
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: lightGray,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: lightGray,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  ElevatedButton(
                    onPressed: _submitProduct,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: primaryColor,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      'Add Product',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<ProductsBloc, ProductsState>(
            builder: (context, state) {
              if (state is ProductsLoadingState) {
                return const Positioned.fill(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
