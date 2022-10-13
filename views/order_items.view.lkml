# The name of this view in Looker is "Order Items"
view: order_items {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `looker-private-demo.thelook.order_items`
    ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: created {
    label: "受注日時"
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

  dimension: date {
    type: date
    sql: ${created_raw} ;;
    datatype: datetime
  }

  dimension_group: delivered {
    label: "到着日時"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.delivered_at ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Inventory Item ID" in Explore.

  dimension: inventory_item_id {
    type: number
    hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    label: "返品日時"
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
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    label: "売上額"
    type: number
    sql: ${TABLE}.sale_price ;;
    value_format_name: usd
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_sale_price {
    label: "総売上額"
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd

    filters: [status: "Cancelled, Returned"]
  }

  measure: average_sale_price {
    label: "平均売上額"
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  dimension_group: shipped {
    label: "出荷日時"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: status_jp {
    label: "ステータス"
    type: string
    sql:
      CASE
        WHEN ${status} = 'Processing' THEN 'プロセス中'
        WHEN ${status} = 'Shipped' THEN '出荷'
        WHEN ${status} = 'Complete' THEN '完了'
        WHEN ${status} = 'Returned' THEN '返品'
        WHEN ${status} = 'Cancelled' THEN 'キャンセル'
        ELSE null
      END ;;

  }

  dimension: user_id {
    type: number
    hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: is_returned {
    label: "返品フラグ"
    type: yesno
    sql: ${status} = "Returned" ;;
  }

  measure: num_of_return {
    label: "返品数"
    type: count
    filters: [is_returned: "yes"]
  }

  measure: count {
    label: "オーダー数"
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.last_name,
      users.id,
      users.first_name,
      inventory_items.id,
      inventory_items.product_name,
      orders.order_id
    ]
  }

  # ----- Sets advanced information ------
  parameter: date_selector {
    label: "日付粒度選択"
    type: unquoted
    allowed_value: {
      label: "年"
      value: "year"
    }

    allowed_value: {
      label: "月"
      value: "month"
    }

    allowed_value: {
      label: "週"
      value: "week"
    }

    allowed_value: {
      label: "日"
      value: "day"
    }

    default_value: "day"
  }

  dimension: param_date {
    label: "選択日付"
    type: date
    sql:
          {% if date_selector._parameter_value == 'day' %} ${created_date}

      {% elsif date_selector._parameter_value == 'week' %} ${created_week}

      {% elsif date_selector._parameter_value == 'month' %} ${created_month}

      {% elsif date_selector._parameter_value == 'year' %} ${created_year}

      {% else %} null {% endif %}

    ;;
  }
}
