*** Settings ***
Resource          ${EXECDIR}/resources/config/config.resource

*** Variables ***
# Test User Credentials (SauceDemo)
${STANDARD_USER}              standard_user
${LOCKED_OUT_USER}            locked_out_user
${PROBLEM_USER}               problem_user
${PERFORMANCE_GLITCH_USER}    performance_glitch_user
${ERROR_USER}                 error_user
${VISUAL_USER}                visual_user
${VALID_PASSWORD}             secret_sauce

# Sample Test Data for Checkout
${TEST_FIRST_NAME}            John
${TEST_LAST_NAME}             Doe
${TEST_POSTAL_CODE}           12345

# Expected Product Data (for assertions)
${PRODUCT_1_NAME}             Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops
${PRODUCT_1_PRICE}            109.95
