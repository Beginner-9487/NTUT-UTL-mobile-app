import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../res/strings/strings.dart';
import '../utils/screen_utils.dart';

part 'user_entity.g.dart';

@JsonSerializable()
class UserEntity {
  String account;
  String username;
  String id;
  String avatar_path;

  UserEntity(this.account, this.username, this.id, this.avatar_path);

  factory UserEntity.getIllegalUserEntity() {
    return IllegalUserEntity(ResourceString.guest, ResourceString.guest, "...", "");
  }
  factory UserEntity.getGuestUserEntity() {
    return GuestUserEntity(ResourceString.guest, ResourceString.guest, "...", "");
  }

  UserEntity copyWith({account, username, id, avatar_path}) {
    UserEntity copy = UserEntity(
        account ?? this.account,
        username ?? this.username,
        id ?? this.id,
        avatar_path ?? this.avatar_path
    );
    return copy;
  }

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserEntityToJson(this);

  Map getParams() {
    return toJson();
  }

  Widget get_avatar(double size) {
    return CachedNetworkImage(
      imageUrl: avatar_path,
      width: pt(size),
      height: pt(size),
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(
        Icons.account_circle,
        color: Colors.white,
        size: pt(size),
      ),
    );
  }
}

abstract class UserEntityAbstract {}

class IllegalUserEntity extends UserEntity implements UserEntityAbstract {
  IllegalUserEntity(super.account, super.username, super.id, super.avatar_path);
}

class GuestUserEntity extends IllegalUserEntity {
  GuestUserEntity(super.account, super.username, super.id, super.avatar_path);
}

class NormalUserEntity extends UserEntity implements UserEntityAbstract {
  NormalUserEntity(super.account, super.username, super.id, super.avatar_path);
}

class AdministratorUserEntity extends UserEntity implements UserEntityAbstract {
  AdministratorUserEntity(super.account, super.username, super.id, super.avatar_path);
}