import 'package:clean_commerce/features/presentation/views/auth/widgets/auth_btn.dart';
import 'package:clean_commerce/features/presentation/widgets/custom_textformfield.dart';
import 'package:clean_commerce/features/presentation/widgets/dialog_action.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(6.w),
          children: [
            SizedBox(height: 3.h),
            CustomTextFormField(
              textController: _emailCtrl,
              validator: (val) {
                if (val == null) return "*required";
              },
              label: "Email",
              hint: "yourmail@mail.com",
              obscureText: false,
              prefixIcon: Icons.email_outlined,
            ),
            SizedBox(height: 3.h),
            AuthButton(
              isLoading: false,
              onPressed: () {
                // _formKey.currentState?.validate();
                //TODO: implement api
                showDialog(
                  context: context,
                  builder: (_) => DialogAction(
                    title: "Feature Not Implemented Yet.",
                    confirmText: "Ok",
                    icon: Icons.construction,
                    onSubmit: () {
                      Navigator.pop(context);
                    },
                  ),
                );
              },
              text: "Send Reset Request",
            ),
          ],
        ),
      ),
    );
  }
}
