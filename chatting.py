from flask import Flask, request, jsonify
from flask_cors import CORS
import joblib
import pandas as pd
import os

app = Flask(__name__)
CORS(app)

MODEL_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "loan_eligibility_model.pkl")
model = joblib.load(MODEL_PATH) if os.path.exists(MODEL_PATH) else None

# အသုံးပြုသူတစ်ဦးချင်းစီရဲ့ အမေးအဖြေ State ကို မှတ်ထားရန် ယာယီ Memory
user_sessions = {}

@app.route('/predict_loan', methods=['POST'])
def predict_loan():
    data = request.get_json()
    # Flutter ဘက်က ရိုက်လိုက်တဲ့ တကယ့်စာသားကို ဖတ်ယူခြင်း
    user_message = data.get('user_message', '').strip()
    
    # ⚠️ ဒီနေရာမှာ လက်ရှိ စမ်းသပ်မှုလွယ်ကူစေရန် single user အနေဖြင့် 'default_user' ဟု သတ်မှတ်ပါမည်
    user_id = 'default_user' 
    
    if user_id not in user_sessions:
        user_sessions[user_id] = {'step': 1, 'data': {}}

    session = user_sessions[user_id]

    # စကားပြောခြင်း အဆင့်ဆင့် Logic
    if session['step'] == 1:
        session['step'] = 2
        return jsonify({'status': 'success', 'loan_eligibility': "မင်္ဂလာပါခင်ဗျာ 🙏 ချေးငွေရနိုင်ခြေကို စစ်ဆေးပေးပါ့မယ်။ သင့်ရဲ့ တစ်နှစ်ဝင်ငွေ (Income Annum) ကို ဂဏန်းသီးသန့် ရိုက်ထည့်ပေးပါဗျာ။"})

    elif session['step'] == 2:
        try:
            session['data']['income_annum'] = float(user_message)
            session['step'] = 3
            return jsonify({'status': 'success', 'loan_eligibility': "ဟုတ်ကဲ့ပါခင်ဗျာ။ လျှောက်ထားလိုတဲ့ ချေးငွေပမာဏ (Loan Amount) ကိုလည်း ဂဏန်းသီးသန့်လေး ရိုက်ပေးပါဦး။"})
        except:
            return jsonify({'status': 'success', 'loan_eligibility': "ကျေးဇူးပြု၍ ဝင်ငွေကို ဂဏန်းသီးသန့် (ဥပမာ - 500000) ပဲ ရိုက်ထည့်ပေးပါဗျာ။"})

    elif session['step'] == 3:
        try:
            session['data']['loan_amount'] = float(user_message)
            session['step'] = 4
            return jsonify({'status': 'success', 'loan_eligibility': "နောက်ဆုံးအနေနဲ့ သင့်ရဲ့ CIBIL Score (Credit Score) ကို ရိုက်ထည့်ပေးပါဗျာ။"})
        except:
            return jsonify({'status': 'success', 'loan_eligibility': "ကျေးဇူးပြု၍ ချေးငွေပမာဏကို ဂဏန်းသီးသန့်ပဲ ရိုက်ထည့်ပေးပါဗျာ။"})

    elif session['step'] == 4:
        try:
            session['data']['cibil_score'] = float(user_message)
            
            # မော်ဒယ်အတွက် လိုအပ်သော ကျန် feature များကို ပုံသေဖြည့်ခြင်း
            feature_names = [
                'no_of_dependents', 'education', 'self_employed', 'income_annum', 
                'loan_amount', 'loan_term', 'cibil_score', 'residential_assets_value', 
                'commercial_assets_value', 'luxury_assets_value', 'bank_asset_value'
            ]
            
            input_dict = {}
            for col in feature_names:
                if col in session['data']:
                    input_dict[col] = [session['data'][col]]
                elif col == 'loan_term':
                    input_dict[col] = [12.0] # ပုံသေ ၁၂ လ ဟု ထည့်ခြင်း
                else:
                    input_dict[col] = [0.0]

            # Model ဖြင့် အဖြေတွက်ခြင်း
            X_inside = pd.DataFrame(input_dict)
            prediction = model.predict(X_inside.values)
            
            result = "ချေးငွေ လျှောက်ထားနိုင်ပါသည် (Eligible) 🎉" if prediction[0] == 1 else "ချေးငွေ လျှောက်ထားရန် သတ်မှတ်ချက် မပြည့်မီပါ (Not Eligible) ❌"
            
            # Session ကို ပြန်ဖျက်ပြီး အစက ပြန်စခိုင်းခြင်း
            del user_sessions[user_id]
            return jsonify({'status': 'success', 'loan_eligibility': f"အချက်အလက်များ အရ သင့်အတွက် ရလဒ်မှာ- {result}\n\nအသစ်ပြန်စစ်ချင်ရင် 'hi' လို့ ထပ်ရိုက်ပေးပါ။"})
            
        except Exception as e:
            del user_sessions[user_id]
            return jsonify({'status': 'success', 'loan_eligibility': "အမှားတစ်ခု ဖြစ်သွားလို့ စစ်ဆေးမှု ပျက်ပြယ်သွားပါပြီ။ 'hi' ဟု ရိုက်ပြီး ပြန်စပေးပါ။"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)