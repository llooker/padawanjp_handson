connection: "looker-public-demo"

include: "/views/*.view.lkml"                # include all views in the views/ folder in this project
# include: "/**/*.view.lkml"                 # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }

explore: order_items {}

explore: hands_on_sample {
  label: "受注データ分析"

  view_name: order_items
  view_label: "オーダー"

  always_filter: {
    filters: [order_items.created_date: "last 7 days"]
  }

  access_filter: {
    field: products.brand
    user_attribute: brand
  }

  join: orders {
    view_label: "オーダー"
    relationship: many_to_one
    sql_on: ${orders.order_id} = ${orders.order_id} ;;
  }

  join: inventory_items {
    view_label: "在庫アイテム"
    #Left Join only brings in items that have been sold as order_item
    type: full_outer
    relationship: one_to_one
    sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
  }

  join: users {
    view_label: "ユーザー"
    relationship: many_to_one
    sql_on: ${order_items.user_id} = ${users.id} ;;
  }

  join: products {
    view_label: "プロダクト"
    relationship: many_to_one
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
  }


}
