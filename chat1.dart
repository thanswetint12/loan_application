import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatBotUI1 extends StatefulWidget {
  const ChatBotUI1({super.key});

  @override
  _ChatBotUIState createState() => _ChatBotUIState();
}

class _ChatBotUIState extends State<ChatBotUI1> with TickerProviderStateMixin {
  final TextEditingController messageController = TextEditingController();
  final List<Map<String, String>> messages = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // App စတင်ပွင့်ချိန်တွင် Bot မှ လှပစွာ နှုတ်ဆက်စာသား အော်တိုပြသပေးခြင်း
    _addMessage("Bot", "Hey there 👋\nချေးငွေရနိုင်ခြေ စစ်ဆေးပေးဖို့အတွက် 'hi' သို့မဟုတ် စာတစ်ကြောင်း ရိုက်ပို့ပေးပါဗျာ။");
  }

  // AnimatedList တွင် Message စနစ်တကျ တိုးရန်နှင့် Auto Scroll ဆင်းရန် Function
  void _addMessage(String sender, String text) {
    messages.add({"sender": sender, "text": text});
    _listKey.currentState?.insertItem(messages.length - 1, duration: const Duration(milliseconds: 200));

    // Auto Scroll to Bottom - အောက်ဆုံးသို့ အလိုအလျောက် ရွှေ့ပေးခြင်း
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> askQuestion(String question) async {
    // ၁။ လူသားရိုက်လိုက်သည့် မက်ဆေ့ခ်ျကို အရင်ပြသခြင်း
    _addMessage("You", question);

    // ၂။ Bot စာရိုက်နေသည့် ပုံစံ Animation (၃ စက်ခုန်ခြင်း) အား ဖွင့်လိုက်ခြင်း
    setState(() {
      _isTyping = true;
    });

    try {
      // ⚠️ သတိပြုရန်: သင့် Flask Server ရဲ့ IP လိပ်စာ (192.168.1.7 သို့မဟုတ် 192.168.1.45) ကို သေချာအောင် စစ်ဆေးပြင်ဆင်ပါ
      var response = await http.post(
        Uri.parse('http://10.237.223.134:5000/predict_loan'), 
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'user_message': question, // 👈 ဤနေရာတွင် အသေကိန်းများအစား လူရိုက်လိုက်သည့် စာသားကို တိုက်ရိုက်ပေးပို့လိုက်ပါပြီ
        }),
      ).timeout(const Duration(seconds: 10));

      // ၃။ ဆာဗာထံမှ အဖြေရလျှင် Typing Animation ပြန်ပိတ်ခြင်း
      setState(() {
        _isTyping = false;
      });

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        // Flask ဘက်မှ ပြန်လာသော စကားပြောစာသားကို ယူခြင်း
        String botResponse = responseData['loan_eligibility']?.toString() ?? "ရလဒ် ရှာမတွေ့ပါ";
        _addMessage("Bot", botResponse);
      } else {
        _addMessage("Bot", "ဆာဗာဘက်မှ အမှားပြနေပါသည် (Error: ${response.statusCode})");
      }
    } catch (e) {
      setState(() {
        _isTyping = false;
      });
      _addMessage("Bot", "ဆာဗာသို့ ချိတ်ဆက်၍မရပါ။ ဖုန်းနှင့် ကွန်ပျူတာ Wifi ကွန်ရက်တစ်ခုတည်း ချိတ်ထားမထား စစ်ဆေးပါ။");
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ပုံထဲကအတိုင်း ခရမ်းရောင် သို့မဟုတ် ပန်းရောင်ရင့်ရင့် (Pink/Red Accent) ပြောင်းလဲအသုံးပြုနိုင်ပါတယ်
    final primaryColor = const Color.fromARGB(255, 213, 14, 81); // ပုံထဲက ပန်းရောင်ရင့်ရင့် ဒီဇိုင်းအမှန်

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            const Text(
              "Chatbot",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 28),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat Messages List
          Expanded(
            child: AnimatedList(
              key: _listKey,
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              initialItemCount: messages.length,
              itemBuilder: (context, index, animation) {
                final msg = messages[index];
                final isUser = msg["sender"] == "You";

                return SlideTransition(
                  position: animation.drive(
                    Tween<Offset>(
                      begin: Offset(isUser ? 0.2 : -0.2, 0.0),
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.easeOutCubic)),
                  ),
                  child: FadeTransition(
                    opacity: animation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isUser) ...[
                            CircleAvatar(
                              backgroundColor: primaryColor,
                              radius: 16,
                              child: const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 16),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Container(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: isUser ? primaryColor : const Color(0xFFf0f2f9),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: Radius.circular(isUser ? 16 : 4),
                                bottomRight: Radius.circular(isUser ? 4 : 16),
                              ),
                            ),
                            child: Text(
                              msg["text"] ?? "",
                              style: TextStyle(
                                color: isUser ? Colors.white : Colors.black87,
                                fontSize: 15,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Typing Indicator (စက်ဝိုင်း ၃ စက်ခုန်သည့် Animation)
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: primaryColor,
                    radius: 16,
                    child: const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFf0f2f9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (index) => _buildDot(index)),
                    ),
                  ),
                ],
              ),
            ),

          // Message Input Bar
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24, top: 8),
            decoration: const BoxDecoration(color: Colors.white),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        hintText: "Message...",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) {
                        if (messageController.text.trim().isNotEmpty) {
                          askQuestion(messageController.text.trim());
                          messageController.clear();
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.sentiment_satisfied_alt_outlined, color: Colors.grey.shade500),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: primaryColor),
                    onPressed: () {
                      if (messageController.text.trim().isNotEmpty) {
                        askQuestion(messageController.text.trim());
                        messageController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Typing Dot Animation Builder
  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 150)),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.grey.shade500.withOpacity(0.3 + (value * 0.7)),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}