import 'package:flutter/material.dart';
import 'product_details_page.dart';

class ProductCataloguePage extends StatefulWidget {
  const ProductCataloguePage({super.key});

  @override
  State<ProductCataloguePage> createState() => _ProductCataloguePageState();
}

class _ProductCataloguePageState extends State<ProductCataloguePage> {
  String searchQuery = '';
  String? selectedPrice;
  String? selectedType;

  // Full product list with all color names and image paths
  final List<Map<String, dynamic>> products = const [
    {
      "name": "Waterblock 6mm",
      "price": "RM 136.00/box",
      "tags": ["Waterproof", "Plastic-free"],
      "image": "assets/6mm/6mm.jpg",
      "type": "6mm",
      "colors": [
        "W6601 Blanco Roble",
        "W6602 Pizarra",
        "W6603 Durazno",
        "W6605 Sabio Roble",
        "W6606 Moreno Teca",
        "W6608 Fresia",
        "W6609 Chocolate",
        "W6610 Jarra Vino"
      ],
      "colorImages": [
        "assets/6mm/W6601 Blanco Roble.jpg",
        "assets/6mm/W6602 Pizarra.jpg",
        "assets/6mm/W6603 Durazno.jpg",
        "assets/6mm/W6605 Sabio Roble.jpg",
        "assets/6mm/W6606 Moreno Teca.jpg",
        "assets/6mm/W6608 Fresia.jpg",
        "assets/6mm/W6609 Chocolate.jpg",
        "assets/6mm/W6610 Jarra Vino.jpg"
      ]
    },
    {
      "name": "Waterblock Pro 8.6mm",
      "price": "RM 200.00/box",
      "tags": ["Waterproof", "Plastic-free"],
      "image": "assets/8.6mm/8.6mm.jpg",
      "type": "8mm",
      "colors": [
        "W01 Raggi di Sole",
        "W02 Bianco",
        "W03 Desiderio",
        "W05 Authentico",
        "W06 Barcelona Oak",
        "W08 Black Walnut",
        "W09 Bocote",
        "W10 Bubinga"
      ],
      "colorImages": [
        "assets/8.6mm/W01 Raggi di Sole.jpg",
        "assets/8.6mm/W02 Bianco.jpg",
        "assets/8.6mm/W03 Desiderio.jpg",
        "assets/8.6mm/W05 Authentico.jpg",
        "assets/8.6mm/W06 Barcelona Oak.jpg",
        "assets/8.6mm/W08 Black Walnut.jpg",
        "assets/8.6mm/W09 Bocote.jpg",
        "assets/8.6mm/W10 Bubinga.jpg"
      ]
    },
    {
      "name": "Waterblock XE 8mm",
      "price": "RM 150.00/box",
      "tags": ["Waterproof", "Plastic-Free"],
      "image": "assets/XE/XE.jpg",
      "type": "8mm",
      "colors": [
        "33 Balli Teak",
        "21 Sakulamento Oak",
        "36 Madula Oak",
        "39 Abinyong",
        "46 Hunjehan Oak"
      ],
      "colorImages": [
        "assets/XE/33 Balli Teak.jpg",
        "assets/XE/21 Sakulamento Oak.jpg",
        "assets/XE/36 Madula Oak.jpg",
        "assets/XE/39 Abinyong.jpg",
        "assets/XE/46 Hunjehan Oak.jpg"
      ]
    },
    {
      "name": "Waterblock Pro 12.6mm Herringbone",
      "price": "RM 144.00/box",
      "tags": ["Waterproof", "Plastic-Free"],
      "image": "assets/12.6mm/12.6mm.jpg",
      "type": "12.6mm",
      "colors": [
        "46 Hunjehan Oak",
        "06 Barcelona Oak",
        "08 Black Walnut",
        "09 Bocote",
        "10 Bubinga",
        "12"
      ],
      "colorImages": [
        "assets/12.6mm/46 Hunjehan Oak.jpg",
        "assets/12.6mm/06 Barcelona Oak.jpg",
        "assets/12.6mm/08 Black Walnut.jpg",
        "assets/12.6mm/09 Bocote.jpg",
        "assets/12.6mm/10 Bubinga.jpg",
        "assets/12.6mm/12.jpg"
      ]
    },
  ];

  // Filter function
  List<Map<String, dynamic>> filterProducts() {
    return products.where((product) {
      final matchesSearch = product["name"]
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      bool matchesPrice = true;
      if (selectedPrice != null) {
        final priceValue = double.tryParse(
                product["price"].toString().replaceAll(RegExp(r'[^0-9.]'), '')) ??
            0;
        if (selectedPrice == "<150") {
          matchesPrice = priceValue < 150;
        } else if (selectedPrice == ">150") {
          matchesPrice = priceValue >= 150;
        }
      }

      bool matchesType = true;
      if (selectedType != null) {
        if (selectedType == "6mm") {
          matchesType = product["type"] == "6mm";
        } else if (selectedType == "8mm") {
          matchesType = product["type"] == "8mm";
        } else if (selectedType == "12.6mm") {
          matchesType = product["type"] == "12.6mm";
        }
      }

      return matchesSearch && matchesPrice && matchesType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = filterProducts();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Browse Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (_) => FilterDialog(
                  selectedPrice: selectedPrice,
                  selectedType: selectedType,
                  onApply: (price, type) {
                    setState(() {
                      selectedPrice = price;
                      selectedType = type;
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search products...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() {
                searchQuery = val;
              }),
            ),
          ),

          // Product Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsPage(product: product),
                    ),
                  ),
                  child: ProductTile(product: product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FilterDialog extends StatefulWidget {
  final String? selectedPrice;
  final String? selectedType;
  final Function(String?, String?) onApply;

  const FilterDialog({
    super.key,
    required this.selectedPrice,
    required this.selectedType,
    required this.onApply,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String? price;
  String? type;

  @override
  void initState() {
    super.initState();
    price = widget.selectedPrice;
    type = widget.selectedType;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Filter Products"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Price"),
          CheckboxListTile(
            title: const Text("Below RM150"),
            value: price == "<150",
            onChanged: (val) {
              setState(() {
                price = val! ? "<150" : null;
              });
            },
          ),
          CheckboxListTile(
            title: const Text("Above RM150"),
            value: price == ">150",
            onChanged: (val) {
              setState(() {
                price = val! ? ">150" : null;
              });
            },
          ),
          const SizedBox(height: 8),
          const Text("Type"),
          CheckboxListTile(
            title: const Text("6mm"),
            value: type == "6mm",
            onChanged: (val) {
              setState(() {
                type = val! ? "6mm" : null;
              });
            },
          ),
          CheckboxListTile(
            title: const Text("8mm"),
            value: type == "8mm",
            onChanged: (val) {
              setState(() {
                type = val! ? "8mm" : null;
              });
            },
          ),
          CheckboxListTile(
            title: const Text("12.6mm"),
            value: type == "12.6mm",
            onChanged: (val) {
              setState(() {
                type = val! ? "12.6mm" : null;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onApply(price, type);
            Navigator.pop(context);
          },
          child: const Text("Apply"),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              price = null;
              type = null;
            });
          },
          child: const Text("Clear"),
        ),
      ],
    );
  }
}


// Product Tile
class ProductTile extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              product["image"],
              width: double.infinity,
              height: 400,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product["name"],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  children: (product["tags"] as List<String>)
                      .map((tag) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(tag,
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.black)),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product["price"],
                  style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                const Text(
                  "View details →",
                  style: TextStyle(
                      color: Color.fromARGB(255, 72, 72, 72),
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
