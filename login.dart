import 'package:flutter/material.dart';
import 'package:loan_application/pages/register.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() =>
      _MotherFinanceLoginPageState();
}

class _MotherFinanceLoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        //width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ Color.fromARGB(255, 191, 0, 19),Color.fromARGB(255, 235, 242, 241)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only( top: 80.0),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Container(
                  //   margin: const EdgeInsets.all(15),
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 15,
                  //     vertical: 12,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: Colors.deepOrange,
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   child: const Row(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Icon(Icons.info_outline, color: Colors.white),
                  //       SizedBox(width: 10),
                  //       // Expanded(
                  //       //   child: Text(
                  //       //     "သင်၏ဖုန်း / SIM Card ပျောက်ဆုံးပါက Mother Finance Facebook Page Messenger ကို ဆက်သွယ်ပေးပါ။",
                  //       //     style: TextStyle(
                  //       //       color: Colors.white,
                  //       //       fontSize: 13,
                  //       //     ),
                  //       //   ),
                  //       // ),
                  //     ],
                  //   ),
                  // ),

              Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                        // Image.asset(
                        //   "assets/images/mother_finance_logo.png",
                        //   height: 90,
                        // ),

                        const SizedBox(height: 10),

                        const Text(
                          "Mother Finance",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 30),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "ဖုန်းနံပါတ်",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '🇲🇲 +95',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: TextFormField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                maxLength: 11,

                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "ဖုန်းနံပါတ် ဖြည့်ပါ";
                                  }

                                  if (!RegExp(r'^09\d{7,9}$').hasMatch(value)) {
                                    return "မှန်ကန်သော ဖုန်းနံပါတ် ထည့်ပါ";
                                  }

                                  return null;
                                },

                                decoration: InputDecoration(
                                  hintText: "ဖုန်းနံပါတ်",
                                  prefixIcon: const Icon(Icons.phone_android),
                                  helperText: " ",

                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                    const SizedBox(height: 8),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'ဖုန်းနံပါတ်ကို "09" စတင်ပြီး အပြည့်အစုံရိုက်ထည့်ပေးပါ',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 191, 0, 19),
                          fontSize: 12,
                        ),
                      ),
                    ),

                        const SizedBox(height: 25),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "လျှို့ဝှက်နံပါတ်",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                    TextFormField(
                      controller: passwordController,
                      obscureText: obscurePassword,

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "လျှို့ဝှက်နံပါတ် ဖြည့်ပါ";
                        }

                        if (value.length < 6) {
                          return "လျှို့ဝှက်နံပါတ် အနည်းဆုံး 6 လုံးရှိရမည်";
                        }

                        // အက္ခရာ + ဂဏန်း ပါရမည်
                        if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) {
                          return "အင်္ဂလိပ်စာလုံးနှင့် ဂဏန်း ပါဝင်ရမည်";
                        }

                        return null;
                      },

                      decoration: InputDecoration(
                        hintText: "လျှို့ဝှက်နံပါတ်",
                        prefixIcon: const Icon(Icons.lock_outline),
                        helperText: " ",
                        helperStyle: const TextStyle(height: 0.8),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                        const SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Login Success"),
                                  ),
                                );

                                // Login API Call
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              Color.fromARGB(255, 191, 0, 19),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "အကောင့်သို့ဝင်မည်",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: OutlinedButton(
                            onPressed: () {
                              // Register Page
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => Register())
                              );


                            },
                            style: OutlinedButton.styleFrom(

                              side: const BorderSide(
                                color: Color.fromARGB(255, 191, 0, 19),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "အကောင့်အသစ်ဖွင့်မည်",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "လျှို့ဝှက်နံပါတ်မေ့နေပါသလား",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ),

                  const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "သဘောတူချက်၊ ကန့်သတ်ချက်၊ Contact License",
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}