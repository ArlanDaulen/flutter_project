import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_week10/model/user.dart';
import 'package:flutter_week10/pages/user_info_page.dart';

class RegisterFormPage extends StatefulWidget {
  @override
  _RegisterFormPageState createState() => _RegisterFormPageState();
}

class _RegisterFormPageState extends State<RegisterFormPage> {
  bool _hidePass = true; // See/hide password

  final _formKey = GlobalKey<FormState>(); // Global'nyi klutch
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _storyController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  List<String> _countries = [
    'Kazakhstan',
    'Russia',
    'Ukraine',
    'Germany',
    'France'
  ];
  String _selectedCountry;

  final _nameFocus = FocusNode(); // Focus to name form
  final _phoneFocus = FocusNode();
  final _passFocus = FocusNode();

  User newUser = User();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _storyController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _passFocus.dispose();

    super.dispose();
  }

  void _fieldFocusChange(BuildContext context, FocusNode currentFocus,
      FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  } // Change focus

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Register Form'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // Full Name
            TextFormField(
              focusNode: _nameFocus,
              autofocus: true,
              onFieldSubmitted: (_) {
                _fieldFocusChange(context, _nameFocus, _phoneFocus);
              },
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name*',
                hintText: 'Enter Full Name',
                icon: Icon(Icons.person),
                suffixIcon: GestureDetector(
                  onTap: () {
                    _nameController.clear();
                  },
                  child: Icon(Icons.delete_outline),
                ),
              ),
              validator: _validateName,
              onSaved: (value) => newUser.name = value,
            ),
            SizedBox(
              height: 10,
            ),
            // Phone Number
            TextFormField(
              focusNode: _phoneFocus,
              onFieldSubmitted: (_) {
                _fieldFocusChange(context, _phoneFocus, _passFocus);
              },
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number*',
                hintText: 'Enter Phone Number',
                icon: Icon(Icons.phone),
                suffixIcon: GestureDetector(
                  onTap: (){
                    _phoneController.clear();
                  },
                  child: Icon(Icons.delete_outline),
                ),
              ),
              keyboardType: TextInputType.phone,
              //Number keyboard
              inputFormatters: [
                //FilteringTextInputFormatter.digitsOnly,   //Only digits
                FilteringTextInputFormatter(RegExp(r'^[()\d -]{1,15}$'),
                    allow: true),
              ],
              validator: (value) =>
              _validatePhoneNumber(value)
                  ? null
                  : 'Phone number must be entered as (###)-###-####',
              onSaved: (value) => newUser.phone = value,
            ),
            SizedBox(
              height: 10,
            ),
            // Email
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                icon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress, // Email keyboard
              //validator: _validateEmail,
              onSaved: (value) => newUser.email = value,
            ),
            SizedBox(
              height: 10,
            ),

            DropdownButtonFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(Icons.map),
                labelText: 'Country?',
              ),
              items: _countries.map((country) {
                return DropdownMenuItem(
                  child: Text(country),
                  value: country,
                );
              }).toList(),
              onChanged: (country) {
                print(country);
                setState(() {
                  _selectedCountry = country;
                  newUser.country = country;
                });
              },
              value: _selectedCountry,
            ),

            SizedBox(
              height: 10,
            ),
            // Life Story
            TextFormField(
              controller: _storyController,
              decoration: InputDecoration(
                labelText: 'Life Story',
              ),
              maxLines: 3,
              inputFormatters: [
                LengthLimitingTextInputFormatter(100),
              ],
              onSaved: (value) => newUser.story = value,
            ),
            SizedBox(
              height: 10,
            ),
            // Password
            TextFormField(
              focusNode: _passFocus,
              controller: _passController,
              obscureText: _hidePass,
              // Hide text
              decoration: InputDecoration(
                labelText: 'Password*',
                hintText: 'Enter the password',
                suffixIcon: IconButton(
                  icon:
                  Icon(_hidePass ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _hidePass = !_hidePass;
                    });
                  },
                ),
                icon: Icon(Icons.security),
              ),
              validator: _validatePass,
            ),
            SizedBox(
              height: 10,
            ),
            // Confirm Password
            TextFormField(
              controller: _confirmPassController,
              obscureText: _hidePass, // Hide text
              decoration: InputDecoration(
                labelText: 'Confirm Password*',
                icon: Icon(Icons.border_color),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            RaisedButton(
              onPressed: _submitForm,
              color: Colors.green,
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _showDialog(_nameController.text);   // Show that all was successful by Alert
      print('Form is valid');
      print('Name ${_nameController.text}');
      print('Phone ${_phoneController.text}');
      print('Email ${_emailController.text}');
      print('Country ${_selectedCountry}');
      print('Story ${_storyController.text}');
    } else {
      _showMessage('Form is not valid! Please review and correct');   // Show incorrect input result by SnackBar
    }
  }

  String _validateName(String value) {
    final _nameExp = RegExp(r'^[A-Za-z]+$');
    if (value.isEmpty) {
      return 'Name is required';
    } else if (!_nameExp.hasMatch(value)) {
      return 'Please enter alphabetical characters';
    } else {
      return null;
    }
  }

  bool _validatePhoneNumber(String input) {
    final _phoneExp = RegExp(r'^\(\d\d\d\)\d\d\d\-\d\d\d\d$');
    return _phoneExp.hasMatch(input);
  }

  String _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email can not be empty';
    } else if (!_emailController.text.contains('@')) {
      return 'Invalid email address';
    } else {
      return null;
    }
  }

  String _validatePass(String value) {
    if (_passController.text.length != 8) {
      return '8 characters required for passswrod';
    } else if (_confirmPassController.text != _passController.text) {
      return 'Password does not match';
    } else {
      return null;
    }
  }

  void _showMessage(String message) {   // Show incorrect input result by SnackBar
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        backgroundColor: Colors.red,
        content: Text(message,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 10,
            )),
      ),
    );
  }

  void _showDialog(String name) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Registration Successful'),
            content: Text(
              '$name is now a verified register form',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.green),
            ),
            actions: [
              FlatButton(onPressed: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => UserInfoPage(
                    userInfo: newUser,
                  ),
                ));
              }, child: Text('Verified', style: TextStyle(
                color: Colors.green,
                fontSize: 18,
              ),))
            ],
          );
        });
  }
}
