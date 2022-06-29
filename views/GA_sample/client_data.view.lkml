view: client_data {
  sql_table_name: `boreal-coyote-290510.google_analytics_sample.client_data`
    ;;

  dimension: fullVisitorId {
    type: string
    sql: ${TABLE}.fullVisitorId ;;
  }

  dimension: email {
    tags: ["email"]
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: phone {
    tags: ["phone"]
    type: string
    sql: ${TABLE}.clean_phone ;;
  }

  dimension: segment {
    type: string
    sql: ${TABLE}.segment ;;
  }

  dimension: status {
    type: string
    sql: COALESCE(${TABLE}.status,'inactive') ;;
  }

  dimension: engagement {
    type: string
    sql:
      CASE
       WHEN ${TABLE}.engagement > 80 THEN 'High'
       WHEN ${TABLE}.engagement > 40 THEN 'Medium'
       ELSE 'Low'
      END;;
  }
}
