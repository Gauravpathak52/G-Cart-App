import 'package:e_commerce/homepage.dart';
import 'package:e_commerce/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Payment extends StatelessWidget {
  const Payment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 330,
            width: 250,
            child: Image.asset(
              'assets/gaurav.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          const Text('Welcome to Gaurav'),
          const SizedBox(
            height: 12,
          ),
          Center(
              child: ElevatedButton(
                  onPressed: () {}, child: const Text('Payment'))),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            tileColor: Colors.blue[200],
            title: const Text('Logout'),
            leading: const Icon(Icons.logout),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ));
              var snackBar = const SnackBar(
                backgroundColor: Colors.red,
                content: Text('Logout',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              var sharedPref = await SharedPreferences.getInstance();
              sharedPref.setBool(ProductDetailState.loginkey, false);
            },
          )
        ],
      ),
    );
  }
}
