import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seven_bits_task/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({Key? key,}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _number_controller = TextEditingController();

  File? _image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
          _loadPrefrences();

      
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromGallery() async {
    PickedFile? image =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        _image = File(image.path);
      }
    });
    print(_image!.path);
  }

  _imgFromCamera() async {
    PickedFile? image =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
    setState(() {
      if (image != null) {
        _image = File(image.path);
      }
    });
    print(_image!.path);
  }

  Future<void> _logout() async {
    try {
      // signout code
      await FirebaseAuth.instance.signOut();
      Fluttertoast.showToast(
        msg: "logged Successfully !",
        toastLength: Toast.LENGTH_SHORT,
       
  
        textColor: Colors.black,
    );
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginScreen()));


    } catch (e) {
      print(e.toString());
    }
  }

  _saveField() async {
      final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }else{
        _formKey.currentState!.save();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("name", _nameController.text.toString());
    preferences.setString("number", _number_controller.text.toString());
    preferences.setString("email", _emailController.text.toString());
    preferences.setString("img", _image!.path.toString());

      Fluttertoast.showToast(
        msg: "Saved Successfully !",
        toastLength: Toast.LENGTH_SHORT,
       
  
        textColor: Colors.black,
    );

    print("Files saved!");

    }
  
  }

  _loadPrefrences() async{
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String? name = preferences.getString("name");
                String? email = preferences.getString("email");

        String? number = preferences.getString("number");
                String? img = preferences.getString("img");

                _nameController.text = name!;
                _emailController.text = email!;
                _number_controller.text = number!;
                setState(() {
                                  _image =  File(img!);

                });



print(name);
print(email);
print(number);
print(img);



  }
   var _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Center(
                child: Text(
              ' Add Your Profile ',
              style: TextStyle(color: Colors.white),
            )),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                  Color.fromRGBO(66, 151, 200, 50),
                  Color.fromRGBO(14, 54, 146, 1)
                ])),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await _logout();
              },
              icon: Icon(Icons.logout),
              color: Colors.white,
            )
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(17.0),
          child: ListView(
            children: [
              if (_image != null)
                Container(
                  child: Image.file(_image!),
                ),
              SizedBox(height: 14.0),
              RaisedButton(
                onPressed: () {
                  _showPicker(context);
                },
                child: Text("Select Picture"),
              ),
              SizedBox(height: 14.0),
              Container(
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    new BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      spreadRadius: 1,
                      offset: new Offset(0.0, 0.0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextFormField(
                 
                  validator: (value){
                    if(value!.isEmpty || value == ''  )
                    {
                      return 'This field cannot be empty !';
                    }
                                        return null;

                  },
                  controller: _nameController,
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  cursorColor: Color.fromRGBO(
                      14, 54, 146, 7), //Theme.of(context).primaryColor,
                  decoration: InputDecoration(
                    isDense: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                      ),
                      //  borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        width: 1.5,
                        color: Color.fromRGBO(14, 54, 146, 7),
                      ),
                    ),
                    
                    focusColor: Color.fromRGBO(14, 54, 146, 7),
                    hoverColor: Color.fromRGBO(14, 54, 146, 7),
                    // prefixIcon: Icon(
                    //  ,
                    //   color: Color.fromRGBO(14, 54, 146, 7),
                    // ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: "Enter Name",
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(14, 54, 146, 7),
                      // fontSize: Theme.of(context).textTheme.bodyText1.fontSize,
                    ),
                    // errorStyle: TextStyle(
                    //   fontSize: Theme.of(context).textTheme.subtitle2.fontSize,
                    // ),
                  ),
                ),
              ),
              SizedBox(height: 14.0),
              Container(
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    new BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      spreadRadius: 1,
                      offset: new Offset(0.0, 0.0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextFormField(
                  validator:(value){
                    if(value!.isEmpty || value == ''){
                      return 'This field cannot be empty';

                    }else if(value.length < 10 || value.length > 10){
                      return 'Enter Valid Number';

                    }
                    return null;

                  } ,
                  controller: _number_controller,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  cursorColor: Color.fromRGBO(
                      14, 54, 146, 7), //Theme.of(context).primaryColor,
                  decoration: InputDecoration(
                    isDense: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                      ),
                      //  borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        width: 1.5,
                        color: Color.fromRGBO(14, 54, 146, 7),
                      ),
                    ),
                    focusColor: Color.fromRGBO(14, 54, 146, 7),
                    hoverColor: Color.fromRGBO(14, 54, 146, 7),
                    // prefixIcon: Icon(
                    //  ,
                    //   color: Color.fromRGBO(14, 54, 146, 7),
                    // ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: "Enter Mobile Number",

                    hintStyle: TextStyle(
                      color: Color.fromRGBO(14, 54, 146, 7),
                      // fontSize: Theme.of(context).textTheme.bodyText1.fontSize,
                    ),
                    // errorStyle: TextStyle(
                    //   fontSize: Theme.of(context).textTheme.subtitle2.fontSize,
                    // ),
                  ),
                ),
              ),
              SizedBox(height: 14.0),
              Container(
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    new BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      spreadRadius: 1,
                      offset: new Offset(0.0, 0.0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextFormField(
                  validator: (value){
                    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!);
                    if(!emailValid){
                      return 'Enter valid email !';
                    }else if(value == '' || value.isEmpty){
                      return 'This field cannot be empty !';

                    }
                                        return null;

                  },
                  controller: _emailController,
                  maxLines: 1,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Color.fromRGBO(
                      14, 54, 146, 7), //Theme.of(context).primaryColor,
                  decoration: InputDecoration(
                    isDense: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                      ),
                      //  borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        width: 1.5,
                        color: Color.fromRGBO(14, 54, 146, 7),
                      ),
                    ),
                    focusColor: Color.fromRGBO(14, 54, 146, 7),
                    hoverColor: Color.fromRGBO(14, 54, 146, 7),
                    // prefixIcon: Icon(
                    //  ,
                    //   color: Color.fromRGBO(14, 54, 146, 7),
                    // ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: "Enter email Address",
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(14, 54, 146, 7),
                      // fontSize: Theme.of(context).textTheme.bodyText1.fontSize,
                    ),
                    // errorStyle: TextStyle(
                    //   fontSize: Theme.of(context).textTheme.subtitle2.fontSize,
                    // ),
                  ),
                ),
              ),
              SizedBox(
                height: 14,
              ),
              ElevatedButton(onPressed: () async{
              await  _saveField();

              }, child: Text("Save to database"))
            ],
          ),
        ),
      ),
    );
  }
}
