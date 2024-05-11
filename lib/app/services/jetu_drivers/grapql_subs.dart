class JetuDriverSubscription {
  static String getDrivers() {
    return ("""query(\$lat: float8,\$long: float8){
  neardrivers(args: {latitude: \$lat,longitute:\$long,distancekm: 3}){
    id,
    lat,
    long
  }
}
""");
  }

  static String getIntercityOrders() {
    return ("""subscription check_intercity_order(\$userId: String!) {
  jetu_intercity_orders(order_by: {date: asc},where: {user_id: {_eq: \$userId},status: {_eq: "finding"}}){
    id,
    jetu_city{
      id,
      title
    },
    a_address,
    jetuCityByBCity{
      id,
      title
    },
    b_address,
    price,
    comment,
    date,
    time,
    status
  }
}
""");
  }

  static String getUserOrderHistory() {
    return ("""query (\$userId: String!){
  jetu_orders(where: {user_id: {_eq: \$userId}},order_by: {created_at: desc}){
    id,
    point_a_address,
    point_b_address
    cost,
    currency,
    comment,
    status,
    created_at
  }
}
""");
  }

  static String getDriverLocation() {
    return ("""query (\$driverId: String!){
  jetu_drivers(where: {id: {_eq: \$driverId}}){
    id,
    lat,
    long,
    name
  }
}
""");
  }
}
