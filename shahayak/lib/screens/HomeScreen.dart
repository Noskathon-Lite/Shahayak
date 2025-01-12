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
  void _getCategories() {
    categories = CategoryModel.getCategories();
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
          SizedBox(height: 40),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
              ),
              SizedBox(height: 15),
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
            hintText: 'search',
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
        ));
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Shahayak',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
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
          child: SvgPicture.asset('assets/icons/profile-svhrepo-com.svg',
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
                height: 5, width: 5),
          ),
        ),
      ],
      centerTitle: true,
    );
  }
}
