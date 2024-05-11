class JetuOrderSubscription {
  static String subscribeOrder() {
    return ("""subscription (\$userId: String!) {
  jetu_orders(where: {user_id: {_eq: \$userId}, status: {_in: ["requested","onway","arrived","started","paymend"]}}){
    id,
    jetu_driver{
      id,
      name,
      surname,
      phone,
      avatar_url,
      rating,
      car_model,
      car_color,
      car_number,
      is_verified
    },
    
    cost,
    status,
    point_a_lat,
    point_a_long,
    currency,
    point_b_lat,
    point_b_long,
    point_a_address,
    point_b_address
    created_at,
    comment,
  }
}
""");
  }

  static String getIntercityOrders() {
    return ("""
    subscription check_intercity_order(\$start: timestamptz!,\$end: timestamptz!,\$aCity: uuid!,\$bCity: uuid!) {
  jetu_intercity_orders(order_by: {date: asc},where: {date: {_gte: \$start, _lte: \$end},a_city: {_eq: \$aCity},b_city: {_eq: \$bCity},status: {_eq: "finding"},driver_id: {_is_null: false}}){
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
    status,
    jetu_driver{
      id,
      name,
      surname,
      phone,
      avatar_url,
      rating,
      car_model,
      car_color,
      car_number,
      is_verified
      }
  }
}
    """);
  }

  static String subscribeAlertOrderFare() {
    return ("""
    subscription orderDetailCheck(\$orderId: uuid!) {
  alert_fare(where: {order_id: {_eq: \$orderId},_and: {isReject: {_eq: false}},_not:{isUserSend: {_eq: true}}}){
    id,
    jetu_user{
      id,
      name,
      phone,
    },
    jetu_driver{
      id,
      name,
      surname,
      phone,
      avatar_url,
      rating,
      car_model,
      car_color,
      car_number,
      is_verified
      },
    cost
  }
}
""");
  }
}
