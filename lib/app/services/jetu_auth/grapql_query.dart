class JetuAuthQuery {
  static String fetchUserInfo() {
    return ("""query fetch_user_info(\$userId: String!){
  jetu_users_by_pk(id: \$userId) {
    id,
    name,
    surname,
    phone,
    email,
    avatarUrl
  }
}
""");
  }

  static String fetchUserInfoSubs() {
    return ("""query fetch_user_info(\$userId: String!){
  jetu_users_by_pk(id: \$userId) {
    id,
    name,
    surname,
    phone,
    email,
    avatarUrl
  }
}
""");
  }

  static String isRegistered() {
    return ("""query check_user_login(\$phone: String!){
  jetu_users (where: {phone: {_like: \$phone}}){
    id
  }
}
""");
  }
}
