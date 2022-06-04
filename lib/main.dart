import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class User {
  String email;
  String password;
  String gender;
  bool agreePolicy;
  bool receiveEmail;

  User(
      {this.email = "",
      this.password = "",
      this.gender = "male",
      this.agreePolicy = false,
      this.receiveEmail = false});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String appTitle = "Form Validation";
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: CustomForm(),
      ),
    );
  }
}

class CustomForm extends StatefulWidget {
  const CustomForm({Key? key}) : super(key: key);

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  final _formKey = GlobalKey<FormState>(); //ต้องมีการสร้าง Key
  User user = User();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              decoration: _buildInputDecoration(
                  label: 'Email', hint: 'example@gmail.com', icon: Icons.email),
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
              onSaved: (String? value){
                user.email = value!;
              },
            ),
            TextFormField(
              decoration: _buildInputDecoration(
                  label: 'Password', hint: '', icon: Icons.lock),
              obscureText: true, //ไม่ให้ show password
              validator: _validatePassword,
              onSaved: (String? value){
                user.password = value!;
              },
            ),
            _buildGenderForm(),
            _buildReceiveEmailForm(),
            _buildAgreePolicyForm(),
            _buildSummitButton(),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(
      {required String label, required String hint, required IconData icon}) {
    return InputDecoration(labelText: label, hintText: hint, icon: Icon(icon));
  }

  Widget _buildAgreePolicyForm() {
    return Container(
      alignment: Alignment.center, // set text center
      margin: EdgeInsets.only(top: 28),
      child: Row(mainAxisSize: MainAxisSize.min, // set space min to text center
          children: [
            Checkbox(
              value: user.agreePolicy,
              activeColor: Colors.orange,
              onChanged: (value) {
                setState(() {
                  user.agreePolicy = value!; /////////////
                });
              },
            ),
            Text("I Agree the"),
            GestureDetector(
              onTap: _launchURL, // run url
              child: Text(
                "Privacy Policy",
                style: TextStyle(
                    color: Colors.blue, decoration: TextDecoration.underline),
              ),
            )
          ]),
    );
  }

  Widget _buildGenderForm() {
    final Color activeColor = Colors.orange;

    return Container(
      margin: EdgeInsets.only(top: 12),
      child: Row(children: [
        Text(
          "Gender",
          style: TextStyle(fontSize: 16),
        ),
        Radio(
          activeColor: activeColor,
          value: "male",
          groupValue: user.gender,
          onChanged: _handleRadioValueChange,
        ),
        Text("Male"),
        Radio(
          activeColor: activeColor,
          value: "female",
          groupValue: user.gender,
          onChanged: _handleRadioValueChange,
        ),
        Text("Female"),
      ]),
    );
  }

  Widget _buildReceiveEmailForm() {
    return Row(
      children: [
        Text(
          "Receive Email",
          style: TextStyle(fontSize: 16),
        ),
        Switch(
            activeColor: Colors.orange,
            value: user.receiveEmail, //receiveEmail = false
            onChanged: (select) {
              setState(() {
                user.receiveEmail = select;
              });
            })
      ],
    );
  }

  Widget _buildSummitButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 4),
      child: ElevatedButton(
        //child: Colors.blue,
        onPressed: _submit,
        child: Text(
          "Submit",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _handleRadioValueChange(value) {
    print('value: ${value}');
    setState(() {
      user.gender = value;
    });
  }

  String? _validateEmail(value) {
    if (value.isEmpty) {
      return "The Email is Empty";
    }
    if (!isEmail(value)) {
      return "The Email must be a valid email.";
    }
  }

  String? _validatePassword(value) {
    if (value.length < 8) {
      return 'The Password must be at least 8 charactors';
    }
  }

  _launchURL() async {
    final Uri _url = Uri.parse('https://www.google.co.th/');
    if (await canLaunchUrl(_url)) {
      //สามารถ run url ได้ไหม
      await launchUrl(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }

  void _submit() {
    if (this._formKey.currentState!.validate()) {
      if (user.agreePolicy == false) {
        showAlertDialog();
      } else{
          _formKey.currentState?.save();     // ไปเรียก onSave(); email,password  show email/password ตรง debug console
          print("Email:${user.email}");
          print("Password:${user.password}");
          print("Gender:${user.gender}");
          print("Receive Email:${user.receiveEmail}");
          print("Agree Policy:${user.agreePolicy}");
      }
    }
  }

  void showAlertDialog(){
     showDialog(    // มี popup
          context: context,
          barrierDismissible: false,   // true คือสามารถกดข้างนอกได้ ถ้ามี popup เด้ง  false ไม่สามารถกดข้างนอกได้นอกจากปุ่ม close
          builder: (context) {
            return AlertDialog(
              title: Text("Title"),
              content: SingleChildScrollView(   // ถ้ามี Detail เยอะๆ สามารถ scroll ได้
                child: ListBody(
                  children: [
                    Text("Detail1"),
                    Text("Detail2"),
                    Text("Detail3"),
                    Icon(Icons.directions_bike),
                  ],
                ),
              ),
              actions: [
                IconButton(onPressed: null, icon: Icon(Icons.cake,color: Colors.blue,)),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();  
                    },
                    child: Text("Colse")),
              ],
            );
          },
        );
  }
}
