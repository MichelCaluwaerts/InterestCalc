
 const changeBox = () => {
 const conv = document.querySelectorAll('fieldset > .form-check input');
 const pct = document.querySelector("#taux-conv");
 const zap = document.querySelector("#switch");
  conv.forEach((c) => {
   c.addEventListener("click", (e) => {
     if (conv[0].checked === true) {
       pct.style.display = "";
       zap.style.display = "none";
     } else if (conv[1].checked === true) {
       pct.style.display = "none";
       zap.style.display = "";
     } else {
       pct.style.display = "none";
       zap.style.display = "none";
     }
     return e;
 });
});
}

export { changeBox }