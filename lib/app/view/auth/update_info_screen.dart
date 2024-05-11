import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:jetu/app/services/jetu_drivers/grapql_mutation.dart';
import 'package:jetu/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu/app/widgets/button/app_button_v1.dart';
import 'package:jetu/app/widgets/text_field_input.dart';
import 'package:jetu/data/model/jetu_user_model.dart';
import 'package:jetu/gateway/graphql_service.dart';
import 'package:nhost_flutter_auth/nhost_flutter_auth.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class UpdateInfoScreen extends StatefulWidget {
  final JetuUserModel? user;
  final bool isEdit;

  const UpdateInfoScreen({
    Key? key,
    this.user,
    this.isEdit = false,
  }) : super(key: key);

  @override
  State<UpdateInfoScreen> createState() => _UpdateInfoScreenState();
}

class _UpdateInfoScreenState extends State<UpdateInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    if (widget.user?.name?.isNotEmpty ?? false) {
      _nameController.text = widget.user?.name ?? '';
    }

    if (widget.user?.surname?.isNotEmpty ?? false) {
      _surnameController.text = widget.user?.surname ?? '';
    }

    if (widget.user?.email?.isNotEmpty ?? false) {
      _emailController.text = widget.user?.email ?? '';
    }

    _emailController.addListener(updateState);
    _nameController.addListener(updateState);
    _emailController.addListener(updateState);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _surnameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
  }

  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: Divider.createBorderSide(context,
          color: AppColors.black.withOpacity(0.3), width: 0.5),
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        title: const Text(
          "Профиль",
          style: TextStyle(
            color: AppColors.black,
          ),
        ),
        leading: widget.isEdit
            ? GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: AppColors.black,
                ),
              )
            : null,
        actions: [
          if (widget.isEdit)
            IconButton(
              onPressed: () => deleteAccountDialog(context),
              icon: const Icon(
                Icons.delete,
                color: AppColors.red,
              ),
            )
        ],
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24.0.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 12.h),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        UploadPhotoItem(
                          userImage: widget.user!.avatarUrl.toString(),
                          selectedFile: (file) {
                            log(widget.user!.id.toString());
                            log(widget.user!.avatarUrl.toString());
                            uploadImage(file!,
                                driverId: widget.user!.id.toString());
                          },
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.user?.name ?? 'Не указано'} ${widget.user?.surname ?? ''}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              widget.user?.phone ?? '',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0, bottom: 2),
                    child: Text(
                      'Имя',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.699999988079071),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 2.14,
                      ),
                    ),
                  ),
                  TextFieldInput(
                    hintText: 'Имя',
                    textInputType: TextInputType.text,
                    textEditingController: _nameController,
                    border: inputBorder,
                  ),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0, bottom: 2),
                    child: Text(
                      'Фамилия',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.699999988079071),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 2.14,
                      ),
                    ),
                  ),
                  TextFieldInput(
                    hintText: 'Фамилия',
                    textInputType: TextInputType.text,
                    textEditingController: _surnameController,
                    border: inputBorder,
                  ),
                  SizedBox(height: 36.h),
                  AppButtonV1(
                    onTap: () => context.read<AuthCubit>().updateUserData(
                          context,
                          name: _nameController.text,
                          surname: _surnameController.text,
                          email: _emailController.text,
                        ),
                    isLoading: state.isLoading,
                    text: 'Сохранить',
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> deleteAccountDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext ncontext) {
        return AlertDialog(
          title: const Text("Удаление аккаунта"),
          content: const Text(
              "Вы уверены, что хотите удалить свой аккаунт? Вы можете снова войти в систему в течение 30 дней, чтобы восстановить учетную запись. По истечении этого периода ваши данные будут полностью удалены."),
          actions: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: TextButton(
                    onPressed: () {
                      context.read<AuthCubit>().logout();
                      Navigator.of(ncontext).pop();
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Удалить аккаунт",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Color(0xffb20d0e),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Отмена",
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> uploadImage(File file, {String driverId = ''}) async {
    print(driverId);
    try {
      final auth = NhostAuthClient(
        url: "https://elmrnhqzybgkyhthobqy.auth.eu-central-1.nhost.run/v1",
      );

      final storage = NhostStorageClient(
        url: 'https://elmrnhqzybgkyhthobqy.storage.eu-central-1.nhost.run/v1',
        session: auth.userSession,
      );
      final res = await auth.signInEmailPassword(
        email: 'user-1@nhost.io',
        password: 'password-1',
      );

      final imageResponse = await storage.uploadBytes(
        fileName: '${Platform.operatingSystem}_${getUniqueValue()}',
        fileContents: await file.readAsBytes(),
        mimeType: 'image/jpeg',
        bucketId: 'driver_documents',
      );

      String imageLink =
          "https://elmrnhqzybgkyhthobqy.storage.eu-central-1.nhost.run/v1/files/${imageResponse.id}";

      final MutationOptions options = MutationOptions(
        document: gql(JetuDriverMutation.updateUserImage()),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {
          "userId": driverId,
          "avatarUrl": imageLink,
        },
      );
      final client = await GraphQlService.init();
      final ress = await client.value.mutate(options);
      log(ress.data.toString());
      print("uploadPhone: ${ress.exception}");
    } catch (err) {
      print('image err: $err');
    }
  }

  static String getUniqueValue() {
    var uuid = const Uuid();
    return uuid.v1();
  }
}

class UploadPhotoItem extends StatefulWidget {
  final Function(File?) selectedFile;
  String userImage;

  UploadPhotoItem({
    Key? key,
    required this.userImage,
    required this.selectedFile,
  }) : super(key: key);

  @override
  State<UploadPhotoItem> createState() => _UploadPhotoItemState();
}

class _UploadPhotoItemState extends State<UploadPhotoItem> {
  final ImagePicker picker = ImagePicker();

  File? imageFile;

  Future<void> _pickImage(ImageSource source) async {
    XFile? pickedImage;
    try {
      pickedImage = await picker.pickImage(source: source, maxWidth: 1920);
      if (pickedImage == null) return;
      final String fileName = path.basename(pickedImage.path);
      imageFile = File(pickedImage.path);
      setState(() {});
      widget.selectedFile.call(imageFile);
    } catch (err) {
      log('err: $err');
    }
  }

  showImageSelectionBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(16.r),
          right: Radius.circular(16.r),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 280,
          child: SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Выберите способ добавления фото",
                ),
                SizedBox(height: 20.h),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                  title: const Text("Сфотографировать"),
                  trailing: const Icon(Icons.photo_camera_outlined),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                  title: const Text("Загрузить из галереи"),
                  trailing: const Icon(Icons.photo_library_outlined),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        pickPhotoArea(context),
        // photoType(
        //   isUploaded: imageFile != null,
        // ),
      ],
    );
  }

  Widget pickPhotoArea(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: InkWell(
            onTap: () {
              showImageSelectionBottomSheet(context);
            },
            child: SizedBox(
              height: 56,
              width: 56,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(99.r),
                child: imageFile != null
                    ? Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: const Color(0xff7c94b6),
                          image: DecorationImage(
                            image: FileImage(imageFile!),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        ),
                      )
                    : (widget.userImage == 'null')
                        ? Container(
                            width: 60.0,
                            height: 60.0,
                            decoration: BoxDecoration(
                              color: const Color(0xff7c94b6),
                              image: DecorationImage(
                                image:
                                    AssetImage('assets/images/jetu_logo.jpeg'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                            ),
                          )
                        : Container(
                            width: 60.0,
                            height: 60.0,
                            decoration: BoxDecoration(
                              color: const Color(0xff7c94b6),
                              image: DecorationImage(
                                image: NetworkImage(widget.userImage),
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                            ),
                          ),
              ),
            ),
            // TextButton(
            //     onPressed: () => showImageSelectionBottomSheet(context),
            //     child: const Text('Загрузить фото'),
            //   ),
          ),
        ));
  }

  Widget photoType({
    bool isUploaded = false,
  }) {
    return isUploaded
        ? TextButton(
            onPressed: () {
              setState(
                () => imageFile = null,
              );
              widget.selectedFile.call(imageFile);
            },
            child: const Text(
              "🗑️ Удалить",
              style: TextStyle(
                color: AppColors.red,
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
