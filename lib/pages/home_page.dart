import 'package:clickcart_client/controller/home_controller.dart';
import 'package:clickcart_client/pages/login_page.dart';
import 'package:clickcart_client/pages/product_description_page.dart';
import 'package:clickcart_client/pages/widgets/drop_down_btn.dart';
import 'package:clickcart_client/pages/widgets/multi_select_drop_down.dart';
import 'package:clickcart_client/pages/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return RefreshIndicator(
        onRefresh: () async{
          ctrl.fetchProducts();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'FootWare Store', style: TextStyle(fontWeight: FontWeight.bold),),
            centerTitle: true,
            actions: [
              IconButton(onPressed: () {
                GetStorage box = GetStorage();
                box.erase();
                Get.offAll(LoginPage());
              }, icon: Icon(Icons.logout))
            ],
          ),
          body: Column(
            children: [
              SizedBox(height: 50,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: ctrl.productCategories.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          ctrl.filterByCategory(ctrl.productCategories[index].name ?? 'Category not found');
                        },
                        child: Padding(padding: const EdgeInsets.all(6.0),
                            child: Chip(label: Text(ctrl.productCategories[index].name ?? 'Error'))
                        ),
                      );
                    }),
              ),
              Row(
                children: [
                  Flexible(child: DropdownBtn(items: [
                    'Rs : Low to High', 'Rs: High to Low'
                  ],
                    selectedItemText: 'Sort',
                    onSelected: (selected) {
                   ctrl.sortByPrice(ascending:selected == 'Rs : Low to High' ? true : false);
                    },
                    selectedValue: '',)),
                  Flexible(child: MultiSelectDropDown(
                    items: ['Nike', 'Crocs', 'Puma','Centrino','SPARX','Reebok','Bata','Bacca Bucci','DOCTOR','Woodland'],
                    onSelectionChanged: (selectedItems) {
                      ctrl.filterByBrand(selectedItems);
                    },))
                ],
              ),
        
              Expanded(
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: ctrl.productsShowInUi.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        name: ctrl.productsShowInUi[index].name ?? 'No Name',
                        imageUrl: ctrl.productsShowInUi[index].image ?? 'url',//'https://m.media-amazon.com/images/I/51FTUNbD21L._SY695_.jpg',
                        price: ctrl.productsShowInUi[index].price ?? 00,
                        offerTag: '20 % off',
                        onTap: () {
                         Get.to(ProductDescriptionPage(),arguments: {'data':ctrl.productsShowInUi[index]});
                        },
                      );
                    }),
              )
            ],
          ),
        ),
      );
    });
  }
}
