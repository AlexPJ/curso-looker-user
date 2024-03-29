connection: "bmind_analytics_n_viz"

include: "/views/**/*.view" # include all the views


######## Datagroups ########
datagroup: ga_sessions_datagroup {
  sql_trigger:  SELECT MAX(SUBSTR(table_id,-8)) AS date FROM `bigquery-public-data.google_analytics_sample.__TABLES__`;;
  max_cache_age: "24 hour"
}

datagroup: ecommerce_datagroup {
  sql_trigger:  SELECT TIMESTAMP_MILLIS(MAX(last_modified_time)) last_modified_time FROM `bigquery-public-data.thelook_ecommerce.__TABLES__`;;
  max_cache_age: "24 hour"
}


######## Google Analytics Sessions Sample ########
explore: ga_sessions_sample {
  label: "(1) GA Sessions"

  persist_with: ga_sessions_datagroup

  always_filter: {
    filters: [ga_sessions_sample.data_date: "30 days"]
  }

  join: client_data {
    view_label: "Client Data form CRM"
    sql: LEFT JOIN `boreal-coyote-290510.google_analytics_sample.client_data` as client_data ON ${ga_sessions_sample.full_visitor_id} = ${client_data.fullVisitorId};;
    relationship: one_to_one
  }

  join: world_cities {
    view_label: "World Cities"
    sql: LEFT JOIN `boreal-coyote-290510.google_analytics_sample.world_cities` as world_cities ON ${ga_sessions_sample.geo_network__country} = ${world_cities.country} AND ${ga_sessions_sample.geo_network__city} = ${world_cities.city_ascii};;
    relationship: one_to_one
  }

  join: ga_sessions_sample__hits {
    view_label: "GA Sessions: Hits"
    sql: LEFT JOIN UNNEST(${ga_sessions_sample.hits}) as ga_sessions_sample__hits ;;
    relationship: one_to_many
  }

  join: ga_sessions_sample__custom_dimensions {
    view_label: "GA Sessions: Custom Dimensions"
    sql: LEFT JOIN UNNEST(${ga_sessions_sample.custom_dimensions}) as ga_sessions_sample__custom_dimensions ;;
    relationship: one_to_many
  }

  join: ga_sessions_sample__hits__product {
    view_label: "GA Sessions: Hits Product"
    sql: LEFT JOIN UNNEST(${ga_sessions_sample__hits.product}) as ga_sessions_sample__hits__product ;;
    relationship: one_to_many
  }

  join: ga_sessions_sample__hits__promotion {
    view_label: "GA Sessions: Hits Promotion"
    sql: LEFT JOIN UNNEST(${ga_sessions_sample__hits.promotion}) as ga_sessions_sample__hits__promotion ;;
    relationship: one_to_many
  }

  join: ga_sessions_sample__hits__custom_metrics {
    view_label: "GA Sessions: Hits Custom Metrics"
    sql: LEFT JOIN UNNEST(${ga_sessions_sample__hits.custom_metrics}) as ga_sessions_sample__hits__custom_metrics ;;
    relationship: one_to_many
  }

  join: ga_sessions_sample__hits__custom_variables {
    view_label: "GA Sessions: Hits Custom Variables"
    sql: LEFT JOIN UNNEST(${ga_sessions_sample__hits.custom_variables}) as ga_sessions_sample__hits__custom_variables ;;
    relationship: one_to_many
  }

  join: ga_sessions_sample__hits__custom_dimensions {
    view_label: "GA Sessions: Hits Custom Dimensions"
    sql: LEFT JOIN UNNEST(${ga_sessions_sample__hits.custom_dimensions}) as ga_sessions_sample__hits__custom_dimensions ;;
    relationship: one_to_many
  }

  join: ga_sessions_sample__hits__experiment {
    view_label: "GA Sessions: Hits Experiment"
    sql: LEFT JOIN UNNEST(${ga_sessions_sample__hits.experiment}) as ga_sessions_sample__hits__experiment ;;
    relationship: one_to_many
  }

  join: ga_sessions_sample__hits__publisher_infos {
    view_label: "GA Sessions: Hits Publisher Infos"
    sql: LEFT JOIN UNNEST(${ga_sessions_sample__hits.publisher_infos}) as ga_sessions_sample__hits__publisher_infos ;;
    relationship: one_to_many
  }

  join: ga_sessions_sample__hits__product__custom_metrics {
    view_label: "GA Sessions: Hits Product Custom Metrics"
    sql: LEFT JOIN UNNEST(${ga_sessions_sample__hits__product.custom_metrics}) as ga_sessions_sample__hits__product__custom_metrics ;;
    relationship: one_to_many
  }

  join: ga_sessions_sample__hits__product__custom_dimensions {
    view_label: "GA Sessions: Hits Product Custom Dimensions"
    sql: LEFT JOIN UNNEST(${ga_sessions_sample__hits__product.custom_dimensions}) as ga_sessions_sample__hits__product__custom_dimensions ;;
    relationship: one_to_many
  }
}


