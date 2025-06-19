// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ar';

  static String m0(skill) => "تم قبول الحجز مع تبادل المهارة: ${skill}";

  static String m1(error) => "فشل: ${error}";

  static String m2(date) => "لا يمكن الإكمال قبل ${date}";

  static String m3(userName) => "اختر إحدى مهارات ${userName} في المقابل";

  static String m4(skill) => "هل أنت متأكد أنك تريد إزالة \"${skill}\"؟";

  static String m5(error) => "خطأ في إضافة المهارات: ${error}";

  static String m6(error) => "فشل التحديث: ${error}";

  static String m7(fee) => "تم إرسال طلب الرسوم: \$${fee}";

  static String m8(seconds) =>
      "إعادة إرسال البريد الإلكتروني خلال ${seconds} ثانية";

  static String m9(userName) => "اختر مهارة من ${userName}";

  static String m10(skill) => "تم حذف المهارة \"${skill}\"";

  static String m11(bookingId) => "تبادل مهارة للحجز: ${bookingId}";

  static String m12(userName) => "${userName} ليس لديه مهارات متاحة";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "accept": MessageLookupByLibrary.simpleMessage("قبول"),
    "addCommentOptional": MessageLookupByLibrary.simpleMessage(
      "أضف تعليقاً (اختياري)",
    ),
    "addCustomSkill": MessageLookupByLibrary.simpleMessage("إضافة مهارة مخصصة"),
    "addSkills": MessageLookupByLibrary.simpleMessage("إضافة مهارات"),
    "address": MessageLookupByLibrary.simpleMessage("العنوان"),
    "age": MessageLookupByLibrary.simpleMessage("العمر"),
    "ageRangeLabel": MessageLookupByLibrary.simpleMessage("العمر"),
    "all": MessageLookupByLibrary.simpleMessage("الكل"),
    "allBookings": MessageLookupByLibrary.simpleMessage("الكل"),
    "allGender": MessageLookupByLibrary.simpleMessage("الكل"),
    "allSkills": MessageLookupByLibrary.simpleMessage("جميع المهارات:"),
    "amount": MessageLookupByLibrary.simpleMessage("المبلغ"),
    "appSettings": MessageLookupByLibrary.simpleMessage("إعدادات التطبيق"),
    "arabic": MessageLookupByLibrary.simpleMessage("العربية"),
    "attachmentsUnderDevelopment": MessageLookupByLibrary.simpleMessage(
      "ميزة المرفقات قيد التطوير",
    ),
    "back": MessageLookupByLibrary.simpleMessage("رجوع"),
    "bookService": MessageLookupByLibrary.simpleMessage("حجز الخدمة"),
    "bookingAcceptedWithSkillExchange": m0,
    "bookingCancelled": MessageLookupByLibrary.simpleMessage("تم إلغاء الحجز"),
    "bookingFailed": m1,
    "bookingMarkedCompleted": MessageLookupByLibrary.simpleMessage(
      "تم تحديد الحجز كمكتمل",
    ),
    "bookingRejected": MessageLookupByLibrary.simpleMessage(
      "تم رفض الحجز بنجاح",
    ),
    "bookingSent": MessageLookupByLibrary.simpleMessage("تم إرسال الحجز ✅"),
    "bookingSkillDetails": MessageLookupByLibrary.simpleMessage(
      "تفاصيل حجز المهارة",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "cancelBooking": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "cancelBookingMessage": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد من أنك تريد إلغاء هذا الحجز؟",
    ),
    "cancelBookingTitle": MessageLookupByLibrary.simpleMessage("إلغاء الحجز"),
    "cannotCompleteBefore": m2,
    "cannotUseAppWithoutAgreement": MessageLookupByLibrary.simpleMessage(
      "عذراً، لن تتمكن من استخدام التطبيق دون الموافقة على الشروط. شكراً لك!",
    ),
    "cardNumber": MessageLookupByLibrary.simpleMessage("رقم البطاقة"),
    "chat": MessageLookupByLibrary.simpleMessage("المحادثة"),
    "chooseCompensationMessage": MessageLookupByLibrary.simpleMessage(
      "كيف تريد أن تحصل على مقابل لهذه الخدمة؟",
    ),
    "chooseExchangeType": MessageLookupByLibrary.simpleMessage(
      "اختر نوع التبادل",
    ),
    "chooseLocation": MessageLookupByLibrary.simpleMessage("اختر موقعك"),
    "chooseSkillInExchange": MessageLookupByLibrary.simpleMessage(
      "اختر المهارة التي تريدها في المقابل:",
    ),
    "chooseStartDate": MessageLookupByLibrary.simpleMessage(
      "اختر تاريخ البداية",
    ),
    "chooseSuggestedSkills": MessageLookupByLibrary.simpleMessage(
      "اختر من المهارات المقترحة:",
    ),
    "chooseUserSkillsExchange": m3,
    "complete": MessageLookupByLibrary.simpleMessage("إكمال"),
    "completeAllFields": MessageLookupByLibrary.simpleMessage(
      "يرجى إكمال جميع الحقول",
    ),
    "completedBookings": MessageLookupByLibrary.simpleMessage("مكتمل"),
    "confirm": MessageLookupByLibrary.simpleMessage("تأكيد"),
    "confirmCompletion": MessageLookupByLibrary.simpleMessage("تأكيد الإكمال"),
    "confirmCompletionMessage": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد من أنك تريد تحديد هذا الحجز كمكتمل؟",
    ),
    "confirmDelete": MessageLookupByLibrary.simpleMessage("تأكيد الحذف"),
    "confirmDeleteSkill": m4,
    "confirmExchange": MessageLookupByLibrary.simpleMessage("تأكيد التبادل"),
    "confirmLogout": MessageLookupByLibrary.simpleMessage("تأكيد تسجيل الخروج"),
    "contact": MessageLookupByLibrary.simpleMessage("تواصل"),
    "continueButton": MessageLookupByLibrary.simpleMessage("متابعة"),
    "cvv": MessageLookupByLibrary.simpleMessage("رمز الأمان"),
    "day": MessageLookupByLibrary.simpleMessage("يوم"),
    "delete": MessageLookupByLibrary.simpleMessage("حذف"),
    "destinationLocationNotFound": MessageLookupByLibrary.simpleMessage(
      "لم يتم العثور على موقع الوجهة",
    ),
    "distance": MessageLookupByLibrary.simpleMessage("المسافة"),
    "duration": MessageLookupByLibrary.simpleMessage("المدة"),
    "email": MessageLookupByLibrary.simpleMessage("البريد الإلكتروني"),
    "emailVerificationSent": MessageLookupByLibrary.simpleMessage(
      "تم إرسال رسالة تأكيد البريد الإلكتروني",
    ),
    "english": MessageLookupByLibrary.simpleMessage("English"),
    "enterAmount": MessageLookupByLibrary.simpleMessage("أدخل المبلغ"),
    "enterAmountForService": MessageLookupByLibrary.simpleMessage(
      "أدخل المبلغ الذي تريد تحصيله مقابل هذه الخدمة:",
    ),
    "enterReason": MessageLookupByLibrary.simpleMessage("أدخل السبب..."),
    "enterValidAmount": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال مبلغ صحيح",
    ),
    "enterValidCvv": MessageLookupByLibrary.simpleMessage("أدخل رمز أمان صحيح"),
    "enterValidDate": MessageLookupByLibrary.simpleMessage(
      "أدخل تاريخاً صحيحاً",
    ),
    "error": MessageLookupByLibrary.simpleMessage("خطأ"),
    "errorAddingSkills": m5,
    "errorFetchingLocation": MessageLookupByLibrary.simpleMessage(
      "خطأ في جلب الموقع",
    ),
    "errorLoadingMessages": MessageLookupByLibrary.simpleMessage(
      "خطأ في تحميل الرسائل",
    ),
    "errorSavingData": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ أثناء حفظ البيانات. يرجى المحاولة مرة أخرى لاحقاً.",
    ),
    "exchange": MessageLookupByLibrary.simpleMessage("التبادل"),
    "exchangeSkills": MessageLookupByLibrary.simpleMessage("تبادل المهارات"),
    "exchangedSkill": MessageLookupByLibrary.simpleMessage("المهارة المتبادلة"),
    "expiryDate": MessageLookupByLibrary.simpleMessage("تاريخ الانتهاء"),
    "failedToUpdate": m6,
    "fee": MessageLookupByLibrary.simpleMessage("الرسوم"),
    "feeRequestSent": m7,
    "female": MessageLookupByLibrary.simpleMessage("أنثى"),
    "femaleGender": MessageLookupByLibrary.simpleMessage("أنثى"),
    "filters": MessageLookupByLibrary.simpleMessage("الفلاتر"),
    "fromUser": MessageLookupByLibrary.simpleMessage("من المستخدم"),
    "gender": MessageLookupByLibrary.simpleMessage("الجنس"),
    "genderLabel": MessageLookupByLibrary.simpleMessage("الجنس"),
    "goToHome": MessageLookupByLibrary.simpleMessage(
      "الذهاب إلى الشاشة الرئيسية",
    ),
    "goToProfile": MessageLookupByLibrary.simpleMessage(
      "الذهاب إلى الملف الشخصي",
    ),
    "home": MessageLookupByLibrary.simpleMessage("الرئيسية"),
    "hoursAbbreviation": MessageLookupByLibrary.simpleMessage("س"),
    "inProgressBookings": MessageLookupByLibrary.simpleMessage("قيد التنفيذ"),
    "incomingRequests": MessageLookupByLibrary.simpleMessage("الطلبات الواردة"),
    "invalidEmail": MessageLookupByLibrary.simpleMessage(
      "عنوان بريد إلكتروني غير صحيح",
    ),
    "kilometers": MessageLookupByLibrary.simpleMessage("كم"),
    "loading": MessageLookupByLibrary.simpleMessage("جارٍ التحميل..."),
    "location": MessageLookupByLibrary.simpleMessage("الموقع"),
    "locationUpdated": MessageLookupByLibrary.simpleMessage("تم تحديث الموقع!"),
    "login": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
    "loginButton": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
    "loginError": MessageLookupByLibrary.simpleMessage(
      "فشل تسجيل الدخول. يرجى التحقق من بياناتك والمحاولة مرة أخرى.",
    ),
    "logout": MessageLookupByLibrary.simpleMessage("تسجيل الخروج"),
    "logoutConfirmMessage": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد أنك تريد تسجيل الخروج؟",
    ),
    "male": MessageLookupByLibrary.simpleMessage("ذكر"),
    "maleGender": MessageLookupByLibrary.simpleMessage("ذكر"),
    "manageMyBookings": MessageLookupByLibrary.simpleMessage("إدارة حجوزاتي"),
    "markAsCompleted": MessageLookupByLibrary.simpleMessage("تحديد كمكتمل"),
    "maxDistanceLabel": MessageLookupByLibrary.simpleMessage("المسافة القصوى"),
    "minutesAbbreviation": MessageLookupByLibrary.simpleMessage("د"),
    "month": MessageLookupByLibrary.simpleMessage("شهر"),
    "mustLoginFirst": MessageLookupByLibrary.simpleMessage(
      "يجب تسجيل الدخول أولاً",
    ),
    "mustLoginMessage": MessageLookupByLibrary.simpleMessage(
      "يجب تسجيل الدخول للوصول إلى هذه الشاشة.",
    ),
    "myBookings": MessageLookupByLibrary.simpleMessage("حجوزاتي"),
    "name": MessageLookupByLibrary.simpleMessage("الاسم"),
    "nameCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
      "لا يمكن أن يكون الاسم فارغاً",
    ),
    "nameUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تم تحديث الاسم بنجاح!",
    ),
    "no": MessageLookupByLibrary.simpleMessage("لا"),
    "noBookingsAvailable": MessageLookupByLibrary.simpleMessage(
      "لا توجد حجوزات متاحة.",
    ),
    "noIncomingRequests": MessageLookupByLibrary.simpleMessage(
      "لا توجد طلبات واردة",
    ),
    "noLocationAvailable": MessageLookupByLibrary.simpleMessage(
      "لا يوجد موقع متاح للتتبع",
    ),
    "noLocationAvailableForTracking": MessageLookupByLibrary.simpleMessage(
      "لا يوجد موقع متاح للتتبع",
    ),
    "noMatchingUsers": MessageLookupByLibrary.simpleMessage(
      "لم يتم العثور على مستخدمين متطابقين لهذه المهارة.\nيرجى تجربة كلمة مفتاحية مختلفة للبحث.",
    ),
    "noNewSkillsToAdd": MessageLookupByLibrary.simpleMessage(
      "لا توجد مهارات جديدة لإضافتها.",
    ),
    "noNotes": MessageLookupByLibrary.simpleMessage("لا توجد ملاحظات"),
    "noPaymentRequests": MessageLookupByLibrary.simpleMessage(
      "لا توجد طلبات دفع في الوقت الحالي",
    ),
    "noRouteFound": MessageLookupByLibrary.simpleMessage(
      "لم يتم العثور على طريق",
    ),
    "noSkillsAdded": MessageLookupByLibrary.simpleMessage(
      "لم يتم إضافة مهارات.",
    ),
    "none": MessageLookupByLibrary.simpleMessage("لا يوجد"),
    "notSelected": MessageLookupByLibrary.simpleMessage("غير محدد"),
    "notes": MessageLookupByLibrary.simpleMessage("ملاحظات (اختيارية)"),
    "now": MessageLookupByLibrary.simpleMessage("الآن"),
    "ok": MessageLookupByLibrary.simpleMessage("موافق"),
    "onlyWithLocation": MessageLookupByLibrary.simpleMessage(
      "فقط من لديهم موقع",
    ),
    "password": MessageLookupByLibrary.simpleMessage("كلمة المرور"),
    "passwordCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
      "لا يمكن أن تكون كلمة المرور فارغة",
    ),
    "payNow": MessageLookupByLibrary.simpleMessage("ادفع الآن"),
    "payment": MessageLookupByLibrary.simpleMessage("الدفع"),
    "paymentPendingBookings": MessageLookupByLibrary.simpleMessage(
      "في انتظار الدفع",
    ),
    "paymentRequests": MessageLookupByLibrary.simpleMessage("طلبات الدفع"),
    "paymentSuccessful": MessageLookupByLibrary.simpleMessage(
      "تم الدفع بنجاح! تم إشعار مقدم الخدمة.",
    ),
    "paymentWillingnessQuestion": MessageLookupByLibrary.simpleMessage(
      "هل أنت مستعد لدفع رسوم بسيطة للحصول على الخدمات إذا لم تكن لديك مهارات للتبادل؟",
    ),
    "pendingBookings": MessageLookupByLibrary.simpleMessage("قيد الانتظار"),
    "pickLocation": MessageLookupByLibrary.simpleMessage("اختر الموقع"),
    "playServicesUnavailable": MessageLookupByLibrary.simpleMessage(
      "Google Play Services غير متوفّر",
    ),
    "pleaseEnterValidCardNumber": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال رقم بطاقة صحيح",
    ),
    "pleaseIndicatePaymentWillingness": MessageLookupByLibrary.simpleMessage(
      "يرجى تحديد ما إذا كنت مستعداً لدفع الرسوم.",
    ),
    "pleaseSelectAge": MessageLookupByLibrary.simpleMessage("يرجى اختيار عمرك"),
    "pleaseSelectGender": MessageLookupByLibrary.simpleMessage(
      "يرجى اختيار جنسك",
    ),
    "pleaseSelectLocation": MessageLookupByLibrary.simpleMessage(
      "يرجى اختيار موقعك",
    ),
    "pleaseSelectPaymentMethod": MessageLookupByLibrary.simpleMessage(
      "يرجى اختيار طريقة دفع",
    ),
    "pleaseSelectSkills": MessageLookupByLibrary.simpleMessage(
      "يرجى اختيار أو إدخال مهارة واحدة على الأقل.",
    ),
    "profile": MessageLookupByLibrary.simpleMessage("الملف الشخصي"),
    "providerLocationUnavailable": MessageLookupByLibrary.simpleMessage(
      "موقع مقدم الخدمة غير متوفر.",
    ),
    "providerNotFound": MessageLookupByLibrary.simpleMessage(
      "لم يتم العثور على مقدم الخدمة",
    ),
    "rateOtherUser": MessageLookupByLibrary.simpleMessage("قيم المستخدم الآخر"),
    "rateTheService": MessageLookupByLibrary.simpleMessage("قيم الخدمة"),
    "reasonForRejection": MessageLookupByLibrary.simpleMessage("سبب الرفض"),
    "reciprocalBookingCreated": MessageLookupByLibrary.simpleMessage(
      "تم إنشاء حجز متبادل",
    ),
    "register": MessageLookupByLibrary.simpleMessage("التسجيل"),
    "registrationFailed": MessageLookupByLibrary.simpleMessage("فشل التسجيل"),
    "registrationSuccessful": MessageLookupByLibrary.simpleMessage(
      "تم التسجيل بنجاح! تم إرسال بريد إلكتروني للتحقق.",
    ),
    "reject": MessageLookupByLibrary.simpleMessage("رفض"),
    "rejectedBookings": MessageLookupByLibrary.simpleMessage("مرفوض"),
    "requestFee": MessageLookupByLibrary.simpleMessage("طلب رسوم"),
    "requestedOn": MessageLookupByLibrary.simpleMessage("طُلب في"),
    "requestedSkill": MessageLookupByLibrary.simpleMessage("المهارة المطلوبة:"),
    "requesterLocationUnavailable": MessageLookupByLibrary.simpleMessage(
      "موقع الطالب غير متاح",
    ),
    "requesterNotFound": MessageLookupByLibrary.simpleMessage(
      "لم يتم العثور على الطالب",
    ),
    "requiresSmallFee": MessageLookupByLibrary.simpleMessage(
      "يتطلب رسوماً بسيطة",
    ),
    "resendEmailInSeconds": m8,
    "reviewSubmitted": MessageLookupByLibrary.simpleMessage(
      "تم إرسال التقييم ✅",
    ),
    "saveSkills": MessageLookupByLibrary.simpleMessage("حفظ المهارات"),
    "searchFailed": MessageLookupByLibrary.simpleMessage("فشل البحث"),
    "searchSkills": MessageLookupByLibrary.simpleMessage(
      "البحث عن المهارات...",
    ),
    "selectGender": MessageLookupByLibrary.simpleMessage("اختر الجنس"),
    "selectLanguage": MessageLookupByLibrary.simpleMessage("اللغة:"),
    "selectPaymentMethod": MessageLookupByLibrary.simpleMessage(
      "اختر طريقة الدفع",
    ),
    "selectSkillFromUser": m9,
    "selectYourSkills": MessageLookupByLibrary.simpleMessage("حدد مهاراتك"),
    "selectedSkills": MessageLookupByLibrary.simpleMessage("المهارات المحددة:"),
    "selectionRequired": MessageLookupByLibrary.simpleMessage("الاختيار مطلوب"),
    "sendAgain": MessageLookupByLibrary.simpleMessage("إرسال مرة أخرى"),
    "sendFeeRequest": MessageLookupByLibrary.simpleMessage("إرسال طلب الرسوم"),
    "sendFirstMessage": MessageLookupByLibrary.simpleMessage(
      "أرسل أول رسالة لبدء المحادثة",
    ),
    "sender": MessageLookupByLibrary.simpleMessage("المرسل"),
    "setFeeForService": MessageLookupByLibrary.simpleMessage(
      "حدد رسماً لخدمتك",
    ),
    "signUp": MessageLookupByLibrary.simpleMessage("إنشاء حساب"),
    "skill": MessageLookupByLibrary.simpleMessage("المهارة"),
    "skillAccounting": MessageLookupByLibrary.simpleMessage("المحاسبة"),
    "skillCarpentry": MessageLookupByLibrary.simpleMessage("النجارة"),
    "skillChildcare": MessageLookupByLibrary.simpleMessage("رعاية الأطفال"),
    "skillCooking": MessageLookupByLibrary.simpleMessage("الطبخ"),
    "skillDeleted": m10,
    "skillDeviceRepair": MessageLookupByLibrary.simpleMessage("إصلاح الأجهزة"),
    "skillEventPlanning": MessageLookupByLibrary.simpleMessage(
      "تنظيم الفعاليات",
    ),
    "skillExchange": MessageLookupByLibrary.simpleMessage("تبادل المهارات"),
    "skillExchangeAvailable": MessageLookupByLibrary.simpleMessage(
      "تبادل المهارات متاح",
    ),
    "skillExchangeForBooking": m11,
    "skillFitnessTraining": MessageLookupByLibrary.simpleMessage(
      "التدريب البدني",
    ),
    "skillGardening": MessageLookupByLibrary.simpleMessage("البستنة"),
    "skillGraphicDesign": MessageLookupByLibrary.simpleMessage(
      "التصميم الجرافيكي",
    ),
    "skillMarketing": MessageLookupByLibrary.simpleMessage("التسويق"),
    "skillMusicLessons": MessageLookupByLibrary.simpleMessage("دروس الموسيقى"),
    "skillPainting": MessageLookupByLibrary.simpleMessage("الرسم"),
    "skillPhotography": MessageLookupByLibrary.simpleMessage(
      "التصوير الفوتوغرافي",
    ),
    "skillPrivateTutoring": MessageLookupByLibrary.simpleMessage(
      "التدريس الخاص",
    ),
    "skillProgramming": MessageLookupByLibrary.simpleMessage("البرمجة"),
    "skillProvider": MessageLookupByLibrary.simpleMessage("مقدم المهارة"),
    "skillSewing": MessageLookupByLibrary.simpleMessage("الخياطة"),
    "skillTranslation": MessageLookupByLibrary.simpleMessage("الترجمة"),
    "skillVideoEditing": MessageLookupByLibrary.simpleMessage("تحرير الفيديو"),
    "skillWebDevelopment": MessageLookupByLibrary.simpleMessage(
      "تطوير المواقع",
    ),
    "skillWriting": MessageLookupByLibrary.simpleMessage("الكتابة"),
    "skills": MessageLookupByLibrary.simpleMessage("المهارات"),
    "skillsAddedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تم إضافة المهارات بنجاح!",
    ),
    "skillsLabel": MessageLookupByLibrary.simpleMessage("المهارات"),
    "sorry": MessageLookupByLibrary.simpleMessage("عذراً"),
    "startConversation": MessageLookupByLibrary.simpleMessage("ابدأ المحادثة"),
    "startDate": MessageLookupByLibrary.simpleMessage("تاريخ البدء"),
    "status": MessageLookupByLibrary.simpleMessage("الحالة"),
    "statusCompleted": MessageLookupByLibrary.simpleMessage("مكتمل"),
    "statusInProgress": MessageLookupByLibrary.simpleMessage("قيد التنفيذ"),
    "statusPaymentPending": MessageLookupByLibrary.simpleMessage(
      "في انتظار الدفع",
    ),
    "statusPending": MessageLookupByLibrary.simpleMessage("قيد الانتظار"),
    "statusRejected": MessageLookupByLibrary.simpleMessage("مرفوض"),
    "submit": MessageLookupByLibrary.simpleMessage("إرسال"),
    "systemSupport": MessageLookupByLibrary.simpleMessage("دعم النظام"),
    "termsOfApp": MessageLookupByLibrary.simpleMessage("شروط التطبيق"),
    "track": MessageLookupByLibrary.simpleMessage("تتبع"),
    "trackDistance": MessageLookupByLibrary.simpleMessage("تتبع المسافة"),
    "trackTrip": MessageLookupByLibrary.simpleMessage("تتبع الرحلة"),
    "trustScore": MessageLookupByLibrary.simpleMessage("نقاط الثقة"),
    "twoDays": MessageLookupByLibrary.simpleMessage("يومان"),
    "typeCustomSkill": MessageLookupByLibrary.simpleMessage(
      "أو اكتب مهارتك الخاصة:",
    ),
    "typingNow": MessageLookupByLibrary.simpleMessage("يكتب الآن"),
    "typingNowDots": MessageLookupByLibrary.simpleMessage("يكتب الآن..."),
    "unavailable": MessageLookupByLibrary.simpleMessage("غير متوفر"),
    "unknown": MessageLookupByLibrary.simpleMessage("غير معروف"),
    "userHasNoSkills": m12,
    "userNotLoggedIn": MessageLookupByLibrary.simpleMessage(
      "المستخدم غير مسجل الدخول",
    ),
    "verificationEmailSent": MessageLookupByLibrary.simpleMessage(
      "تم إرسال رسالة تأكيد إلى عنوان بريدك الإلكتروني. يرجى التحقق من صندوق الوارد والنقر على رابط التأكيد.",
    ),
    "verificationFailed": MessageLookupByLibrary.simpleMessage(
      "تأكيد البريد الإلكتروني لا يزال قيد الانتظار. يرجى التحقق من بريدك الإلكتروني والنقر على رابط التأكيد.",
    ),
    "viewPaymentRequest": MessageLookupByLibrary.simpleMessage("عرض طلب الدفع"),
    "week": MessageLookupByLibrary.simpleMessage("أسبوع"),
    "welcome": MessageLookupByLibrary.simpleMessage("مرحباً"),
    "welcomeMessage": MessageLookupByLibrary.simpleMessage(
      "مرحباً! استخدم شريط البحث أعلاه للبحث عن مهارة أو خدمة.\n\nيمكنك أيضاً التحقق من الطلبات الواردة لتقديم المساعدة إذا لزم الأمر.",
    ),
    "willingToPay": MessageLookupByLibrary.simpleMessage("مستعد للدفع"),
    "writeYourMessage": MessageLookupByLibrary.simpleMessage(
      "اكتب رسالتك هنا...",
    ),
    "years": MessageLookupByLibrary.simpleMessage("سنة"),
    "yes": MessageLookupByLibrary.simpleMessage("نعم"),
    "you": MessageLookupByLibrary.simpleMessage("أنت"),
  };
}
