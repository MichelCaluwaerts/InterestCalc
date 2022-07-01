const btnDisable = () => {
const bts = document.querySelectorAll(".add_fields");
  const calc = document.getElementById("calc");
    bts.forEach((b) => {
      b.addEventListener('click', (e) => {
        calc.classList.add("disabled");
        return e;
      });
    });

    form.addEventListener("submit", (e) => {
      calc.classList.remove("disabled");
      return e;
    });
  };
  
  export { btnDisable }