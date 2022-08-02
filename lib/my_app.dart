import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_and_appwrite/main.dart';
import 'package:flutter_and_appwrite/pj_button.dart';
import 'package:flutter_and_appwrite/video_player_screen.dart';
import 'package:get/get.dart';

class MyAppSceen extends StatefulWidget {
  MyAppSceen({super.key});

  @override
  State<MyAppSceen> createState() => _MyAppSceenState();
}

class _MyAppSceenState extends State<MyAppSceen> {
  bool isEdit = false;
  bool isDelete = false;

  final subscription = realtime.subscribe(['files']);

  @override
  Widget build(BuildContext context) {
    subscription.stream.listen((response) {
      log(response.events.toString());
      setState(() {
        // if (response.events.contains('buckets.*.files.*.delete')) {
        //   file!.files.remove(File.fromMap(response.payload));
        //   log(file!.files.length.toString());
        // }
        if (response.events.contains('buckets.*.files.*.create')) {
          File listenedFile = File.fromMap(response.payload);
          if (listenedFile.name != file!.files[file!.files.length - 1].name){
            file!.files.add(File.fromMap(response.payload));
          }
        }
      });
    });
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(27, 30, 38, 1.0),
        ),
        backgroundColor: Color.fromRGBO(15, 18, 24, 1),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              PjButton(
                onTap: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  InputFile? file;

                  if (result != null) {
                    file = InputFile(path: result.files[0].path);
                  } else {
                    log('error');
                  }
                  try {
                    await storage!.createFile(
                      bucketId: '62e7971e274a1754cf4f',
                      fileId: 'sdftyuh566dfgyhbgfd',
                      file: file!,
                    );
                  } on Exception catch (e) {
                    log(e.toString());
                  }
                },
                text: 'Загрузить файл',
              ),
              SizedBox(height: 20),
              PjButton(
                onTap: () {
                  setState((){
                    isDelete = false;
                    isEdit = !isEdit;
                  });
                },
                isSelected: isEdit,
                text: 'Обновить файлы',
              ),
              SizedBox(height: 20),
              PjButton(
                onTap: () {
                  setState((){
                    isDelete = !isDelete;
                    isEdit = false;
                  });
                },
                isSelected: isDelete,
                text: 'Удалить файлы',
              ),
              SizedBox(height: 20),
              PjButton(
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) {
                        return VideoPlayerScreen();
                      },
                    ),
                  );
                },
                text: 'Смотреть видео',
              ),
              SizedBox(
                height: file!.files.length * 120,
                child: ListView.builder(
                  itemCount: file!.files.length,
                  itemBuilder: (context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: GestureDetector(
                        onTap: () async {
                          if (isEdit) {
                            try {
                              await storage!.updateFile(
                                bucketId: '62e7971e274a1754cf4f',
                                fileId: file!.files[index].$id,
                              );
                              isEdit = false;
                            } catch (e) {
                              log(e.toString());
                            }
                          }
                          if (isDelete) {
                            try {
                              await storage!.deleteFile(
                                bucketId: '62e7971e274a1754cf4f',
                                fileId: file!.files[index].$id,
                              );
                              setState(() {
                                file!.files.removeAt(index);
                              });
                              isDelete = false;
                            } catch (e) {
                              log(e.toString());
                            }
                          }
                        },
                        child: Container(
                          width: 336,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Color.fromRGBO(51, 56, 66, 1),
                            ),
                            color: Color.fromRGBO(27, 30, 38, 1.0),
                          ),
                          child: Center(
                            child: Text(
                              file!.files[index].name,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          backgroundColor: Color.fromRGBO(51, 56, 66, 1),
          child: Column(
            children: [
              SizedBox(height: 100),
              Text(
                'User name: ' + user!.name,
                style: const TextStyle(
                  fontSize: 20,
                  color: Color.fromRGBO(15, 18, 24, 1),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'User email: ' + user!.email,
                style: const TextStyle(
                  fontSize: 20,
                  color: Color.fromRGBO(15, 18, 24, 1),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'User phone: ' + user!.phone,
                style: const TextStyle(
                  fontSize: 20,
                  color: Color.fromRGBO(15, 18, 24, 1),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'User id: ' + user!.$id,
                style: const TextStyle(
                  fontSize: 20,
                  color: Color.fromRGBO(15, 18, 24, 1),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
