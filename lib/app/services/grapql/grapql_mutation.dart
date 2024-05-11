class GraphMutation {
  static String addUser() {
    return ("""{mutation {
  insert_jetu_users(objects: [{ name: "Test User 1" ,city: "Batumi"}]) {
    returning {
      id
      name
      rating
    }
  }
}
""");
  }
}
