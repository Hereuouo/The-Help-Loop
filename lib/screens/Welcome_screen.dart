import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'base_scaffold.dart';
import 'font_styles.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome",
                style: FontStyles.heading(context,
                    fontSize: 32, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _buildButton(
                context,
                icon: Icons.login,
                label: "Login",
                color: Colors.teal,
                onPressed: () => Navigator.pushNamed(context, '/login'),
              ),
              _buildButton(
                context,
                icon: Icons.app_registration,
                label: "Register",
                color: Colors.indigo,
                onPressed: () => Navigator.pushNamed(context, '/register'),
              ),
              _buildButton(
                context,
                icon: Icons.home,
                label: "Go to Home Screen",
                color: Colors.green.shade700,
                onPressed: () =>
                    _checkLoginAndNavigate(context, const HomeScreen()),
              ),
              _buildButton(
                context,
                icon: Icons.person,
                label: "Go to Profile Screen",
                color: Colors.deepPurple,
                onPressed: () =>
                    _checkLoginAndNavigate(context, const ProfileScreen()),
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
        const SnackBar(
          content: Text("You must log in to access this screen."),
          backgroundColor: Colors.redAccent,
        ),
      );
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    }
  }
}
