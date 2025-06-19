// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(skill) => "Booking accepted with skill exchange: ${skill}";

  static String m1(error) => "Failed: ${error}";

  static String m2(date) => "Cannot complete before ${date}";

  static String m3(userName) =>
      "Choose one of ${userName}\'s skills in exchange";

  static String m4(skill) => "Are you sure you want to remove \"${skill}\"?";

  static String m5(error) => "Error adding skills: ${error}";

  static String m6(error) => "Failed to update: ${error}";

  static String m7(fee) => "Fee request sent: \$${fee}";

  static String m8(seconds) => "Resend email in ${seconds} seconds";

  static String m9(userName) => "Select Skill from ${userName}";

  static String m10(skill) => "Skill \"${skill}\" deleted";

  static String m11(bookingId) => "Skill exchange for booking: ${bookingId}";

  static String m12(userName) => "${userName} has no skills available";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "accept": MessageLookupByLibrary.simpleMessage("Accept"),
    "addCommentOptional": MessageLookupByLibrary.simpleMessage(
      "Add a comment (optional)",
    ),
    "addCustomSkill": MessageLookupByLibrary.simpleMessage("Add Custom Skill"),
    "addSkills": MessageLookupByLibrary.simpleMessage("Add Skills"),
    "address": MessageLookupByLibrary.simpleMessage("Address"),
    "age": MessageLookupByLibrary.simpleMessage("Age"),
    "ageRangeLabel": MessageLookupByLibrary.simpleMessage("Age"),
    "all": MessageLookupByLibrary.simpleMessage("All"),
    "allBookings": MessageLookupByLibrary.simpleMessage("All"),
    "allGender": MessageLookupByLibrary.simpleMessage("All"),
    "allSkills": MessageLookupByLibrary.simpleMessage("All Skills:"),
    "amount": MessageLookupByLibrary.simpleMessage("Amount"),
    "appSettings": MessageLookupByLibrary.simpleMessage("App Settings"),
    "arabic": MessageLookupByLibrary.simpleMessage("العربية"),
    "attachmentsUnderDevelopment": MessageLookupByLibrary.simpleMessage(
      "Attachments feature is under development",
    ),
    "back": MessageLookupByLibrary.simpleMessage("Back"),
    "bookService": MessageLookupByLibrary.simpleMessage("Book Service"),
    "bookingAcceptedWithSkillExchange": m0,
    "bookingCancelled": MessageLookupByLibrary.simpleMessage(
      "Booking cancelled",
    ),
    "bookingFailed": m1,
    "bookingMarkedCompleted": MessageLookupByLibrary.simpleMessage(
      "Booking marked as completed",
    ),
    "bookingRejected": MessageLookupByLibrary.simpleMessage(
      "Booking rejected successfully",
    ),
    "bookingSent": MessageLookupByLibrary.simpleMessage("Booking sent ✅"),
    "bookingSkillDetails": MessageLookupByLibrary.simpleMessage(
      "Booking Skill Details",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cancelBooking": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cancelBookingMessage": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to cancel this booking?",
    ),
    "cancelBookingTitle": MessageLookupByLibrary.simpleMessage(
      "Cancel Booking",
    ),
    "cannotCompleteBefore": m2,
    "cannotUseAppWithoutAgreement": MessageLookupByLibrary.simpleMessage(
      "Sorry, you won\'t be able to use the app without agreeing to the terms. Thank you!",
    ),
    "cardNumber": MessageLookupByLibrary.simpleMessage("Card Number"),
    "chat": MessageLookupByLibrary.simpleMessage("Chat"),
    "chooseCompensationMessage": MessageLookupByLibrary.simpleMessage(
      "How would you like to be compensated for this service?",
    ),
    "chooseExchangeType": MessageLookupByLibrary.simpleMessage(
      "Choose Exchange Type",
    ),
    "chooseLocation": MessageLookupByLibrary.simpleMessage(
      "Choose your location",
    ),
    "chooseSkillInExchange": MessageLookupByLibrary.simpleMessage(
      "Choose a skill you want in exchange:",
    ),
    "chooseStartDate": MessageLookupByLibrary.simpleMessage(
      "Choose start date",
    ),
    "chooseSuggestedSkills": MessageLookupByLibrary.simpleMessage(
      "Choose from suggested skills:",
    ),
    "chooseUserSkillsExchange": m3,
    "complete": MessageLookupByLibrary.simpleMessage("Complete"),
    "completeAllFields": MessageLookupByLibrary.simpleMessage(
      "Complete all fields please",
    ),
    "completedBookings": MessageLookupByLibrary.simpleMessage("Completed"),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "confirmCompletion": MessageLookupByLibrary.simpleMessage(
      "Confirm Completion",
    ),
    "confirmCompletionMessage": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to mark this booking as completed?",
    ),
    "confirmDelete": MessageLookupByLibrary.simpleMessage("Confirm Delete"),
    "confirmDeleteSkill": m4,
    "confirmExchange": MessageLookupByLibrary.simpleMessage("Confirm Exchange"),
    "confirmLogout": MessageLookupByLibrary.simpleMessage("Confirm Logout"),
    "contact": MessageLookupByLibrary.simpleMessage("Contact"),
    "continueButton": MessageLookupByLibrary.simpleMessage("Continue"),
    "cvv": MessageLookupByLibrary.simpleMessage("CVV"),
    "day": MessageLookupByLibrary.simpleMessage("Day"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "destinationLocationNotFound": MessageLookupByLibrary.simpleMessage(
      "Destination location not found",
    ),
    "distance": MessageLookupByLibrary.simpleMessage("Distance"),
    "duration": MessageLookupByLibrary.simpleMessage("Duration"),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "emailVerificationSent": MessageLookupByLibrary.simpleMessage(
      "Email Verification Sent",
    ),
    "english": MessageLookupByLibrary.simpleMessage("English"),
    "enterAmount": MessageLookupByLibrary.simpleMessage("Enter amount"),
    "enterAmountForService": MessageLookupByLibrary.simpleMessage(
      "Enter the amount you want to charge for this service:",
    ),
    "enterReason": MessageLookupByLibrary.simpleMessage("Enter reason..."),
    "enterValidAmount": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid amount",
    ),
    "enterValidCvv": MessageLookupByLibrary.simpleMessage("Enter valid CVV"),
    "enterValidDate": MessageLookupByLibrary.simpleMessage("Enter valid date"),
    "error": MessageLookupByLibrary.simpleMessage("Error"),
    "errorAddingSkills": m5,
    "errorFetchingLocation": MessageLookupByLibrary.simpleMessage(
      "Error fetching location",
    ),
    "errorLoadingMessages": MessageLookupByLibrary.simpleMessage(
      "Error loading messages",
    ),
    "errorSavingData": MessageLookupByLibrary.simpleMessage(
      "An error occurred while saving data. Please try again later.",
    ),
    "exchange": MessageLookupByLibrary.simpleMessage("Exchange"),
    "exchangeSkills": MessageLookupByLibrary.simpleMessage("Exchange Skills"),
    "exchangedSkill": MessageLookupByLibrary.simpleMessage("Exchanged Skill"),
    "expiryDate": MessageLookupByLibrary.simpleMessage("Expiry (MM/YY)"),
    "failedToUpdate": m6,
    "fee": MessageLookupByLibrary.simpleMessage("Fee"),
    "feeRequestSent": m7,
    "female": MessageLookupByLibrary.simpleMessage("Female"),
    "femaleGender": MessageLookupByLibrary.simpleMessage("Female"),
    "filters": MessageLookupByLibrary.simpleMessage("Filters"),
    "fromUser": MessageLookupByLibrary.simpleMessage("From User"),
    "gender": MessageLookupByLibrary.simpleMessage("Gender"),
    "genderLabel": MessageLookupByLibrary.simpleMessage("Gender"),
    "goToHome": MessageLookupByLibrary.simpleMessage("Go to Home Screen"),
    "goToProfile": MessageLookupByLibrary.simpleMessage("Go to Profile Screen"),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "hoursAbbreviation": MessageLookupByLibrary.simpleMessage("h"),
    "inProgressBookings": MessageLookupByLibrary.simpleMessage("In Progress"),
    "incomingRequests": MessageLookupByLibrary.simpleMessage(
      "Incoming Requests",
    ),
    "invalidEmail": MessageLookupByLibrary.simpleMessage(
      "Invalid email address",
    ),
    "kilometers": MessageLookupByLibrary.simpleMessage("km"),
    "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
    "location": MessageLookupByLibrary.simpleMessage("Location"),
    "locationUpdated": MessageLookupByLibrary.simpleMessage(
      "Location updated!",
    ),
    "login": MessageLookupByLibrary.simpleMessage("Login"),
    "loginButton": MessageLookupByLibrary.simpleMessage("Login"),
    "loginError": MessageLookupByLibrary.simpleMessage(
      "Login failed. Please check your credentials and try again.",
    ),
    "logout": MessageLookupByLibrary.simpleMessage("Log Out"),
    "logoutConfirmMessage": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to log out?",
    ),
    "male": MessageLookupByLibrary.simpleMessage("Male"),
    "maleGender": MessageLookupByLibrary.simpleMessage("Male"),
    "manageMyBookings": MessageLookupByLibrary.simpleMessage(
      "Manage My Bookings",
    ),
    "markAsCompleted": MessageLookupByLibrary.simpleMessage(
      "Mark as Completed",
    ),
    "maxDistanceLabel": MessageLookupByLibrary.simpleMessage(
      "Maximum Distance",
    ),
    "minutesAbbreviation": MessageLookupByLibrary.simpleMessage("m"),
    "month": MessageLookupByLibrary.simpleMessage("Month"),
    "mustLoginFirst": MessageLookupByLibrary.simpleMessage(
      "You must log in first",
    ),
    "mustLoginMessage": MessageLookupByLibrary.simpleMessage(
      "You must log in to access this screen.",
    ),
    "myBookings": MessageLookupByLibrary.simpleMessage("My Bookings"),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "nameCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
      "Name cannot be empty",
    ),
    "nameUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Name updated successfully!",
    ),
    "no": MessageLookupByLibrary.simpleMessage("No"),
    "noBookingsAvailable": MessageLookupByLibrary.simpleMessage(
      "No bookings available.",
    ),
    "noIncomingRequests": MessageLookupByLibrary.simpleMessage(
      "No incoming requests found",
    ),
    "noLocationAvailable": MessageLookupByLibrary.simpleMessage(
      "No location available for tracking",
    ),
    "noLocationAvailableForTracking": MessageLookupByLibrary.simpleMessage(
      "No location available",
    ),
    "noMatchingUsers": MessageLookupByLibrary.simpleMessage(
      "No matching users found for this skill.\nPlease try a different search keyword.",
    ),
    "noNewSkillsToAdd": MessageLookupByLibrary.simpleMessage(
      "No new skills to add.",
    ),
    "noNotes": MessageLookupByLibrary.simpleMessage("No notes"),
    "noPaymentRequests": MessageLookupByLibrary.simpleMessage(
      "No payment requests at this time",
    ),
    "noRouteFound": MessageLookupByLibrary.simpleMessage("No route found"),
    "noSkillsAdded": MessageLookupByLibrary.simpleMessage("No skills added."),
    "none": MessageLookupByLibrary.simpleMessage("None"),
    "notSelected": MessageLookupByLibrary.simpleMessage("Not selected"),
    "notes": MessageLookupByLibrary.simpleMessage("Notes (optional)"),
    "now": MessageLookupByLibrary.simpleMessage("Now"),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "onlyWithLocation": MessageLookupByLibrary.simpleMessage(
      "Only those with location",
    ),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
      "Password cannot be empty",
    ),
    "payNow": MessageLookupByLibrary.simpleMessage("Pay Now"),
    "payment": MessageLookupByLibrary.simpleMessage("Payment"),
    "paymentPendingBookings": MessageLookupByLibrary.simpleMessage(
      "Payment Pending",
    ),
    "paymentRequests": MessageLookupByLibrary.simpleMessage("Payment Requests"),
    "paymentSuccessful": MessageLookupByLibrary.simpleMessage(
      "Payment successful! The service provider has been notified.",
    ),
    "paymentWillingnessQuestion": MessageLookupByLibrary.simpleMessage(
      "Are you willing to pay a small fee to receive services if you don\'t have skills to exchange?",
    ),
    "pendingBookings": MessageLookupByLibrary.simpleMessage("Pending"),
    "pickLocation": MessageLookupByLibrary.simpleMessage("Pick Location"),
    "playServicesUnavailable": MessageLookupByLibrary.simpleMessage(
      "Google Play Services unavailable",
    ),
    "pleaseEnterValidCardNumber": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid card number",
    ),
    "pleaseIndicatePaymentWillingness": MessageLookupByLibrary.simpleMessage(
      "Please indicate if you are willing to pay a fee.",
    ),
    "pleaseSelectAge": MessageLookupByLibrary.simpleMessage(
      "Please select your age",
    ),
    "pleaseSelectGender": MessageLookupByLibrary.simpleMessage(
      "Please select your gender",
    ),
    "pleaseSelectLocation": MessageLookupByLibrary.simpleMessage(
      "Please select your location",
    ),
    "pleaseSelectPaymentMethod": MessageLookupByLibrary.simpleMessage(
      "Please select a payment method",
    ),
    "pleaseSelectSkills": MessageLookupByLibrary.simpleMessage(
      "Please select or enter at least one skill.",
    ),
    "profile": MessageLookupByLibrary.simpleMessage("Profile"),
    "providerLocationUnavailable": MessageLookupByLibrary.simpleMessage(
      "Provider location unavailable.",
    ),
    "providerNotFound": MessageLookupByLibrary.simpleMessage(
      "Provider not found",
    ),
    "rateOtherUser": MessageLookupByLibrary.simpleMessage(
      "Rate the other user",
    ),
    "rateTheService": MessageLookupByLibrary.simpleMessage("Rate the Service"),
    "reasonForRejection": MessageLookupByLibrary.simpleMessage(
      "Reason for Rejection",
    ),
    "reciprocalBookingCreated": MessageLookupByLibrary.simpleMessage(
      "A reciprocal booking has been created",
    ),
    "register": MessageLookupByLibrary.simpleMessage("Register"),
    "registrationFailed": MessageLookupByLibrary.simpleMessage(
      "Registration failed",
    ),
    "registrationSuccessful": MessageLookupByLibrary.simpleMessage(
      "Registration successful! A verification email has been sent.",
    ),
    "reject": MessageLookupByLibrary.simpleMessage("Reject"),
    "rejectedBookings": MessageLookupByLibrary.simpleMessage("Rejected"),
    "requestFee": MessageLookupByLibrary.simpleMessage("Request Fee"),
    "requestedOn": MessageLookupByLibrary.simpleMessage("Requested on"),
    "requestedSkill": MessageLookupByLibrary.simpleMessage("Requested Skill:"),
    "requesterLocationUnavailable": MessageLookupByLibrary.simpleMessage(
      "Requester location unavailable",
    ),
    "requesterNotFound": MessageLookupByLibrary.simpleMessage(
      "Requester not found",
    ),
    "requiresSmallFee": MessageLookupByLibrary.simpleMessage(
      "Requires Small Fee",
    ),
    "resendEmailInSeconds": m8,
    "reviewSubmitted": MessageLookupByLibrary.simpleMessage(
      "Review submitted ✅",
    ),
    "saveSkills": MessageLookupByLibrary.simpleMessage("Save Skills"),
    "searchFailed": MessageLookupByLibrary.simpleMessage("Search failed"),
    "searchSkills": MessageLookupByLibrary.simpleMessage("Search for skills…"),
    "selectGender": MessageLookupByLibrary.simpleMessage("Select Gender"),
    "selectLanguage": MessageLookupByLibrary.simpleMessage("Language:"),
    "selectPaymentMethod": MessageLookupByLibrary.simpleMessage(
      "Select Payment Method",
    ),
    "selectSkillFromUser": m9,
    "selectYourSkills": MessageLookupByLibrary.simpleMessage(
      "Select Your Skills",
    ),
    "selectedSkills": MessageLookupByLibrary.simpleMessage("Selected Skills:"),
    "selectionRequired": MessageLookupByLibrary.simpleMessage(
      "Selection Required",
    ),
    "sendAgain": MessageLookupByLibrary.simpleMessage("Send Again"),
    "sendFeeRequest": MessageLookupByLibrary.simpleMessage("Send Fee Request"),
    "sendFirstMessage": MessageLookupByLibrary.simpleMessage(
      "Send the first message to start the conversation",
    ),
    "sender": MessageLookupByLibrary.simpleMessage("Sender"),
    "setFeeForService": MessageLookupByLibrary.simpleMessage(
      "Set a fee for your service",
    ),
    "signUp": MessageLookupByLibrary.simpleMessage("Sign Up"),
    "skill": MessageLookupByLibrary.simpleMessage("Skill"),
    "skillAccounting": MessageLookupByLibrary.simpleMessage("Accounting"),
    "skillCarpentry": MessageLookupByLibrary.simpleMessage("Carpentry"),
    "skillChildcare": MessageLookupByLibrary.simpleMessage("Childcare"),
    "skillCooking": MessageLookupByLibrary.simpleMessage("Cooking"),
    "skillDeleted": m10,
    "skillDeviceRepair": MessageLookupByLibrary.simpleMessage("Device Repair"),
    "skillEventPlanning": MessageLookupByLibrary.simpleMessage(
      "Event Planning",
    ),
    "skillExchange": MessageLookupByLibrary.simpleMessage("Skill exchange"),
    "skillExchangeAvailable": MessageLookupByLibrary.simpleMessage(
      "Skill Exchange Available",
    ),
    "skillExchangeForBooking": m11,
    "skillFitnessTraining": MessageLookupByLibrary.simpleMessage(
      "Fitness Training",
    ),
    "skillGardening": MessageLookupByLibrary.simpleMessage("Gardening"),
    "skillGraphicDesign": MessageLookupByLibrary.simpleMessage(
      "Graphic Design",
    ),
    "skillMarketing": MessageLookupByLibrary.simpleMessage("Marketing"),
    "skillMusicLessons": MessageLookupByLibrary.simpleMessage("Music Lessons"),
    "skillPainting": MessageLookupByLibrary.simpleMessage("Painting"),
    "skillPhotography": MessageLookupByLibrary.simpleMessage("Photography"),
    "skillPrivateTutoring": MessageLookupByLibrary.simpleMessage(
      "Private Tutoring",
    ),
    "skillProgramming": MessageLookupByLibrary.simpleMessage("Programming"),
    "skillProvider": MessageLookupByLibrary.simpleMessage("Skill Provider"),
    "skillSewing": MessageLookupByLibrary.simpleMessage("Sewing"),
    "skillTranslation": MessageLookupByLibrary.simpleMessage("Translation"),
    "skillVideoEditing": MessageLookupByLibrary.simpleMessage("Video Editing"),
    "skillWebDevelopment": MessageLookupByLibrary.simpleMessage(
      "Web Development",
    ),
    "skillWriting": MessageLookupByLibrary.simpleMessage("Writing"),
    "skills": MessageLookupByLibrary.simpleMessage("Skills"),
    "skillsAddedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Skills added successfully!",
    ),
    "skillsLabel": MessageLookupByLibrary.simpleMessage("Skills"),
    "sorry": MessageLookupByLibrary.simpleMessage("Sorry"),
    "startConversation": MessageLookupByLibrary.simpleMessage(
      "Start Conversation",
    ),
    "startDate": MessageLookupByLibrary.simpleMessage("Start Date"),
    "status": MessageLookupByLibrary.simpleMessage("Status"),
    "statusCompleted": MessageLookupByLibrary.simpleMessage("Completed"),
    "statusInProgress": MessageLookupByLibrary.simpleMessage("In Progress"),
    "statusPaymentPending": MessageLookupByLibrary.simpleMessage(
      "Payment Pending",
    ),
    "statusPending": MessageLookupByLibrary.simpleMessage("Pending"),
    "statusRejected": MessageLookupByLibrary.simpleMessage("Rejected"),
    "submit": MessageLookupByLibrary.simpleMessage("Submit"),
    "systemSupport": MessageLookupByLibrary.simpleMessage("System Support"),
    "termsOfApp": MessageLookupByLibrary.simpleMessage("Terms of App"),
    "track": MessageLookupByLibrary.simpleMessage("Track"),
    "trackDistance": MessageLookupByLibrary.simpleMessage("Track Distance"),
    "trackTrip": MessageLookupByLibrary.simpleMessage("Track Trip"),
    "trustScore": MessageLookupByLibrary.simpleMessage("Trust Score"),
    "twoDays": MessageLookupByLibrary.simpleMessage("2 Days"),
    "typeCustomSkill": MessageLookupByLibrary.simpleMessage(
      "Or type your own skill:",
    ),
    "typingNow": MessageLookupByLibrary.simpleMessage("Typing now"),
    "typingNowDots": MessageLookupByLibrary.simpleMessage("Typing now..."),
    "unavailable": MessageLookupByLibrary.simpleMessage("unavailable"),
    "unknown": MessageLookupByLibrary.simpleMessage("Unknown"),
    "userHasNoSkills": m12,
    "userNotLoggedIn": MessageLookupByLibrary.simpleMessage(
      "User not logged in",
    ),
    "verificationEmailSent": MessageLookupByLibrary.simpleMessage(
      "A verification email has been sent to your email address. Please check your inbox and click the verification link.",
    ),
    "verificationFailed": MessageLookupByLibrary.simpleMessage(
      "Email verification is still pending. Please check your email and click the verification link.",
    ),
    "viewPaymentRequest": MessageLookupByLibrary.simpleMessage(
      "View Payment Request",
    ),
    "week": MessageLookupByLibrary.simpleMessage("Week"),
    "welcome": MessageLookupByLibrary.simpleMessage("Welcome"),
    "welcomeMessage": MessageLookupByLibrary.simpleMessage(
      "Welcome! Use the search bar above to look for a skill or service.\n\nYou can also check your incoming requests to offer your help if needed.",
    ),
    "willingToPay": MessageLookupByLibrary.simpleMessage("Willing to Pay"),
    "writeYourMessage": MessageLookupByLibrary.simpleMessage(
      "Write your message here...",
    ),
    "years": MessageLookupByLibrary.simpleMessage("years"),
    "yes": MessageLookupByLibrary.simpleMessage("Yes"),
    "you": MessageLookupByLibrary.simpleMessage("You"),
  };
}
