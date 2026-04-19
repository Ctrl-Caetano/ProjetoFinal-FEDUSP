{% macro calcular_dias(data_inicio, data_fim) %}
    case 
        when {{ data_inicio }} is not null and {{ data_fim }} is not null 
        then cast({{ data_fim }} as integer) - cast({{ data_inicio }} as integer)
        else null 
    end
{% endmacro %}
