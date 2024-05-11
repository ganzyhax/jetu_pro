class GraphSubscription {
  static String subscribeUsers() {
    return ("""subscription subscribeUsers {
    jetu_users {
        name
        surname
        rating
    }
}
""");
  }
}
