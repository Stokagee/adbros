*** Settings ***
Documentation     Locators for SauceDemo inventory/products page

*** Variables ***
${PRODUCT_LIST}      .inventory_list
${PRODUCT_ITEM}      .inventory_item
${PRODUCT_NAME}      data-test=inventory-item-name
${PRODUCT_PRICE}     data-test=inventory-item-price
${ADD_TO_CART_BTN}   data-test=add-to-cart-
${REMOVE_BTN}        data-test=remove-
${SORT_DROPDOWN}     data-test=product-sort-container
