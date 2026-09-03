# 05 — دليل التطوير والاختبارات وهندسة البناء (Development, Testing & Release)

يحدد هذا الدليل المعايير الهندسية الصارمة، خطوات التحقق والتدقيق الجنائي للبيانات، ومصفوفة الاختبارات الآلية وإجراءات بناء حزم الإنتاج الموقعة لتطبيق **سِراج (SIRAJ v1.0)**.

---

## 🛡️ 1. القيود والمعايير الهندسية الحاكمة (Architectural Guardrails)

لضمان سلامة واستقرار التطبيق وامتثاله التام للأصالة الشرعية، يجب الالتزام بالقواعد الهندسية التالية:

```mermaid
graph TD
    subgraph Guardrails["القيود الهندسية الأربعة الأساسية"]
        G1["1. قيد الاستقلالية والعمل بدون إنترنت (Zero-Network Dependency)"]
        G2["2. قيد الذاكرة الصارم وتدفق الملفات (Zero Memory Spikes & Streaming I/O)"]
        G3["3. قيد سلامة اتصال الخط العربي (HarfBuzz Ligature Preservation)"]
        G4["4. قيد الإغلاق عند فشل البيانات الشرعية (Fail-Closed Integrity)"]
    end
```

1. **الاستقلالية التامة عن الشبكة (Zero Network Dependency)**:
   - يُمنع منعاً باتاً استدعاء أي خادم خارجي أو اشتراط اتصال بالإنترنت لعرض القرآن، الأذكار، التفسير، أو حساب مواقيت الصلاة والقبلة.
2. **منع تراكم الذاكرة عند معالجة الصوتيات (Zero Memory Spikes)**:
   - كافة عمليات فك ضغط حزم التلاوات واستخراجها يجب أن تتم عبر تدفق مباشر من القرص للقرص (`InputFileStream` و `OutputFileStream`) مع استدعاء `file.clear()` فوراً بعد كل ملف صوتي.
3. **سلامة اتصال الخط العربي (HarfBuzz Ligature Preservation)**:
   - يُمنع تجزئة الكلمات القرآنية بأنماط خطوط مختلفة (`FontWeight.bold`) داخل الكلمة الواحدة للحفاظ على ترابط الحروف العربية بنسبة 100%.
4. **النزاهة الشرعية والإغلاق عند الفشل (Fail-Closed Integrity)**:
   - في حال تلف أي ملف بيانات، يرفض التطبيق عرض محتوى غير مؤكد ويعود فوراً للنسخة المعتمدة والمثبتة.

---

## 🧪 2. مصفوفة الاختبارات الآلية (Automated Testing Matrix)

يحتوي المشروع على منظومة اختبارات تغطي كافة المستويات الهندسية والوظيفية:

```bash
# تشغيل كامل مصفوفة الاختبارات
flutter test
```

### مصفوفة الاختبارات الأساسية (Core Test Matrix):

| ملف الاختبار | المجال والوحدة | سيناريوهات التحقق والفحص |
| :--- | :--- | :--- |
| **`test/modules/quran/quran_offline_audio_service_test.dart`** | خدمة التلاوة بدون إنترنت | • فك ضغط حزم ZIP بنظام التدفق بدون تراكم في الذاكرة<br>• فحص سلامة ملفات الآيات من `001001.mp3` إلى `114006.mp3`<br>• التعامل مع ملفات ZIP التالفة أو الفارغة وإرجاع رسائل خطأ واضحة<br>• التحقق من مسارات التخزين وحذف الكاش بنجاح |
| **`test/shell/quran_reader_screen_test.dart`** | شاشة وقارئ المصحف الشريف | • عرض السور والأجزاء والتنقل الفوري<br>• اختبار الفواصل المرجعية وإضافتها وحذفها<br>• التحقق من مطابقة الرسم العثماني وعلامات نهاية الآيات |
| **`test/shell/quran_audio_radio_and_features_test.dart`** | مشغل التلاوة والإذاعات | • اختبار التبويبات الفرعية لمشغل التلاوة والإذاعة القرآنية<br>• التحكم في سرعات التلاوة، التكرار، والتمرير التلقائي |

---

## 🔍 3. التحليل الساكن وضبط الجودة (Static Analysis & Linting)

يخضع المشروع لقواعد تحليل ساكن صارمة محددة في `analysis_options.yaml`:

```bash
# التحقق من خلو المشروع تماماً من الأخطاء والتحذيرات
flutter analyze
```

> **معيار القبول الإلزامي (Zero Warnings Gate)**:
> يجب أن تكون النتيجة: **`No issues found!`** (0 أخطاء و0 تحذيرات و0 تلميحات غير مقبولة).

---

## 📦 4. دليل بناء حزم الإنتاج الرسمية (Production Release Build)

```mermaid
sequenceDiagram
    autonumber
    actor Developer as المطور
    participant Analyzer as الفحص والتحليل (Flutter Analyze)
    participant Tester as مصفوفة الاختبارات (Flutter Test)
    participant Gradle as محرك البناء (Android Gradle & R8)
    participant APK as الحزمة النهائية (Release APK)

    Developer->>Analyzer: تشغيل flutter analyze
    Analyzer-->>Developer: No issues found!
    Developer->>Tester: تشغيل flutter test
    Tester-->>Developer: All tests passed! (100% Green)
    Developer->>Gradle: flutter build apk --release
    Gradle->>Gradle: تطبيق Tree-Shaking للأيقونات والخطوط
    Gradle->>Gradle: حماية الكود وضغطه وتوقيع الحزمة (V2/V3 Signing)
    Gradle-->>APK: إنتاج build/app/outputs/flutter-apk/app-release.apk
```

### أمر البناء الرسمي:
```bash
flutter build apk --release
```

### مواصفات الحزمة الناتجة:
- **المسار**: `build/app/outputs/flutter-apk/app-release.apk`
- **الحجم الإجمالي**: ~443.0 ميجابايت (متضمنة كافة الخطوط، البيانات العثمانية، الترجمات الـ 11، والتلاوة التأسيسية المدمجة).
- **التوافق**:
  - الحد الأدنى لإصدار أندرويد: **Android 6.0 (Marshmallow - API 23)**.
  - الإصدار المستهدف: **Android 14 (API 34)**.
  - المعماريات المدعومة: `arm64-v8a`, `armeabi-v7a`, `x86_64`.

