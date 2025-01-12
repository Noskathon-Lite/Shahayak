import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shahayak/models/category_model.dart';
import 'package:shahayak/api_service.dart';
import 'package:shahayak/screens/CreatePostScreen.dart';
import 'package:shahayak/screens/post.dart'; // Unified `Post` import

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<CategoryModel> categories = [];
  List<Post> allPosts = [];
  List<Post> filteredPosts = [];
  bool isLoading = true;
  String? selectedCategory;
  RangeValues priceRange = const RangeValues(0, 10000);
  String? selectedType;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _fetchPosts();
  }

  /// Initializes the categories and applies initial filters.
  void _initializeData() {
    categories = CategoryModel.getCategories();
    filteredPosts = List.from(allPosts);
  }

  /// Fetches posts from the API and updates the state.
  Future<void> _fetchPosts() async {
    try {
      List<Post> fetchedPosts = await ApiService().fetchPosts();
      setState(() {
        allPosts = fetchedPosts;
        filteredPosts =
            List.from(allPosts); // Update filteredPosts with fetched data
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load posts')),
      );
    }
  }

  /// Applies the selected filters to the posts.
  void _applyFilters() {
    setState(() {
      filteredPosts = allPosts.where((post) {
        final isCategoryMatch =
            selectedCategory == null || selectedCategory == post.category;
        final isPriceMatch =
            post.price >= priceRange.start && post.price <= priceRange.end;
        final isTypeMatch = selectedType == null || selectedType == post.type;
        return isCategoryMatch && isPriceMatch && isTypeMatch;
      }).toList();
    });
  }

  /// Opens the filter bottom sheet for selecting filters.
  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Filter',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 20),
                    const Text('Category', style: TextStyle(fontSize: 16)),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: selectedCategory,
                      hint: const Text('Select a category'),
                      items: categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category.categoryName,
                          child: Text(category.categoryName ?? 'Unknown'),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    const Text('Price Range', style: TextStyle(fontSize: 16)),
                    RangeSlider(
                      values: priceRange,
                      min: 0,
                      max: 10000,
                      divisions: 5,
                      labels: RangeLabels(
                        priceRange.start.round().toString(),
                        priceRange.end.round().toString(),
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          priceRange = values;
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    const Text("Type", style: TextStyle(fontSize: 16)),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: selectedType,
                      hint: const Text("Select type"),
                      items: ["Exchange", "Donation"].map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _applyFilters();
                      },
                      child: const Text('Apply'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SearchField(),
                const SizedBox(height: 20),
                if (categories.isNotEmpty)
                  Container(
                    height: 40,
                    color: Colors.black,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: categories[index].boxColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            categories[index].categoryName ?? "Unknown",
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePostScreen()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  AppBar _buildAppBar() {
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

  Widget _SearchField() {
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: const Color(0xff1D1537).withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0),
      ]),
      child: TextField(
        onChanged: (query) {
          setState(() {
            filteredPosts = allPosts
                .where((post) => post.productName
                    .toLowerCase()
                    .contains(query.toLowerCase()))
                .toList();
          });
        },
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
          ),
        ),
      ),
    );
  }
}
