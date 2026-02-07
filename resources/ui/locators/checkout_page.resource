*** Settings ***
Documentation     Locators for SauceDemo checkout pages (step 1, step 2, complete)

*** Variables ***
# Checkout Step 1
${FIRST_NAME_INPUT}    data-test=firstName
${LAST_NAME_INPUT}     data-test=lastName
${POSTAL_CODE_INPUT}   data-test=postalCode
${CONTINUE_BUTTON}     data-test=continue
${CANCEL_BUTTON}       data-test=cancel
${CHECKOUT_ERROR}      data-test=error

# Checkout Step 2
${ITEM_TOTAL}          data-test=subtotal-label
${TAX_LABEL}           data-test=tax-label
${TOTAL_LABEL}         data-test=total-label
${FINISH_BUTTON}       data-test=finish

# Checkout Complete
${COMPLETE_HEADER}     data-test=complete-header
${COMPLETE_TEXT}       data-test=complete-text
${BACK_HOME_BUTTON}    data-test=back-to-products
