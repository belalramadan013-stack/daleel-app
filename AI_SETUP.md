# ربط المساعد الذكي بنموذج ذكاء اصطناعي

## الإعداد

### 1. الحصول على مفتاح API

**خيار أ: OpenAI**
1. اذهب إلى https://platform.openai.com
2. أنشئ حساباً أو سجل الدخول
3. اذهب إلى API Keys وأنشئ مفتاحاً جديداً

**خيار ب: مزود آخر متوافق مع OpenAI API**
- Groq (مجاني وسريع)
- Together AI
- أي مزود يدعم Chat Completions API

### 2. تحديث الإعدادات

افتح الملف:
```
lib/services/ai_service.dart
```

غيّر القيم التالية:
```dart
static const String _apiKey = 'sk-your-actual-api-key';
static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';
static const String _model = 'gpt-4o-mini';
```

### 3. لـ Groq (مجاني):
```dart
static const String _apiKey = 'gsk_your-groq-key';
static const String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
static const String _model = 'llama-3.1-70b-versatile';
```

### 4. تشغيل التطبيق
```bash
flutter pub get
flutter run
```

## ملاحظات

- بدون مفتاح API، يعمل التطبيق بالردود المحلية المدمجة
- يتم حفظ آخر 10 رسائل في السياق للمحادثة المتصلة
- الردود تتضمن تنويهاً بأنها للإرشاد فقط
