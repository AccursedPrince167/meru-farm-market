import 'package:hive/hive.dart';
import '../models/produce.dart';
import '../models/user.dart';
import '../models/cart_item.dart';
import '../models/review.dart';

// PRODUCE ADAPTER
class ProduceAdapter extends TypeAdapter<Produce> {
  @override
  final int typeId = 0;

  @override
  Produce read(BinaryReader reader) {
    return Produce(
      name: reader.readString(),
      price: reader.readDouble(),
      unit: reader.readString(),
      quantity: reader.readInt(),
      image: reader.readString(),
      farmerName: reader.readString(),
      farmerLocation: reader.readString(),
      rating: reader.readDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, Produce obj) {
    writer.writeString(obj.name);
    writer.writeDouble(obj.price);
    writer.writeString(obj.unit);
    writer.writeInt(obj.quantity);
    writer.writeString(obj.image);
    writer.writeString(obj.farmerName);
    writer.writeString(obj.farmerLocation);
    writer.writeDouble(obj.rating);
  }
}

// USER ADAPTER
class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 1;

  @override
  User read(BinaryReader reader) {
    return User(
      id: reader.readString(),
      name: reader.readString(),
      email: reader.readString(),
      phone: reader.readString(),
      role: reader.read() as UserRole,
      farmLocation: reader.readString(),
      farmName: reader.readString(),
      joinDate: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.email);
    writer.writeString(obj.phone);
    writer.write(obj.role);
    writer.writeString(obj.farmLocation ?? '');
    writer.writeString(obj.farmName ?? '');
    writer.writeInt(obj.joinDate.millisecondsSinceEpoch);
  }
}

// CART ITEM ADAPTER
class CartItemAdapter extends TypeAdapter<CartItem> {
  @override
  final int typeId = 2;

  @override
  CartItem read(BinaryReader reader) {
    return CartItem(
      produce: reader.read() as Produce,
      quantity: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, CartItem obj) {
    writer.write(obj.produce);
    writer.writeInt(obj.quantity);
  }
}

// USER ROLE ADAPTER
class UserRoleAdapter extends TypeAdapter<UserRole> {
  @override
  final int typeId = 3;

  @override
  UserRole read(BinaryReader reader) {
    return UserRole.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, UserRole obj) {
    writer.writeInt(obj.index);
  }
}

// REVIEW ADAPTER - NEW
class ReviewAdapter extends TypeAdapter<Review> {
  @override
  final int typeId = 4;

  @override
  Review read(BinaryReader reader) {
    return Review(
      id: reader.readString(),
      productName: reader.readString(),
      farmerName: reader.readString(),
      userName: reader.readString(),
      rating: reader.readDouble(),
      comment: reader.readString(),
      date: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
    );
  }

  @override
  void write(BinaryWriter writer, Review obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.productName);
    writer.writeString(obj.farmerName);
    writer.writeString(obj.userName);
    writer.writeDouble(obj.rating);
    writer.writeString(obj.comment);
    writer.writeInt(obj.date.millisecondsSinceEpoch);
  }
}