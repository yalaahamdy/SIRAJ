<p align="center">
  <img src="assets/images/siraj_logo.png" alt="SIRAJ Logo" width="120" height="120" onerror="this.src='icon.png'"/>
</p>

<h1 align="center">سِراج | SIRAJ</h1>

<p align="center">
  <strong>المنصة الإسلامية الشاملة والمفتوحة المصدر المبنية بأحدث تقنيات Flutter و Clean Architecture</strong><br>
  <em>The Comprehensive, Privacy-First, Offline-Capable Islamic Application built with Flutter & Modular DDD Architecture</em>
</p>

<p align="center">
  <a href="#-الميزات-الرئيسية--key-features"><img src="https://img.shields.io/badge/Flutter-3.24+-02569B?style=flat&logo=flutter&logoColor=white" alt="Flutter Version"/></a>
  <a href="#-الميزات-الرئيسية--key-features"><img src="https://img.shields.io/badge/Dart-3.5+-0175C2?style=flat&logo=dart&logoColor=white" alt="Dart Version"/></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-green.svg?style=flat" alt="License: MIT"/></a>
  <a href=".github/workflows/ci.yml"><img src="https://img.shields.io/badge/CI-Passing-brightgreen?style=flat&logo=github-actions" alt="Build Status"/></a>
  <a href="#-الاختبارات-والجودة--quality-assurance"><img src="https://img.shields.io/badge/Tests-187%20Passed-success?style=flat" alt="Tests Passed"/></a>
  <a href="#-الخصوصية-والأمان--privacy--security"><img src="https://img.shields.io/badge/Privacy-100%25%20Local--First-blueviolet?style=flat" alt="Privacy Local-First"/></a>
</p>

---

