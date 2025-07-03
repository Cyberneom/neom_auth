import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neom_commons/commons/ui/theme/app_color.dart';
import 'package:neom_commons/commons/ui/theme/app_theme.dart';
import 'package:neom_commons/commons/utils/constants/app_assets.dart';
import 'package:neom_commons/commons/utils/constants/app_translation_constants.dart';
import 'package:neom_commons/commons/utils/constants/message_translation_constants.dart';
import 'package:neom_core/core/app_config.dart';
import 'package:neom_core/core/utils/constants/app_route_constants.dart';

import '../../utils/enums/login_method.dart';
import '../login/login_controller.dart';

  bool _rememberMe = false;

  Widget buildEmailTF(LoginController _) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(AppTranslationConstants.email.tr, style: AppTheme.kLabelStyle),
        AppTheme.heightSpace10,
        Container(
          alignment: Alignment.centerLeft,
          decoration: AppTheme.kBoxDecorationStyle,
          height: 50.0,
          child: TextField(
            controller: _.emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: AppTheme.fontFamily,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: const Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: AppTranslationConstants.enterEmail.tr,
              hintStyle: AppTheme.kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPasswordTF(LoginController _) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(AppTranslationConstants.password.tr, style: AppTheme.kLabelStyle),
        AppTheme.heightSpace10,
        Container(
          alignment: Alignment.centerLeft,
          decoration: AppTheme.kBoxDecorationStyle,
          height: 50.0,
          child: TextField(
            controller: _.passwordController,
            obscureText: true,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: AppTheme.fontFamily,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: const Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: AppTranslationConstants.enterPassword.tr,
              hintStyle: AppTheme.kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildForgotPasswordBtn(LoginController _) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Get.toNamed(AppRouteConstants.forgotPassword),
        style: TextButton.styleFrom(padding: const EdgeInsets.only(right: 0.0)),
        child: Text(AppTranslationConstants.forgotPassword.tr,
          style: AppTheme.kLabelStyle,
        ),
      ),
    );
  }

  Widget buildRememberMeCheckbox(LoginController _) {
    return SizedBox(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                _rememberMe = value!;
                AppConfig.logger.e('Remember me: $_rememberMe');
              },
            ),
          ),
          const Text(
            'Remember me',
            style: AppTheme.kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget buildLoginBtn(LoginController _) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async => {
          if(_.emailController.text.trim().isNotEmpty && _.passwordController.text.trim().isNotEmpty) {
            if(!_.isButtonDisabled.value) {
              await _.handleLogin(LoginMethod.email)
            }
          } else {
            Get.snackbar(
              MessageTranslationConstants.errorLoginEmail.tr,
              MessageTranslationConstants.pleaseFillSignUpForm.tr,
              snackPosition: SnackPosition.bottom
            )
          }
        },
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          padding: const EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: Colors.white,),
        child: Text(
          AppTranslationConstants.login.toUpperCase(),
          style: const TextStyle(
            color: AppColor.textButton,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: AppTheme.fontFamily,
          ),
        ),
      ),
    );
  }

  Widget buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- ${AppTranslationConstants.or.tr} -',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          AppTranslationConstants.signInWith.tr,
          style: AppTheme.kLabelStyle,
        ),
      ],
    );
  }

  Widget buildSocialBtnRow(LoginController _) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: (_.isIOS13OrHigher && AppConfig.instance.appInfo.googleLoginEnabled)
            ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
        children: <Widget>[
          _.isIOS13OrHigher ? GestureDetector(
              onTap: () async => {
                if(!_.isButtonDisabled.value) {
                  await _.handleLogin(LoginMethod.apple)
                }
              },
              child: Container(
                height: 60.0,
                width: 60.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    ),
                  ],
                  image: DecorationImage(
                    scale: 0.5,
                    image: AssetImage(AppAssets.appleWhiteLogo,
                    ),
                  ),
                ),
              )
          ) : const SizedBox.shrink(),
          (AppConfig.instance.appInfo.googleLoginEnabled || kDebugMode)
              ? TextButton(
            onPressed: () async => {
              if(!_.isButtonDisabled.value) {
                await _.handleLogin(LoginMethod.google)
              }
            },
            child: Container(
              height: 60.0,
              width: 60.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 6.0,
                  ),
                ],
                image: DecorationImage(
                  image: AssetImage(AppAssets.googleLogo),
                ),
              ),
            ),
          ) : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget buildSignupBtn(LoginController _) {
    return GestureDetector(
      onTap: () => {
        if(!_.isButtonDisabled.value) Get.toNamed(AppRouteConstants.signup)
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: AppTranslationConstants.dontHaveAnAccount.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: AppTranslationConstants.signUp.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
