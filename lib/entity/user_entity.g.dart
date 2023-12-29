part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) {
  return UserEntity(
      json['account'] as String,
      json['username'] as String,
      json['id'] as String,
      json['avatar_path'] as String
  );
}

Map<String, dynamic> _$UserEntityToJson(UserEntity instance) =>
    <String, dynamic>{
      'account': instance.account,
      'username': instance.username,
      'id': instance.id,
      'avatar_path': instance.avatar_path,
    };
