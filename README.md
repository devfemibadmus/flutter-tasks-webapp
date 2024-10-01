# Picquest AI

## Overview

Picquest AI is a task platform where users complete tasks by submitting images. It features a beautiful UI, easy navigation, and allows users to earn prizes. Task statuses include failed, pending, and passed. Users can view their balance, withdraw funds, and manage bank details. The platform is powered by a backend API available at [devfemibadmus/picquest](https://github.com/devfemibadmus/picquest).

## Features

- **File Upload**: Submit tasks and documents with file size limits.
- **Tasks Status**: View pending, failed, and passed tasks.
- **Balance**: Check earned balance, transaction history, and supported banks.
- **Profile**: Signup, Signin, and account verification.


## SOME MODELS

Tasks submission below, check more in lib/models.dart

```dart
Future<String> submitTasks(int taskId, html.File selectedImage) async {
  String token = html.window.localStorage['token'] ?? '';
  try {
    var uri = Uri.parse('$baseUrl/api/v1/submit/');
    var request = http.MultipartRequest('POST', uri);
    request.fields['token'] = token;
    request.fields['taskId'] = taskId.toString();
    var reader = html.FileReader();
    reader.readAsArrayBuffer(selectedImage);
    await reader.onLoad.first;
    var fileBytes = reader.result as List<int>;
    var multipartFile = http.MultipartFile.fromBytes(
      'photo',
      fileBytes,
      filename: selectedImage.name,
    );
    request.files.add(multipartFile);

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    final data = jsonDecode(responseBody);
    return data['message'];
  } catch (e) {
    // print('Error: $e');
  }
  return 'Something went wrong';
}
```


### Screenshots and Demonstration:

| About | Rewards |
|-------------------- | ------------------- |
| ![About](medias/picquest.online_(iPhone%2012%20Pro).png?raw=true) | ![Rewards](medias/picquest.online_(iPhone%2012%20Pro)%20(2).png?raw=true) |

| Terms | Terms |
|-------------- | ---------------------------- |
| ![Terms](medias/picquest.online_(iPhone%2012%20Pro)%20(3).png?raw=true) | ![Terms](medias/picquest.online_(iPhone%2012%20Pro)%20(1).png?raw=true) |

| Signup | Signin |
|--------------------- | --------------------------- |
| ![Signup](medias/picquest.online_app_(iPhone%2012%20Pro)%20(5).png?raw=true) | ![Signin](medias/picquest.online_app_(iPhone%2012%20Pro)%20(6).png?raw=true) |

| Tasks | Task |
|----------------------- | ---------- |
| ![Tasks](medias/picquest.online_app_(iPhone%2012%20Pro)%20(1).png?raw=true) | ![Task](medias/picquest.online_app_(iPhone%2012%20Pro)%20(4).png?raw=true) |

| Profile | Balance |
|----------------------- | ---------- |
| ![Profile](medias/picquest.online_app_(iPhone%2012%20Pro)%20(2).png?raw=true) | ![Balance](medias/picquest.online_app_(iPhone%2012%20Pro)%20(3).png?raw=true) |


