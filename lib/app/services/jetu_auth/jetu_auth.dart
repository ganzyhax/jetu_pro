class JetuAuthMutation {
  static String insertFirstData() {
    return ("""mutation create_user(\$object: jetu_users_insert_input!){
  insert_jetu_users_one(object: \$object){
    id
  }
}
""");
  }

  static String updateUserData() {
    return ("""mutation update_user(\$userId: String!,\$name: String!,\$surname: String!, \$email: String!){
  update_jetu_users_by_pk(pk_columns: {id: \$userId}
    _set: {name: \$name,surname: \$surname,email: \$email}){
    id
  }
}
""");
  }
}
