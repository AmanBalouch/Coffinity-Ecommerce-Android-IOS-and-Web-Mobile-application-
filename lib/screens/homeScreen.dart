import 'package:coffeemobileapplicationandroid/UX/Providers/DBProvider.dart';
import 'package:coffeemobileapplicationandroid/helpers/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../UX/Database/DBHelper.dart';

class homeScreen extends StatefulWidget {
  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  String _userName="";
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadUserName();
    // Use microtask to ensure context is available
    Future.microtask(() async {
      final provider = context.read<DBProvider>();
      await provider.getProductsFirstTime("coffee");
    });

    // Optional: call setState to rebuild on text change
    searchController.addListener(() {
      setState(() {});
    });
  }

  Future<void> _loadUserName() async{
    _userName=await DBHelper.getuserName();
  }
  @override
  Widget build(BuildContext context) {
    List<Product> _allProducts=context.watch<DBProvider>().getProducts();
    final isSearching = searchController.text.isNotEmpty;
    final query = searchController.text.toLowerCase();
    final filteredProducts = _allProducts.where((product) {
      final nameMatch = product.name.toLowerCase().contains(query);
      final sizeMatch = product.size.toString().toLowerCase().contains(query);
      final priceMatch = product.price.toString().toLowerCase().contains(query);
      return nameMatch || sizeMatch || priceMatch;
    }).toList();
    final _products = isSearching ? filteredProducts : _allProducts;
    return Scaffold(
      resizeToAvoidBottomInset: false, // This disables auto-resizing
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 0),
      backgroundColor: Color(0xFFFFFFF0),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(30, 1, 30, 1),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: InterTextWidget(
                              text: "Hello,${_userName}",
                              color: Colors.black,
                              size: 24,
                              weight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 4),
                                MontserratTextWidget(
                                  text: "Kot Addu Pubjab Pakistan",
                                  color: Colors.black,
                                  size: 14,
                                  weight: FontWeight.w400,
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.notifications, size: 30, color: Colors.black),
                  ],
                ),
                SizedBox(height: 20),
                SearchTextField(
                  controller: searchController,
                  backgroundColor: Colors.white,
                  iconBackgroundColor: Color(0xFFC67C4E),
                  iconColor: Colors.white,
                  textColor: Color(0xFFB9B9B9),
                  onPressed: (){
                  },
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: MontserratTextWidget(
                          text: "Categories",
                          color: Colors.black,
                          size: 18,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                    CustomTextButton(
                      text: "See all",
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      textColor: Color(0xFFC67C4E),
                      onPressed: () {},
                    ),
                  ],
                ),
                SizedBox(height:  MediaQuery.of(context).size.height * 0.01),
                CategoryRow(),
                SizedBox(height: 10,),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.29,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _products.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: ProductCardWidget(
                          title: product.name,
                          size: "${product.size} ml",
                          price: "\$${product.price.toStringAsFixed(2)}",
                          rating: product.rating,
                          imageUrl: product.imageUrl ?? "https://res.cloudinary.com/dap4ehgew/image/upload/v1753518508/default_fypj9h.webp", // fallback image
                          desc: product.desc,
                      ),
                      );
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        MontserratTextWidget(text: "Popular Now", color: Colors.black, size: 18, weight:FontWeight.w600),
                        Expanded(child: SizedBox()),
                        Icon(
                          Icons.info,
                          size: 21,
                          color: Color(0xFFC67C4E),
                        )
                      ],
                    )
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.20, // 👈 Adjust height as needed
                  child: ListView.builder(
                    scrollDirection: Axis.vertical, // 👈 vertical direction
                    itemCount: _products.where((p) => p.isPopular).length,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemBuilder: (context, index) {
                      final popularProducts = _products.where((p) => p.isPopular).toList();
                      final product = popularProducts[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12), // spacing between items
                        child: PopularItemCard(
                          title: product.name,
                          size: "${product.size} ml",
                          price: "\$${product.price.toStringAsFixed(2)}",
                          imageUrl: product.imageUrl ??
                              "https://res.cloudinary.com/dap4ehgew/image/upload/v1753518508/default_fypj9h.webp",
                          rating: product.rating,
                          desc: product.desc,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
