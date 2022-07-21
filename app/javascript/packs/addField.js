
import { initFlatpickr } from "../plugins/flatpickr";

const addField = () => {
   $('form').on('click', '.add_fields', function(event) {
  var regexp, time, fld, box;
  time = new Date().getTime();
  regexp = new RegExp($(this).data('id'), 'g');
  if ((this).innerText === "Nouvelle Créance" || (this).innerText === "New credit") {
    fld = '.fields-credit';
    box = document.getElementById("crd").getBoundingClientRect().bottom - document.body.getBoundingClientRect().top;
    window.scrollTo(0, box);
  } else if ((this).innerText === "Nouveau Payement" || (this).innerText === "New payment") {
    fld = '.fields-payment';
    box = document.getElementById("pmt").getBoundingClientRect().bottom - document.body.getBoundingClientRect().top;
    window.scrollTo(0, box);
  } else if ((this).innerText === "Nouveau Coût" || (this).innerText === "New cost") {
    fld = '.fields-cost';
    box = document.getElementById("cst").getBoundingClientRect().bottom - document.body.getBoundingClientRect().top;
    window.scrollTo(0, box);
  } else  if ((this).innerText === "Capitaliser" || (this).innerText === "Capitalize") {
    fld = '.fields-capitalisation';
    box = document.getElementById("cpt").getBoundingClientRect().bottom - document.body.getBoundingClientRect().top;
    window.scrollTo(0, box);
  }
  $(fld).append($(this).data('fields').replace(regexp, time));
  initFlatpickr();
  return event.preventDefault();
});
};
export { addField }