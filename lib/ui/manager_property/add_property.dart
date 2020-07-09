import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mutuuze/bloc/authentication/user_bloc.dart';
import 'package:mutuuze/bloc/property/create_property_bloc.dart';
import 'package:mutuuze/models/user_object.dart';

class AddProperty extends StatefulWidget {
  @override
  _AddPropertyState createState() => _AddPropertyState();
}

class _AddPropertyState extends State<AddProperty> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final createPropertyBloc = CreatePropertyBloc();
  final userBloc = UserBloc();

  int selectedCategory;
  List<File> imagesList;
  List<Widget> fileNames;
  List categories = [
    {'name': "Single Rooms", 'id': 1},
    {'name': "Double Rooms", 'id': 2},
    {'name': "Bungalow", 'id': 3},
    {'name': "Land", 'id': 4},
    {'name': "Apartments", 'id': 5},
    {'name': "Commercial", 'id': 6},
    {'name': "Office Space", 'id': 7}
  ];
  bool showError;
  String errorMessage;
  String token;

  @override
  void initState() {
    selectedCategory = null;
    imagesList = [];
    fileNames = [];
    showError = false;
    errorMessage = "";
    token = "";
    userBloc.loadUserData();
    super.initState();
  }

  void openCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imagesList.add(image);
    });
  }

  void openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagesList.add(image);
    });
  }

  void setErrorMessage(String message) {
    setState(() {
      errorMessage = message;
      showError = true;
    });
  }

  void setToken(String userToken) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        token = userToken;
      });
    });
  }

  void saveProperty() {
    String propName = _nameController.text.toString();
    String propPrice = _priceController.text.toString();
    String propDescription = _descriptionController.text.toString();
    String propAddress = _addressController.text.toString();
    int propCategory = selectedCategory;
    if (propCategory == null) {
      setErrorMessage("* Select a Category for this Property");
    }
    if (imagesList.isEmpty) {
      setErrorMessage("* Add minimum of one image for clients to see");
    }
    var propDetails = {
      'prop_details': {
        'name': propName,
        'price': propPrice,
        'description': propDescription,
        'address': propAddress,
        'category': propCategory
      }
    };
    createPropertyBloc.createNewProperty(token, propDetails, imagesList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("New Property",
            style: TextStyle(
              color: Colors.black,
            )),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
        child: StreamBuilder<UserObject>(
            stream: userBloc.userStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                setToken(snapshot.data.token);
                return ListView(
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: <Widget>[
                    TextFormField(
                      controller: _nameController,
                      decoration: new InputDecoration(
                        labelText: "Name",
                        errorStyle: TextStyle(color: Colors.orange),
                        border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Error | Property Name is required";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    TextFormField(
                      controller: _priceController,
                      decoration: new InputDecoration(
                        labelText: "Rent / Price",
                        errorStyle: TextStyle(color: Colors.orange),
                        border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Error | Property rent/price is required";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: new InputDecoration(
                        labelText: "Description",
                        errorStyle: TextStyle(color: Colors.orange),
                        border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Error | Property Description is required";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    TextFormField(
                      controller: _addressController,
                      decoration: new InputDecoration(
                        labelText: "Address",
                        errorStyle: TextStyle(color: Colors.orange),
                        border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Error | Property Location is required";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(
                      height: 35.0,
                    ),
                    DropdownButton<int>(
                      isDense: true,
                      hint: Text(
                        "   -   Select Property Category   -   ",
                        style: TextStyle(fontSize: 20.0),
                      ),
                      value: selectedCategory,
                      onChanged: (v) {
                        setState(() {
                          selectedCategory = v;
                        });
                      },
                      items: categories.map((var category) {
                        return DropdownMenuItem<int>(
                          value: category['id'],
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                category['name'],
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20.0),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 30.0),
                    Text(
                      "Images",
                      style: TextStyle(fontSize: 25.0),
                    ),
                    Text("Atleast one Image"),
                    Container(
                      height: 50.0,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: ScrollPhysics(),
                        children: imagesList.map((File e) {
                          String name = e == null ? "" : e.path.split('/').last;
                          return Text(name);
                        }).toList(),
                      ),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.start,
                      children: <Widget>[
                        RaisedButton(
                          child: Text(
                            "Open Camera",
                          ),
                          onPressed: () {
                            openCamera();
                          },
                        ),
                        RaisedButton(
                          child: Text(
                            "Open Gallery",
                          ),
                          onPressed: () {
                            openGallery();
                          },
                        )
                      ],
                    ),
                    showError
                        ? SizedBox(
                            height: 15.0,
                          )
                        : Container(),
                    showError
                        ? Text(
                            errorMessage,
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.orange),
                          )
                        : Container(),
                    showError
                        ? SizedBox(
                            height: 15.0,
                          )
                        : Container(),
                    SizedBox(
                      height: 15.0,
                    ),
                    FlatButton(
                      padding: EdgeInsets.symmetric(
                          horizontal: 35.0, vertical: 15.0),
                      color: Color(0xFFff8000),
                      child: Text(
                        "Save Property",
                        style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.normal,
                            fontSize: 18.0),
                      ),
                      onPressed: () => saveProperty(),
                    ),
                  ],
                );
              }
              return Container();
            }),
      ),
    );
  }
}
