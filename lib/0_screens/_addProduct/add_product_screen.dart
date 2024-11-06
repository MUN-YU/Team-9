import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart'; // 사진 불러오기를 위한 패키지
import 'package:intl/intl.dart'; // 가격 포맷팅을 위한 패키지
import '../5_main/main_screen.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final bool _isLoading = false; // 로딩 상태
  final _titleController = TextEditingController(); // 제목
  final _priceController = TextEditingController(); // 가격
  bool _isNegotiable = false; // 가격 제안 가능 여부
  List<File> _selectedImages = []; // 사진 목록
  final _descriptionController = TextEditingController(); // 제품 상세 설명
  String? _selectedCategory = '도서'; // 제품 카테고리 선택
  final ImagePicker _picker = ImagePicker();

  //final String _jwtToken =

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null && images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images.map((image) => File(image.path)));
      });
    }
  }

  String _getCategoryValue(String? selectedCategory) {
    switch (selectedCategory) {
      case '도서':
        return 'TEXTBOOK';
      case '실험복':
        return 'EXERCISE_EQUIPMENT';
      case '공학계산기':
        return 'ELECTRONICS';
      default:
        return 'OTHER';
    }
  }

  Future<void> _submitData() async {
    final title = _titleController.text;
    final price = int.tryParse(_priceController.text.replaceAll(',', '')) ?? 0;
    final description = _descriptionController.text;
    final isOfferAccepted = _isNegotiable;
    final category = _getCategoryValue(_selectedCategory);

    final url = Uri.parse('https://swe9.comit-server.com/items');

    try {
      // MultipartRequest 생성
      var request = http.MultipartRequest('POST', url);

      // Authorization 헤더 추가
      request.headers['Authorization'] =
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI2IiwidXNlcm5hbWUiOiJoYW5uYWhzIiwiaWF0IjoxNzMwNzg1ODY3LCJleHAiOjE3NDYzMzc4Njd9.gg7du8q1QBPDl5dT8gYxJsScNpBOkrn3tbVkCQjG544';
      request.headers['Content-Type'] =
          'multipart/form-data; boundary=<calculated when request is sent>';

      request.fields['title'] = title;
      request.fields['price'] = price.toString();
      request.fields['isOfferAccepted'] = isOfferAccepted.toString();
      request.fields['category'] = category;
      request.fields['description'] = description;

      // 파일 업로드
      if (_selectedImages.isEmpty) {
        // 사진 없으면 로고 업로드
        final byteData = await rootBundle
            .load('assets/images/logo/logo_white_moon_green_back.png');
        final tempDir = await getTemporaryDirectory();
        final file =
            await File('${tempDir.path}/default_image.png').writeAsBytes(
          byteData.buffer.asUint8List(),
        );
        request.files
            .add(await http.MultipartFile.fromPath('photos', file.path));
      } else {
        // 선택한 이미지를 업로드
        for (var image in _selectedImages) {
          request.files
              .add(await http.MultipartFile.fromPath('photos', image.path));
        }
      }

      // 요청 보내기
      final response = await request.send();

      if (response.statusCode == 201) {
        print('물품 등록 성공');
        final responseBody = await response.stream.bytesToString();
        print('응답: $responseBody');

        // Navigate back to MainScreen after successful submission
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } else {
        final responseBody = await response.stream.bytesToString();
        print('물품 등록 실패: ${response.statusCode}');
        print('에러 메시지: $responseBody');
      }
    } catch (error) {
      print('에러 발생: $error');
    }
  }

  void _removeImage(int index) {
    if (index >= 0 && index < _selectedImages.length) {
      setState(() {
        _selectedImages.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 37, 26),

      // 상단 바
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '내 물품 등록',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          }, // 뒤로가기 버튼
        ),
      ),

      // 물품 등록 body
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFC4D5BA),
          padding: const EdgeInsets.all(16.0),
          child: AddProduct(
            titleController: _titleController,
            priceController: _priceController,
            descriptionController: _descriptionController,
            selectedCategory: _selectedCategory,
            onCategoryChanged: (value) {
              setState(() {
                _selectedCategory = value ?? '도서';
              });
            },
            isNegotiable: _isNegotiable,
            onNegotiableChanged: (value) {
              setState(() {
                _isNegotiable = value;
              });
            },
            onPickImage: _pickImage,
            selectedImages: _selectedImages,
            onRemoveImage: _removeImage,
          ),
        ),
      ),

      // 물품 등록하기 버튼
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF204020), // 짙은 배경색 설정
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0), // 버튼 위아래 패딩
          child: Center(
            child: SizedBox(
              width: 450, // 버튼의 가로 크기 설정
              height: 70, // 버튼의 세로 크기 설정
              child: ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC4D5BA), // 버튼 배경색
                  foregroundColor: Colors.black, // 텍스트 색상
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  "물품 등록하기",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 입력한 가격 포맷팅
class PriceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    final text = newValue.text.replaceAll(',', '').replaceAll('₩', '');
    final int value = int.tryParse(text) ?? 0;
    final formattedValue = '${NumberFormat('#,###').format(value)}';

    return newValue.copyWith(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}

class AddProduct extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController priceController;
  final TextEditingController descriptionController;
  final String? selectedCategory;
  final bool isNegotiable;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<bool> onNegotiableChanged;
  final VoidCallback onPickImage;
  final List<File> selectedImages;
  final void Function(int) onRemoveImage;

  const AddProduct({
    required this.titleController,
    required this.priceController,
    required this.descriptionController,
    required this.selectedCategory,
    required this.isNegotiable,
    required this.onCategoryChanged,
    required this.onNegotiableChanged,
    required this.onPickImage,
    required this.selectedImages,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    const borderColor = Color.fromARGB(255, 20, 37, 26);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // 제목 입력
        const Text('제목', style: TextStyle(fontSize: 20)),
        const SizedBox(height: 6),
        TextField(
          controller: titleController,
          decoration: InputDecoration(
            hintText: ' 제목 입력',
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 2.0),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Divider(color: Colors.grey, thickness: 1),
        const SizedBox(height: 10),

        // 가격 입력
        const Text('가격', style: TextStyle(fontSize: 20)),
        const SizedBox(height: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    PriceInputFormatter(),
                  ],
                  decoration: InputDecoration(
                    prefixText: '₩ ',
                    hintText: '가격 입력',
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor, width: 2.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 가격 제안 여부
          Row(children: [
            Transform.scale(
              scale: 1.3,
              child: Checkbox(
                value: isNegotiable,
                activeColor: borderColor,
                onChanged: (value) {
                  onNegotiableChanged(value!);
                },
              ),
            ),
            const Text("가격 제안 받기", style: TextStyle(fontSize: 16)),
          ])
        ]),
        const SizedBox(height: 10),
        const Divider(color: Colors.grey, thickness: 1),
        const SizedBox(height: 10),

        // 사진 등록
        const Text('사진', style: TextStyle(fontSize: 20)),
        const SizedBox(height: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // 사진
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, size: 40),
                    onPressed: selectedImages.length < 10 ? onPickImage : null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: selectedImages.isEmpty
                      ? Container() // 사진이 없을 때는 아무것도 표시하지 않음
                      : SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: selectedImages.length,
                            itemBuilder: (context, index) {
                              return Container(
                                color: Colors.white,
                                child: Stack(
                                  children: [
                                    Image.file(
                                      selectedImages[index],
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      // 사진 삭제 기능
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: Icon(Icons.close,
                                                color: Colors.white),
                                            onPressed: () =>
                                                onRemoveImage(index),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // 사진이 없으면 0/10로, 있으면 '사진 개수'/10로 표시
            Text(
              ' ${selectedImages.isEmpty ? 0 : selectedImages.length}/10',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(color: Colors.grey, thickness: 1),
        const SizedBox(height: 10),

        // 제품 상세 설명 입력
        const Text('제품 상세 설명', style: TextStyle(fontSize: 20)),
        const SizedBox(height: 12),
        const Text('카테고리 선택', style: TextStyle(fontSize: 16)),
        ButtonTheme(
          alignedDropdown: true,
          child: DropdownButtonFormField<String>(
            // 카테고리 선택
            value: selectedCategory,
            isExpanded: false,
            items: ['도서', '실험복', '공학계산기', '요약본', '기타 품목']
                .map((String category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ))
                .toList(),
            onChanged: onCategoryChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor, width: 2.0),
              ),
            ),
            dropdownColor: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        const Text('상세 설명', style: TextStyle(fontSize: 16)),
        TextField(
          controller: descriptionController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: '상세 설명 입력',
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 2.0),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