## 📖 جدول المحتويات | Table of Contents
- [نظرة عامة | Overview](#-نظرة-عامة--overview)
- [الميزات الرئيسية | Key Features](#-الميزات-الرئيسية--key-features)
- [المعمارية البرمجية | Architecture](#-المعمارية-البرمجية--architecture)
- [حزمة التلاوات والقراء | Reciters & Audio Engine](#-حزمة-التلاوات-والقراء--reciters--audio-engine)
- [تثبيت وبناء التطبيق | Installation & Build](#-تثبيت-وبناء-التطبيق--installation--build)
- [الاختبارات والجودة | Quality Assurance](#-الاختبارات-والجودة--quality-assurance)
- [الخصوصية والأمان | Privacy & Security](#-الخصوصية-والأمان--privacy--security)
- [دليل المساهمة | Contributing](#-دليل-المساهمة--contributing)
- [الترخيص | License](#-الترخيص--license)

---

## 🌟 نظرة عامة | Overview

**تطبيق سِراج (SIRAJ)** هو مشروع إسلامي رقمي متطور، صُمم ليكون المرجع والرفيق اليومي الشامل للمسلم في شتى بقاع الأرض. تم بناء التطبيق بأعلى المعايير الهندسية المعاصرة ليعمل **بدون اتصال بالإنترنت (Offline-First)** بالكامل، مع الحفاظ المطلق على خصوصية المستخدم وانعدام التتبع أو جمع البيانات.

**SIRAJ** is an enterprise-grade, open-source Islamic super-app built with Flutter. It combines sacred Islamic heritage with modern software engineering: offline-first operation, local AI-assisted Quran recitation verification, millimeter-accurate astronomical prayer algorithms, sensor-fused Qibla compass, complete Sahih Hadith corpora, comprehensive Fiqh guides, dynamic multi-currency Zakat calculations, and interactive Hajj & Umrah visualizers.

---

## ✨ الميزات الرئيسية | Key Features

### 📖 1. القرآن الكريم والمصحف الشريف (Holy Quran)
* **عرض مصحفي عالي الدقة (Medina Mushaf)**: محاكاة صفحة بصفحة مطابقة لمصحف المدينة النبوية (مجمع الملك فهد) بدقة 604 صفحات، مع دعم وضع التمرير الرأسي ووضع التقليب الأفقي المتصل بانسيابية فائقة بين السور.
* **محرك تسميع ذكي (Local Recitation Tester)**: خوارزمية ذكية لمطابقة التسميع الصوتي لحظياً، مع كشف الكلمات وتلوين الأخطاء ومعالجة نافذة الكلمات الثلاث المتزامنة لتجربة تسميع مرنة ودقيقة.
* **مكتبة تلاوات تضم أشهر 40+ قارئاً**: دعم التلاوات المرتلة والمجودة والمصحف المعلم من كبار قراء العالم الإسلامي مع إمكانية استيراد حزم MP3 المضغوطة (ZIP) وتشغيلها بدون إنترنت.
* **التفاسير والترجمات وإعراب الكلمات**: إمكانية الوصول الفوري لتفسير الآيات، معجم الكلمات واللغويات، والترجمات العالمية المعتمدة.

### 🕌 2. مواقيت الصلاة والأذان والقبلة (Prayer & Qibla)
* **حسابات فلكية دقيقة بدون إنترنت**: دعم طرق الحساب المعتمدة عالمياً (أم القرى، رابطة العالم الإسلامي، الهيئة المصرية العامة للمساحة، جامعة العلوم الإسلامية بكراتشي، وغيرها).
* **إدارة التنبيهات والأذان بصوت كبار المؤذنين**: تشغيل صوت الأذان الشريف كاملاً في الخلفية مع تخصيص تنبيهات كل صلاة على حدة.
* **بوصلة القبلة الدقيقة ثلاثية الأبعاد**: دمج حساسات الجيروسكوب ومقياس المغناطيسية لتحديد زاوية الكعبة المشرفة مع مؤشر موثوقية المعايرة.

### 📿 3. الأذكار وحصن المسلم (Adhkar & Hisn Al-Muslim)
* **موسوعة الأذكار المبوّبة**: أذكار الصباح والمساء، أذكار الصلاة، النوم، الاستيقاظ، وأدعية المناسبات مع التخريج والتوثيق من الأحاديث الصحيحة.
* **المسبحة الإلكترونية التفاعلية**: عداد ذكي مع دعم الاهتزاز اللمسي (Haptic Feedback) والتكرار التلقائي ومؤشرات الإنجاز.

### 💰 4. محرك وحاسبة الزكاة الذكية (Zakat Engine)
* **معايير النصاب الشرعي الدقيقة**: احتساب نصاب الذهب والفضة مع دعم متعدد للعملات العالمية والإقليمية.
* **أصناف الأموال الشاملة**: الذهب، الفضة، السيولة النقدية، الأسهم، عروض التجارة، العقارات الاستثمارية، والديون.

### 📚 5. موسوعة الحديث والفقه والسيرة النبوية (Knowledge, Hadith & Seerah)
* **دواوين الحديث الشريف المعتمدة**: صحيح البخاري، صحيح مسلم، الأربعون النووية، وكتب السنن بتنسيق نصوص محقق ومفهرس بالكامل.
* **موسوعة الفقه الإسلامي**: أبواب فقه العبادات والمعاملات موثقة ومبسطة للرجوع السريع.
* **السيرة النبوية العطرة**: خط زمني تفاعلي يستعرض الغزوات، المواقف التربوية، والأحداث التاريخية في العهدين المكي والمدني.

### 🕋 6. دليل مناسك الحج والعمرة (Hajj & Umrah Interactive Guide)
* خطوات إرشادية مصورة لجميع مناسك الحج (الإفراد، القِران، التمتع) والعمرة من الإحرام وطواف القدوم إلى طواف الوداع.
* دليل مواقيت الإحرام المكانية والزمانية مع تنبيهات الأدعية المأثورة.

---

## 🏛 المعمارية البرمجية | Architecture

يتبع المشروع معمارية صارمة ونظيفة مبنية على مبادئ **Clean Architecture** و **Domain-Driven Design (DDD)** تفصل منطق الأعمال الشرعي عن واجهات المستخدم والخدمات التقنية:

```text
SIRAJ Architecture:
┌─────────────────────────────────────────────────────────┐
│                      Shell Layer                        │
│   (Presentation: Screens, Themes, Widgets, Routing)     │
└───────────────────────────┬─────────────────────────────┘
                            ▼
┌─────────────────────────────────────────────────────────┐
│                     Modules Layer                       │
│  ├── quran        (Mushaf, Audio, Recitation, WordByWord)│
│  ├── prayer       (Astronomical Engine, Athan, Qibla)   │
│  ├── adhkar       (Dhikr Engine, Counters, Provenance)  │
│  ├── zakat        (Nisab Engine, Multi-Currency, Policy)│
│  ├── knowledge    (Hadith Repositories, Fiqh Tree)      │
│  └── hajj/seerah  (Ritual Engines, Timelines, Checklists)│
└───────────────────────────┬─────────────────────────────┘
                            ▼
┌─────────────────────────────────────────────────────────┐
│                      Core Layer                         │
│  (Pure Foundation: Math, Time, Storage, Sound, Sensors) │
└─────────────────────────────────────────────────────────┘
```

---

## 🎙 حزمة التلاوات والقراء | Reciters & Audio Engine

يدعم سِراج مكتبة ضخمة تضم **أشهر قراء العالم الإسلامي** بجودة عالية من مصادر شبكة EveryAyah العالمية:

| القارئ | نوع التلاوة | الرواية |
|---|---|---|
| **الشيخ عبد الباسط عبد الصمد** | المرتل / المجود | حفص عن عاصم |
| **الشيخ محمد صديق المنشاوي** | المرتل / المجود / المعلم | حفص عن عاصم |
| **الشيخ محمود خليل الحصري** | المرتل / المجود / المعلم | حفص عن عاصم |
| **الشيخ مصطفى إسماعيل** | المجود | حفص عن عاصم |
| **الشيخ محمود علي البنا** | المرتل | حفص عن عاصم |
| **الشيخ محمد محمود الطبلاوي** | المرتل | حفص عن عاصم |
| **الشيخ مشاري راشد العفاسي** | المرتل | حفص عن عاصم |
| **الشيخ عبد الرحمن السديس** | المرتل | حفص عن عاصم |
| **الشيخ سعود الشريم** | المرتل | حفص عن عاصم |
| **الشيخ ماهر المعيقلي** | المرتل | حفص عن عاصم |
| **الشيخ ياسر الدوسري** | المرتل | حفص عن عاصم |
| **الشيخ ناصر القطامي** | المرتل | حفص عن عاصم |
| **الشيخ أحمد بن علي العجمي** | المرتل | حفص عن عاصم |
| **الشيخ سعد الغامدي** | المرتل | حفص عن عاصم |
| **الشيخ أبو بكر الشاطري** | المرتل | حفص عن عاصم |
| **الشيخ علي الحذيفي** | المرتل | حفص عن عاصم |
| **الشيخ محمد أيوب** | المرتل | حفص عن عاصم |
| **الشيخ محمد جبريل** | المرتل | حفص عن عاصم |
| **الشيخ علي جابر** | المرتل | حفص عن عاصم |
| **الشيخ عبد الله بصفر** | المرتل | حفص عن عاصم |
| **الشيخ فارس عباد** | المرتل | حفص عن عاصم |
| **الشيخ هاني الرفاعي** | المرتل | حفص عن عاصم |
| **الشيخ خليفة الطنيجي** | المرتل | حفص عن عاصم |
| **الشيخ صلاح البدير** | المرتل | حفص عن عاصم |
| **الشيخ عبد الله عواد الجهني** | المرتل | حفص عن عاصم |
| **الشيخ إبراهيم الأخضر** | المرتل | حفص عن عاصم |
| **الشيخ خالد القحطاني** | المرتل | حفص عن عاصم |
| **الشيخ صلاح بو خاطر** | المرتل | حفص عن عاصم |
| **الشيخ عبد المحسن القاسم** | المرتل | حفص عن عاصم |
| **الدكتور أيمن رشدي سويد** | المعلم وأحكام التجويد | حفص عن عاصم |

---

## 🚀 تثبيت وبناء التطبيق | Installation & Build

### المتطلبات الأساسية (Prerequisites)
* **Flutter SDK**: الإصدار `3.24.0` أو أحدث.
* **Dart SDK**: الإصدار `3.5.0` أو أحدث.
* **Android Studio / Xcode**: لأدوات البناء والمحاكيات.

### خطوات التشغيل المحلي (Running Locally)
```bash
# 1. استنساخ المستودع
git clone https://github.com/<YOUR_USERNAME>/SIRAJ.git
cd SIRAJ

# 2. تحميل الحزم والمكتبات
flutter pub get

# 3. التحقق من سلامة الأكواد
flutter analyze

# 4. تشغيل الاختبارات الآلية
flutter test

# 5. تشغيل التطبيق
flutter run
```

### بناء حزم التوزيع (Building Release Artifacts)
```bash
# بناء حزمة أندرويد APK مجمعة
flutter build apk --release

# بناء حزمة أندرويد App Bundle للمتجر
flutter build appbundle --release

# بناء إصدار الويب
flutter build web --release
```

---

## 🧪 الاختبارات والجودة | Quality Assurance

يحتوي المستودع على منظومة اختبارات تغطي كافة الطبقات الأساسية (187+ اختبار):
```bash
# تشغيل كامل حزمة الاختبارات
flutter test

# تشغيل اختبارات القرآن ومحرك التسميع
flutter test test/modules/quran/

# تشغيل اختبارات أوقات الصلاة والقبلة
flutter test test/modules/prayer/

# تشغيل اختبارات الزكاة والسياسات المالية
flutter test test/modules/zakat/
```

---

## 🔒 الخصوصية والأمان | Privacy & Security

* **100% بدون تتبع (Zero Telemetry)**: لا يتم إرسال أي إحصائيات، سجلات استخدام، أو استعلامات إلى أي خادم خارجي.
* **بياناتك ملكك (Local-First)**: كافة العلامات المرجعية، سجلات التسميع، وأوزان الزكاة تُحفظ محلياً على جهاز المستخدم حصراً.
* **أصول شرعية موثقة (Canonical Provenance)**: خضعت جميع النصوص القرآنية والأحاديث الشريفة للمطابقة المباشرة مع مجمع الملك فهد لطباعة المصحف الشريف وأمهات كتب الحديث المحققة.

---

## 🤝 دليل المساهمة | Contributing

نرحب بمساهمات المطورين والمهتمين بالبرمجيات الإسلامية المفتوحة المصدر!
يرجى قراءة [دليل المساهمة (CONTRIBUTING.md)](CONTRIBUTING.md) للتعرف على معايير الكود، آلية فتح الـ Pull Requests، ودستور المشروع.

---

## 📄 الترخيص | License

هذا المشروع مرخص تحت رخصة **MIT** المفتوحة المصدر — طالع ملف [LICENSE](LICENSE) لمزيد من التفاصيل.

---

<p align="center">
  صُنع بإتقان واحتساب لخدمة المسلمين في كل مكان 🤍<br>
  <em>Built with excellence to serve the global Muslim community.</em>
</p>
