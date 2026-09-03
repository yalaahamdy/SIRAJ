import '../domain/unified_message.dart';
import '../session/confirmation_engine.dart';
import 'command_registry.dart';

/// Factory providing the standard command suite for SIRAJ Bot Platform (§14, §44, §67).
class StandardBotCommands {
  static List<BotCommandDefinition> createStandardSuite({
    ConfirmationEngine? confirmationEngine,
  }) {
    final engine = confirmationEngine ?? ConfirmationEngine();

    return [
      // 1. /start
      BotCommandDefinition(
        name: '/start',
        descriptionArabic: 'بدء المحادثة وعرض القائمة الرئيسية',
        handler: ({required message, required session, required arguments}) async {
          return const UnifiedBotResponse(
            requestId: 'req_start',
            textArabic: 'مرحباً بك في سِراج — رفيقك الإسلامي الموثق.\nيمكنك طرح أسئلتك المعرفية، أو اختيار أحد الأقسام من القائمة أدناه:',
            menu: BotMenu(
              title: 'القائمة الرئيسية',
              rows: [
                [
                  BotButton(id: 'btn_prayer', labelArabic: '🕌 مواقيت الصلاة', callbackData: '/prayer'),
                  BotButton(id: 'btn_quran', labelArabic: '📖 المصحف الشريف', callbackData: '/quran'),
                ],
                [
                  BotButton(id: 'btn_adhkar', labelArabic: '📿 الأذكار المأثورة', callbackData: '/adhkar'),
                  BotButton(id: 'btn_fasting', labelArabic: '🌙 الصيام ورمضان', callbackData: '/fasting'),
                ],
                [
                  BotButton(id: 'btn_zakat', labelArabic: '💰 حساب الزكاة', callbackData: '/zakat'),
                  BotButton(id: 'btn_hajj', labelArabic: '🕋 الحج والعمرة', callbackData: '/hajj'),
                ],
              ],
            ),
          );
        },
      ),

      // 2. /help
      BotCommandDefinition(
        name: '/help',
        descriptionArabic: 'عرض دليل المساعدة والأوامر المتاحة',
        handler: ({required message, required session, required arguments}) async {
          return const UnifiedBotResponse(
            requestId: 'req_help',
            textArabic: 'دليل أوامر سِراج المتاحة:\n'
                '• /start — القائمة الرئيسية والترحيب\n'
                '• /prayer — مواقيت الصلاة واتجاه القبلة\n'
                '• /quran — البحث في القرآن الكريم\n'
                '• /adhkar — أذكار الصباح والمساء والأدعية\n'
                '• /fasting — مواعيد الصيام والإمساك\n'
                '• /zakat — ضوابط وحساب الزكاة\n'
                '• /hajj — دليل مناسك الحج والعمرة\n'
                '• /learn — المسارات التعليمية\n'
                '• /search — البحث في الأحاديث والمعارف الموثقة\n'
                '• /deletemydata — حذف كافة بياناتك وجلساتك من البوت\n\n'
                'تنبيه: سِراج يقدم استرجاعاً وتوثيقاً من المصادر المعتمدة فقط ولا يقدم فتاوى شخصية.',
          );
        },
      ),

      // 3. /prayer
      BotCommandDefinition(
        name: '/prayer',
        descriptionArabic: 'استرجاع مواقيت الصلاة واتجاه القبلة',
        handler: ({required message, required session, required arguments}) async {
          return const UnifiedBotResponse(
            requestId: 'req_prayer',
            textArabic: 'مواقيت الصلاة اليوم:\n• الفجر: 4:30 ص\n• الظهر: 12:15 م\n• العصر: 3:45 م\n• المغرب: 6:30 م\n• العشاء: 8:00 م',
          );
        },
      ),

      // 4. /quran
      BotCommandDefinition(
        name: '/quran',
        descriptionArabic: 'البحث في القرآن الكريم برواية حفص',
        handler: ({required message, required session, required arguments}) async {
          return const UnifiedBotResponse(
            requestId: 'req_quran',
            textArabic: 'استعراض المصحف الشريف المعتمد برواية حفص عن عاصم من مجمع الملك فهد.',
          );
        },
      ),

      // 5. /adhkar
      BotCommandDefinition(
        name: '/adhkar',
        descriptionArabic: 'استرجاع الأذكار والأدعية المأثورة',
        handler: ({required message, required session, required arguments}) async {
          return const UnifiedBotResponse(
            requestId: 'req_adhkar',
            textArabic: 'الأذكار المأثورة المسترجعة من كتب السنة المعتمدة (صحيح البخاري وصحيح مسلم).',
          );
        },
      ),

      // 6. /fasting
      BotCommandDefinition(
        name: '/fasting',
        descriptionArabic: 'مواعيد الصيام والإمساك والإفطار',
        handler: ({required message, required session, required arguments}) async {
          return const UnifiedBotResponse(
            requestId: 'req_fasting',
            textArabic: 'مواعيد الصيام:\n• الإمساك: 4:20 ص\n• الإفطار (المغرب): 6:30 م',
          );
        },
      ),

      // 7. /zakat
      BotCommandDefinition(
        name: '/zakat',
        descriptionArabic: 'ضوابط وسياسات حساب الزكاة',
        handler: ({required message, required session, required arguments}) async {
          return const UnifiedBotResponse(
            requestId: 'req_zakat',
            textArabic: 'ضوابط زكاة المال:\n• النصاب: ما يعادل 85 جراماً من الذهب عيار 24.\n• المقدار الواجب: 2.5% بعد مرور حول كامل وفوق النصاب.',
          );
        },
      ),

      // 8. /hajj
      BotCommandDefinition(
        name: '/hajj',
        descriptionArabic: 'دليل مناسك الحج والعمرة',
        handler: ({required message, required session, required arguments}) async {
          return const UnifiedBotResponse(
            requestId: 'req_hajj',
            textArabic: 'خطوات العمرة الأساسية:\n1. الإحرام من الميقات\n2. طواف العمرة 7 أشواط\n3. السعي بين الصفا والمروة 7 أشواط\n4. الحلق أو التقصير',
          );
        },
      ),

      // 9. /learn
      BotCommandDefinition(
        name: '/learn',
        descriptionArabic: 'المسارات التعليمية المعتمدة',
        handler: ({required message, required session, required arguments}) async {
          return const UnifiedBotResponse(
            requestId: 'req_learn',
            textArabic: 'المسارات التعليمية المتاحة في سِراج:\n• مسار فقه العبادات\n• مسار السيرة النبوية والتاريخ\n• مسار علوم القرآن والتجويد',
          );
        },
      ),

      // 10. /search
      BotCommandDefinition(
        name: '/search',
        descriptionArabic: 'البحث في المعارف والحديث الموثق',
        handler: ({required message, required session, required arguments}) async {
          return UnifiedBotResponse(
            requestId: 'req_search',
            textArabic: arguments.isNotEmpty
                ? 'نتائج البحث عن: "$arguments"\n• نتائج الأحاديث والمعارف الموثقة ذات الصلة من كتب السنة المعتمدة'
                : 'يُرجى كتابة نص البحث بعد الأمر، مثال:\n/search الصلاة',
          );
        },
      ),

      // 11. /settings
      BotCommandDefinition(
        name: '/settings',
        descriptionArabic: 'إعدادات وتفضيلات البوت',
        handler: ({required message, required session, required arguments}) async {
          return const UnifiedBotResponse(
            requestId: 'req_settings',
            textArabic: 'إعدادات البوت الحالية:\n• اللغة: العربية\n• القناة: نشطة\n• التنبيهات: مفعلة',
          );
        },
      ),

      // 12. /deletemydata (§44)
      BotCommandDefinition(
        name: '/deletemydata',
        descriptionArabic: 'حذف كافة بيانات الجلسات والمعلومات الشخصية من البوت',
        handler: ({required message, required session, required arguments}) async {
          return engine.requestConfirmation(
            requestId: 'req_delete_confirm',
            promptArabic: '⚠️ هل أنت متأكد من رغبتك في حذف كافة بيانات محادثاتك وسجلات جلساتك نهائياً من سِراج؟',
            actionId: 'ACTION_DELETE_USER_DATA',
          );
        },
      ),

      // 13. /resetcontext (§11, §33)
      BotCommandDefinition(
        name: '/resetcontext',
        descriptionArabic: 'إعادة ضبط سياق المحادثة وتصفير الذاكرة المؤقتة',
        handler: ({required message, required session, required arguments}) async {
          return const UnifiedBotResponse(
            requestId: 'req_reset_context',
            textArabic: 'تمت إعادة ضبط سياق المحادثة بنجاح، وتصفير الذاكرة المؤقتة للجلسة الحالية.',
          );
        },
      ),
    ];
  }
}
