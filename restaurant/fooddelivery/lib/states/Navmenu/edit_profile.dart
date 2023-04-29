import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/models/user_model.dart';
import 'package:fooddelivery/utility/my_constant.dart';
import 'package:fooddelivery/utility/my_dialog.dart';
import 'package:fooddelivery/widgets/show_images.dart';
import 'package:fooddelivery/widgets/show_progress.dart';
import 'package:fooddelivery/widgets/show_titles.dart';
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
  TextEditingController ownnameController = TextEditingController();
  TextEditingController storenameController = TextEditingController();
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
        '${MyConstant.domain}/getUserWhereUser.php?isAdd=true&email_address=$email_address';
    await Dio().get(apiGetUser).then((value) {
      print('${email_address}');
      print('value from API ==>> $value');
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
          ownnameController.text = userModel!.owner_name;
          storenameController.text = userModel!.res_name;
          addressController.text = userModel!.complete_address;
          phoneController.text = userModel!.res_telephone;
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
                buildStoreImg(constraints),
                buildOwnName(constraints),
                buildStoreName(constraints),
                buildPhone(constraints),
                buildAddress(constraints),
               // buildMap(constraints),
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
        editValueToMySQL(userModel!.company_logo);
      } else {
        String apiSaveAvatar = '${MyConstant.domain}/saveRestaurantImg.php';

        List<String> nameAvatars = userModel!.company_logo.split('/');
        String nameFile = nameAvatars[nameAvatars.length - 1];
        nameFile = 'edit${Random().nextInt(100)}$nameFile';

        print('## User New Avatar nameFile ==>>> $nameFile');

        Map<String, dynamic> map = {};
        map['file'] =
            await MultipartFile.fromFile(file!.path, filename: nameFile);
        FormData formData = FormData.fromMap(map);
        await Dio().post(apiSaveAvatar, data: formData).then((value) {
          print('Upload Succes');
          String pathStoreImg = '/RestaurantImg/$nameFile';
          editValueToMySQL(pathStoreImg);
        });
      }
    }
  }

  Future<Null> editValueToMySQL(String pathStoreImg) async {
    print('## pathStoreImg ==> $pathStoreImg');
    String apiEditProfile =
        '${MyConstant.domain}/Restaurant_editProfileWhereResId.php?isAdd=true&res_id=${userModel!.res_id}&res_name=${storenameController.text}&complete_address=${addressController.text}&owner_name=${ownnameController.text}&company_logo=$pathStoreImg&res_telephone=${phoneController.text}&latitude=${latLng!.latitude}&longitude=${latLng!.longitude}';
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
              ? ShowProgress()
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

  Row buildStoreImg(BoxConstraints constraints) {
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
                  child: userModel!.company_logo == null
                      ? ShowImages(path: MyConstant.store_img)
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
      imageUrl: '${MyConstant.domain}${userModel!.company_logo}',
      placeholder: (context, url) => ShowProgress(),
    );
  }

  Row buildOwnName(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          width: constraints.maxWidth * 0.9,
          child: TextFormField(
            controller: ownnameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกชื่อเจ้าของร้านค้าของท่าน';
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
              labelText: 'ชื่อเจ้าของร้าน',
              hintText: 'กรุณากรอกชื่อเจ้าของร้านของคุณ',
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

  Row buildStoreName(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.9,
          child: TextFormField(
            controller: storenameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกชื่อร้านค้าของท่าน';
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
              labelText: 'ชื่อร้าน',
              hintText: 'กรุณากรอกชื่อร้านของคุณ',
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
                return 'กรุณากรอกที่อยู่ร้านค้าของท่าน';
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
              hintText: 'กรุณากรอกที่อยู่ร้านค้าของคุณ',
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
