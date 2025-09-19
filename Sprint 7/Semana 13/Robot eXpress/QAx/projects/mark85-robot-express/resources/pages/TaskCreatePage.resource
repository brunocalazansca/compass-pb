*** Settings ***
Documentation        Ações e elementos da página de cadastro de tarefas
Library              Browser


*** Keywords ***
Submit task form
    [Arguments]        ${task}

    Fill Text        css=input[placeholder$=tarefa]        ${task}[name]
    Click            css=button >> text=Cadastrar