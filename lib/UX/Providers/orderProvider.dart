import 'package:coffeemobileapplicationandroid/UX/Database/DBHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class orderProvider extends ChangeNotifier{
  List<OrderedProduct>_orderProducts=[];
  List<Order> _ordersInProcess=[];
  List<Order> _allOrders=[];
  double _totalBill=0.0;

  List<OrderedProduct> getOrderProducts(){
    return _orderProducts;
  }

  double getTotalBill(){
    return _totalBill;
  }

  List<Order> getOrdersInProcess() {
    return _ordersInProcess;
  }

  List<Order> getAllOrders(){
    return _allOrders;
  }


  Future<void> LoadInProcessOrders() async {
    _ordersInProcess=await DBHelper().fetchInProcessOrders();
    notifyListeners();
  }

  Future<void> LoadAllOrders() async{
    _allOrders=await DBHelper().fetchAllOrders();
    notifyListeners();
  }

  void addProductToOrder({
    required String name,
    required String size,
    required double price,
    required int quantity,
    required double bill,
    required String imageUrl,
  }) {
    // Find index of the product (if exists)
    int existingIndex = _orderProducts.indexWhere((product) =>
    product.name == name && product.size == size
    );

    if (existingIndex != -1) {
      addBillAndQuantity(existingIndex);
      return;
    }

    OrderedProduct product = OrderedProduct(
      name: name,
      size: size,
      price: price,
      quantity: quantity,
      bill: bill,
      imageUrl: imageUrl,
    );

    _orderProducts.add(product);
    notifyListeners();
  }



  Future<void> placeOrder(BuildContext context,double totalBill,String address,String phoneNo) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _orderProducts.isEmpty) return;

    await DBHelper.placeOrder(
      user: user,
      products: _orderProducts,
      totalBill: totalBill,
      address: address,
      phoneNo: phoneNo
    );

    clearOrder();
    clearTotalBill();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order placed successfully!')),
    );
    LoadInProcessOrders();
  }

  void addInTotalBill(double i){
    _totalBill=_totalBill+i;
    notifyListeners();
  }

  void minusInTotalBill(double i){
    _totalBill=_totalBill-i;
    notifyListeners();
  }

  void addBillAndQuantity(int index){
    _orderProducts[index].bill+=_orderProducts[index].price;
    _orderProducts[index].quantity+=1;
    notifyListeners();
  }

  void minusBillAndQuantity(int index){
    _orderProducts[index].bill-=_orderProducts[index].price;
    _orderProducts[index].quantity-=1;
    notifyListeners();
  }

  // Optional: Clear the order list
  void clearOrder() {
    _orderProducts.clear();
    notifyListeners();
  }

  void clearTotalBill(){
    _totalBill=0.0;
    notifyListeners();
  }

  void removeProductFromOrder(int index) {
    if (index >= 0 && index < _orderProducts.length) {
      // Subtract the bill of the product being removed from total bill
      _totalBill -= _orderProducts[index].bill;
      _orderProducts.removeAt(index);
      notifyListeners();
    }
    if(_orderProducts.length==0){
      clearTotalBill();
    }
  }

}