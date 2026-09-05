# دليل المساهمة في مشروع سِراج | Contributing to SIRAJ

جزاكم الله خيراً لاهتمامكم بالمساهمة في مشروع **سِراج (SIRAJ)**. نرحب بمساهمات المطورين، المصممين، والمحققين الشرعيين.

---

## 📜 المبادئ الأساسية للمشروع | Core Principles

1. **القدسية والأمانة العلمية (Canonical Integrity)**:
   - النصوص القرآنية والأحاديث الشريفة خط أحمر؛ لا يُقبل أي تعديل أو دمج لأي نص دون تخريج وتدقيق مطابق لمجمع الملك فهد أو الصحاح والسنن المعتمدة.
2. **الخصوصية المطلقة وتصفير التتبع (Zero Telemetry & Local-First)**:
   - لا يُسمح بإضافة أي مكتبات تحليلات، إعلانات، أو حزم تقوم بتسريب بيانات المستخدم.
3. **المعمارية المعيارية والنظيفة (Clean Architecture & Modular DDD)**:
   - الفصل التام بين `Core` و `Modules` و `Shell`.
   - يمنع استيراد طبقة `Shell` داخل طبقة `Modules` أو `Core`.

---

## 🛠 دورة التطوير والمساهمة | Development Workflow

1. **Fork & Branching**:
   - قم بعمل Fork للمستودع.
   - أنشئ فرعاً جديداً لميزتك أو إصلاحك:
     ```bash
     git checkout -b feat/quran-audio-enhancement
     # أو
     git checkout -b fix/prayer-compass-bearing
     ```

2. **معايير كتابة الكود (Code Standards)**:
   - الالتزام بقواعد التحليل الساكن لـ Flutter:
     ```bash
     flutter analyze
     ```
   - الالتزام بتنسيق الكود:
     ```bash
     dart format --set-exit-if-changed lib/ test/
     ```

3. **كتابة وتشغيل الاختبارات (Testing Requirement)**:
   - يجب أن يتضمن أي تعديل في المنطق (Domain/Services) اختبارات وحدة تغطي كافة الحالات المتطرفة:
     ```bash
     flutter test
     ```

4. **رسائل الـ Git Commit (Conventional Commits)**:
   نتبع نمط Conventional Commits:
   - `feat(quran): add new reciter options`
   - `fix(prayer): resolve compass bearing calibration`
   - `docs: update architecture guidelines`
   - `test(zakat): add gold standard boundary tests`

---

## 🚀 تقديم طلبات الدمج | Pull Requests

- افتح Pull Request موضحاً فيه سبب التغيير وما تم اختباره.
- تأكد من اجتياز جميع اختبارات الـ CI/CD بنجاح.
- سيقوم مراجعو الكود بمراجعة طلبك ومناقشة التحسينات المحتملة.

نشكركم على جهودكم وجعلها الله في ميزان حسناتكم.
