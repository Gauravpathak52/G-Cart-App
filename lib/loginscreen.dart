import 'package:e_commerce/homepage.dart';
import 'package:e_commerce/payment.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String name = "";
  bool isShown = false;
  bool changeButton = false;
  final TextEditingController _emailcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  moveToHome(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      var sharedPref = await SharedPreferences.getInstance();
      sharedPref.setBool(ProductDetailState.loginkey, true);

      setState(() {
        changeButton = true;
      });
      await Future.delayed(const Duration(seconds: 3));
      Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const Payment()));
      var snackBar = const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Login',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        changeButton = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 60,
                ),
                SizedBox(
                  height: 200,
                  width: 250,
                  child: Image.asset(
                    'assets/hi.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  'Welcome $name',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailcontroller,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "User name can not be empty";
                          }
                          bool emailValid =
                              RegExp("g@gmail.com").hasMatch(value);
                          if (!emailValid) {
                            return "Please Enter Valid Email";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          name = value;
                          setState(() {});
                        },
                        decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.deepOrange,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 3,
                                )),
                            hintText: 'Enter Email',
                            helperText: 'Please Enter Email',
                            labelText: 'Email'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password  can not be empty";
                          } else if (value.length < 6) {
                            return "Password should be atleast 6";
                          }
                          bool passwordValue = RegExp("Gaurav").hasMatch(value);
                          if (!passwordValue) {
                            return "Please Enter Valid Password";
                          }
                          return null;
                        },
                        obscureText: isShown ? false : true,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                isShown
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: const Color.fromARGB(255, 177, 5, 28),
                              ),
                              onPressed: () {
                                setState(() {
                                  isShown = !isShown;
                                });
                              },
                            ),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.deepOrange,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 3,
                                )),
                            hintText: 'Enter  Password',
                            helperText: 'Please Enter Password',
                            labelText: 'Password'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () => moveToHome(context),
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 2),
                          height: 40,
                          width: changeButton ? 100 : 200,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            shape: changeButton
                                ? BoxShape.circle
                                : BoxShape.rectangle,
                          ),
                          child: changeButton
                              ? const Icon(
                                  Icons.done,
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white),
                                ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
