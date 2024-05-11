class JetuOrderMutation {
  static String orderTaxi() {
    return ("""mutation create_order(\$object: jetu_orders_insert_input!){
  insert_jetu_orders(objects: [\$object]){
    returning {
      status
    }
  }
}
""");
  }

  static String cancelOrder() {
    return ("""mutation cancelOrder(\$orderId: uuid!){
  update_jetu_orders_by_pk(
    pk_columns: {id: \$orderId}
    _set: { status: "canceled" }
  ){
    status
  }
}
""");
  }

  static String updateStatusOrder() {
    return ("""mutation update_order_status(\$orderId: uuid!,\$status: String!){
  update_jetu_orders_by_pk(
    pk_columns: {id: \$orderId}
    _set: { status: \$status }
  ){
    status
  }
}
""");
  }

  static String updateStatusIntercityOrder() {
    return ("""mutation update_order_status(\$orderId: uuid!,\$status: String!){
  update_jetu_intercity_orders_by_pk(
    pk_columns: {id: \$orderId}
    _set: { status: \$status }
  ){
    status
  }
}
""");
  }

  static createFareAlert() {
    return ("""mutation create_alert_fare(\$object: alert_fare_insert_input!){
  insert_alert_fare(objects: [\$object]){
    returning {
      id
    }
  }
}
""");
  }

  static String updateOrderCost() {
    return ("""mutation updateOrderCost(\$orderId: uuid!,\$newCost: String!){
  update_jetu_orders_by_pk(
    pk_columns: {id: \$orderId}
    _set: { cost: \$newCost }
  ){
    status
  }
}
""");
  }

  static String rejectAlertFare() {
    return ("""mutation updateOrderCost(\$orderId: uuid!){
  update_alert_fare_by_pk(
    pk_columns: {id: \$orderId}
    _set: { isReject: true }
  ){
    id
  }
}
""");
  }

  static String acceptOrder() {
    return ("""mutation accept_order(\$orderId: uuid!,\$driverId: String!){
  update_jetu_orders_by_pk(
    pk_columns: {id: \$orderId}
  	_set: { driver_id: \$driverId, status: "onway"}
  ){
    status
  }
}
""");
  }

  static String setRating() {
    return ("""mutation setRating(\$orderId: uuid!,\$driverId: String!){
  update_jetu_orders_by_pk(
    pk_columns: {id: \$orderId}
  	_set: { driver_id: \$driverId, status: "onway"}
  ){
    status
  }
}
""");
  }
}
