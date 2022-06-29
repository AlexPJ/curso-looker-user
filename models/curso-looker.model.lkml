connection: "bmind_analytics_n_viz"

include: "/views/**/*.view" # include all the views

datagroup: curso_looker_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: curso_looker_default_datagroup

explore: ga_sessions_sample {
  label: "GA Sessions"

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
