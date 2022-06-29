view: world_cities {
  sql_table_name: `boreal-coyote-290510.google_analytics_sample.world_cities`
    ;;

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: city_ascii {
    type: string
    sql: ${TABLE}.city_ascii ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: location {
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitud};;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.lat ;;
  }

  dimension: longitud {
    type: number
    sql: ${TABLE}.lng ;;
  }

  dimension: population {
    type: number
    sql: ${TABLE}.population ;;
  }
}
