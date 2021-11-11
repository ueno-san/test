connection: "bigquery"

include: "/views/*.view.lkml"

datagroup: data_analyst_bootcamp_ja_default_datagroup {
  sql_trigger: SELECT Current_date;;
  max_cache_age: "1 hour"
}

persist_with: data_analyst_bootcamp_ja_default_datagroup


# This explore contains multiple views
explore: order_items {
  # fields: [ALL_FIELDS*,-order_items.total_revenue]
  # fields: [order_items.visible_dimensions_and_mesures*]
  group_label: "bootcamp 2021 fall"
  # access_filter: {
  #   field: users.email
  #   user_attribute: email
  # }
  label: "(1) オーダー、アイテム、ユーザー関連"
  view_label: "オーダー"
  join: users {
    view_label: "ユーザー"
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    view_label: "在庫アイテム"
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }
  # extends: [inventory_items]
  join: products {
    view_label: "プロダクト"
      type: left_outer
      sql_on: ${inventory_items.product_id} = ${products.id} ;;
      relationship: many_to_one
  }

  # join: customer_lifetime_value {
  #   view_label: "カスタマーライフタイムバリュー"
  #   type: left_outer
  #   sql_on: ${customer_lifetime_value.user_id}=${order_items.user_id} ;;
  #   relationship: many_to_one
  # }

  # join: users_boss {
  #   from: users
  #   view_label: "上司ユーザー"
  #   type: left_outer
  #   sql_on: ${order_items.user_id} = ${users_boss.id} ;;
  #   relationship: many_to_one
  # }


  # join: events {
  #   view_label: "イベント"
  #   type: left_outer
  #   sql_on: ${events.user_id} = ${users.id} ;;
  #   relationship: many_to_one
  # }

  # aggregate_table: sales_monthly {
  #   materialization: {
  #     datagroup_trigger: data_analyst_bootcamp_ja_default_datagroup
  # increment_key: "created_month"
  # increment_offset: 1

  #   }
  #   query: {
  #     dimensions: [order_items.created_month, order_items.status] # <-- orders.region field
  #     measures: [order_items.total_revenue]
  #     timezone: America/New_York
  #   }
  # }
  # aggregate_table: sales_recent_3days {
  #   materialization: {
  #     datagroup_trigger: data_analyst_bootcamp_ja_default_datagroup
  #   }
  #   query: {
  #     dimensions: [order_items.created_date, order_items.status] # <-- orders.region field
  #     # measures: [order_items.total_revenue]
  #     filters: [order_items.created_date: "3 days"]
  #     timezone: America/New_York
  #   }
  # }
}

named_value_format: yen_0 {
  value_format: "\"¥\"#,##0"
}

explore: advanced_pdt {}

# explore: advanced_pdt_ndt {}

# explore: events {}

# explore: products {}


# explore: users {}
