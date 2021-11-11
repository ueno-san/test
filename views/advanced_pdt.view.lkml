view: advanced_pdt {
  derived_table: {
    increment_key: "created_date"
    increment_offset: 3
    sql:SELECT
          order_items.created_at AS order_items.created_at,
          order_items.inventory_item_id AS order_items.inventory_item_id,
          order_items.id AS order_items.id,
          order_items.order_id AS order_items.order_id,
          order_items.status AS order_items.status,
          order_items.user_id AS order_items.user_id,
          order_items.sale_price AS order_items.sale_price
        FROM
          `thelook.order_items` AS order_items
        where
        {% incrementcondition %} created_at {% endincrementcondition %};;
    partition_keys: ["created_at"]
    datagroup_trigger:data_analyst_bootcamp_ja_default_datagroup
  }

  dimension: id {
    type: string
    primary_key: yes
    sql: ${TABLE}.id ;;
  }

  dimension_group: created_at {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      year
    ]
    datatype: timestamp
    sql: ${TABLE}.created_at ;;
  }

  dimension: inventory_item_id {
    type: string
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}.order_id ;;
  }

  dimension:status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: sales_price {
    type: number
    sql: ${TABLE}.sales_price ;;
  }

}
