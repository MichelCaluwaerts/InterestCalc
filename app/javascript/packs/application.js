// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)


// ----------------------------------------------------
// Note(lewagon): ABOVE IS RAILS DEFAULT CONFIGURATION
// WRITE YOUR OWN JS STARTING FROM HERE 👇
// ----------------------------------------------------

// External imports
import "bootstrap";

// Internal imports, e.g:
// import { initSelect2 } from '../components/init_select2';
import { initFlatpickr } from "../plugins/flatpickr";

document.addEventListener('turbolinks:load', () => {
  // Call your functions here, e.g:
  // initSelect2();
  initFlatpickr();

  $('form').on('click', '.remove_record', function(event) {
    $(this).prev('input[type=hidden]').val('1');
    $(this).closest('tr').hide();
    return event.preventDefault();
  });
 
  $('form').on('click', '.add_fields', function(event) {
    var regexp, time, fld;
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    if ((this).innerText === "Nouvelle Créance") {
      fld = '.fields-credit';
    } else if ((this).innerText === "Nouveau Payement") {
      fld = '.fields-payment';
    } else if ((this).innerText === "Nouveau Coût") {
      fld = '.fields-cost';
    } else {
      fld = '.fields-capitalisation'
    }
    $(fld).append($(this).data('fields').replace(regexp, time));
    return event.preventDefault();
  });

  const conv = document.querySelectorAll('fieldset > .form-check input');
  const pct = document.querySelector("#taux-conv");
  conv.forEach((c) => {
    c.addEventListener("click", (e) => {
      if (conv[0].checked === true) {
        pct.style.display = "";
      } else  {
        pct.style.display = "none";
      }
      return e;
  });
});

});
