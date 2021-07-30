import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/user_controller.dart';
import '../elements/BlockButtonWidget.dart';
import '../elements/MobileVerificationBottomSheetWidget.dart';
import '../helpers/app_config.dart' as config;
import '../helpers/helper.dart';

class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends StateMVC<SignUpWidget> {
  UserController _con;

  String prefixNumber = "+503";

  _SignUpWidgetState() : super(UserController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
      child: Scaffold(
        key: _con.scaffoldKey,
        resizeToAvoidBottomInset: true,
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Positioned(
              top: 0,
              child: Container(
                width: config.App(context).appWidth(100),
                height: config.App(context).appHeight(20),
                decoration: BoxDecoration(color: Theme.of(context).accentColor),
              ),
            ),
            Positioned(
              top: config.App(context).appHeight(25) - 120,
              child: Container(
                width: config.App(context).appWidth(84),
                height: config.App(context).appHeight(25),
                child: Text(
                  S.of(context).lets_start_with_register,
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .merge(TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
            ),
            Positioned(
              top: config.App(context).appHeight(23) - 50,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 50,
                            color: Theme.of(context).hintColor.withOpacity(0.2),
                          )
                        ]),
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 1, horizontal: 27),
                    width: config.App(context).appWidth(88),
//              height: config.App(context).appHeight(55),
                    child: Form(
                      key: _con.loginFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                           CountryCodePicker(
                            onChanged: (value) {
                              //print(value.dialCode);
                              prefixNumber = value.dialCode;
                              setState(() {});
                            },
                            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                            initialSelection: 'SV',
                            favorite: ['+503', 'SV'],
                            // optional. Shows only country name and flag
                            showCountryOnly: true,
                            showDropDownButton: false,
                            showFlagDialog: true,
                            showFlagMain: true,
                            showFlag: true,
                            // optional. Shows only country name and flag when popup is closed.
                            showOnlyCountryWhenClosed: true,
                            // optional. aligns the flag and the Text left
                            alignLeft: false,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            onSaved: (input) => _con.user.name = input,
                            validator: (input) => input.length < 3
                                ? S.of(context).should_be_more_than_3_letters
                                : null,
                            decoration: InputDecoration(
                              labelText: S.of(context).full_name,
                              labelStyle: TextStyle(
                                  color: Theme.of(context).accentColor),
                              contentPadding: EdgeInsets.all(12),
                              hintText: S.of(context).john_doe,
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.7)),
                              prefixIcon: Icon(Icons.person_outline,
                                  color: Theme.of(context).accentColor),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.5))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                            ),
                          ),
                          SizedBox(height: 30),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (input) => _con.user.email = input,
                            validator: (input) => !input.contains('@')
                                ? S.of(context).should_be_a_valid_email
                                : null,
                            decoration: InputDecoration(
                              labelText: S.of(context).email,
                              labelStyle: TextStyle(
                                  color: Theme.of(context).accentColor),
                              contentPadding: EdgeInsets.all(12),
                              hintText: 'johndoe@gmail.com',
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.7)),
                              prefixIcon: Icon(Icons.alternate_email,
                                  color: Theme.of(context).accentColor),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.5))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                            ),
                          ),
                          SizedBox(height: 30),
                          // IntlPhoneField(
                          //   // decoration: InputDecoration(
                          //   //   labelText: 'Phone Number',
                          //   //   border: OutlineInputBorder(
                          //   //     borderSide: BorderSide(),
                          //   //   ),
                          //   // ),
                          //   decoration: InputDecoration(
                          //     labelText: S.of(context).phoneNumber,
                          //     labelStyle: TextStyle(
                          //         color: Theme.of(context).accentColor),
                          //     contentPadding: EdgeInsets.all(12),
                          //     hintText: '',
                          //     hintStyle: TextStyle(
                          //         color: Theme.of(context)
                          //             .focusColor
                          //             .withOpacity(0.7)),
                          //     prefixIcon: Icon(
                          //       Icons.phone_android,
                          //       color: Theme.of(context).accentColor,
                          //     ),
                          //     prefixText: prefixNumber,
                          //     border: OutlineInputBorder(
                          //         borderSide: BorderSide(
                          //             color: Theme.of(context)
                          //                 .focusColor
                          //                 .withOpacity(0.2))),
                          //     focusedBorder: OutlineInputBorder(
                          //         borderSide: BorderSide(
                          //             color: Theme.of(context)
                          //                 .focusColor
                          //                 .withOpacity(0.5))),
                          //     enabledBorder: OutlineInputBorder(
                          //         borderSide: BorderSide(
                          //             color: Theme.of(context)
                          //                 .focusColor
                          //                 .withOpacity(0.2))),
                          //   ),
                          //   initialCountryCode: 'SV',
                          //   onChanged: (phone) {
                          //     print(phone.completeNumber);
                          //   },
                          // ),
                         
                          //SizedBox(height: 30),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            onSaved: (input) =>
                                _con.user.phone = prefixNumber + input,
                            validator: (input) {
                              // print(input.startsWith('\+'));
                              // return !input.startsWith('\+') &&
                              //         !input.startsWith('00')
                              //     ? "Should be valid mobile number with country code"
                              //     : null;
                              // return !input.startsWith('00')
                              //     ? "Should be valid mobile number with country code"
                              //     : null;
                              return input == ""
                                  ? "Should be valid mobile number with country code"
                                  : null;
                            },
                            decoration: InputDecoration(
                              labelText: S.of(context).phoneNumber,
                              labelStyle: TextStyle(
                                  color: Theme.of(context).accentColor),
                              contentPadding: EdgeInsets.all(12),
                              hintText: '',
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.7)),
                              prefixIcon: Icon(
                                Icons.phone_android,
                                color: Theme.of(context).accentColor,
                              ),
                              prefixText: prefixNumber,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.5))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                            ),
                          ),
                          SizedBox(height: 30),
                          TextFormField(
                            obscureText: _con.hidePassword,
                            onSaved: (input) => _con.user.password = input,
                            validator: (input) => input.length < 6
                                ? S.of(context).should_be_more_than_6_letters
                                : null,
                            decoration: InputDecoration(
                              labelText: S.of(context).password,
                              labelStyle: TextStyle(
                                  color: Theme.of(context).accentColor),
                              contentPadding: EdgeInsets.all(12),
                              hintText: '••••••••••••',
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.7)),
                              prefixIcon: Icon(Icons.lock_outline,
                                  color: Theme.of(context).accentColor),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _con.hidePassword = !_con.hidePassword;
                                  });
                                },
                                color: Theme.of(context).focusColor,
                                icon: Icon(_con.hidePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.5))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                            ),
                          ),
                          SizedBox(height: 30),
                          BlockButtonWidget(
                            text: Text(
                              S.of(context).register,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            color: Theme.of(context).accentColor,
                            onPressed: () {
                              if (_con.loginFormKey.currentState.validate()) {
                                _con.loginFormKey.currentState.save();
                                var bottomSheetController = _con
                                    .scaffoldKey.currentState
                                    .showBottomSheet(
                                  (context) =>
                                      MobileVerificationBottomSheetWidget(
                                          scaffoldKey: _con.scaffoldKey,
                                          user: _con.user),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                  ),
                                );
                                bottomSheetController.closed.then((value) {
                                  _con.register();
                                });
                              }
                            },
                          ),
                          SizedBox(height: 25),
//                      MaterialButton(elevation:0,
//                        onPressed: () {
//                          Navigator.of(context).pushNamed('/MobileVerification');
//                        },
//                        padding: EdgeInsets.symmetric(vertical: 14),
//                        color: Theme.of(context).accentColor.withOpacity(0.1),
//                        shape: StadiumBorder(),
//                        child: Text(
//                          'Register with Google',
//                          textAlign: TextAlign.start,
//                          style: TextStyle(
//                            color: Theme.of(context).accentColor,
//                          ),
//                        ),
//                      ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  MaterialButton(
                    elevation: 0,
                    onPressed: () {
                      Navigator.of(context).pushNamed('/Login');
                    },
                    textColor: Theme.of(context).hintColor,
                    child: Text(S.of(context).i_have_account_back_to_login),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
