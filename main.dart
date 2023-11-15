import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class Product {
  String name;
  int price;
  int stock;

  Product(this.name, this.price, this.stock);
}

class ProductList with ChangeNotifier {
  List<Product> _products = [
    Product('Beras', 18000, 100),
    Product('Minyak Goreng', 10000, 70),
    Product('Gula', 5000, 30),
    Product('Mie Instant', 3000, 50),
    Product('Telur', 12000, 50),
    Product('Kopi', 15000, 50),
    Product('Asbak', 22000, 10),
    Product('Gelas', 12000, 30),
    Product('Mangkok', 42000, 20),
    Product('Kabel', 25000, 10),
  ];

  String _query = '';

  List<Product> get filteredProducts {
    return _query.isEmpty
        ? _products
        : _products
            .where((product) =>
                product.name.toLowerCase().contains(_query.toLowerCase()))
            .toList();
  }

  List<Product> get products => _products;

  set query(String value) {
    _query = value;
    notifyListeners();
  }

  void deleteProduct(Product product) {
    _products.remove(product);
    notifyListeners();
  }

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductList()),
      ],
      child: MaterialApp(
        home: LoginScreen(),
        theme: ThemeData(
          primaryColor: Colors.teal,
          scaffoldBackgroundColor: Colors.white,
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
            subtitle1: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              onPrimary: Colors.white,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.teal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GUDANG SELATAN'),
        centerTitle: true, // Center the title
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: SizedBox(
          height: 300,
          child: Card(
            // Add the color property to set the background color
            color: Colors.teal,
            margin: EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 20),
                    _buildTextField(
                        'Username', Icons.person, usernameController),
                    SizedBox(height: 20),
                    _buildTextField(
                        'Password', Icons.lock, passwordController, true),
                    SizedBox(height: 20),
                    _buildElevatedButton('Login', _performLogin),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String labelText, IconData prefixIcon, TextEditingController controller,
      [bool obscureText = false]) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        prefixIcon: Icon(prefixIcon),
      ),
      onSubmitted: (_) => _performLogin(),
    );
  }

  Widget _buildElevatedButton(String label, void Function() onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.green,
        onPrimary: Colors.white,
        elevation: 3,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      ),
      child: Text(label, style: TextStyle(fontSize: 18)),
    );
  }

  void _performLogin() {
    if (usernameController.text == 'tugas' &&
        passwordController.text == '3337210023') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductListScreen()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title:
              Text('Invalid Credentials', style: TextStyle(color: Colors.red)),
          content: Text('Please check your username and password.',
              style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK', style: TextStyle(color: Colors.teal)),
            ),
          ],
        ),
      );
    }
  }
}

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var productList = Provider.of<ProductList>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('GUDSEL PRODUCT LIST'),
        centerTitle: true, // Center the title
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                productList.query = value;
              },
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: productList.filteredProducts.length,
              itemBuilder: (context, index) {
                final product = productList.filteredProducts[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Card(
                    elevation: 3,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            'Price: ${formatCurrency(product.price)}', // Format the price
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.teal,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Stock: ${product.stock}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.teal,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteProduct(context, product),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _addProduct(context),
          tooltip: 'Add Product',
          child: Icon(Icons.add),
          backgroundColor: Colors.green),
      bottomNavigationBar: BottomAppBar(
        color: Colors.teal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.logout, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  String formatCurrency(int amount) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
    return formatCurrency.format(amount);
  }

  void _deleteProduct(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Product'),
          content: Text('Are you sure you want to delete ${product.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Provider.of<ProductList>(context, listen: false)
                    .deleteProduct(product);
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _addProduct(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController nameController = TextEditingController();
        TextEditingController priceController = TextEditingController();
        TextEditingController stockController = TextEditingController();

        return AlertDialog(
          title: Text('Add Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField('Product Name', null, nameController),
              SizedBox(height: 10),
              _buildTextField('Product Price', null, priceController, false,
                  TextInputType.number),
              SizedBox(height: 10),
              _buildTextField('Product Stock', null, stockController, false,
                  TextInputType.number),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _validateAndAddProduct(
                    context, nameController, priceController, stockController);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(
      String labelText, IconData? prefixIcon, TextEditingController controller,
      [bool obscureText = false, TextInputType? keyboardType]) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
    );
  }

  void _validateAndAddProduct(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController priceController,
    TextEditingController stockController,
  ) {
    var productList = Provider.of<ProductList>(context, listen: false);

    if (nameController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        stockController.text.isNotEmpty) {
      Product newProduct = Product(
        nameController.text,
        int.parse(priceController.text),
        int.parse(stockController.text),
      );

      productList.addProduct(newProduct);

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields.'),
        ),
      );
    }
  }
}
