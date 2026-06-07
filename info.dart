import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  int currentPage = 0;
  bool isEnglish = true;
  final List<Map<String, String>> pages = [
    {
      "image":
      "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
      "title_en": "Win Myo Oo",
    "title_mm": "ဝင်းမျိုးဦး",

      "desc_en":
      "Manage your financial problems easily and efficiently.",

      "desc_mm":
      "ငွေကြေးရေးရာ အခက်အခဲများကိုလွယ်ကူစွာ စီမံခန့်ခွဲနိုင်ရန် ကူညီပေးပါသည်။",
    },
    {
      "image":
      "https://cdn-icons-png.flaticon.com/512/4320/4320337.png",

      "title_en": "Finance Management",
      "title_mm": "ငွေကြေးစီမံခန့်ခွဲမှု",

      "desc_en":
      "Organize and manage your financial activities systematically.",

      "desc_mm":
      "ငွေကြေးဆိုင်ရာလုပ်ငန်းများကို\nစနစ်တကျ စီမံနိုင်စေရန် ကူညီပေးပါသည်။",
    },
    {
      "image":
      "https://cdn-icons-png.flaticon.com/512/2910/2910768.png",

      "title_en": "Security",
      "title_mm": "လုံခြုံမှု",

      "desc_en":
      "Your information is stored safely and securely.",

      "desc_mm":
      "သင့်အချက်အလက်များကို\nလုံခြုံစွာ သိမ်းဆည်းပေးပါသည်။",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE53935), // RED BACKGROUND
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        "🇬🇧",
                        style: TextStyle(fontSize: 30),
                      ),
                      const SizedBox(width: 10),

                      // SWITCH
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isEnglish = !isEnglish;
                          });
                        },

                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),

                          width: 60,
                          height: 32,

                          padding: const EdgeInsets.all(3),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),

                          alignment:
                          isEnglish
                              ? Alignment.centerLeft
                              : Alignment.centerRight,

                          child: Container(
                            width: 26,
                            height: 26,

                            decoration: const BoxDecoration(
                              color: Color(0xffE53935),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      const Text(
                        "🇲🇲",
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  ),

                  const Text(
                    "4.0.4",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // MAIN CARD
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _controller,
                          itemCount: pages.length,
                          onPageChanged: (index) {
                            setState(() {
                              currentPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 25),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  // IMAGE
                                  CircleAvatar(
                                    radius: 70,
                                    backgroundColor:
                                    Colors.red.shade50,
                                    child: Padding(
                                      padding: const EdgeInsets.all(18),
                                      child: Image.network(
                                        pages[index]["image"]!,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 40),

                                  // TITLE
                                  Text(
                                    isEnglish
                                        ? pages[index]["title_en"]!
                                        : pages[index]["title_mm"]!,

                                    textAlign: TextAlign.center,

                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                      color: Color(0xffE53935),
                                    ),
                                  ),
                                  const SizedBox(height: 25),

                                  // DESCRIPTION
                                  Text(
                                    isEnglish
                                        ? pages[index]["desc_en"]!
                                        : pages[index]["desc_mm"]!,

                                    textAlign: TextAlign.center,

                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      height: 1.5,
                                      letterSpacing: 0.3,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      // DOTS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          pages.length,
                              (index) => AnimatedContainer(
                            duration:
                            const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 4),
                            width: currentPage == index ? 24 : 10,
                            height: 8,
                            decoration: BoxDecoration(
                              color: currentPage == index
                                  ? const Color(0xffE53935)
                                  : Colors.grey.shade400,
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      Text(
                        isEnglish
                            ? "Swipe to explore."
                            : "ဆွဲပြီးလေ့လာနိုင်ပါသည်။",

                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // BUTTON
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 25,
                          bottom: 20,
                        ),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: () {},
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children:  [
                                Text(
                                  isEnglish
                                      ? "Enter App"
                                      : "App စတင်ဝင်မည်",

                                  style: TextStyle(
                                    color: Color(0xffE53935),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Color(0xffE53935),
                                  size: 26,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}