-- Macro that converts a UTC timestamp to Australia/Perth timezone
{% macro convert_to_wa_time() %}
    convert_timezone('Australia/Perth', current_timestamp())
{% endmacro %}

-- Macro that converts a UTC timestamp to Australia/Perth timezone, with parameters and return value
{% macro convert_to_wa_time_params(input_date) %}
    from_utc_timestamp({{ input_date }}, 'Australia/Perth')
{% endmacro %}


-- Macro to round off to 2 decimal places
{% macro round_to_2_decimal_places(number) %}
    ROUND({{ number }}, 2)
{% endmacro %}


-- Macro to fix schema to process silver and gold layer upon dbt run
{% macro generate_schema_name(custom_schema_name, node) %}
    {% if custom_schema_name is not none %}
        {{ custom_schema_name }}
    {% else %}
        {{ target.schema }}
    {% endif %}
{% endmacro %}