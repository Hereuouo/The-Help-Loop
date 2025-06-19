import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'base_scaffold.dart';
import 'font_styles.dart';
import '../generated/l10n.dart';
import '../providers/locale_provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void changeLanguage(BuildContext context, String languageCode) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    localeProvider.setLocale(Locale(languageCode));
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLanguage = localeProvider.locale.languageCode;

    return BaseScaffold(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Container(
                margin: const EdgeInsets.only(bottom: 32),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      S.of(context).selectLanguage,
                      style: FontStyles.body(context, color: Colors.white70),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: currentLanguage,
                        dropdownColor: Colors.grey[800],
                        underline: Container(),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                        style: FontStyles.body(context, color: Colors.white),
                        items: [
                          DropdownMenuItem(
                            value: 'en',
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('🇺🇸', style: TextStyle(fontSize: 18)),
                                const SizedBox(width: 8),
                                Text(S.of(context).english),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'ar',
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('🇸🇦', style: TextStyle(fontSize: 18)),
                                const SizedBox(width: 8),
                                Text(S.of(context).arabic),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            changeLanguage(context, newValue);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),


              Text(
                S.of(context).welcome,
                style: FontStyles.heading(context,
                    fontSize: 32, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),


              _buildButton(
                context,
                icon: Icons.login,
                label: S.of(context).loginButton,
                color: Colors.teal,
                onPressed: () => Navigator.pushNamed(context, '/login'),
              ),
              _buildButton(
                context,
                icon: Icons.app_registration,
                label: S.of(context).register,
                color: Colors.indigo,
                onPressed: () => Navigator.pushNamed(context, '/register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color color,
        required VoidCallback onPressed,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: Icon(icon, size: 22, color: Colors.white),
          label: Text(label,
              style:
              FontStyles.body(context, fontSize: 18, color: Colors.white)),
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 4,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            shadowColor: Colors.black45,
          ),
        ),
      ),
    );
  }

  void _checkLoginAndNavigate(BuildContext context, Widget screen) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).mustLoginMessage),
          backgroundColor: Colors.redAccent,
        ),
      );
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    }
  }
}