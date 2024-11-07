import 'dart:async';
import 'dart:convert';
import 'package:e_commerce/loginscreen.dart';
import 'package:e_commerce/payment.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetail extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetail({super.key, required this.product});

  @override
  State<ProductDetail> createState() => ProductDetailState();
}

class ProductDetailState extends State<ProductDetail> {
  static const loginkey = "loginkey";
  @override
  Widget build(BuildContext context) {
    String title = widget.product['title'] ?? '';
    String imageUrl = widget.product['thumbnail'] ?? 'default_image_url';
    String description = widget.product['description'] ?? '';
    double price = widget.product['price'] ?? 0.0;
    double rating = widget.product['rating'] ?? 0.0;
    String brand = widget.product['brand'] ?? '';
    List<String> tags = (widget.product['tags'] is List)
        ? List<String>.from(widget.product['tags'])
        : [];
    String warrantyInformation = widget.product['warrantyInformation'] ?? '';
    String returnPolicy = widget.product['returnPolicy'] ?? '';
    String availabilityStatus = widget.product['availabilityStatus'] ?? '';

    // Handle meta information
    String metaDisplay;
    if (widget.product['meta'] != null && widget.product['meta'] is Map) {
      metaDisplay = jsonEncode(widget.product['meta']);
    } else {
      metaDisplay = 'Meta information not available';
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 60, top: 20),
          child: Text(title),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                imageUrl,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey,
                    child: const Center(child: Text('Image not available')),
                  );
                },
              ),
              const SizedBox(height: 16.0),
              Text(tags.join(' ')),
              const SizedBox(height: 6),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(brand),
              const SizedBox(height: 8.0),
              Text('Price: \$${price.toString()}'),
              const SizedBox(height: 8.0),
              Text('Warranty Information: $warrantyInformation'),
              const SizedBox(height: 8.0),
              Text('Return Policy: $returnPolicy'),
              const SizedBox(height: 8.0),
              Text('Availability Status: $availabilityStatus'),
              const SizedBox(height: 8.0),
              Text('Rating: ${rating.toString()} ⭐'),
              const SizedBox(height: 16.0),
              const Text(
                'Description:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(description),
              const SizedBox(height: 8.0),
              // Display the meta information
              const Text(
                'Meta Information:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(metaDisplay),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      wheretogo();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // बटन का बैकग्राउंड रंग
                        foregroundColor: Colors.white, // बटन के टेक्स्ट का रंग
                        minimumSize: const Size(200, 60)),
                    child: const Text('Buy')),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> wheretogo() async {
    var sharedPref = await SharedPreferences.getInstance();
    var islogedin = sharedPref.getBool(ProductDetailState.loginkey);

    if (islogedin != null) {
      if (islogedin) {
        Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => const Payment(),
            ));
      } else {
        Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => const Login(),
            ));
      }
    } else {
      Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => const Login(),
          ));
    }
  }
}

class ApiService {
  Future<List<dynamic>> fetchProducts() async {
    try {
      final phoneResponse = await http
          .get(Uri.parse('https://dummyjson.com/products/search?q=phone'));
      final productsResponse =
          await http.get(Uri.parse('https://dummyjson.com/products?limit=600'));
      final smartphoneResponse = await http.get(Uri.parse(
          'https://dummyjson.com/products/category/smartphones?limit=200'));

      if (phoneResponse.statusCode == 200 &&
          productsResponse.statusCode == 200 &&
          smartphoneResponse.statusCode == 200) {
        List<dynamic> phoneItems = json.decode(phoneResponse.body)['products'];
        List<dynamic> foodItems =
            json.decode(productsResponse.body)['products'];
        List<dynamic> smartphoneItems =
            json.decode(smartphoneResponse.body)['products'];

        // Combine items as per your need
        return [...phoneItems, ...foodItems, ...smartphoneItems];
      } else {
        throw Exception('API response error');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}

class Producthome extends StatefulWidget {
  const Producthome({super.key});

  @override
  State<Producthome> createState() => _Producthome();
}

class _Producthome extends State<Producthome> {
  final ApiService apiService = ApiService();
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;
  Future<List<dynamic>>? _futureProducts;

  @override
  void initState() {
    super.initState();
    // ApiService को केवल एक बार call करें और result को cache कर लें
    _futureProducts = apiService.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent[500],
      appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent[100],
          title: const Padding(
            padding: EdgeInsets.only(left: 50),
            child: Text('Products'),
          )),
      body: FutureBuilder<List<dynamic>>(
        future: _futureProducts, // Cached future
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('त्रुटि: ${snapshot.error}'));
          } else {
            List<dynamic> products = snapshot.data!;
            List<dynamic> carouselItems =
                products.take(5).toList(); // Carousel के लिए items
            List<dynamic> gridItems =
                products.skip(5).toList(); // Grid के लिए items

            return ListView(
              children: [
                buildCarousel(carouselItems), // Carousel function
                buildCarouselIndicator(
                    carouselItems), // Carousel Indicator function
                buildProductGrid(gridItems), // Grid function
              ],
            );
          }
        },
      ),
    );
  }

  // Carousel builder function
  Widget buildCarousel(List<dynamic> carouselItems) {
    return SizedBox(
      height: 170,
      width: 450,
      child: CarouselSlider.builder(
        itemCount: carouselItems.length,
        itemBuilder: (context, index, realIndex) {
          var product = carouselItems[index];
          return buildCarouselItem(product);
        },
        options: CarouselOptions(
          scrollPhysics: const BouncingScrollPhysics(),
          autoPlay: true,
          aspectRatio: 1,
          viewportFraction: 1,
          onPageChanged: (index, reason) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }

  // Carousel item builder
  Widget buildCarouselItem(dynamic product) {
    String title = product['title'] ?? '';
    String imageUrl = product['thumbnail'] ?? 'default_image_url';
    double price = product['price'] ?? 0.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetail(product: product),
          ),
        );
      },
      child: Container(
        height: 185,
        margin: const EdgeInsets.all(5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Column(
            children: [
              Text(title),
              SizedBox(
                height: 120,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey,
                      child: const Center(child: Text('Image not available')),
                    );
                  },
                ),
              ),
              Text('\$${price.toString()}'),
            ],
          ),
        ),
      ),
    );
  }

  // Carousel indicators
  Widget buildCarouselIndicator(List<dynamic> carouselItems) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(carouselItems.length, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 3.0),
            width: currentIndex == index ? 15 : 7,
            height: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: currentIndex == index ? Colors.red : Colors.green,
            ),
          );
        }),
      ),
    );
  }

  // Grid builder function
  Widget buildProductGrid(List<dynamic> gridItems) {
    return GridView.builder(
      shrinkWrap: true, // GridView की height को restrict करता है
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
      ),
      itemCount: gridItems.length,
      itemBuilder: (context, index) {
        var product = gridItems[index];
        return buildGridItem(product);
      },
    );
  }

  // Grid item builder
  Widget buildGridItem(dynamic product) {
    String title = product['title'] ?? 'अनजान उत्पाद';
    String imageUrl = product['thumbnail'] ?? 'default_image_url';
    double price = product['price'] ?? 0.0;
    dynamic rating = product['rating'] ?? 0.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetail(product: product),
          ),
        );
      },
      child: SizedBox(
        height: 200,
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  imageUrl,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 100,
                      color: Colors.grey,
                      child: const Center(child: Text('Image not available')),
                    );
                  },
                ),
                const SizedBox(height: 8.0),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                Text('\$${price.toString()}'),
                const SizedBox(height: 4.0),
                Text('${rating.toString()} ⭐'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
