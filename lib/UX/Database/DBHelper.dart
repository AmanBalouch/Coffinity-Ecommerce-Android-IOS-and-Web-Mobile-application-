import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Product {
  final String name;
  final double price;
  final double rating;
  final int size;
  final String? imageUrl;
  final bool isPopular;
  final String desc;

  Product({
    required this.name,
    required this.price,
    required this.rating,
    required this.size,
    this.imageUrl,
    required this.desc,
    required this.isPopular,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toDouble(),   // Fix here
      rating: (data['rating'] ?? 0).toDouble(),
      size: (data['size'] ?? 0).toDouble().toInt(),     // Fix here
      imageUrl: data['imageUrl'],
      desc:  data['desc'] ?? '',
      isPopular: data['isPop']??false
    );
  }
}

class OrderedProduct {
  final String name;
  final String size;
  final double price;
  int quantity;
  double bill;
  final String imageUrl;

  OrderedProduct({
    required this.name,
    required this.quantity,
    required this.bill,
    required this.imageUrl,
    required this.price,
    required this.size,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'bill': bill,
      'imageUrl': imageUrl,
      'size':size,
      'price':price
    };
  }
}

class Order {
  final List<OrderedProduct> products;
  final double totalBill;
  final int status; // 0: in process, 1: completed, 2: cancelled
  final DateTime orderDate;
  final String orderId;
  final String address;
  final String phoneNo;

  Order({
    required this.products,
    required this.totalBill,
    this.status = 0,
    DateTime? orderDate,
    required this.orderId,
    required this.address,
    required this.phoneNo,
  }) : orderDate = orderDate ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'products': products.map((p) => p.toMap()).toList(),
      'totalBill': totalBill,
      'status': status,
      'orderDate': orderDate,
      'address':address,
      "phoneNo":phoneNo
    };
  }
}


class DBHelper {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final Map<String, List<Product>> _categoryCache = {};

  static Future<List<Product>> fetchProductsByCategory(String categoryName) async {
    // Return cached data if exists
    if (_categoryCache.containsKey(categoryName)) {
      return _categoryCache[categoryName]!;
    }

    final List<Product> products = [];

    // 🔍 Find the document where name == categoryName
    final querySnapshot = await _firestore
        .collection('items')
        .where('name', isEqualTo: categoryName)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return []; // no matching category found
    }

    final categoryDoc = querySnapshot.docs.first.reference;
    final productsSnapshot = await categoryDoc.collection('products').get();

    for (var productDoc in productsSnapshot.docs) {
      products.add(Product.fromFirestore(productDoc));
    }

    // Cache the data
    _categoryCache[categoryName] = products;

    return products;
  }


  // ✅ Clear cache if needed
  static void clearProductsCache() {
    _categoryCache.clear();
  }

  static Future<List<String>> getAllCategoryNames() async {
    final snapshot = await _firestore.collection('items').get();
    return snapshot.docs.map((doc) => doc['name'] as String).toList();
  }

  static Future<void> createUserDocument(User user,String name) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

    // Create base user profile
    await userDoc.set({
      'email': user.email,
      'createdAt': FieldValue.serverTimestamp(),
      'name': name,  // optional
    });
  }

  static Future<void> placeOrder({
    required User user,
    required List<OrderedProduct> products,
    required double totalBill,
    int status = 0,
    required String address,
    required String phoneNo
  }) async {
    final orderRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .doc(); // auto-ID

    final orderId = orderRef.id;

    final order = Order(
      products: products,
      totalBill: totalBill,
      status: status,
      orderId: orderId,
      address:address,
      phoneNo:phoneNo
    );
    await orderRef.set(order.toMap());
  }

  Future<List<Order>> fetchInProcessOrders() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .where('status', isEqualTo: 0) // 0 = in process
        .orderBy('orderDate', descending: true) // optional: sort by recent
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      // Deserialize ordered products
      final orderedProducts = (data['products'] as List<dynamic>).map((item) {
        return OrderedProduct(
          name: item['name'],
          quantity: item['quantity'],
          bill: item['bill'].toDouble(),
          imageUrl: item['imageUrl'],
          price: item['price'].toDouble(),
          size: item['size'],
        );
      }).toList();

      return Order(
        products: orderedProducts,
        totalBill: data['totalBill'].toDouble(),
        status: data['status'],
        orderDate: (data['orderDate'] as Timestamp).toDate(),
        orderId: doc.id,
        address: data['address'],
        phoneNo: data['phoneNo'],
      );
    }).toList();
  }

  Future<List<Order>> fetchAllOrders() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .orderBy('orderDate', descending: true) // Optional: sort by most recent
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      // Deserialize ordered products
      final orderedProducts = (data['products'] as List<dynamic>).map((item) {
        return OrderedProduct(
          name: item['name'],
          quantity: item['quantity'],
          bill: item['bill'].toDouble(),
          imageUrl: item['imageUrl'],
          price: item['price'].toDouble(),
          size: item['size'],
        );
      }).toList();

      return Order(
        products: orderedProducts,
        totalBill: data['totalBill'].toDouble(),
        status: data['status'],
        orderDate: (data['orderDate'] as Timestamp).toDate(),
        orderId: doc.id,
        address: data['address'],
        phoneNo: data['phoneNo'],
      );
    }).toList();
  }

  static Future<String> fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      throw Exception("User document not found");
    }

    final data = userDoc.data()!;
    return data['name'] ?? '';
  }
  static Future<String> fetchEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      throw Exception("User document not found");
    }

    final data = userDoc.data()!;
    return data['email'] ?? '';
  }

  static Future<String> getuserName() async {
    final prefs = await SharedPreferences.getInstance();
    String _userName=(await prefs.getString("userName"))!;
    return _userName;
  }

  static Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    String _email=(await prefs.getString("email"))!;
    return _email;
  }
}


