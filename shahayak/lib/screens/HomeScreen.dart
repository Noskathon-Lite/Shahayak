import 'package:flutter/material.dart';
import 'User.dart';
import 'post.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shahayak/models/category_model.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});
  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<CategoryModel> categories = [];
  String? selectedCategory;
  RangeValues priceRange = RangeValues(0, 10000);
  String? selectedType;

  void _getCategories() {
    categories = CategoryModel.getCategories();
  }

  void _openFilterBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Filter',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 20),
                  //Filter:1 category dropdwon
                  const Text('Category', style: TextStyle(fontSize: 16)),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: selectedCategory,
                    items: categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category.categoryName,
                        child: Text(category.categoryName),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                ],
              ));
        });
  }

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  @override
  Widget build(BuildContext context) {
    _getCategories();
    return Scaffold(
      appBar: appBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SearchField(),
          const SizedBox(height: 40),
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20),
              ),
              const SizedBox(height: 15),
              Container(
                height: 40,
                color: Colors.black,
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return Container(
                      color: categories[index].boxColor,
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Container _SearchField() {
    return Container(
        margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: const Color(0xff1D1537).withOpacity(0.11),
              blurRadius: 40,
              spreadRadius: 0),
        ]),
        child: TextField(
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(15),
              hintText: 'Search',
              hintStyle: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: 15,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset('assets/icons/Search.svg'),
              ),
              suffixIcon: SizedBox(
                width: 100,
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const VerticalDivider(
                        color: Colors.black,
                        thickness: 0.1,
                        indent: 10,
                        endIndent: 10,
                      ),
                      GestureDetector(
                        onTap: _openFilterBottomSheet,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset('assets/icons/Filter.svg'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              )),
        ));
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      leading: GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgPicture.asset('assets/icons/profile-svgrepo-com.svg',
              height: 20, width: 20),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            width: 37,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset('assets/icons/setting-svgrepo-com.svg',
                height: 20, width: 20),
          ),
        ),
      ],
      centerTitle: true,
    );
  }
}
