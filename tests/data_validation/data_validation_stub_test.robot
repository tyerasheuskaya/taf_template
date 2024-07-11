*** Settings ***
Documentation        This is initial test suite for data validation
Resource             ../../resources/data_validation/data_validation.resource

*** Variables ***
${source_name}  UFFS
${target_db}    ORACLE19

*** Test Cases ***
Verify tables existence
    [Documentation]  Run tests to tables existance
    [Template]  Verify table presents for ${schema}
    FOR  ${schema}  ${tables}  IN  &{${source_name}}
        ${target_db}  ${schema}  ${tables}
    END

Verify metadata
    [Documentation]  Run tests to verify metadata
    [Template]  Verify metadata for ${schema}.${table}
    FOR    ${schema}  ${tables}  IN  &{${source_name}}
        FOR    ${table}  IN  @{tables}
            ${target_db}  ${schema}  ${table}  ${source_name}
        END
    END

Verify data existence
    [Documentation]  Run tests to verify counts
    [Template]  Verify counts for ${schema}.${table}. Should be >0
    FOR    ${schema}  ${tables}  IN  &{${source_name}}
        FOR    ${table}    IN    @{tables}
            ${target_db}  ${schema}  ${table}
        END
    END


Verify data with custom query
    [Documentation]  Run custom query and check the data is valid
    [Template]  Verify custom queries
    FOR     ${CUSTOM_QUERY}     IN      @{CUSTOM_QUERIES}
            ${target_db}    ${CUSTOM_QUERY.query}   ${CUSTOM_QUERY.expected_data}
    END
