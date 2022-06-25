import flatpickr from "flatpickr";
import { French } from "flatpickr/dist/l10n/fr.js"

const initFlatpickr = () => {
  flatpickr(".datepicker", { 
    "locale": French,
    altInput: true,
    altFormat: "d-m-Y"
});
}

export { initFlatpickr };