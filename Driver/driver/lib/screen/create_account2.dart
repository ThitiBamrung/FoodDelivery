import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:driver/widgets/show_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:driver/utility/my_constant.dart';
import 'package:driver/utility/my_dialog.dart';
import 'package:driver/widgets/show_images.dart';
import 'package:driver/widgets/show_titles.dart';

class CreateAccount2 extends StatefulWidget {
  String phone, firstname, lastname, email, password;

  CreateAccount2(
      {required this.phone,
      required this.firstname,
      required this.lastname,
      required this.email,
      required this.password});

  @override
  State<CreateAccount2> createState() =>
      _CreateAccount2State(phone, firstname, lastname, email, password);
}

class _CreateAccount2State extends State<CreateAccount2> {
  String phone, firstname, lastname, email, password;
  _CreateAccount2State(
      this.phone, this.firstname, this.lastname ,this.email, this.password);

  String avata = '';
  double? lat, lng;
  File? file;
  final formKey = GlobalKey<FormState>();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    CheckPermission();
  }

  Future<void> Insertdata() async {
    String address = addressController.text;
    if (file == null) {
      processInsertMySQL(
        phone: phone,
        firstname: firstname,
        lastname: lastname,
        email: email,
        password: password,
        address: address,
      );
    } else {
      String apiSaveImg =
          '${MyConstant.domain}/Driver_saveDriverImg.php';
      int i = Random().nextInt(100000);
      String nameRIMG = 'D_Img$i.jpg';
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameRIMG);
      FormData data = FormData.fromMap(map);
      await Dio().post(apiSaveImg, data: data).then((value) {
        avata = '/DriverImg/$nameRIMG';
        processInsertMySQL(
          phone: phone,
          firstname: firstname,
          lastname: lastname,
          email: email,
          password: password,
          address: address,
        );
      });
    }
  }

  Future<void> processInsertMySQL({
    String? phone,
    String? firstname,
    String? lastname,
    String? email,
    String? password,
    String? address,
  }) async {
    print('Process insert data success');
    String apiInsertUser =
        '${MyConstant.domain}/Driver_insertData.php?isAdd=true&driver_firstname=$firstname&driver_lastname=$lastname&address=$address&driver_telephone=$phone&email_address=$email&profile_image=$avata&latitude=$lat&longitude=$lng&password=$password&wallet=0&open_close=0&driver_status=1';
    await Dio().get(apiInsertUser).then((value) {
      if (value.toString() == 'true') {
        Navigator.pushNamed(context, MyConstant.routeAuthen);
      } else {
        MyDialog()
            .normalDialog(context, 'Create User Fail !!', 'Please try again');
      }
    });
  }

  Future<Null> CheckPermission() async {
    bool locationService;
    LocationPermission locationPermission;

    locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      print("Service Location Open");

      locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocationService(
              context, 'ไม่อนุญาตให้เเชร์ Location', 'โปรเเชร์ Location');
        } else {
          findLatLng();
        }
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocationService(
              context, 'ไม่อนุญาตให้เเชร์ Location', 'โปรเเชร์ Location');
        } else {
          findLatLng();
        }
      }
    } else {
      print("Service Location Close");
      MyDialog().alertLocationService(
          context,
          'คุณยังไม่ได้ทำการเปิด Location Service',
          'กรุณาเปิด Location Service');
    }
  }

  Future<Null> findLatLng() async {
    print('findLatLan ==> Work');
    Position? position = await findPosition();
    setState(() {
      lat = position!.latitude;
      lng = position.longitude;
      print('lat = $lat, lng = $lng');
    });
  }

  Future<Position?> findPosition() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 0,
        title: Text(
          'รายละเอียดเพิ่มเติม',
          style: TextStyle(
              color: Colors.black, fontSize: 36, fontFamily: "MN MINI"),
        ),
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                BuildStoreImg(size),
                BuildAddress(size),
                //buildMap(size),
                BuildNextPage(size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row BuildAddress(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          width: size * 0.9,
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
              labelText: 'ที่อยู่',
              hintText: 'กรุณากรอกที่อยู่ของท่าน',
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

  Future<Null> chooseImages(ImageSource source) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Row BuildStoreImg(double size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: () => chooseImages(ImageSource.camera),
            icon: Icon(
              Icons.add_a_photo_outlined,
              size: 30,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: size * 0.4,
          child: file == null
              ? ShowImages(path: MyConstant.profile)
              : Image.file(file!),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: () => chooseImages(ImageSource.gallery),
            icon: Icon(
              Icons.add_photo_alternate_outlined,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }

  Set<Marker> setMarker() => <Marker>[
        Marker(
          markerId: MarkerId('id'),
          position: LatLng(lat!, lng!),
          infoWindow: InfoWindow(
              title: 'ตำเเหน่งปัจจุบัน', snippet: 'Lat = $lat, lng = $lng'),
        ),
      ].toSet();

  // Widget buildMap(double size) => Container(
  //       //color: Colors.grey,
  //       width: size * 0.9,
  //       height: 200,
  //       child: lat == null
  //           ? ShowProgress()
  //           : GoogleMap(
  //               initialCameraPosition: CameraPosition(
  //                 target: LatLng(lat!, lng!),
  //                 zoom: 16,
  //               ),
  //               onMapCreated: (controller) {},
  //               markers: setMarker(),
  //             ),
  //     );

  Container BuildTitle(String title) {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 10, bottom: 10),
      child: ShowTitles(
        title: title,
        textStyle: TextStyle(
          color: Colors.black,
          fontFamily: "MN MINI Bold",
          fontSize: 16,
        ),
      ),
    );
  }

  Row BuildNextPage(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 30),
          width: size * 0.9,
          height: 48,
          child: ElevatedButton(
            style: MyConstant().myButtonStyle(),
            onPressed: () {
              // Navigator.pushNamed(context, MyConstant.routeCreateAccount2);
              Insertdata();
            },
            child: Text(
              'เสร็จสิ้น',
              style: TextStyle(
                fontSize: 20,
                fontFamily: "MN MINI",
              ),
            ),
          ),
        ),
      ],
    );
  }
}
