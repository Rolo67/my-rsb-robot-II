*** Settings ***
Documentation     Orders robots from RobotSpareBin Industries Inc.
...               Saves the order HTML receipt as a PDF file.
...               Saves the screenshot of the ordered robot.
...               Embeds the screenshot of the robot to the PDF receipt.
...               Creates ZIP archive of the receipts and the images.

Library           RPA.Browser.Playwright
Library           RPA.HTTP
Library           RPA.Tables


*** Test Cases ***
Test
    Open the robot order website
    Download the orders file, read it as a table, and return the result

*** Keywords ***
Open the robot order website
    Open Browser    https://robotsparebinindustries.com/#/robot-order

Close the annoying modal
    Click    css=button.btn-dark

Download the orders file, read it as a table, and return the result
    RPA.HTTP.Download    https://robotsparebinindustries.com/orders.csv    overwrite=True
    ${orders}=    Read table from CSV    orders.csv
    FOR    ${order}    IN    @{orders}
        Get Orders    ${order}
    END
 Get Orders
    [Arguments]    ${order}
    Close the annoying modal
    Select Options By    id=head    value    ${order}[Head]
    Check Checkbox   id=id-body-${order}[Body]
    Fill Text    css=input[placeholder="Enter the part number for the legs"]     ${order}[Legs]
    Fill Text    id=address     ${order}[Address]
    Wait Until Keyword Succeeds    5x    0.5 sec    Click    id=order
    Click    id=order-another