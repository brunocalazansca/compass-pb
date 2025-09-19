*** Settings ***
Documentation        Ações e elementos da página de listagem de tarefas

*** Keywords ***
Task should be registered
    [Arguments]                    ${task_name}

    Wait For Elements State        css=.task-todo >> text=${task_name}
    ...                            visible        5