view: order_items {
  sql_table_name: `thelook.order_items` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension:create_aa  {
    type: date
    sql: ${created_raw} ;;
    group_label: "作成日"
    group_item_label: "日"
  }
  dimension: create_month_name {
    type: date_month
    sql: ${created_raw} ;;
    group_label: "作成日"
    group_item_label: "月"
  }

  dimension_group: created {
    # label: "作成日"
    group_label: "作成日"
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

  dimension_group: delivered {
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

  dimension: inventory_item_id {
    type: number
    hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    group_label: "オーダー"
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
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
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension_group: shipped {
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
    group_label: "オーダー"
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count_distinct_order {
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: min_created_date {
    type: date
    sql: min(${created_raw}) ;;
  }

  measure: max_created_date {
    type: date
    sql:max( ${created_raw}) ;;

  }




# dimension: Order_SEQ {
#   type: number
#   sql: rank() over (partition by ${user_id} order by ${created_raw}) ;;
# }

  set: set_test {
    fields: [user_id,status]
  }
# filter: filter_on_status {
#   type: string
#   sql: ${status}={% parameter processing_status %} ;;
# }
# filter: sample_filter {
#   type: string
#   sql: {%condition filter_on_status %}${status}{% endcondition %}
# }

  filter: input_filter_for_ndt{
    type: string
    sql: ${status} ;;
    default_value: "Completed"
    # suggest_explore: order_items
  }

  filter: status_template_filter_for_ndt {
    type: string
#    sql: {% condition input_filter_for_ndt %}${order_items.status}{% endcondition %} ;;
  }

  dimension: sample {
    sql:
    {% if processing_status._parameter_value == 'Complete' %}
      "コンプリート"
    {% elsif processing_status._parameter_value == 'Cancelled' %}
      "キャンセル"
    {% else %}
    "終了"
    {% endif %};;
  }
  parameter: processing_status {
    description: "Select Status"
    type: unquoted
    allowed_value: {
      label: "Complete"
      value: "Complete"
    }
    allowed_value: {
      label: "Cancelled"
      value: "Cancelled"
    }
    allowed_value: {
      label: "Processing"
      value: "Processing"
    }
    allowed_value: {
      label: "Returned"
      value: "Returned"
    }
    allowed_value: {
      label: "Shipped"
      value: "Shipped"
    }

  }


  measure: list_test {
    type: list
    list_field: status
  }

  measure: total_count {
    type: count
  }

  measure: ave_sales_price {
    type: average
    sql: ${sale_price} ;;
  }
  measure: Total_Sales_Price {
    type: sum
    sql: ${sale_price} ;;
  }

  measure: Average_Sale_Price {
    type: average
    sql: ${sale_price} ;;
  }

  measure: Cumulative_Total_Sales{
    type: running_total
    sql: ${sale_price} ;;
  }

  measure: Total_Gross_Revenue {
    type: sum
    sql: ${sale_price};;
    filters: [status: "Complete"]
  }

  measure: Number_of_Items_Returned{
    type: count_distinct
    sql: ${inventory_item_id} ;;
    filters: [status: "Returned"]
  }

  measure: Item_Return_Rate {
    type: number
    sql: ${Number_of_Items_Returned}/${};;
    value_format: "0.00%"
  }

  measure: Number_of_Customers_Reteuning_Items {
    type: count_distinct
    sql: ${user_id} ;;
    filters: [status: "Retruned"]
  }

  measure: Total_Number_of_Customers {
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: Percent_of_Users_with_Returns{
    type: number
    sql: ${Number_of_Customers_Reteuning_Items}/${Total_Number_of_Customers} ;;
    value_format: "0.00%"
  }

  measure: Average_Spend_per_Customer {
    type: number
    sql: ${Total_Sales_Price}/${Total_Number_of_Customers} ;;
    value_format: "0.00"
  }

  measure: Gross_Margin_Percentage {
    type: number
    sql: ${Total_Gross_Revenue}/${Total_Sales_Price} ;;
    value_format: "0.0%"
  }

  measure: order_count {
    label: "Total_Lifetime_Orders"
    type: count_distinct
    sql: ${order_id} ;;
    sql_distinct_key: ${user_id} ;;
  }

  measure: count_user_order_lastday {
    type: count_distinct
    sql: ${user_id} ;;
    filters: [created_date: "yesterday"]
  }

  measure: count_user {
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: count {
    type: count
  }
# ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.last_name,
      users.id,
      users.first_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }
}
