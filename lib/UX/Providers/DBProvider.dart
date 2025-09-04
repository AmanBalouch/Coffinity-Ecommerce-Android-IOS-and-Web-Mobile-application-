import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Database/DBHelper.dart';

class DBProvider extends ChangeNotifier{
  List<Product> _products=[];
  List<String> _category=[];
  bool _isLoading = false;

  List<Product> getProducts(){
    return _products;
  }
  List<String> getCategories(){
    return _category;
  }

  bool getIsLoading(){
    return _isLoading;
  }

  Future<void> productsByCategory(String catagoryName) async {
    _isLoading = true;
    notifyListeners();

    _products = await DBHelper.fetchProductsByCategory(catagoryName);
    _isLoading=false;
    notifyListeners();
  }

  Future<void> allCategories() async {
    _isLoading = true;
    notifyListeners();
    _category=await DBHelper.getAllCategoryNames();
    _isLoading=false;
    notifyListeners();
  }

  Future<List<Product>> getProductsFirstTime(String catagoryName) async {
    await productsByCategory(catagoryName);
    return _products;
  }
}

