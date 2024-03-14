document.addEventListener("keydown", function(e) {
  if (e.ctrlKey && e.key == "k") {
    e.preventDefault();
    
    const searchForm = document.querySelector("#search-field");
    if (searchForm) {
      searchForm.focus();
    }
  }
});

document.querySelector("#search-form").addEventListener("keydown", function(e) {
  if (e.key == "Enter") {
    e.preventDefault();
    searchBarQuery();
  }
})

function renderImportForm() {
  // form
  const importForm = document.createElement("form");
  importForm.setAttribute("action", "/upload");
  importForm.setAttribute("method", "post");
  importForm.setAttribute("accept", "text/csv");
  importForm.setAttribute("enctype", "multipart/form-data");
  // input form
  const input = document.createElement("input");
  input.setAttribute("id", "file");
  input.setAttribute("type", "file");
  input.setAttribute("name", "file");
  input.className = "form-control";
    // submit
  const submitBtn = document.createElement("button");
  submitBtn.setAttribute("type", "submit");
  submitBtn.innerText = "Enviar"
  submitBtn.className = "btn btn-outline-primary"
    // cancel
  const cancelBtn = document.createElement("button");
  cancelBtn.setAttribute("onclick", "renderSearchForm()");
  cancelBtn.setAttribute("type", "button");
  cancelBtn.innerText = "Cancelar";
  cancelBtn.className = "btn btn-outline-danger"
    // input group
  const inputGroup = document.createElement("div");
  inputGroup.className = "d-flex flex-row gap-2"
  inputGroup.append(input, submitBtn, cancelBtn);
  
  importForm.append(inputGroup);
  
  const navForm = document.querySelector("#nav-form");
  navForm.innerHTML = "";
  navForm.append(importForm);
}

function renderSearchForm() {
  // form
  const form = document.createElement("form");
  form.className = "d-flex";
  form.setAttribute("role", "search");
  form.setAttribute("action", "/search");
  form.setAttribute("method", "get");
    // input
  const input = document.createElement("input");
  input.className = "form-control me-2";
  input.setAttribute("type", "search");
  input.setAttribute("placeholder", "Token (6 caracteres)");
  input.setAttribute("name", "token");
    // search btn
  const searchBtn = document.createElement("button");
  searchBtn.className = "btn btn-outline-primary";
  searchBtn.setAttribute("id", "search-btn");
  searchBtn.setAttribute("type", "submit");
  searchBtn.innerText = "Buscar"
    // import button
  const importBtn = document.createElement("button");
  importBtn.className = "btn btn-outline-dark ms-2";
  importBtn.setAttribute("id", "import-btn");
  importBtn.setAttribute("type", "button");
  importBtn.setAttribute("onclick", "renderImportForm()");
  importBtn.innerText = "Importar";
  
  form.append(input, searchBtn, importBtn);
  
  const navForm = document.querySelector("#nav-form");
  navForm.innerHTML = "";
  navForm.append(form);
}