######## eCommerce ########
explore: order_items {
  label: "(2) eCommerce: Orders, Items and Users"
  view_name: order_items

  persist_with: ecommerce_datagroup

  join: inventory_items {
    view_label: "Inventory Items"
    #Left Join only brings in items that have been sold as order_item
    type: full_outer
    relationship: one_to_one
    sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
  }

  join: users {
    view_label: "Users"
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.user_id} = ${users.id} ;;
  }

  join: products {
    view_label: "Products"
    type: left_outer
    relationship: many_to_one
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
  }

  join: distribution_centers {
    view_label: "Distribution Center"
    type: left_outer
    sql_on: ${distribution_centers.id} = ${inventory_items.product_distribution_center_id} ;;
    relationship: many_to_one
  }
}



#########  Event Data Explores #########

explore: events {
  label: "(3) eCommerce: Web Event Data"

  persist_with: ecommerce_datagroup

  join: sessions {
    view_label: "Sessions"
    type: left_outer
    sql_on: ${events.session_id} =  ${sessions.session_id} ;;
    relationship: many_to_one
  }

  join: session_landing_page {
    view_label: "Session Landing Page"
    from: events
    type: left_outer
    sql_on: ${sessions.landing_event_id} = ${session_landing_page.event_id} ;;
    fields: [simple_page_info*]
    relationship: one_to_one
  }

  join: session_bounce_page {
    view_label: "Session Bounce Page"
    from: events
    type: left_outer
    sql_on: ${sessions.bounce_event_id} = ${session_bounce_page.event_id} ;;
    fields: [simple_page_info*]
    relationship: many_to_one
  }

  join: product_viewed {
    view_label: "Product Viewed"
    from: products
    type: left_outer
    sql_on: ${events.viewed_product_id} = ${product_viewed.id} ;;
    relationship: many_to_one
  }

  join: users {
    view_label: "Users"
    type: left_outer
    sql_on: ${sessions.session_user_id} = ${users.id} ;;
    relationship: many_to_one
  }

}

explore: sessions {
  label: "(4) eCommerce: Web Session Data"

  persist_with: ecommerce_datagroup

  join: events {
    view_label: "Events"
    type: left_outer
    sql_on: ${sessions.session_id} = ${events.session_id} ;;
    relationship: one_to_many
  }

  join: product_viewed {
    view_label: "Product Viewed"
    from: products
    type: left_outer
    sql_on: ${events.viewed_product_id} = ${product_viewed.id} ;;
    relationship: many_to_one
  }

  join: session_landing_page {
    view_label: "Session Landing Page"
    from: events
    type: left_outer
    sql_on: ${sessions.landing_event_id} = ${session_landing_page.event_id} ;;
    fields: [session_landing_page.simple_page_info*]
    relationship: one_to_one
  }

  join: session_bounce_page {
    view_label: "Session Bounce Page"
    from: events
    type: left_outer
    sql_on: ${sessions.bounce_event_id} = ${session_bounce_page.event_id} ;;
    fields: [session_bounce_page.simple_page_info*]
    relationship: one_to_one
  }

  join: users {
    view_label: "Users"
    type: left_outer
    relationship: many_to_one
    sql_on: ${users.id} = ${sessions.session_user_id} ;;
  }

}
