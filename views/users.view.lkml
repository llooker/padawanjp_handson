# The name of this view in Looker is "Users"
view: users {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `looker-private-demo.thelook.users`
    ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    label: "ユーザーID"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Age" in Explore.

  dimension: age {
    label: "年齢"
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: age_tier {
    label: "年齢層"
    type: tier
    tiers: [0,10,20,30,40,50,60,70,80]
    style: integer
    sql: ${age} ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: average_age {
    label: "平均年齢"
    type: average
    sql: ${age} ;;
  }

  dimension: city {
    group_label: "居住地"
    label: "市区町村"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    group_label: "居住地"
    label: "国"
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: created {
    label: "ユーザー登録日時"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    label: "メールアドレス"
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    hidden: yes
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    hidden: yes
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: name {
    label: "ユーザー名"
    type: string
    sql: ${first_name} || ' ' || ${last_name} ;;
  }


  dimension: gender {
    label: "性別"
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: latitude {
    group_label: "居住地"
    label: "緯度"
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    group_label: "居住地"
    label: "経度"
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: location {
    group_label: "居住地"
    label: "ロケーション"
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
  }

  dimension: state {
    group_label: "居住地"
    label: "都道府県 / 州"
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: traffic_source {
    label: "流入経路"
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    group_label: "居住地"
    label: "郵便番号 / ZIPコード"
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    label: "ユーザー数"
    type: count
    drill_fields: [id, last_name, first_name, order_items.count, orders.count]
  }
}
