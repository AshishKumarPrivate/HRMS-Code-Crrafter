import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/screen/auth/controller/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../../bottom_navigation_screen.dart';
import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../../ui_helper/common_widget/custom_text_field.dart';
import '../../../ui_helper/common_widget/solid_rounded_button.dart';
import '../../../util/loading_indicator.dart';
import '../../../util/responsive_helper_util.dart';
import '../emp_foreget_password_screen.dart';

class LoginFormWidget extends StatefulWidget {
  LoginFormWidget();

  @override
  _LoginFormWidgetState createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>(); // 🔹 Add Form Key for validation

  // handle the login api here
  void handleSubmit() {
    final loginProvider = context.read<AuthAPIProvider>();
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      return;
    }
    loginProvider.userLogin(
      context,
      emailController.text,
      passwordController.text,
    );
  }

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() => setState(() {}));
    _passwordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Hide keyboard on tap
      },
      child: Form(
        key: _formKey, // 🔹 Wrap in Form for validation
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Container(
            color: AppColors.whiteColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: emailController,
                  focusNode: _emailFocusNode,
                  icon: Icons.email_outlined,
                  hintText: "Enter your email",
                  title: "Email",
                  errorMessage: "Invalid Email",
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: passwordController,
                  focusNode: _passwordFocusNode,
                  icon: Icons.lock_open,
                  hintText: "Enter your password",
                  title: "Password",
                  errorMessage: "Invalid Password",
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen(),
                          // builder: (context) => MyWishListScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Forget Password",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.heading1(context,
                          overrideStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontSize: ResponsiveHelper.fontSize(context, 12),
                          )),
                    ),
                  ),
                ),
                // const SizedBox(height: 10),
                const SizedBox(height: 15),
                Consumer<AuthAPIProvider>(
                  builder: (context, loginProvider, child) {
                    print("✅ Consumer call ho rha hai ");
                    return loginProvider.isLoading
                        ? loadingIndicator() // Show loader
                        : CustomButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              handleSubmit();
                            }
                          },
                          text: 'Login',
                        );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
