class JetuServicesQuery {
  static String fetchServices() {
    return ("""{
  jetu_services {
    id
    title,
    icon_assets,
    info,
    enable
  }
}
""");
  }

  static String getCity() {
    return ("""query (\$query: String!){
  jetu_city(
    where: {title: {_like: \$query}}
  ) {
    id
    title,
    address
  }
}
""");
  }
}
