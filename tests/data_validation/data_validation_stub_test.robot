*** Settings ***
Documentation        This is initial test suite for data validation
Resource             ../../resources/data_validation/data_validation.resource

*** Variables ***
${source_name}  UFFS
${target_db}    ORACLE19

*** Test Cases ***
Verify metadata
    [Documentation]  Run tests by prepared queries
    [Template]  Verify metadata for ${schema}.${table}. Should be TODO
    FOR    ${schema}  ${tables}  IN  &{${source_name}}
        FOR    ${table}  IN  @{tables}
            ${target_db}  ${schema}  ${table}
        END
    END


Verify data existance
    [Documentation]  Verify counts
    [Template]  Verify counts for ${schema}.${table}. Should be >0
    FOR    ${schema}  ${tables}  IN  &{${source_name}}
        FOR    ${table}    IN    @{tables}
            ${target_db}  ${schema}  ${table}
        END
    END
