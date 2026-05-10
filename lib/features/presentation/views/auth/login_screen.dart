import 'package:clean_commerce/features/presentation/viewmodels/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final controller = ref.read(authControllerProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorScheme.primaryFixed, colorScheme.tertiaryFixed],
          ),
        ),
        child: Center(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 24,
                vertical: size.height * 0.05,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(theme, colorScheme),
                    const SizedBox(height: 48),
                    _buildEmailField(controller, theme, colorScheme),
                    const SizedBox(height: 16),
                    _buildPasswordField(controller, theme, colorScheme),
                    const SizedBox(height: 12),
                    _buildOptionsRow(theme, colorScheme),
                    const SizedBox(height: 24),
                    _LoginButton(
                      isLoading: state.isLoading,
                      onPressed: () => _handleLogin(controller),
                    ),
                    const SizedBox(height: 24),
                    _buildSignUpPrompt(theme, colorScheme),
                    const SizedBox(height: 16),
                    _buildSocialLogin(theme, colorScheme),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colorScheme.primaryFixed, colorScheme.tertiaryFixed],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colorScheme.primaryFixedDim.withAlpha(150),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(Icons.shopping_bag, size: 48, color: colorScheme.primary),
        ),
        const SizedBox(height: 24),
        Text(
          "Clean Commerce",
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Login to your account",
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(
    AuthController controller,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return TextFormField(
      controller: _emailCtrl,
      validator: controller.emailValidator,
      keyboardType: TextInputType.emailAddress,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: "Email Address",
        hintText: "you@example.com",
        prefixIcon: Icon(Icons.email_outlined, color: colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: colorScheme.surface,
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    AuthController controller,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return TextFormField(
      controller: _passCtrl,
      obscureText: _obscurePassword,
      validator: controller.passwordValidator,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: "Password",
        prefixIcon: Icon(Icons.lock_outline, color: colorScheme.primary),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: colorScheme.onSurfaceVariant,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: colorScheme.surface,
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildOptionsRow(ThemeData theme, ColorScheme colorScheme) {
    return TextButton(
      onPressed: () {
        // TODO: Implement forgot password
      },
      child: Text(
        "Forgot Password?",
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSignUpPrompt(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        TextButton(
          onPressed: () {
            // TODO: Navigate to signup screen
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            "Sign Up",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLogin(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(color: colorScheme.outline.withOpacity(0.3)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "OR",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              child: Divider(color: colorScheme.outline.withOpacity(0.3)),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _SocialLoginButton(
                icon: Icons.g_mobiledata,
                label: "Google",
                color: Colors.red,
                onPressed: () {
                  // TODO: Implement Google login
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SocialLoginButton(
                icon: Icons.apple,
                label: "Apple",
                color: Colors.black,
                onPressed: () {
                  // TODO: Implement Apple login
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleLogin(AuthController controller) {
    if (_formKey.currentState!.validate()) {
      controller.login(_emailCtrl.text.trim(), _passCtrl.text.trim());
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }
}

class _LoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _LoginButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      height: 55,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 3,
          shadowColor: colorScheme.primary.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: colorScheme.onPrimary,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                "Login",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimary,
                ),
              ),
      ),
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _SocialLoginButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
