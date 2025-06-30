import 'package:clickcart_client/model/product_category/product_category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../model/product/product.dart';

class  HomeController extends GetxController{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference productCollection;
  late CollectionReference categoryCollection;

  TextEditingController  productNameCtrl = TextEditingController();
  TextEditingController  productDescriptionCtrl = TextEditingController();
  TextEditingController  productImgCtrl = TextEditingController();
  TextEditingController  productPriceCtrl = TextEditingController();

  List<Product> products = [];
  List<Product> productsShowInUi = [];
  List<ProductCategory> productCategories = [];

  @override
  void onInit() async{
    productCollection = firestore.collection('products');
    categoryCollection = firestore.collection('category');
    await fetchCategory();
    await fetchProducts();

    super.onInit();
  }

  fetchProducts() async{
    try {
      QuerySnapshot productSnapshot = await productCollection.get();
      final List<Product> retrievedProducts = productSnapshot.docs.map((doc)=> Product.fromJson(doc.data() as Map<String,dynamic>)).toList();
      products.clear();
      products.assignAll(retrievedProducts);

      productsShowInUi.clear();
      productsShowInUi.assignAll(products);
      Get.snackbar('Success', 'Products fetched successfully', colorText:Colors.green);
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText:Colors.red);
      print(e);
    }finally{
      update();
    }
  }

  fetchCategory() async{
    try {
      QuerySnapshot categorySnapshot = await categoryCollection.get();
      final List<ProductCategory> retrievedCategories = categorySnapshot.docs.map((doc)=> ProductCategory.fromJson(doc.data() as Map<String,dynamic>)).toList();
      productCategories.clear();
      productCategories.assignAll(retrievedCategories);
     // Get.snackbar('Success', 'Category fetched successfully', colorText:Colors.green);
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText:Colors.red);
      print(e);
    }finally{
      update();
    }
  }

  filterByCategory(String category){
    productsShowInUi.clear();
    productsShowInUi = products.where((products) => products.category == category).toList();
    update();
  }

  filterByBrand(List<String> brands){
    if(brands.isEmpty){
      productsShowInUi = products;
    }else{
      List<String> lowerCaseBrands = brands.map((brand) => brand.toLowerCase()).toList();
      productsShowInUi = products.where((product) {
        final brand = product.brand?.toLowerCase() ?? '';
        return lowerCaseBrands.contains(brand);
      }).toList();
    }
    update();
  }

  sortByPrice({required bool ascending}){
  List<Product> sortedProducts  = List<Product>.from(productsShowInUi);
  sortedProducts.sort((a, b)=> ascending ? a.price!.compareTo(b.price!) : b.price!.compareTo(a.price!));
  productsShowInUi = sortedProducts;
  update();
  }

}