import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fooddelivery/states/create_account.dart';
import 'package:fooddelivery/utility/my_dialog.dart';
import 'package:fooddelivery/widgets/show_progress.dart';
import 'package:fooddelivery/widgets/show_titles.dart';
import 'package:fooddelivery/utility/my_constant.dart';
import 'package:fooddelivery/widgets/show_images.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class CreateBussinessDetail extends StatefulWidget {
  String phone, ownername, email, password;

  CreateBussinessDetail(
      {required this.phone,
      required this.ownername,
      //required this.lastname,
      required this.email,
      required this.password});

  @override
  State<CreateBussinessDetail> createState() =>
      _CreateBussinessDetailState(phone, ownername, email, password);
}

class _CreateBussinessDetailState extends State<CreateBussinessDetail> {
  String phone, ownername,email, password;
  _CreateBussinessDetailState(
      this.phone, this.ownername,this.email, this.password);

  String avata = '';
  double? lat, lng;
  File? file;
  final formKey = GlobalKey<FormState>();
  TextEditingController res_nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    CheckPermission();
  }

  Future<Null> Insertdata() async {
    String res_name = res_nameController.text;
    String address = addressController.text;
    if (file == null) {
      processInsertMySQL(
        phone: phone,
        ownername: ownername,
        //lastname: lastname,
        email: email,
        password: password,
        res_name: res_name,
        address: address,
      );
    } else {
      String apiSaveImg =
          '${MyConstant.domain}/saveRestaurantImg.php';
      int i = Random().nextInt(100000);
      String nameRIMG = 'R_Img$i.jpg';
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameRIMG);
      FormData data = FormData.fromMap(map);
      await Dio().post(apiSaveImg, data: data).then((value) {
        avata = '/RestaurantImg/$nameRIMG';
        processInsertMySQL(
          phone: phone,
          ownername: ownername,
          //lastname: lastname,
          email: email,
          password: password,
          res_name: res_name,
          address: address,
        );
      });
    }
  }

  Future<void> processInsertMySQL({
    String? phone,
    String? ownername,
    //String? lastname,
    String? email,
    String? password,
    String? res_name,
    String? address,
  }) async {
    print('Process insert data success');
    String apiInsertUser =
        '${MyConstant.domain}/insertData.php?isAdd=true&res_name=$res_name&complete_address=$address&email_address=$email&owner_name=$ownername&company_logo=$avata&res_telephone=$phone&latitude=$lat&longitude=$lng&username=username&password=$password&wallet=0&res_status=1';
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
          'รายละเอียดธุรกิจ',
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
                BuildNameStore(size),
                BuildAddress(size),
                BuildTitle('เเสดงพิกัดปัจจุบัน'),
                BuildMap(size),
                BuildNextPage(size),
                //BuildType(size),
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
          width: size * 0.3,
          child: file == null
              ? ShowImages(path: MyConstant.store_img)
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

  Widget BuildMap(double size) => Container(
        //color: Colors.grey,
        width: size * 0.9,
        height: 200,
        child: lat == null
            ? ShowProgress()
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(lat!, lng!),
                  zoom: 16,
                ),
                onMapCreated: (controller) {},
                markers: setMarker(),
              ),
      );

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

  Row BuildNameStore(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 60),
          width: size * 0.9,
          child: TextFormField(
            controller: res_nameController,
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
}
