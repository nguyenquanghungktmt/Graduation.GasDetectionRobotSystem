import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:gas_detek/common/alert_helper.dart';
import 'package:gas_detek/model/device_model.dart';

import '../constant.dart';

class DeviceInfo extends StatefulWidget {
  final Device device;
  const DeviceInfo({Key? key, required this.device}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DeviceInfoState();
  }
}

class _DeviceInfoState extends State<DeviceInfo> {
  late Device _device;

  @override
  void initState() {
    super.initState();
    _device = widget.device;
  }

  void _saveImage(String url) async {
    try {
      await GallerySaver.saveImage(
        url,
        albumName: 'Flutter',
      ).then((success) {
        String message = 'Save failed';
        if (success ?? false) {
          message = 'Image saved';
        }

        Alert.toastSuccess(message);
        Alert.closeToast(
            durationBeforeClose: const Duration(milliseconds: 1500));
      });
    } catch (e) {
      Alert.toastSuccess('Save failed');
      Alert.closeToast(durationBeforeClose: const Duration(milliseconds: 1500));
    }
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    String imageUrl = "$domain/images/${_device.imageUrl}";
    // String imageUrl = 'https://raspberrypi.vn/wp-content/uploads/2016/10/raspberry_pi_3.jpg';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _device.modelName,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: kDarkBlue,
        iconTheme: const IconThemeData(color: Colors.white, size: 36),
        // bottom: PreferredSize(
        //   preferredSize: const Size.fromHeight(4.0),
        //   child: Container(
        //     color: Colors.grey,
        //     height: 0.5,
        //   ),
        // ),
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert_outlined,
              size: 36,
              color: Colors.white,
            ),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  padding: const EdgeInsets.only(right: 10, left: 20),
                  onTap: () => _saveImage(imageUrl),
                  value: 0,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Save Image'),
                      SizedBox(width: 5),
                      Icon(Icons.save_alt_outlined,
                          size: 20, color: Colors.black87),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        // physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container avatar image
            Container(
                height: maxWidth * 0.6,
                width: maxWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: kDarkBlue, width: 2.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14.0),
                  child: Image.network(imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/icon_404_not_found.png'); 
                    }
                  ),
                ),
              ),
            const SizedBox(height: 30.0),

            // model name
            SizedBox(
              height: 46.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Model Name:",
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        _device.modelName,
                        style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Divider(
                      color: Colors.grey.shade400,
                      thickness: 1.0,
                      height: 1.0,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            // serial number
            SizedBox(
              height: 46.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Serial Number:",
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        _device.serialNumber,
                        style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Divider(
                      color: Colors.grey.shade400,
                      thickness: 1.0,
                      height: 1.0,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            
            // serial number
            SizedBox(
              height: 46.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Warranty Status:",
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        _device.deviceStatus,
                        style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Divider(
                      color: Colors.grey.shade400,
                      thickness: 1.0,
                      height: 1.0,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            
            // specifications
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Specifications:",
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey),
                    ),
                    const SizedBox(height: 8.0,),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        ("- ${_device.description}").replaceAll('\\n', '\n\n- '),
                        style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            height: 1.0),
                      ),
                    ),
                    const SizedBox(height: 8.0,),
                    Divider(
                      color: Colors.grey.shade400,
                      thickness: 1.0,
                      height: 1.0,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            
          ],
        ),
      ),
    );
  }
}
