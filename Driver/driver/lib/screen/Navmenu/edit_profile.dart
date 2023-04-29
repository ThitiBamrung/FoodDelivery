import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:driver/models/user_model.dart';
import 'package:driver/utility/my_constant.dart';
import 'package:driver/utility/my_dialog.dart';
import 'package:driver/widgets/show_images.dart';
import 'package:driver/widgets/show_progress.dart';
import 'package:driver/widgets/show_titles.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  UserModel? userModel;
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  LatLng? latLng;
  final formKey = GlobalKey<FormState>();
  File? file;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
    findLatLng();
  }

  Future<Null> findLatLng() async {
    Position? position = await findPosition();
    if (position != null) {
      setState(() {
        latLng = LatLng(position.latitude, position.longitude);
        print('lat = ${latLng!.latitude}');
      });
    }
  }

  Future<Position?> findPosition() async {
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition();
    } catch (e) {
      position = null;
    }
    return position;
  }

  Future<void> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String email_address = preferences.getString('email_address')!;

    String apiGetUser =
        '${MyConstant.domain}/Driver_getUserWhereUser.php?isAdd=true&email_address=$email_address';
    await Dio().get(apiGetUser).then((value) {
      print('${email_address}');
      print('value from API ==>> $value');
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
          firstnameController.text = userModel!.driver_firstname;
          lastnameController.text = userModel!.driver_lastname;
          addressController.text = userModel!.address;
          phoneController.text = userModel!.driver_telephone;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
        centerTitle: true,
        title: Text('เเก้ไขข้อมูลส่วนตัว'),
        titleTextStyle: TextStyle(
            fontFamily: 'MN MINI Bold', fontSize: 36, color: Colors.black87),
        actions: [
          IconButton(
            onPressed: () => processEditProfileSeller(),
            icon: Icon(
              Icons.edit,
              color: MyConstant.primary,
            ),
            tooltip: 'เเก้ไขข้อมูลส่วนตัว',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                buildProfileImg(constraints),
                buildFirstName(constraints),
                buildLastName(constraints),
                buildPhone(constraints),
                buildAddress(constraints),
                //buildMap(constraints),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> processEditProfileSeller() async {
    print('processEditProfileSeller Work');

    MyDialog().showProgressDialog(context);

    if (formKey.currentState!.validate()) {
      if (file == null) {
        print('## User Current Avatar');
        editValueToMySQL(userModel!.profile_image);
      } else {
        String apiSaveAvatar = '${MyConstant.domain}/Driver_saveDriverImg.php';

        List<String> nameAvatars = userModel!.profile_image.split('/');
        String nameFile = nameAvatars[nameAvatars.length - 1];
        nameFile = 'edit${Random().nextInt(100)}$nameFile';

        print('## User New Avatar nameFile ==>>> $nameFile');

        Map<String, dynamic> map = {};
        map['file'] =
            await MultipartFile.fromFile(file!.path, filename: nameFile);
        FormData formData = FormData.fromMap(map);
        await Dio().post(apiSaveAvatar, data: formData).then((value) {
          print('Upload Succes');
          String pathStoreImg = '/DriverImg/$nameFile';
          editValueToMySQL(pathStoreImg);
        });
      }
    }
  }

  Future<Null> editValueToMySQL(String pathStoreImg) async {
    print('## pathStoreImg ==> $pathStoreImg');
    String apiEditProfile =
        '${MyConstant.domain}/Driver_editProfileWhereDriverId.php?isAdd=true&driver_id=${userModel!.driver_id}&driver_firstname=${firstnameController.text}&driver_lastname=${lastnameController.text}&address=${addressController.text}&driver_telephone=${phoneController.text}&profile_image=$pathStoreImg&latitude=${latLng!.latitude}&longitude=${latLng!.longitude}';
    await Dio().get(apiEditProfile).then((value) {
      print('Upload = $value');
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  Row buildMap(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          margin: EdgeInsets.symmetric(vertical: 16),
          width: constraints.maxWidth * 0.75,
          height: constraints.maxWidth * 0.5,
          child: latLng == null
              ? const ShowProgress()
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: latLng!,
                    zoom: 16,
                  ),
                  onMapCreated: (controller) {},
                  markers: <Marker>[
                    Marker(
                      markerId: MarkerId('id'),
                      position: latLng!,
                      infoWindow: InfoWindow(
                          title: 'You Location',
                          snippet:
                              'lat = ${latLng!.latitude}, lng = ${latLng!.longitude}'),
                    ),
                  ].toSet(),
                ),
        ),
      ],
    );
  }

  Future<Null> createAvatar({ImageSource? source}) async {
    try {
      var result = await ImagePicker().getImage(
        source: source!,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Row buildProfileImg(BoxConstraints constraints) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: () => createAvatar(source: ImageSource.camera),
            icon: Icon(
              Icons.add_a_photo_outlined,
              size: 30,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: constraints.maxWidth * 0.6,
          height: constraints.maxWidth * 0.6,
          child: userModel == null
              ? ShowProgress()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: userModel!.profile_image == null
                      ? ShowImages(path: MyConstant.profile)
                      : file == null
                          ? buildShowImageNetwork()
                          : Image.file(file!),
                ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: () => createAvatar(source: ImageSource.gallery),
            icon: Icon(
              Icons.add_photo_alternate_outlined,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }

  CachedNetworkImage buildShowImageNetwork() {
    return CachedNetworkImage(
      imageUrl: '${MyConstant.domain}${userModel!.profile_image}',
      placeholder: (context, url) => ShowProgress(),
    );
  }

  Row buildFirstName(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          width: constraints.maxWidth * 0.9,
          child: TextFormField(
            controller: firstnameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกชื่อของท่าน';
              } else {}
            },
            maxLength: 255,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: TextStyle(
                color: Colors.black,
                fontFamily: "MN MINI",
                fontSize: 19,
              ),
              hintStyle: TextStyle(
                fontFamily: "MN MINI",
                fontSize: 16,
              ),
              labelText: 'ชื่อ',
              hintText: 'กรุณากรอกชื่อของคุณ',
              contentPadding: EdgeInsets.only(left: 20),
              suffixIcon: Icon(
                Icons.person_outline,
                color: Colors.black,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildLastName(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.9,
          child: TextFormField(
            controller: lastnameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกนามสกุลของท่าน';
              } else {}
            },
            maxLength: 255,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: TextStyle(
                color: Colors.black,
                fontFamily: "MN MINI",
                fontSize: 19,
              ),
              hintStyle: TextStyle(
                fontFamily: "MN MINI",
                fontSize: 16,
              ),
              labelText: 'นามสกุล',
              hintText: 'กรุณากรอกนามสกุลของคุณ',
              contentPadding: EdgeInsets.only(left: 20),
              suffixIcon: Icon(
                Icons.storefront_outlined,
                color: Colors.black,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildAddress(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.9,
          child: TextFormField(
            controller: addressController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกที่อยู่ของท่าน';
              } else {}
            },
            maxLength: 255,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: TextStyle(
                color: Colors.black,
                fontFamily: "MN MINI",
                fontSize: 19,
              ),
              hintStyle: TextStyle(
                fontFamily: "MN MINI",
                fontSize: 16,
              ),
              labelText: 'ที่อยู่ร้านค้า',
              hintText: 'กรุณากรอกที่อยู่ของคุณ',
              contentPadding: EdgeInsets.only(left: 20),
              suffixIcon: Icon(
                Icons.house_outlined,
                color: Colors.black,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPhone(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.9,
          child: TextFormField(
            controller: phoneController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกเบอร์โทรศัพท์ของท่าน';
              } else {}
            },
            maxLength: 10,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: TextStyle(
                color: Colors.black,
                fontFamily: "MN MINI",
                fontSize: 19,
              ),
              hintStyle: TextStyle(
                fontFamily: "MN MINI",
                fontSize: 16,
              ),
              labelText: 'โทรศัพท์',
              hintText: 'กรุณากรอกเบอร์โทรศัพท์ของคุณ',
              contentPadding: EdgeInsets.only(left: 20),
              suffixIcon: Icon(
                Icons.smartphone_outlined,
                color: Colors.black,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  ShowTitles buildTitle(String title) {
    return ShowTitles(
      title: title,
      textStyle: MyConstant().h2Style(),
    );
  }
}
