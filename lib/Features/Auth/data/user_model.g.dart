part of 'user.dart'; // Make sure this is imported correctly



class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    return UserModel(
      reader.readString(), // id
      email: reader.readString(),
      userName: reader.readString(),
      phoneNumber: reader.readString(),
      password: reader.read(), // can be null
      profilePicture: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.email);
    writer.writeString(obj.userName);
    writer.writeString(obj.phoneNumber);
    writer.write(obj.password); // nullable
    writer.writeString(obj.profilePicture);
  }
}
