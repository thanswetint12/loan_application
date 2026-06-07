import 'package:flutter/material.dart';


class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mother Finance Showcase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 191, 0, 19),
        useMaterial3: true,
      ),
      home: const BilingualLoginScreen(),
    );
  }
}

class BilingualLoginScreen extends StatefulWidget {
  const BilingualLoginScreen({Key? key}) : super(key: key);

  @override
  State<BilingualLoginScreen> createState() => _BilingualLoginScreenState();
}

class _BilingualLoginScreenState extends State<BilingualLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _nrcNumberController = TextEditingController();
  
  bool _isMyanmar = true; 

  // မူရင်း App အတိုင်း ပြည်နယ်နှင့် တိုင်းဒေသကြီး စာရင်း
  final List<String> _statePrefixes = [
    '၁/(ကချင်ပြည်နယ်)',
    '၂/(ကယားပြည်နယ်)',
    '၃/(ကရင်ပြည်နယ်)',
    '၄/(ချင်းပြည်နယ်)',
    '၅/(စစ်ကိုင်းတိုင်းဒေသကြီး)',
    '၆/(တနင်္သာရီတိုင်းဒေသကြီး)',
    '၇/(ပဲခူးတိုင်းဒေသကြီး)',
    '၈/(မကွေးတိုင်းဒေသကြီး)',
    '၉/(မန္တလေးတိုင်းဒေသကြီး)',
    '၁၀/(မွန်ပြည်နယ်)',
    '၁၁/(ရခိုင်ပြည်နယ်)',
    '၁၂/(ရန်ကုန်တိုင်းဒေသကြီး)',
    '၁၃/(ရှမ်းပြည်နယ်)',
    '၁၄/(ဧရာဝတီတိုင်းဒေသကြီး)',
    '၉/(နေပြည်တော်)'
  ];

  // မြို့နယ်တိုကုဒ်များ (တိုင်းဒေသကြီးအလိုက် ချိတ်ဆက်မှုမြေပုံ)
  final Map<String, List<String>> _townshipData = {
    '၁/(ကချင်ပြည်နယ်)': ['မကန', 'ဝမန', 'မဂန'],
    '၅/(စစ်ကိုင်းတိုင်းဒေသကြီး)': ['ကန', 'မမန', 'ရခန'],
    '၈/(မကွေးတိုင်းဒေသကြီး)': ['မမန', 'ရနခ', 'ခမန', 'နမန', 'မသန'],
    '၉/(မန္တလေးတိုင်းဒေသကြီး)': ['မအမ', 'ချအသ', 'ပြင်ဦးလွင်'],
    '၁၂/(ရန်ကုန်တိုင်းဒေသကြီး)': ['မကန', 'ရနခ', 'ခမန', 'နမန', 'မသန', 'တတက', 'မဘန', 'ပဖန', 'စလန', 'ကမန'],
  };

  String? _selectedState;
  String? _selectedTownship;

  Map<String, String> get _text => _isMyanmar ? _mmText : _enText;
  
  final _enText = {
    'phoneLabel': 'Phone Number',
    'phoneHint': 'Enter your active mobile number...',
    'phoneSub': 'Please enter full phone number starting with "09"',
    'nrcLabel': 'NRC Identification',
    'stateHint': 'State/',
    'townshipHint': 'Township',
    'nrcHint': 'Number',
    'button': 'Continue',
    'valState': 'Select state',
    'valTownship': 'Select township',
    'valNrc': 'Required',
  };

  final _mmText = {
    'phoneLabel': 'ဖုန်းနံပါတ်',
    'phoneHint': 'ပုံမှန်ကိုင်နေကျ ဖုန်းနံပါတ်...',
    'phoneSub': 'ဖုန်းနံပါတ်ကို "09" စတင်ပြီး အပြည့်အစုံရိုက်ထည့်ပေးပါ',
    'nrcLabel': 'မှတ်ပုံတင်အမှတ်',
    'stateHint': 'တိုင်း/',
    'townshipHint': 'မြို့နယ်',
    'nrcHint': 'နံပါတ်',
    'button': 'ရှေ့ဆက်ရန်',
    'valState': 'ရွေးရန်',
    'valTownship': 'မြို့နယ်ရွေးရန်',
    'valNrc': 'လိုအပ်သည်',
  };

  @override
  void dispose() {
    _phoneController.dispose();
    _nrcNumberController.dispose();
    super.dispose();
  }

  void _handleAuthenticationPipeline() {
    if (_formKey.currentState!.validate()) {
      final inputNrc = _nrcNumberController.text.trim();

      if (inputNrc == "000000") {
        _showLocalizedErrorDialog();
      } else if (inputNrc == "111111") {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const DashboardPage()));
      }
    }
  }

  void _showLocalizedErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
            Text(_isMyanmar ? "အမှားအယွင်း" : "Authentication Error"),
          ],
        ),
        content: Text(_isMyanmar 
          ? "မှတ်ပုံတင်အမှတ် သို့မဟုတ် အချက်အလက် မှားယွင်းနေပါသည်။" 
          : "Invalid NRC format or mismatched credentials database payload."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Row(
            children: [
              Text("EN", style: TextStyle(color: !_isMyanmar ? Colors.white : Colors.white60, fontWeight: FontWeight.bold)),
              Switch(
                value: _isMyanmar,
                activeColor: Color.fromARGB(255, 191, 0, 19),
                activeTrackColor: Colors.white,
                inactiveThumbColor: Color.fromARGB(255, 191, 0, 19),
                inactiveTrackColor:  Colors.white,
                onChanged: (v) => setState(() => _isMyanmar = v),
              ),
              Text("မြန်မာ ", style: TextStyle(color: _isMyanmar ? Colors.white : Colors.white60, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ Color.fromARGB(255, 191, 0, 19),Color.fromARGB(255, 235, 242, 241)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  Container(
                                    height: 75,
                                    width: 75,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.amber, width: 2),
                                    ),
                                    child: const Icon(Icons.face_retouching_natural, size: 45, color: Colors.orange),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Mother Finance',
                                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),

                            Text(_text['phoneLabel']!, style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text('🇲🇲 +95 ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    maxLength: 11,
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    decoration: _customInputStyle(_text['phoneHint']!).copyWith(
                                      suffixIcon: const Icon(
                                        Icons.help_outline,
                                        color: Colors.grey,
                                        size: 18,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return _isMyanmar
                                            ? 'ဖုန်းနံပါတ် ဖြည့်ပါ'
                                            : 'Phone number is required';
                                      }

                                      if (!RegExp(r'^09\d{7,9}$').hasMatch(value.trim())) {
                                        return _isMyanmar
                                            ? 'မှန်ကန်သော ဖုန်းနံပါတ်ထည့်ပါ'
                                            : 'Enter a valid phone number';
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(_text['phoneSub']!, style: const TextStyle(color: Colors.black, fontSize: 11)),
                            const SizedBox(height: 20),

                            Text(_text['nrcLabel']!, style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // [ပြင်ဆင်ပြီး] တိုင်း/ပြည်နယ် Dropdown - စာသားအပြည့်အစုံမြင်ရအောင် လုပ်ဆောင်ထားသည်။
                                Expanded(
                                  flex: 38,
                                  child: SizedBox(
                                    height: 78,
                                    child: DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      value: _selectedState,
                                      hint: Text(
                                        _text['stateHint']!,
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                      decoration: _customInputStyle(''),
                                      items: _statePrefixes.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: const TextStyle(fontSize: 11),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          _selectedState = newValue;
                                          _selectedTownship = null;
                                        });
                                      },
                                      validator: (v) => v == null ? _text['valState'] : null,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4,),

                                Expanded(
                                  flex: 28,
                                  child: SizedBox(
                                    height: 78,
                                    child: DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      value: _selectedTownship,
                                      hint: Text(
                                        _text['townshipHint']!,
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                      decoration: _customInputStyle('').copyWith(
                                        suffixIcon: _selectedState == null
                                            ? const Icon(Icons.error, color: Colors.red, size: 14)
                                            : null,
                                      ),
                                      items: (_selectedState != null &&
                                          _townshipData.containsKey(_selectedState))
                                          ? _townshipData[_selectedState]!
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        );
                                      }).toList()
                                          : [],
                                      onChanged: (newValue) =>
                                          setState(() => _selectedTownship = newValue),
                                      validator: (v) =>
                                      v == null ? _text['valTownship'] : null,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),

                                Expanded(
                                  flex: 34,
                                  child: SizedBox(
                                    height: 78,
                                    child: TextFormField(
                                      maxLength: 6,
                                      controller: _nrcNumberController,
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(fontSize: 13),
                                      decoration: _customInputStyle(_text['nrcHint']!),
                                      validator: (value) {
                                        if (value == null || value.trim().isEmpty) {
                                          return _isMyanmar
                                              ? 'NRC နံပါတ် ဖြည့်ပါ'
                                              : 'NRC number is required';
                                        }

                                        if (!RegExp(r'^\d{6}$').hasMatch(value.trim())) {
                                          return _isMyanmar
                                              ? 'လိုအပ်သည်'
                                              : 'NRC number must be exactly 6 digits';
                                        }

                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 36),

                            ElevatedButton(
                              onPressed: _handleAuthenticationPipeline,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                backgroundColor: Color.fromARGB(255, 191, 0, 19), 
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                elevation: 0,
                              ),
                              child: Text(_text['button']!, style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Contact License Agreement, Information Collection and Use Rules, Privacy Policy & Terms and Conditions',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 10, height: 1.4),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _customInputStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 14), // Padding ကို အနည်းငယ် လျှော့ချထားသည်
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[200]!)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF00BFA5), width: 1.5)),
      errorStyle: const TextStyle(fontSize: 10, height: 1),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(backgroundColor: Colors.teal, title: const Text("Dashboard Status")),
        body: const Center(child: Text("Welcome! Existing Account verified via Python Core System.")),
      );
}

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(backgroundColor: Colors.orange, title: const Text("KYC Registration")),
        body: const Center(child: Text("Account profile entry not detected. Please register credentials here.")),
      );
}