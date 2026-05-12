import 'package:clean_commerce/features/presentation/viewmodels/auth_controller.dart';
import 'package:clean_commerce/features/presentation/views/auth/widgets/auth_btn.dart';
import 'package:clean_commerce/features/presentation/widgets/custom_textformfield.dart';
import 'package:clean_commerce/features/presentation/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  String _selectedGender = 'Male';
  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final controller = ref.read(authControllerProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Create Account"), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(theme, colorScheme),
                SizedBox(height: 3.h),
                _buildNameRow(),
                SizedBox(height: 2.h),
                _buildEmailField(controller),
                SizedBox(height: 2.h),
                _buildPhoneField(),
                SizedBox(height: 2.h),
                _buildPasswordField(controller),
                SizedBox(height: 2.h),
                _buildConfirmPasswordField(),
                SizedBox(height: 3.h),
                AuthButton(
                  text: 'Sign Up',
                  isLoading: state.isLoading,
                  onPressed: () => _handleSignup(controller),
                ),
                SizedBox(height: 2.h),
                _LoginPrompt(),
                SizedBox(height: 3.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        const Logo(),
        SizedBox(height: 2.h),
        Text(
          "Sign up to get started",
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildNameRow() {
    return Row(
      children: [
        Expanded(
          child: CustomTextFormField(
            textController: _firstNameCtrl,
            label: "First Name",
            hint: "John",
            obscureText: false,
            prefixIcon: Icons.person_outline,
            validator: (value) =>
                value?.isEmpty == true ? 'Enter first name' : null,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: CustomTextFormField(
            textController: _lastNameCtrl,
            label: "Last Name",
            hint: "Doe",
            obscureText: false,
            prefixIcon: Icons.person_outline,
            validator: (value) =>
                value?.isEmpty == true ? 'Enter last name' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(AuthController controller) {
    return CustomTextFormField(
      textController: _emailCtrl,
      label: "Email",
      hint: "yourmail@gmail.com",
      obscureText: false,
      prefixIcon: Icons.mail_outline,
      validator: controller.emailValidator,
    );
  }

  Widget _buildPhoneField() {
    return CustomTextFormField(
      textController: _phoneCtrl,
      label: "Phone",
      hint: "+1234567890",
      obscureText: false,
      prefixIcon: Icons.phone_outlined,
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value?.isEmpty == true) return 'Enter phone number';
        if (value!.length < 10) return 'Enter valid phone number';
        return null;
      },
    );
  }

  Widget _buildAddressField() {
    return CustomTextFormField(
      textController: _addressCtrl,
      label: "Address",
      hint: "123 Main Street, City",
      obscureText: false,
      prefixIcon: Icons.location_on_outlined,
      validator: (value) => value?.isEmpty == true ? 'Enter address' : null,
    );
  }

  Widget _buildPasswordField(AuthController controller) {
    return CustomTextFormField(
      textController: _passwordCtrl,
      label: "Password",
      hint: "********",
      obscureText: true,
      prefixIcon: Icons.lock_outline,
      validator: controller.passwordValidator,
    );
  }

  Widget _buildConfirmPasswordField() {
    return CustomTextFormField(
      textController: _confirmPasswordCtrl,
      label: "Confirm Password",
      hint: "********",
      obscureText: true,
      prefixIcon: Icons.lock_outline,
      validator: (value) {
        if (value?.isEmpty == true) return 'Confirm your password';
        if (value != _passwordCtrl.text) return 'Passwords do not match';
        return null;
      },
    );
  }

  void _handleSignup(AuthController controller) {
    if (_formKey.currentState!.validate()) {
      // controller.signUp();
    }
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }
}

class _LoginPrompt extends StatelessWidget {
  const _LoginPrompt();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            "Login",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
