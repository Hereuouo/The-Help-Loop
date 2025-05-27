import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'font_styles.dart';
import 'base_scaffold.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PaymentRequestsScreen extends StatelessWidget {
  const PaymentRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text('You must be logged in to view payment requests'),
        ),
      );
    }

    return BaseScaffold(
      title: 'Payment Requests',
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('fromUserId', isEqualTo: currentUser.uid)
            .where('status', isEqualTo: 'payment_pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.payment_outlined,
                      size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No payment requests at this time',
                    style: FontStyles.heading(context,
                        color: Colors.grey.shade700),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(data['toUserId'])
                    .get(),
                builder: (context, providerSnapshot) {
                  if (!providerSnapshot.hasData) {
                    return const SizedBox();
                  }

                  final providerData =
                      providerSnapshot.data!.data() as Map<String, dynamic>;
                  final providerName =
                      providerData['name'] ?? 'Unknown Provider';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person, color: Colors.blue.shade800),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  providerName,
                                  style: FontStyles.heading(context,
                                      fontSize: 18,
                                      color: Colors.blue.shade800),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Service: ${data['requestedSkill']}",
                            style: FontStyles.body(context,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Start Date: ${(data['startDate'] as Timestamp).toDate().toString().split(' ')[0]}",
                            style:
                                FontStyles.body(context, color: Colors.black),
                          ),
                          Text(
                            "Duration: ${data['duration']}",
                            style:
                                FontStyles.body(context, color: Colors.black),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.amber.shade200),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.attach_money,
                                    color: Colors.amber),
                                const SizedBox(width: 8),
                                Text(
                                  "Requested Fee: ${data['feeAmount']?.toStringAsFixed(2) ?? '0.00'}",
                                  style: FontStyles.body(context,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.cancel_outlined,
                                      color: Colors.white),
                                  label: Text(
                                    'Cancel Booking',
                                    style: FontStyles.body(context,
                                        color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade600,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                  onPressed: () =>
                                      _cancelBooking(context, doc.id),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.payment,
                                      color: Colors.white),
                                  label: Text(
                                    'Pay Now',
                                    style: FontStyles.body(context,
                                        color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF00695C),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                  onPressed: () {
                                    final feeAmount =
                                        (data['feeAmount'] ?? 0.0) as double;
                                    _confirmPayment(context, doc.id, feeAmount);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmPayment(
      BuildContext context, String bookingId, double feeAmount) async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final amountController =
        TextEditingController(text: feeAmount.toStringAsFixed(2));
    final cardNumberController = TextEditingController();
    final expiryDateController = TextEditingController();
    final cvvController = TextEditingController();

    var cardFormatter = MaskTextInputFormatter(
        mask: '#### #### #### ####', filter: {"#": RegExp(r'[0-9]')});
    var expiryFormatter =
        MaskTextInputFormatter(mask: '##/##', filter: {"#": RegExp(r'[0-9]')});
    var cvvFormatter =
        MaskTextInputFormatter(mask: '###', filter: {"#": RegExp(r'[0-9]')});

    String? selectedPaymentMethod;
    final List<Map<String, String>> paymentMethods = [
      {"name": "Mada", "image": "assets/images/mada.png"},
      {"name": "MasterCard", "image": "assets/images/mastercard.png"},
      {"name": "STC Pay", "image": "assets/images/stc.png"},
    ];

    bool showCardError = false;
    bool showExpiryError = false;
    bool showCvvError = false;
    bool showPaymentMethodError = false;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              backgroundColor: const Color(0xFFECEAFF),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text("Payment",
                            style: FontStyles.heading(context,
                                fontSize: 24, color: Colors.teal.shade900)),
                      ),
                      const SizedBox(height: 20),
                      _buildPaymentField(
                        context,
                        "Amount",
                        amountController,
                        Icons.attach_money,
                        true,
                        null,
                      ),
                      const SizedBox(height: 20),
                      Text("Select Payment Method",
                          style: FontStyles.body(context,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: paymentMethods
                            .map((method) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedPaymentMethod =
                                          method["name"] as String;
                                      showPaymentMethodError = false;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: selectedPaymentMethod ==
                                                  method["name"]
                                              ? const Color(0xFF00695C)
                                              : Colors.grey.shade300,
                                          width: 2),
                                    ),
                                    child: Image.asset(
                                      method["image"] as String,
                                      width: 60,
                                      height: 40,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(
                                          Icons.credit_card,
                                          size: 40,
                                          color: Colors.grey.shade500,
                                        );
                                      },
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                      if (showPaymentMethodError)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "Please select a payment method",
                            style: FontStyles.body(context,
                                color: Colors.red, fontSize: 12),
                          ),
                        ),
                      const SizedBox(height: 20),
                      _buildPaymentField(
                        context,
                        "Card Number",
                        cardNumberController,
                        Icons.credit_card,
                        false,
                        showCardError
                            ? "Please enter a valid card number"
                            : null,
                        formatter: cardFormatter,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildPaymentField(
                              context,
                              "Expiry (MM/YY)",
                              expiryDateController,
                              Icons.date_range,
                              false,
                              showExpiryError ? "Enter valid date" : null,
                              formatter: expiryFormatter,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildPaymentField(
                              context,
                              "CVV",
                              cvvController,
                              Icons.lock_outline,
                              false,
                              showCvvError ? "Enter valid CVV" : null,
                              formatter: cvvFormatter,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(false),
                            child: Text(
                              "Cancel",
                              style:
                                  FontStyles.body(context, color: Colors.grey),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              bool isValid = true;

                              if (selectedPaymentMethod == null) {
                                setState(() => showPaymentMethodError = true);
                                isValid = false;
                              }

                              if (cardNumberController.text
                                      .replaceAll(" ", "")
                                      .length !=
                                  16) {
                                setState(() => showCardError = true);
                                isValid = false;
                              }

                              if (expiryDateController.text.length != 5) {
                                setState(() => showExpiryError = true);
                                isValid = false;
                              }

                              if (cvvController.text.length < 3) {
                                setState(() => showCvvError = true);
                                isValid = false;
                              }

                              if (isValid) {
                                Navigator.of(dialogContext).pop(true);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00695C),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Pay Now",
                              style: FontStyles.body(context,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (confirmed == true) {
      try {
        BuildContext? loadingContext;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) {
            loadingContext = ctx;
            return const Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            );
          },
        );

        await Future.delayed(const Duration(seconds: 2));

        await FirebaseFirestore.instance
            .collection('bookings')
            .doc(bookingId)
            .update({
          'status': 'in_progress',
          'paymentStatus': 'completed',
          'paymentMethod': selectedPaymentMethod,
          'paymentDate': FieldValue.serverTimestamp(),
        });

        if (loadingContext != null) {
          Navigator.of(loadingContext!).pop();
        }

        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
              'Payment successful! The service provider has been notified.',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color(0xFF00695C),
            duration: const Duration(seconds: 3),
          ),
        );

        navigator.pop();
      } catch (e) {
        BuildContext? loadingContext;

        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
              'Payment failed: $e',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildPaymentField(
    BuildContext context,
    String label,
    TextEditingController controller,
    IconData icon,
    bool readOnly,
    String? errorText, {
    MaskTextInputFormatter? formatter,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: FontStyles.body(context,
                color: Colors.black87, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: errorText != null ? Colors.red : Colors.grey.shade300,
              ),
            ),
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              inputFormatters: formatter != null ? [formatter] : null,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: InputBorder.none,
                prefixIcon: Icon(icon, color: Colors.teal.shade700),
                hintText: label,
                errorText: errorText,
                errorStyle:
                    FontStyles.body(context, color: Colors.red, fontSize: 0),
              ),
              style: FontStyles.body(context, color: Colors.black87),
            ),
          ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 12),
              child: Text(
                errorText,
                style:
                    FontStyles.body(context, color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _cancelBooking(BuildContext context, String bookingId) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({
        'status': 'rejected',
        'paymentStatus': 'cancelled',
        'rejectionReason': 'User declined the requested fee',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking cancelled successfully'),
          backgroundColor: Colors.orange,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
