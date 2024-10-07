import 'package:e_commerce/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Splashscreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _Splashscreen();
}

class _Splashscreen extends State<Splashscreen> {
  bool changes = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      reload();
    });
  }

  Future<void> reload() async {
    setState(() {
      changes = true;
    });
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const Producthome()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: changes ? Colors.purple : Colors.blue[800],
        body: Center(
            child: AnimatedContainer(
                curve: Curves.elasticOut,
                decoration: BoxDecoration(
                    color: (changes
                        ? Colors.blue[900]
                        : const Color.fromARGB(255, 218, 39, 188)),
                    shape: changes ? BoxShape.circle : BoxShape.circle),
                width: changes ? 180 : 450,
                height: changes ? 400 : 500,
                duration: const Duration(seconds: 5),
                child: changes
                    ? const Center(
                        child: Text(
                        'G P',
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ))
                    : const Center(
                        child: Text(
                          'Gaurav Pandit',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ))));
  }
}
