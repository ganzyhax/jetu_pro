class GraphQuery {
  static String fetchUsers() {
    return ("""{
  jetu_users {
    name
    surname
  }
}
""");
  }
}
