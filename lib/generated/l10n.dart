// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Login`
  String get loginButton {
    return Intl.message('Login', name: 'loginButton', desc: '', args: []);
  }

  /// `Language:`
  String get selectLanguage {
    return Intl.message(
      'Language:',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `العربية`
  String get arabic {
    return Intl.message('العربية', name: 'arabic', desc: '', args: []);
  }

  /// `Login failed. Please check your credentials and try again.`
  String get loginError {
    return Intl.message(
      'Login failed. Please check your credentials and try again.',
      name: 'loginError',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message('Welcome', name: 'welcome', desc: '', args: []);
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Go to Home Screen`
  String get goToHome {
    return Intl.message(
      'Go to Home Screen',
      name: 'goToHome',
      desc: '',
      args: [],
    );
  }

  /// `Go to Profile Screen`
  String get goToProfile {
    return Intl.message(
      'Go to Profile Screen',
      name: 'goToProfile',
      desc: '',
      args: [],
    );
  }

  /// `You must log in to access this screen.`
  String get mustLoginMessage {
    return Intl.message(
      'You must log in to access this screen.',
      name: 'mustLoginMessage',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Choose your location`
  String get chooseLocation {
    return Intl.message(
      'Choose your location',
      name: 'chooseLocation',
      desc: '',
      args: [],
    );
  }

  /// `Pick Location`
  String get pickLocation {
    return Intl.message(
      'Pick Location',
      name: 'pickLocation',
      desc: '',
      args: [],
    );
  }

  /// `Age`
  String get age {
    return Intl.message('Age', name: 'age', desc: '', args: []);
  }

  /// `Not selected`
  String get notSelected {
    return Intl.message(
      'Not selected',
      name: 'notSelected',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get gender {
    return Intl.message('Gender', name: 'gender', desc: '', args: []);
  }

  /// `Male`
  String get male {
    return Intl.message('Male', name: 'male', desc: '', args: []);
  }

  /// `Female`
  String get female {
    return Intl.message('Female', name: 'female', desc: '', args: []);
  }

  /// `Select Gender`
  String get selectGender {
    return Intl.message(
      'Select Gender',
      name: 'selectGender',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message('Sign Up', name: 'signUp', desc: '', args: []);
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Name cannot be empty`
  String get nameCannotBeEmpty {
    return Intl.message(
      'Name cannot be empty',
      name: 'nameCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email address`
  String get invalidEmail {
    return Intl.message(
      'Invalid email address',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password cannot be empty`
  String get passwordCannotBeEmpty {
    return Intl.message(
      'Password cannot be empty',
      name: 'passwordCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Please select your age`
  String get pleaseSelectAge {
    return Intl.message(
      'Please select your age',
      name: 'pleaseSelectAge',
      desc: '',
      args: [],
    );
  }

  /// `Please select your gender`
  String get pleaseSelectGender {
    return Intl.message(
      'Please select your gender',
      name: 'pleaseSelectGender',
      desc: '',
      args: [],
    );
  }

  /// `Please select your location`
  String get pleaseSelectLocation {
    return Intl.message(
      'Please select your location',
      name: 'pleaseSelectLocation',
      desc: '',
      args: [],
    );
  }

  /// `Registration successful! A verification email has been sent.`
  String get registrationSuccessful {
    return Intl.message(
      'Registration successful! A verification email has been sent.',
      name: 'registrationSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Registration failed`
  String get registrationFailed {
    return Intl.message(
      'Registration failed',
      name: 'registrationFailed',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Search for skills…`
  String get searchSkills {
    return Intl.message(
      'Search for skills…',
      name: 'searchSkills',
      desc: '',
      args: [],
    );
  }

  /// `Welcome! Use the search bar above to look for a skill or service.\n\nYou can also check your incoming requests to offer your help if needed.`
  String get welcomeMessage {
    return Intl.message(
      'Welcome! Use the search bar above to look for a skill or service.\n\nYou can also check your incoming requests to offer your help if needed.',
      name: 'welcomeMessage',
      desc: '',
      args: [],
    );
  }

  /// `No matching users found for this skill.\nPlease try a different search keyword.`
  String get noMatchingUsers {
    return Intl.message(
      'No matching users found for this skill.\nPlease try a different search keyword.',
      name: 'noMatchingUsers',
      desc: '',
      args: [],
    );
  }

  /// `Skill Exchange Available`
  String get skillExchangeAvailable {
    return Intl.message(
      'Skill Exchange Available',
      name: 'skillExchangeAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Requires Small Fee`
  String get requiresSmallFee {
    return Intl.message(
      'Requires Small Fee',
      name: 'requiresSmallFee',
      desc: '',
      args: [],
    );
  }

  /// `Trust Score`
  String get trustScore {
    return Intl.message('Trust Score', name: 'trustScore', desc: '', args: []);
  }

  /// `unavailable`
  String get unavailable {
    return Intl.message('unavailable', name: 'unavailable', desc: '', args: []);
  }

  /// `Unknown`
  String get unknown {
    return Intl.message('Unknown', name: 'unknown', desc: '', args: []);
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `System Support`
  String get systemSupport {
    return Intl.message(
      'System Support',
      name: 'systemSupport',
      desc: '',
      args: [],
    );
  }

  /// `Terms of App`
  String get termsOfApp {
    return Intl.message('Terms of App', name: 'termsOfApp', desc: '', args: []);
  }

  /// `App Settings`
  String get appSettings {
    return Intl.message(
      'App Settings',
      name: 'appSettings',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get logout {
    return Intl.message('Log Out', name: 'logout', desc: '', args: []);
  }

  /// `Confirm Logout`
  String get confirmLogout {
    return Intl.message(
      'Confirm Logout',
      name: 'confirmLogout',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to log out?`
  String get logoutConfirmMessage {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'logoutConfirmMessage',
      desc: '',
      args: [],
    );
  }

  /// `You must log in first`
  String get mustLoginFirst {
    return Intl.message(
      'You must log in first',
      name: 'mustLoginFirst',
      desc: '',
      args: [],
    );
  }

  /// `Search failed`
  String get searchFailed {
    return Intl.message(
      'Search failed',
      name: 'searchFailed',
      desc: '',
      args: [],
    );
  }

  /// `Google Play Services unavailable`
  String get playServicesUnavailable {
    return Intl.message(
      'Google Play Services unavailable',
      name: 'playServicesUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Name updated successfully!`
  String get nameUpdatedSuccessfully {
    return Intl.message(
      'Name updated successfully!',
      name: 'nameUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update: {error}`
  String failedToUpdate(Object error) {
    return Intl.message(
      'Failed to update: $error',
      name: 'failedToUpdate',
      desc: '',
      args: [error],
    );
  }

  /// `Location updated!`
  String get locationUpdated {
    return Intl.message(
      'Location updated!',
      name: 'locationUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Delete`
  String get confirmDelete {
    return Intl.message(
      'Confirm Delete',
      name: 'confirmDelete',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to remove "{skill}"?`
  String confirmDeleteSkill(Object skill) {
    return Intl.message(
      'Are you sure you want to remove "$skill"?',
      name: 'confirmDeleteSkill',
      desc: '',
      args: [skill],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Skill "{skill}" deleted`
  String skillDeleted(Object skill) {
    return Intl.message(
      'Skill "$skill" deleted',
      name: 'skillDeleted',
      desc: '',
      args: [skill],
    );
  }

  /// `Willing to Pay`
  String get willingToPay {
    return Intl.message(
      'Willing to Pay',
      name: 'willingToPay',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Location`
  String get location {
    return Intl.message('Location', name: 'location', desc: '', args: []);
  }

  /// `Skills`
  String get skills {
    return Intl.message('Skills', name: 'skills', desc: '', args: []);
  }

  /// `No skills added.`
  String get noSkillsAdded {
    return Intl.message(
      'No skills added.',
      name: 'noSkillsAdded',
      desc: '',
      args: [],
    );
  }

  /// `Manage My Bookings`
  String get manageMyBookings {
    return Intl.message(
      'Manage My Bookings',
      name: 'manageMyBookings',
      desc: '',
      args: [],
    );
  }

  /// `Add Skills`
  String get addSkills {
    return Intl.message('Add Skills', name: 'addSkills', desc: '', args: []);
  }

  /// `Choose from suggested skills:`
  String get chooseSuggestedSkills {
    return Intl.message(
      'Choose from suggested skills:',
      name: 'chooseSuggestedSkills',
      desc: '',
      args: [],
    );
  }

  /// `Or type your own skill:`
  String get typeCustomSkill {
    return Intl.message(
      'Or type your own skill:',
      name: 'typeCustomSkill',
      desc: '',
      args: [],
    );
  }

  /// `Add Custom Skill`
  String get addCustomSkill {
    return Intl.message(
      'Add Custom Skill',
      name: 'addCustomSkill',
      desc: '',
      args: [],
    );
  }

  /// `Selected Skills:`
  String get selectedSkills {
    return Intl.message(
      'Selected Skills:',
      name: 'selectedSkills',
      desc: '',
      args: [],
    );
  }

  /// `Save Skills`
  String get saveSkills {
    return Intl.message('Save Skills', name: 'saveSkills', desc: '', args: []);
  }

  /// `Please select or enter at least one skill.`
  String get pleaseSelectSkills {
    return Intl.message(
      'Please select or enter at least one skill.',
      name: 'pleaseSelectSkills',
      desc: '',
      args: [],
    );
  }

  /// `No new skills to add.`
  String get noNewSkillsToAdd {
    return Intl.message(
      'No new skills to add.',
      name: 'noNewSkillsToAdd',
      desc: '',
      args: [],
    );
  }

  /// `Skills added successfully!`
  String get skillsAddedSuccessfully {
    return Intl.message(
      'Skills added successfully!',
      name: 'skillsAddedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Error adding skills: {error}`
  String errorAddingSkills(Object error) {
    return Intl.message(
      'Error adding skills: $error',
      name: 'errorAddingSkills',
      desc: '',
      args: [error],
    );
  }

  /// `Booking Skill Details`
  String get bookingSkillDetails {
    return Intl.message(
      'Booking Skill Details',
      name: 'bookingSkillDetails',
      desc: '',
      args: [],
    );
  }

  /// `Requested Skill:`
  String get requestedSkill {
    return Intl.message(
      'Requested Skill:',
      name: 'requestedSkill',
      desc: '',
      args: [],
    );
  }

  /// `All Skills:`
  String get allSkills {
    return Intl.message('All Skills:', name: 'allSkills', desc: '', args: []);
  }

  /// `Book Service`
  String get bookService {
    return Intl.message(
      'Book Service',
      name: 'bookService',
      desc: '',
      args: [],
    );
  }

  /// `Choose start date`
  String get chooseStartDate {
    return Intl.message(
      'Choose start date',
      name: 'chooseStartDate',
      desc: '',
      args: [],
    );
  }

  /// `Duration`
  String get duration {
    return Intl.message('Duration', name: 'duration', desc: '', args: []);
  }

  /// `Day`
  String get day {
    return Intl.message('Day', name: 'day', desc: '', args: []);
  }

  /// `2 Days`
  String get twoDays {
    return Intl.message('2 Days', name: 'twoDays', desc: '', args: []);
  }

  /// `Week`
  String get week {
    return Intl.message('Week', name: 'week', desc: '', args: []);
  }

  /// `Month`
  String get month {
    return Intl.message('Month', name: 'month', desc: '', args: []);
  }

  /// `Notes (optional)`
  String get notes {
    return Intl.message('Notes (optional)', name: 'notes', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Complete all fields please`
  String get completeAllFields {
    return Intl.message(
      'Complete all fields please',
      name: 'completeAllFields',
      desc: '',
      args: [],
    );
  }

  /// `Provider location unavailable.`
  String get providerLocationUnavailable {
    return Intl.message(
      'Provider location unavailable.',
      name: 'providerLocationUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Booking sent ✅`
  String get bookingSent {
    return Intl.message(
      'Booking sent ✅',
      name: 'bookingSent',
      desc: '',
      args: [],
    );
  }

  /// `Failed: {error}`
  String bookingFailed(Object error) {
    return Intl.message(
      'Failed: $error',
      name: 'bookingFailed',
      desc: '',
      args: [error],
    );
  }

  /// `Graphic Design`
  String get skillGraphicDesign {
    return Intl.message(
      'Graphic Design',
      name: 'skillGraphicDesign',
      desc: '',
      args: [],
    );
  }

  /// `Translation`
  String get skillTranslation {
    return Intl.message(
      'Translation',
      name: 'skillTranslation',
      desc: '',
      args: [],
    );
  }

  /// `Programming`
  String get skillProgramming {
    return Intl.message(
      'Programming',
      name: 'skillProgramming',
      desc: '',
      args: [],
    );
  }

  /// `Childcare`
  String get skillChildcare {
    return Intl.message(
      'Childcare',
      name: 'skillChildcare',
      desc: '',
      args: [],
    );
  }

  /// `Device Repair`
  String get skillDeviceRepair {
    return Intl.message(
      'Device Repair',
      name: 'skillDeviceRepair',
      desc: '',
      args: [],
    );
  }

  /// `Private Tutoring`
  String get skillPrivateTutoring {
    return Intl.message(
      'Private Tutoring',
      name: 'skillPrivateTutoring',
      desc: '',
      args: [],
    );
  }

  /// `Photography`
  String get skillPhotography {
    return Intl.message(
      'Photography',
      name: 'skillPhotography',
      desc: '',
      args: [],
    );
  }

  /// `Writing`
  String get skillWriting {
    return Intl.message('Writing', name: 'skillWriting', desc: '', args: []);
  }

  /// `Video Editing`
  String get skillVideoEditing {
    return Intl.message(
      'Video Editing',
      name: 'skillVideoEditing',
      desc: '',
      args: [],
    );
  }

  /// `Web Development`
  String get skillWebDevelopment {
    return Intl.message(
      'Web Development',
      name: 'skillWebDevelopment',
      desc: '',
      args: [],
    );
  }

  /// `Marketing`
  String get skillMarketing {
    return Intl.message(
      'Marketing',
      name: 'skillMarketing',
      desc: '',
      args: [],
    );
  }

  /// `Cooking`
  String get skillCooking {
    return Intl.message('Cooking', name: 'skillCooking', desc: '', args: []);
  }

  /// `Gardening`
  String get skillGardening {
    return Intl.message(
      'Gardening',
      name: 'skillGardening',
      desc: '',
      args: [],
    );
  }

  /// `Painting`
  String get skillPainting {
    return Intl.message('Painting', name: 'skillPainting', desc: '', args: []);
  }

  /// `Carpentry`
  String get skillCarpentry {
    return Intl.message(
      'Carpentry',
      name: 'skillCarpentry',
      desc: '',
      args: [],
    );
  }

  /// `Sewing`
  String get skillSewing {
    return Intl.message('Sewing', name: 'skillSewing', desc: '', args: []);
  }

  /// `Fitness Training`
  String get skillFitnessTraining {
    return Intl.message(
      'Fitness Training',
      name: 'skillFitnessTraining',
      desc: '',
      args: [],
    );
  }

  /// `Music Lessons`
  String get skillMusicLessons {
    return Intl.message(
      'Music Lessons',
      name: 'skillMusicLessons',
      desc: '',
      args: [],
    );
  }

  /// `Event Planning`
  String get skillEventPlanning {
    return Intl.message(
      'Event Planning',
      name: 'skillEventPlanning',
      desc: '',
      args: [],
    );
  }

  /// `Accounting`
  String get skillAccounting {
    return Intl.message(
      'Accounting',
      name: 'skillAccounting',
      desc: '',
      args: [],
    );
  }

  /// `Select Your Skills`
  String get selectYourSkills {
    return Intl.message(
      'Select Your Skills',
      name: 'selectYourSkills',
      desc: '',
      args: [],
    );
  }

  /// `Are you willing to pay a small fee to receive services if you don't have skills to exchange?`
  String get paymentWillingnessQuestion {
    return Intl.message(
      'Are you willing to pay a small fee to receive services if you don\'t have skills to exchange?',
      name: 'paymentWillingnessQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Selection Required`
  String get selectionRequired {
    return Intl.message(
      'Selection Required',
      name: 'selectionRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please indicate if you are willing to pay a fee.`
  String get pleaseIndicatePaymentWillingness {
    return Intl.message(
      'Please indicate if you are willing to pay a fee.',
      name: 'pleaseIndicatePaymentWillingness',
      desc: '',
      args: [],
    );
  }

  /// `Sorry`
  String get sorry {
    return Intl.message('Sorry', name: 'sorry', desc: '', args: []);
  }

  /// `Sorry, you won't be able to use the app without agreeing to the terms. Thank you!`
  String get cannotUseAppWithoutAgreement {
    return Intl.message(
      'Sorry, you won\'t be able to use the app without agreeing to the terms. Thank you!',
      name: 'cannotUseAppWithoutAgreement',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `An error occurred while saving data. Please try again later.`
  String get errorSavingData {
    return Intl.message(
      'An error occurred while saving data. Please try again later.',
      name: 'errorSavingData',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueButton {
    return Intl.message('Continue', name: 'continueButton', desc: '', args: []);
  }

  /// `Incoming Requests`
  String get incomingRequests {
    return Intl.message(
      'Incoming Requests',
      name: 'incomingRequests',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `Pending`
  String get statusPending {
    return Intl.message('Pending', name: 'statusPending', desc: '', args: []);
  }

  /// `In Progress`
  String get statusInProgress {
    return Intl.message(
      'In Progress',
      name: 'statusInProgress',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get statusCompleted {
    return Intl.message(
      'Completed',
      name: 'statusCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Rejected`
  String get statusRejected {
    return Intl.message('Rejected', name: 'statusRejected', desc: '', args: []);
  }

  /// `Payment Pending`
  String get statusPaymentPending {
    return Intl.message(
      'Payment Pending',
      name: 'statusPaymentPending',
      desc: '',
      args: [],
    );
  }

  /// `No incoming requests found`
  String get noIncomingRequests {
    return Intl.message(
      'No incoming requests found',
      name: 'noIncomingRequests',
      desc: '',
      args: [],
    );
  }

  /// `From User`
  String get fromUser {
    return Intl.message('From User', name: 'fromUser', desc: '', args: []);
  }

  /// `Address`
  String get address {
    return Intl.message('Address', name: 'address', desc: '', args: []);
  }

  /// `Start Date`
  String get startDate {
    return Intl.message('Start Date', name: 'startDate', desc: '', args: []);
  }

  /// `None`
  String get none {
    return Intl.message('None', name: 'none', desc: '', args: []);
  }

  /// `Exchanged Skill`
  String get exchangedSkill {
    return Intl.message(
      'Exchanged Skill',
      name: 'exchangedSkill',
      desc: '',
      args: [],
    );
  }

  /// `Fee`
  String get fee {
    return Intl.message('Fee', name: 'fee', desc: '', args: []);
  }

  /// `Status`
  String get status {
    return Intl.message('Status', name: 'status', desc: '', args: []);
  }

  /// `Accept`
  String get accept {
    return Intl.message('Accept', name: 'accept', desc: '', args: []);
  }

  /// `Reject`
  String get reject {
    return Intl.message('Reject', name: 'reject', desc: '', args: []);
  }

  /// `Track Trip`
  String get trackTrip {
    return Intl.message('Track Trip', name: 'trackTrip', desc: '', args: []);
  }

  /// `Mark as Completed`
  String get markAsCompleted {
    return Intl.message(
      'Mark as Completed',
      name: 'markAsCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Cannot complete before {date}`
  String cannotCompleteBefore(Object date) {
    return Intl.message(
      'Cannot complete before $date',
      name: 'cannotCompleteBefore',
      desc: '',
      args: [date],
    );
  }

  /// `Choose Exchange Type`
  String get chooseExchangeType {
    return Intl.message(
      'Choose Exchange Type',
      name: 'chooseExchangeType',
      desc: '',
      args: [],
    );
  }

  /// `How would you like to be compensated for this service?`
  String get chooseCompensationMessage {
    return Intl.message(
      'How would you like to be compensated for this service?',
      name: 'chooseCompensationMessage',
      desc: '',
      args: [],
    );
  }

  /// `Exchange Skills`
  String get exchangeSkills {
    return Intl.message(
      'Exchange Skills',
      name: 'exchangeSkills',
      desc: '',
      args: [],
    );
  }

  /// `Choose one of {userName}'s skills in exchange`
  String chooseUserSkillsExchange(Object userName) {
    return Intl.message(
      'Choose one of $userName\'s skills in exchange',
      name: 'chooseUserSkillsExchange',
      desc: '',
      args: [userName],
    );
  }

  /// `Request Fee`
  String get requestFee {
    return Intl.message('Request Fee', name: 'requestFee', desc: '', args: []);
  }

  /// `Set a fee for your service`
  String get setFeeForService {
    return Intl.message(
      'Set a fee for your service',
      name: 'setFeeForService',
      desc: '',
      args: [],
    );
  }

  /// `Select Skill from {userName}`
  String selectSkillFromUser(Object userName) {
    return Intl.message(
      'Select Skill from $userName',
      name: 'selectSkillFromUser',
      desc: '',
      args: [userName],
    );
  }

  /// `{userName} has no skills available`
  String userHasNoSkills(Object userName) {
    return Intl.message(
      '$userName has no skills available',
      name: 'userHasNoSkills',
      desc: '',
      args: [userName],
    );
  }

  /// `Choose a skill you want in exchange:`
  String get chooseSkillInExchange {
    return Intl.message(
      'Choose a skill you want in exchange:',
      name: 'chooseSkillInExchange',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Exchange`
  String get confirmExchange {
    return Intl.message(
      'Confirm Exchange',
      name: 'confirmExchange',
      desc: '',
      args: [],
    );
  }

  /// `Booking accepted with skill exchange: {skill}`
  String bookingAcceptedWithSkillExchange(Object skill) {
    return Intl.message(
      'Booking accepted with skill exchange: $skill',
      name: 'bookingAcceptedWithSkillExchange',
      desc: '',
      args: [skill],
    );
  }

  /// `A reciprocal booking has been created`
  String get reciprocalBookingCreated {
    return Intl.message(
      'A reciprocal booking has been created',
      name: 'reciprocalBookingCreated',
      desc: '',
      args: [],
    );
  }

  /// `User not logged in`
  String get userNotLoggedIn {
    return Intl.message(
      'User not logged in',
      name: 'userNotLoggedIn',
      desc: '',
      args: [],
    );
  }

  /// `Requester not found`
  String get requesterNotFound {
    return Intl.message(
      'Requester not found',
      name: 'requesterNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Requester location unavailable`
  String get requesterLocationUnavailable {
    return Intl.message(
      'Requester location unavailable',
      name: 'requesterLocationUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Provider not found`
  String get providerNotFound {
    return Intl.message(
      'Provider not found',
      name: 'providerNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Skill exchange for booking: {bookingId}`
  String skillExchangeForBooking(Object bookingId) {
    return Intl.message(
      'Skill exchange for booking: $bookingId',
      name: 'skillExchangeForBooking',
      desc: '',
      args: [bookingId],
    );
  }

  /// `Enter the amount you want to charge for this service:`
  String get enterAmountForService {
    return Intl.message(
      'Enter the amount you want to charge for this service:',
      name: 'enterAmountForService',
      desc: '',
      args: [],
    );
  }

  /// `Enter amount`
  String get enterAmount {
    return Intl.message(
      'Enter amount',
      name: 'enterAmount',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid amount`
  String get enterValidAmount {
    return Intl.message(
      'Please enter a valid amount',
      name: 'enterValidAmount',
      desc: '',
      args: [],
    );
  }

  /// `Fee request sent: ${fee}`
  String feeRequestSent(Object fee) {
    return Intl.message(
      'Fee request sent: \$$fee',
      name: 'feeRequestSent',
      desc: '',
      args: [fee],
    );
  }

  /// `Send Fee Request`
  String get sendFeeRequest {
    return Intl.message(
      'Send Fee Request',
      name: 'sendFeeRequest',
      desc: '',
      args: [],
    );
  }

  /// `Reason for Rejection`
  String get reasonForRejection {
    return Intl.message(
      'Reason for Rejection',
      name: 'reasonForRejection',
      desc: '',
      args: [],
    );
  }

  /// `Enter reason...`
  String get enterReason {
    return Intl.message(
      'Enter reason...',
      name: 'enterReason',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Booking rejected successfully`
  String get bookingRejected {
    return Intl.message(
      'Booking rejected successfully',
      name: 'bookingRejected',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Completion`
  String get confirmCompletion {
    return Intl.message(
      'Confirm Completion',
      name: 'confirmCompletion',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to mark this booking as completed?`
  String get confirmCompletionMessage {
    return Intl.message(
      'Are you sure you want to mark this booking as completed?',
      name: 'confirmCompletionMessage',
      desc: '',
      args: [],
    );
  }

  /// `Complete`
  String get complete {
    return Intl.message('Complete', name: 'complete', desc: '', args: []);
  }

  /// `Booking marked as completed`
  String get bookingMarkedCompleted {
    return Intl.message(
      'Booking marked as completed',
      name: 'bookingMarkedCompleted',
      desc: '',
      args: [],
    );
  }

  /// `No location available for tracking`
  String get noLocationAvailable {
    return Intl.message(
      'No location available for tracking',
      name: 'noLocationAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Email Verification Sent`
  String get emailVerificationSent {
    return Intl.message(
      'Email Verification Sent',
      name: 'emailVerificationSent',
      desc: '',
      args: [],
    );
  }

  /// `A verification email has been sent to your email address. Please check your inbox and click the verification link.`
  String get verificationEmailSent {
    return Intl.message(
      'A verification email has been sent to your email address. Please check your inbox and click the verification link.',
      name: 'verificationEmailSent',
      desc: '',
      args: [],
    );
  }

  /// `Email verification is still pending. Please check your email and click the verification link.`
  String get verificationFailed {
    return Intl.message(
      'Email verification is still pending. Please check your email and click the verification link.',
      name: 'verificationFailed',
      desc: '',
      args: [],
    );
  }

  /// `Send Again`
  String get sendAgain {
    return Intl.message('Send Again', name: 'sendAgain', desc: '', args: []);
  }

  /// `Resend email in {seconds} seconds`
  String resendEmailInSeconds(Object seconds) {
    return Intl.message(
      'Resend email in $seconds seconds',
      name: 'resendEmailInSeconds',
      desc: '',
      args: [seconds],
    );
  }

  /// `My Bookings`
  String get myBookings {
    return Intl.message('My Bookings', name: 'myBookings', desc: '', args: []);
  }

  /// `Payment Requests`
  String get paymentRequests {
    return Intl.message(
      'Payment Requests',
      name: 'paymentRequests',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get allBookings {
    return Intl.message('All', name: 'allBookings', desc: '', args: []);
  }

  /// `Pending`
  String get pendingBookings {
    return Intl.message('Pending', name: 'pendingBookings', desc: '', args: []);
  }

  /// `Payment Pending`
  String get paymentPendingBookings {
    return Intl.message(
      'Payment Pending',
      name: 'paymentPendingBookings',
      desc: '',
      args: [],
    );
  }

  /// `In Progress`
  String get inProgressBookings {
    return Intl.message(
      'In Progress',
      name: 'inProgressBookings',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completedBookings {
    return Intl.message(
      'Completed',
      name: 'completedBookings',
      desc: '',
      args: [],
    );
  }

  /// `Rejected`
  String get rejectedBookings {
    return Intl.message(
      'Rejected',
      name: 'rejectedBookings',
      desc: '',
      args: [],
    );
  }

  /// `No bookings available.`
  String get noBookingsAvailable {
    return Intl.message(
      'No bookings available.',
      name: 'noBookingsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Skill`
  String get skill {
    return Intl.message('Skill', name: 'skill', desc: '', args: []);
  }

  /// `Exchange`
  String get exchange {
    return Intl.message('Exchange', name: 'exchange', desc: '', args: []);
  }

  /// `Skill exchange`
  String get skillExchange {
    return Intl.message(
      'Skill exchange',
      name: 'skillExchange',
      desc: '',
      args: [],
    );
  }

  /// `Payment`
  String get payment {
    return Intl.message('Payment', name: 'payment', desc: '', args: []);
  }

  /// `Skill Provider`
  String get skillProvider {
    return Intl.message(
      'Skill Provider',
      name: 'skillProvider',
      desc: '',
      args: [],
    );
  }

  /// `Requested on`
  String get requestedOn {
    return Intl.message(
      'Requested on',
      name: 'requestedOn',
      desc: '',
      args: [],
    );
  }

  /// `No notes`
  String get noNotes {
    return Intl.message('No notes', name: 'noNotes', desc: '', args: []);
  }

  /// `View Payment Request`
  String get viewPaymentRequest {
    return Intl.message(
      'View Payment Request',
      name: 'viewPaymentRequest',
      desc: '',
      args: [],
    );
  }

  /// `Track`
  String get track {
    return Intl.message('Track', name: 'track', desc: '', args: []);
  }

  /// `Cancel`
  String get cancelBooking {
    return Intl.message('Cancel', name: 'cancelBooking', desc: '', args: []);
  }

  /// `Rate the Service`
  String get rateTheService {
    return Intl.message(
      'Rate the Service',
      name: 'rateTheService',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Booking`
  String get cancelBookingTitle {
    return Intl.message(
      'Cancel Booking',
      name: 'cancelBookingTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to cancel this booking?`
  String get cancelBookingMessage {
    return Intl.message(
      'Are you sure you want to cancel this booking?',
      name: 'cancelBookingMessage',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `Booking cancelled`
  String get bookingCancelled {
    return Intl.message(
      'Booking cancelled',
      name: 'bookingCancelled',
      desc: '',
      args: [],
    );
  }

  /// `No location available`
  String get noLocationAvailableForTracking {
    return Intl.message(
      'No location available',
      name: 'noLocationAvailableForTracking',
      desc: '',
      args: [],
    );
  }

  /// `Rate the other user`
  String get rateOtherUser {
    return Intl.message(
      'Rate the other user',
      name: 'rateOtherUser',
      desc: '',
      args: [],
    );
  }

  /// `Add a comment (optional)`
  String get addCommentOptional {
    return Intl.message(
      'Add a comment (optional)',
      name: 'addCommentOptional',
      desc: '',
      args: [],
    );
  }

  /// `Review submitted ✅`
  String get reviewSubmitted {
    return Intl.message(
      'Review submitted ✅',
      name: 'reviewSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Track Distance`
  String get trackDistance {
    return Intl.message(
      'Track Distance',
      name: 'trackDistance',
      desc: '',
      args: [],
    );
  }

  /// `Distance`
  String get distance {
    return Intl.message('Distance', name: 'distance', desc: '', args: []);
  }

  /// `Sender`
  String get sender {
    return Intl.message('Sender', name: 'sender', desc: '', args: []);
  }

  /// `You`
  String get you {
    return Intl.message('You', name: 'you', desc: '', args: []);
  }

  /// `No route found`
  String get noRouteFound {
    return Intl.message(
      'No route found',
      name: 'noRouteFound',
      desc: '',
      args: [],
    );
  }

  /// `Destination location not found`
  String get destinationLocationNotFound {
    return Intl.message(
      'Destination location not found',
      name: 'destinationLocationNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Error fetching location`
  String get errorFetchingLocation {
    return Intl.message(
      'Error fetching location',
      name: 'errorFetchingLocation',
      desc: '',
      args: [],
    );
  }

  /// `No payment requests at this time`
  String get noPaymentRequests {
    return Intl.message(
      'No payment requests at this time',
      name: 'noPaymentRequests',
      desc: '',
      args: [],
    );
  }

  /// `Pay Now`
  String get payNow {
    return Intl.message('Pay Now', name: 'payNow', desc: '', args: []);
  }

  /// `Amount`
  String get amount {
    return Intl.message('Amount', name: 'amount', desc: '', args: []);
  }

  /// `Select Payment Method`
  String get selectPaymentMethod {
    return Intl.message(
      'Select Payment Method',
      name: 'selectPaymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Please select a payment method`
  String get pleaseSelectPaymentMethod {
    return Intl.message(
      'Please select a payment method',
      name: 'pleaseSelectPaymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Card Number`
  String get cardNumber {
    return Intl.message('Card Number', name: 'cardNumber', desc: '', args: []);
  }

  /// `Please enter a valid card number`
  String get pleaseEnterValidCardNumber {
    return Intl.message(
      'Please enter a valid card number',
      name: 'pleaseEnterValidCardNumber',
      desc: '',
      args: [],
    );
  }

  /// `Expiry (MM/YY)`
  String get expiryDate {
    return Intl.message(
      'Expiry (MM/YY)',
      name: 'expiryDate',
      desc: '',
      args: [],
    );
  }

  /// `Enter valid date`
  String get enterValidDate {
    return Intl.message(
      'Enter valid date',
      name: 'enterValidDate',
      desc: '',
      args: [],
    );
  }

  /// `CVV`
  String get cvv {
    return Intl.message('CVV', name: 'cvv', desc: '', args: []);
  }

  /// `Enter valid CVV`
  String get enterValidCvv {
    return Intl.message(
      'Enter valid CVV',
      name: 'enterValidCvv',
      desc: '',
      args: [],
    );
  }

  /// `Payment successful! The service provider has been notified.`
  String get paymentSuccessful {
    return Intl.message(
      'Payment successful! The service provider has been notified.',
      name: 'paymentSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Filters`
  String get filters {
    return Intl.message('Filters', name: 'filters', desc: '', args: []);
  }

  /// `Age`
  String get ageRangeLabel {
    return Intl.message('Age', name: 'ageRangeLabel', desc: '', args: []);
  }

  /// `years`
  String get years {
    return Intl.message('years', name: 'years', desc: '', args: []);
  }

  /// `Gender`
  String get genderLabel {
    return Intl.message('Gender', name: 'genderLabel', desc: '', args: []);
  }

  /// `All`
  String get allGender {
    return Intl.message('All', name: 'allGender', desc: '', args: []);
  }

  /// `Male`
  String get maleGender {
    return Intl.message('Male', name: 'maleGender', desc: '', args: []);
  }

  /// `Female`
  String get femaleGender {
    return Intl.message('Female', name: 'femaleGender', desc: '', args: []);
  }

  /// `Maximum Distance`
  String get maxDistanceLabel {
    return Intl.message(
      'Maximum Distance',
      name: 'maxDistanceLabel',
      desc: '',
      args: [],
    );
  }

  /// `km`
  String get kilometers {
    return Intl.message('km', name: 'kilometers', desc: '', args: []);
  }

  /// `Only those with location`
  String get onlyWithLocation {
    return Intl.message(
      'Only those with location',
      name: 'onlyWithLocation',
      desc: '',
      args: [],
    );
  }

  /// `Skills`
  String get skillsLabel {
    return Intl.message('Skills', name: 'skillsLabel', desc: '', args: []);
  }

  /// `Contact`
  String get contact {
    return Intl.message('Contact', name: 'contact', desc: '', args: []);
  }

  /// `Chat`
  String get chat {
    return Intl.message('Chat', name: 'chat', desc: '', args: []);
  }

  /// `Typing now...`
  String get typingNowDots {
    return Intl.message(
      'Typing now...',
      name: 'typingNowDots',
      desc: '',
      args: [],
    );
  }

  /// `Typing now`
  String get typingNow {
    return Intl.message('Typing now', name: 'typingNow', desc: '', args: []);
  }

  /// `Error loading messages`
  String get errorLoadingMessages {
    return Intl.message(
      'Error loading messages',
      name: 'errorLoadingMessages',
      desc: '',
      args: [],
    );
  }

  /// `Start Conversation`
  String get startConversation {
    return Intl.message(
      'Start Conversation',
      name: 'startConversation',
      desc: '',
      args: [],
    );
  }

  /// `Send the first message to start the conversation`
  String get sendFirstMessage {
    return Intl.message(
      'Send the first message to start the conversation',
      name: 'sendFirstMessage',
      desc: '',
      args: [],
    );
  }

  /// `Attachments feature is under development`
  String get attachmentsUnderDevelopment {
    return Intl.message(
      'Attachments feature is under development',
      name: 'attachmentsUnderDevelopment',
      desc: '',
      args: [],
    );
  }

  /// `Write your message here...`
  String get writeYourMessage {
    return Intl.message(
      'Write your message here...',
      name: 'writeYourMessage',
      desc: '',
      args: [],
    );
  }

  /// `h`
  String get hoursAbbreviation {
    return Intl.message('h', name: 'hoursAbbreviation', desc: '', args: []);
  }

  /// `m`
  String get minutesAbbreviation {
    return Intl.message('m', name: 'minutesAbbreviation', desc: '', args: []);
  }

  /// `Now`
  String get now {
    return Intl.message('Now', name: 'now', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
