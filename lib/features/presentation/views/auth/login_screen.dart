import 'package:clean_commerce/features/presentation/viewmodels/auth_controller.dart';
import 'package:clean_commerce/features/presentation/views/auth/forgot_password.dart';
import 'package:clean_commerce/features/presentation/views/auth/signup_screen.dart';
import 'package:clean_commerce/features/presentation/widgets/custom_textformfield.dart';
import 'package:clean_commerce/features/presentation/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final controller = ref.read(authControllerProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
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
                  _buildEmailField(controller),
                  const SizedBox(height: 16),
                  _buildPasswordField(controller),
                  const SizedBox(height: 12),
                  _buildForgotPassword(theme, colorScheme),
                  const SizedBox(height: 24),
                  _buildLoginBtn(state, controller),
                  const SizedBox(height: 24),
                  _buildSignUpPrompt(theme, colorScheme),
                  const SizedBox(height: 16),
                  _buildSocialLogin(controller, theme, colorScheme),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  CustomTextFormField _buildEmailField(AuthController controller) {
    return CustomTextFormField(
      textController: _emailCtrl,
      label: "Email",
      hint: "yourmail@gmail.com",
      obscureText: false,
      prefixIcon: Icons.mail_outline,
      validator: controller.emailValidator,
    );
  }

  CustomTextFormField _buildPasswordField(AuthController controller) {
    return CustomTextFormField(
      textController: _passCtrl,
      label: "Password",
      hint: '',
      obscureText: true,
      prefixIcon: Icons.lock_outline,
      validator: controller.passwordValidator,
    );
  }

  AuthButton _buildLoginBtn(AuthState state, AuthController controller) {
    return AuthButton(
      text: "Login",
      isLoading: state.isLoading,
      onPressed: () => _handleLogin(controller),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        Logo(),
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

  TextButton _buildForgotPassword(ThemeData theme, ColorScheme colorScheme) {
    return TextButton(
      onPressed: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => ForgotPassword()));
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
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => SignupScreen()));
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

  Widget _buildSocialLogin(
    AuthController controller,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: colorScheme.outline.withAlpha(30))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "OR",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(child: Divider(color: colorScheme.outline.withAlpha(30))),
          ],
        ),
        const SizedBox(height: 24),
        SocialLoginButton(
          icon: Icons.g_mobiledata,
          label: "Google Login",
          color: Colors.red,
          onPressed: () => controller.googleSignIn(),
        ),
        const SizedBox(width: 16),
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
